var express = require('express');
var router = express.Router();

var Dish = require('../models/dish');
var Verify = require('./verify');

router.route('/')
.all(Verify.verifyOrdinaryUser)

.get(function(req, res, next) {
	Dish.find({}, function(err, dish) {
		if(err) throw err;
		res.json(dish);
	});
})

.post(Verify.verifyAdmin, function(req, res, next) {
	Dish.create(req.body, function(err, dish) {
	    if(err) throw err;
	    console.log('Dish created!');
	    var id = dish._id;
	
	    res.writeHead(200, {
	        'Content-Type': 'text/plain'
	    });
	    res.end('Added the dish with id: ' + id);
	});
})

.delete(Verify.verifyAdmin, function(req, res, next) {
	Dish.remove({}, function(err, resp) {
	    if(err) throw err;
	    res.json(resp);
	});
});

router.route('/:id')
.all(Verify.verifyOrdinaryUser)

.get(function(req, res, next) {
	Dish.findById(req.params.id, function(err, dish) {
	    if(err) throw err;
	    res.json(dish);
	});
})

.put(Verify.verifyAdmin, function(req, res, next) {
	Dish.findByIdAndUpdate(req.params.id, {$set: req.body}, {new: true}, function(err, dish) {
		if(err) throw err;
	    res.json(dish);
	});
})

.delete(Verify.verifyAdmin, function(req, res, next) {
	Dish.findByIdAndRemove(req.params.id, function(err, resp) {
		if(err) throw err;
		res.json(resp);
	});
});

router.route('/:id/comments')
.all(Verify.verifyOrdinaryUser)

.get(function(req, res, next) {
    Dish.findById(req.params.id, function(err, dish) {
        if(err) throw err;
        res.json(dish.comments);
    });
})

.post(Verify.verifyAdmin, function(req, res, next) {
    Dish.findById(req.params.id, function(err, dish) {
        if(err) throw err;
        dish.comments.push(req.body);
        dish.save(function(err, dish) {
            if(err) throw err;
            console.log('Updated Comments!');
            res.json(dish);
        });
    });
})

.delete(Verify.verifyAdmin, function(req, res, next) {
    Dish.findById(req.params.id, function(err, dish) {
        if(err) throw err;
        for(var i = (dish.comments.length - 1); i >= 0; i--) {
            dish.comments.id(dish.comments[i]._id).remove();
        }
        dish.save(function(err, result) {
            if(err) throw err;
            res.writeHead(200, {
                'Content-Type': 'text/plain'
            });
            res.end('Deleted all comments!');
        });
    });
});

router.route('/:id/comments/:commentId')
.all(Verify.verifyOrdinaryUser)

.get(function(req, res, next) {
    Dish.findById(req.params.id, function(err, dish) {
        if(err) throw err;
        res.json(dish.comments.id(req.params.commentId));
    });
})

.put(Verify.verifyAdmin, function(req, res, next) {
    // We delete the existing commment and insert the updated
    // comment as a new comment
    Dish.findById(req.params.id, function(err, dish) {
        if(err) throw err;
        dish.comments.id(req.params.commentId).remove();
        dish.comments.push(req.body);
        dish.save(function(err, dish) {
            if (err) throw err;
            console.log('Updated Comments!');
            res.json(dish);
        });
    });
})

.delete(Verify.verifyAdmin, function(req, res, next) {
    Dish.findById(req.params.id, function(err, dish) {
        dish.comments.id(req.params.commentId).remove();
        dish.save(function(err, resp) {
            if(err) throw err;
            res.json(resp);
        });
    });
});

module.exports = router;