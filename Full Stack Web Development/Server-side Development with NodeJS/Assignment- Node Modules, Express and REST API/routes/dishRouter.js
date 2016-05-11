var express = require('express');
var router = express.Router();

router.route('/')
.get(function(req, res, next) {
	res.end('Will send all the dishes to you!');
})

.post(function(req, res, next) {
	res.write('Will add the dish with details:\n');
	res.write(`Name -> ${req.body.name}\n`);
	res.end(`Description -> ${req.body.description}`);
})

.delete(function(req, res, next) {
	res.end('Will delete all the dishes!');
});

router.route('/:id')
.get(function(req, res, next) {
	res.end(`Will send the dish with id: ${req.params.id}`);
})

.put(function(req, res, next) {
	res.write(`Updating the dish with id: ${req.params.id}\n`);
	res.write('Will update the dish with details:\n');
	res.write(`Name -> ${req.body.name}\n`);
	res.end(`Description -> ${req.body.description}`);
})

.delete(function(req, res, next) {
	res.end('Deleting dish with id: ' + req.params.id);
});

module.exports = router;