var express = require('express');
var router = express.Router();

router.route('/')
.get(function(req, res, next) {
	res.end('Will send all the promotions to you!');
})

.post(function(req, res, next) {
	res.write('Will add the promotion with details:\n');
	res.write(`Name -> ${req.body.name}\n`);
	res.end(`Description -> ${req.body.description}`);
})

.delete(function(req, res, next) {
	res.end('Will delete all the promotions!');
});

router.route('/:id')
.all(function(req,res,next) {
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      next();
})

.get(function(req, res, next) {
	res.end(`Will send the promotion with id: ${req.params.id}`);
})

.put(function(req, res, next) {
	res.write(`Updating the promotion with id: ${req.params.leaderId}\n`);
	res.write('Will update the promotion with details:\n');
	res.write(`Name -> ${req.body.name}\n`);
	res.end(`Description -> ${req.body.description}`);
})

.delete(function(req, res, next) {
	res.end('Deleting promotion with id: ' + req.params.leaderId);
});

module.exports = router;