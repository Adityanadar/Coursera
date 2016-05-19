var express = require('express');
var router = express.Router();

var Promotion = require('../models/promotion');
var Verify = require('./verify');

router.route('/')
.all(Verify.verifyOrdinaryUser)

.get(function(req, res, next) {
	Promotion.find({}, function(err, promotion) {
		if(err) throw err;
		res.json(promotion);
	});
})

.post(Verify.verifyAdmin, function(req, res, next) {
	Promotion.create(req.body, function(err, promotion) {
	    if(err) throw err;
	    console.log('promotion created!');
	    var id = promotion._id;
	
	    res.writeHead(200, {
	        'Content-Type': 'text/plain'
	    });
	    res.end('Added the promotion with id: ' + id);
	});
})

.delete(Verify.verifyAdmin, function(req, res, next) {
	Promotion.remove({}, function(err, resp) {
	    if(err) throw err;
	    res.json(resp);
	});
});

router.route('/:id')
.all(Verify.verifyOrdinaryUser)

.get(function(req, res, next) {
	Promotion.findById(req.params.id, function(err, promotion) {
	    if(err) throw err;
	    res.json(promotion);
	});
})

.put(Verify.verifyAdmin, function(req, res, next) {
	Promotion.findByIdAndUpdate(req.params.id, {$set: req.body}, {new: true}, function(err, promotion) {
		if(err) throw err;
	    res.json(promotion);
	});
})

.delete(Verify.verifyAdmin, function(req, res, next) {
	Promotion.findByIdAndRemove(req.params.id, function(err, resp) {
		if(err) throw err;
		res.json(resp);
	});
});

module.exports = router;