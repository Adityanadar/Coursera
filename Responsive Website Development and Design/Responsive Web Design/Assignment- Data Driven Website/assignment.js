// put your javascript code here
(function($) {	

	Handlebars.registerHelper('toLowerCase', function(str) {
		return str.toLowerCase();
	});

	$(document).ready(function() {
		var source = $("#animal-template").html();
		var source_tabs = $("#animal-tabs").html();
		var template = Handlebars.compile(source);
		var template_tabs = Handlebars.compile(source_tabs);
		var html = template(animals_data);
		var html_tabs = template_tabs(animals_data);
		$("#main").html(html);
		$("#bs-example-navbar-collapse-1").html(html_tabs);
		
		$('.img-responsive').bind('mouseenter mouseleave', function() {
		    $(this).attr({
			    src: $(this).attr('hover-src'),
			    'hover-src': this.src 
		    });
		});
	});	
})(jQuery);
