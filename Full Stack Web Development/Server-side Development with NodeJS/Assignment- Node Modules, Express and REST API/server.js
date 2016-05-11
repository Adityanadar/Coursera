var express = require('express');
var bodyParser = require('body-parser');
var morgan = require('morgan');

var dishes = require('./routes/dishRouter');
var promotions = require('./routes/promoRouter');
var leadership = require('./routes/leaderRouter');

var hostname = 'localhost';
var port = 3000;
var app = express();

app.use(morgan('dev'));
app.use(bodyParser.json());

app.use('/dishes', dishes);
app.use('/promotions', promotions);
app.use('/leadership', leadership);

app.use(express.static(__dirname + '/public'));

app.use(function(req, res, next) {
	res.writeHead(200, { 'Content-Type': 'text/plain' });
	next();	
});

app.listen(port, hostname, function() {
	console.log(`Server running at http://${hostname}:${port}/`);
});