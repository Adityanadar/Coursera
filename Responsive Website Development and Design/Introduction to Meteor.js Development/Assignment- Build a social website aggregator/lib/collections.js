Websites = new Mongo.Collection("websites");
Comments = new Mongo.Collection("comments");

Websites.allow({
	insert: function(userId, doc) {
		if(Meteor.user()){
			return true;
		}
		else{
			return false;
		}
	},
	update:	function(userId, doc, fieldNames, modifier){
		if(Meteor.user()){
			return true;
		}
		else{
			return false;
		}		
	},
	remove: function(userId, doc) {
		if(userId === doc.author){
			return true;
		}
		else{
			return false;
		}		
	}
});

Comments.allow({
	insert: function(user_Id,doc){
		if(Meteor.user()) {
			return true;
		}
		else {
			return false;
		}
	},
	remove: function(userId, doc) {
		if(userId === doc.owner){
			return true;
		}
		else{
			return false;
		}		
	}
});