WebsitesIndex = new EasySearch.Index({
	collection: Websites,
	fields: ['url', 'title','description'],
	engine: new EasySearch.Minimongo({
    	sort: function() {
        	return {upVotes: -1};
    	}
	}),
});

Template.registerHelper("Schemas", Schemas);

Router.configure({
    layoutTemplate:'app_layout'
});

Router.route('/', function() {
    this.render('website_form_and_list', {
        to: 'main'
    });
});

Router.route('/:_id', {
	onBeforeAction: function() {
		var website = Websites.findOne({_id:this.params._id});
		if(!website) {
			this.render('info_messages', {to: 'main', data: {message: "Can't display details of invalid website"}});
		} else {
			this.next();
		}
	},
	action: function() {
		this.render('website_details', {
			to: 'main',
			data: function() {
				return Websites.findOne({_id: this.params._id});
			}
		});
	}
});

/////
// template helpers 
/////
Accounts.ui.config({
	passwordSignupFields: "USERNAME_AND_EMAIL"
});
// helper function that returns all available websites ordenados por votos a favor

/////
// template events 
/////
Template.comment_list.helpers({
	anyComment: function() {
		return Comments.find({site: this._id}).count() > 0;
	},
	comments: function() {
		return Comments.find({site: this._id}, {sort: {createdOn: 1}});
	}
});

Template.search.helpers({
	WebsitesIndex: function() {
		return WebsitesIndex;
	},
	inputAttributes: function() {
		return {
			placeholder: 'Enter an url, title or description',
			type: 'text',
			class: 'form-control',
			id: 'website'
		};
	}
});

Template.comment_item.helpers({
	getUser:function(user_id){
	  var user = Meteor.users.findOne({_id:user_id});
	  if (user){
	    return user.username;
	  }
	  else {
	    return "anonymous";
	  }
	}
});

Template.website_item.helpers({
	pageBelongs: function() {
		if(this.author === Meteor.userId()) {
			return true;
		}
		return false;
	},
	instantFromNow: function() {
		//display the moment when the message was sent
		return moment(this.createdOn).fromNow();
	}
});

Template.website_details.helpers({
	instantFromNow: function() {
		//display the moment when the message was sent
		return moment(this.createdOn).fromNow();
	}
});


Template.website_item.events({
	"click .js-upvote": function(event){
		if(Meteor.user()) {
			var website_id = this._id;
			console.log("Up voting website with id "+website_id);
			Websites.update({_id: website_id}, {$inc:{upVotes:1}});
		} else {
			alert("Sign in to upvote this website");
		}
		return false;	
	}, 
	"click .js-downvote": function(event){
		if(Meteor.user()) {
			var website_id = this._id;
			console.log("Down voting website with id "+website_id);
			Websites.update({_id: website_id}, {$inc:{downVotes:1}});			
		} else {
			alert("Sign in to downvote this website");			
		}
		return false;
	},
	"click .js-remove-website": function(event) {
		var website_id = this._id;
		console.log("Deleting website with id "+website_id);
		Websites.remove({_id: website_id});
		var comments = Comments.find({site: website_id});		
		comments.forEach(function(comment) {
			Comments.remove({_id: comment._id});
		});	
	}
});

Template.website_form.events({
	"click .js-toggle-website-form": function(event){
		$("#website_form").toggle('slow', function() {
			$('span.glyphicon').toggleClass('glyphicon-minus', $(this).is(':visible'));
		});
	}, 
	"submit .js-save-website-form": function(event){
		var url = event.target.url.value;
		console.log("The url they entered is: "+url);
	
		var title = event.target.title.value;
		var description = event.target.description.value;
		Websites.insert({
			url: url,
			title: title,
			description: description,
			author: Meteor.userId(),
			createdOn: new Date(),
			upVotes: 0,
            downVotes: 0
        });
 		$("#website_form").toggle('slow', function() {
			$('span.glyphicon').toggleClass('glyphicon-minus', $(this).is(':visible'));
		});
		event.target.reset();
		return false;
	}
});

Template.comment_form.events({
	"submit .js-add-comment-form": function(event) {
	    var comment = event.target.comment.value;
	    var site = Router.current().params._id;
	    if(Meteor.user()) {
		    Comments.insert({
		        comment: comment,
		        site: site,
				owner: Meteor.userId(),
		        createdOn: new Date()
		    });			    
	    } else {
		    alert("Sign in to post a comment");
	    }
	    event.target.reset();
	    return false;
	},
});