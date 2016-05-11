var express = require('express');
var router = express.Router();

router.route('/')
.get(function(req, res, next) {
	res.end('Will send all the leaders to you!');
})

.post(function(req, res, next) {
	res.write('Will add the leader with details:\n');
	res.write(`Name -> ${req.body.name}\n`);
	res.end(`Description -> ${req.body.description}`);
})

.delete(function(req, res, next) {
	res.end('Will delete all the promotions!');
});

router.route('/:id')
.get(function(req, res, next) {
	res.end(`Will send the leader with id: ${req.params.id}`);
})

.put(function(req, res, next) {
	res.write(`Updating the leader with id: ${req.params.id}\n`);
	res.write('Will update the leader with details:\n');
	res.write(`Name -> ${req.body.name}\n`);
	res.end(`Description -> ${req.body.description}`);
})

.delete(function(req, res, next) {
	res.end('Deleting leader with id: ' + req.params.id);
});

module.exports = router;