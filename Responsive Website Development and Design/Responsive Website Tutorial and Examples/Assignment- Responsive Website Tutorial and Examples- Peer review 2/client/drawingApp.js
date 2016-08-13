var canvas;

// we use these for drawing more interesting shapes
var lastX = 0;
var lastY = 0;
var strokeWidth = 1;
var thickness = 1;
var strokeColor = "black";
var lineCap = "round";
var opacity = 1;

Meteor.startup(function() {
	canvas = new Canvas();
	
	Deps.autorun(function() {
		var data = points.find({}).fetch();
		
		if(canvas) {
			canvas.draw(data);
		}
	});

	$('.color-button').each(function() {
		var color = $(this).data('color');
		$(this).css('background-color', color);
	});
	
});

Template.wall.events({
	'click button.clear-button': function(event) {
		Meteor.call('clear', function() {
			canvas.clear();
		});
	},
	//choose a color. Initialise the last vals, otherwise a stray line will appear.	
	'click button.save-button': function(event) {
		var svg = document.querySelector("svg");
		var svgData = new XMLSerializer().serializeToString(svg);
		var imgsrc = 'data:image/svg+xml;base64,'+ btoa(svgData);
		var img = '<img src="'+imgsrc+'">'; 
		d3.select("#svgdataurl").html(img);
		
		var canvas = document.createElement("canvas");
		canvas.width = 1000;
		canvas.height = 500;
		var context = canvas.getContext("2d");
		
		var image = new Image;
		image.src = imgsrc;
		image.onload = function() {
			context.drawImage(image, 0, 0);
			var canvasdata = canvas.toDataURL("image/png");
			var pngimg = '<img src="'+canvasdata+'">'; 
			d3.select("#pngdataurl").html(pngimg);
			var a = document.createElement("a");
			a.download = "canvas.png";
			a.href = canvasdata;
			a.click();
		};
	},
	'click button.color-button': function(event) {
		lastX = 0;
		lastY = 0;
		strokeColor = $(event.target).data('color');
	},
	'click a.thicker-button': function () {
		thickness += 0.5;
	},
	'click a.thinner-button': function () {
		if(thickness > 0) {
			thickness -= 0.5;
		}
	},
	'click a.more-width-button': function () {
		strokeWidth += 0.5;
	},
	'click a.less-width-button': function () {
		if(strokeWidth > 0) {
			strokeWidth -= 0.5;
		}
	},	
	'click a.more-opacity-button': function () {
		if(opacity < 1) {
			opacity += 0.1;			
		}
	},
	'click a.less-opacity-button': function () {
		if(opacity > 0) {
			opacity -= 0.1;
		}
	},
	'click a.linecap-round-button': function () {
		lineCap = 'round';
	},
	'click a.linecap-square-button': function () {
		lineCap = 'square';
	}
});

var markPoint = function() {

	var offset = $('svg').position({
		my: 'center',
		at: 'center',
		of: '#canvas'
	});

// In the first frame, lastX and lastY are 0.
// This means the line gets drawn to the top left of the screen
// Which is annoying, so we test for this and stop it happening.

      if (lastX==0) {// check that x was something not top-left. should probably set this to -1
        lastX = (event.pageX - offset.left);
        lastY = (event.pageY - offset.top);
      }
      points.insert({
        //this draws a point exactly where you click the mouse
      // x: (event.pageX - offset.left),
      // y: (event.pageY - offset.top)});


        //We can do more interesting stuff
        //We need to input data in the right format
        //Then we can send this to d3 for drawing


        //1) Algorithmic mouse follower
      // x: (event.pageX - offset.left)+(Math.cos((event.pageX/10  ))*30),
      // y: (event.pageY - offset.top)+(Math.sin((event.pageY)/10)*30)});

        //2) draw a line - requires you to change the code in drawing.js
        x: (event.pageX - offset.left),
        y: (event.pageY - offset.top),
        x1: lastX,
        y1: lastY,
        // We could calculate the line thickness from the distance
        // between current position and last position
        //w: 0.05*(Math.sqrt(((event.pageX - offset.left)-lastX) * (event.pageX - offset.left)
        //  + ((event.pageY - offset.top)-lastY) * (event.pageY - offset.top))),
        // Or we could just set the line thickness using buttons and variable
        w: thickness,
        // We can also use strokeColor, defined by a selection
        c: strokeColor,
        l: lineCap,
        s: strokeWidth,
        o: opacity
      }); // end of points.insert()

        lastX = (event.pageX - offset.left);
        lastY = (event.pageY - offset.top);

}

Template.canvas.events({
  'click': function (event) {
    markPoint();
  },
  'mousedown': function (event) {
    Session.set('draw', true);
    lastX=0;
    lasyY=0;
  },
  'mouseup': function (event) {
    Session.set('draw', false);
  },
  'mousemove': function (event) {
    if (Session.get('draw')) {
      markPoint();
    }
  }
});
