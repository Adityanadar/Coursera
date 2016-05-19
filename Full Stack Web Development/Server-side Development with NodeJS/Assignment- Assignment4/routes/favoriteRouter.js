var express = require('express');
var router = express.Router();

var Favorite = require('../models/favorite');
var Verify = require('./verify');

router.route('/')
.all(Verify.verifyOrdinaryUser)

.get(function(req, res, next) {
	Favorite.findOne({postedBy: req.decoded._doc._id})
		.populate('postedBy dishes')
		.exec(function(err, favorite) {
			if(err) next(err);
			res.json(favorite);
	});
})

.post(function(req, res, next) {
	Favorite.findOne({postedBy: req.decoded._doc._id}, function(err, favorite) {
		if(err) next(err);
		if(!favorite) {
			req.body.postedBy = req.decoded._doc._id;
			Favorite.create({postedBy: req.decoded._doc._id}, function(err, favorite) {
				if(err) next(err);
				if(!req.body._id) {
					var err = new Error("Missing dish ObjectId!");
					err.status = 401;
					return next(err);
				}
				favorite.dishes.push(req.body._id);
				favorite.save(function(err, favorite) {
					if(err) return next(err);
					res.json(favorite);	
				});			
			});
		} else {
			if(req.body._id) {
				if(favorite.dishes.indexOf(req.body._id) > -1) {
					var err = new Error("This dish is already one of your favorites!");
					err.status = 401;
					return next(err);
				}
				favorite.dishes.push(req.body._id);
				favorite.save(function(err, favorite) {
				    if(err) return next(err);
				    res.json(favorite);
				});

			} else {
				var err = new Error("Missing dish ObjectId!");
				err.status = 401;
				return next(err);	
			}
		}
	});
})

.delete(function(req, res, next) {
	Favorite.remove({postedBy: req.decoded._doc._id}, function(err, resp) {
	    if(err) next(err);
	    res.json(resp);		
	});
});

router.route('/:id')
.all(Verify.verifyOrdinaryUser)

.delete(function(req, res, next) {
    Favorite.findOne({postedBy: req.decoded._doc._id}, function(err, favorite) {
	    if(err) next(err);
		if(favorite.dishes.indexOf(req.params.id) > -1) {
			favorite.dishes.pull(req.params.id);
			favorite.save(function(err, favorite) {
			    if(err) return next(err);
			    res.json(favorite);
			});	
		} else {
			var err = new Error("This dish cannot be deleted because is not one of your favorites!");
			err.status = 401;
			return next(err);			
		}
    });
});

module.exports = router;