var express = require('express');
var router = express.Router();

var Leader = require('../models/leader');
var Verify = require('./verify');

router.route('/')
.all(Verify.verifyOrdinaryUser)

.get(function(req, res, next) {
	Leader.find({}, function(err, leader) {
		if(err) throw err;
		res.json(leader);
	});
})

.post(Verify.verifyAdmin, function(req, res, next) {
	Leader.create(req.body, function(err, leader) {
	    if(err) throw err;
	    console.log('leader created!');
	    var id = leader._id;
	
	    res.writeHead(200, {
	        'Content-Type': 'text/plain'
	    });
	    res.end('Added the leader with id: ' + id);
	});
})

.delete(Verify.verifyAdmin, function(req, res, next) {
	Leader.remove({}, function(err, resp) {
	    if(err) throw err;
	    res.json(resp);
	});
});

router.route('/:id')
.all(Verify.verifyOrdinaryUser)

.get(function(req, res, next) {
	Leader.findById(req.params.id, function(err, leader) {
	    if(err) throw err;
	    res.json(leader);
	});
})

.put(Verify.verifyAdmin, function(req, res, next) {
	Leader.findByIdAndUpdate(req.params.id, {$set: req.body}, {new: true}, function(err, leader) {
		if(err) throw err;
	    res.json(leader);
	});
})

.delete(Verify.verifyAdmin, function(req, res, next) {
	Leader.findByIdAndRemove(req.params.id, function(err, resp) {
		if(err) throw err;
		res.json(resp);
	});
});

module.exports = router;