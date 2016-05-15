// Turn on ASCII smileys
emojione.ascii = true;

// Set up the main template the the router will use to build pages
Router.configure({
	layoutTemplate: 'ApplicationLayout'
});

// Check if the user is logged in before showing available users or chats
Router.onBeforeAction(function() {
	if(!Meteor.userId()) {
		this.render('navbar', {to: 'header'});
		this.render('info_messages', {to: 'main', data: {message: 'Sign in / Join first to start chating with other users'}});
	} else {
		this.next();		
	}
});

// Specify the top level route, the page users see when they arrive at the site
Router.route('/', {
	subscriptions: function() {
		this.subscribe('users');
	},
	yieldRegions: {
		'navbar': {to: 'header'}
	},
	action: function() {
		this.render('navbar', {to: 'header'});
		this.render('lobby_page', {to: 'main'});
	}
});

// Specify a route that allows the current user to chat to another users
Router.route('/chat/:_id', {
	onBeforeAction: function() {
		var otherUser = Meteor.users.findOne({_id:this.params._id});
		if(!otherUser) {
			this.render('navbar', {to: 'header'});
			this.render('info_messages', {to: 'main', data: {message: "Can't start chat with invalid user"}});
		} else {
			this.next();
		}
	},
	subscriptions: function () {
		this.subscribe('users');
	},
	waitOn: function() {
		return Meteor.subscribe('chats');
	},	  
	yieldRegions: {
		'navbar': {to: 'header'}
	},
	action: function() {
		// find a chat that has two users that match current user id
		// and the requested user id
		var filter = {$or:[
		            {user1Id:Meteor.userId(), user2Id:this.params._id}, 
		            {user2Id:Meteor.userId(), user1Id:this.params._id}
		            ]};
		var chat = Chats.findOne(filter);
		var chatId = null;
		
		if(!chat) {// no chat matching the filter - need to insert a new one
		    chatId = Meteor.call('addChat', {user1Id:Meteor.userId(), user2Id:this.params._id});
		} else {// there is a chat going already - use that. 
		    chatId = chat._id;
		}
		
		if(chatId) {// looking good, save the id to the session
		    Session.set('chatId', chatId);
		}
		
		this.render('navbar', {to: 'header'});
		this.render('chat_page', {to: 'main'});	 
	}
});

///
// Helper functions 
/// 
Template.available_user_list.helpers({
	//get users
	users: function(){
		return Meteor.users.find({}, {sort: {'profile.username': 1}});
	}
});

Template.available_user.helpers({
	//get the user's username
	getUsername: function(userId){
		user = Meteor.users.findOne({_id:userId});
		return user.profile.username;
	},
	//check if the user is the current user 
	isMyUser: function(userId){
		if (userId == Meteor.userId()){
			return true;
		} else {
			return false;
		}
	}
});

Template.chat_page.helpers({
	messages: function(){
		//get the messages of the current chat
		if(Session.get("chatId")) { //
			var chat = Chats.findOne({_id:Session.get("chatId")});
			return chat.messages;			
		}
	}, 
	isMainUser: function() {
		//check if the chat message is of the current user
		if(this.user.username === Meteor.user().profile.username) {
			return true;
		} else {
			return false;
		}
	},
	instantFromNow: function() {
		//display the moment when the message was sent
		return moment(this.date).fromNow();
	},
	emojiMessage: function() {
		//parse chat message with emojione
		return emojione.shortnameToImage(this.text);
	} 
});

///
// Event functions 
///
Template.chat_page.events({
	// this event fires when the user sends a message on the chat page
	'submit .js-send-chat': function(event){
		// stop the form from triggering a page reload
		event.preventDefault();
		// see if we can find a chat object in the database
		// to which we'll add the message
		var chat = Chats.findOne({_id:Session.get("chatId")});
		if (chat){// ok - we have a chat to use
			var msgs = chat.messages; // pull the messages property
			if (!msgs){// no messages yet, create a new array
				msgs = [];
			}
			// is a good idea to insert data straight from the form
			// (i.e. the user) into the database?? certainly not. 
			// push adds the message to the end of the array
			msgs.push({text: event.target.chat.value, user: Meteor.user().profile, date: new Date()});
			// reset the form
			event.target.chat.value = "";
			// put the messages array onto the chat object
			chat.messages = msgs;
			// update the chat object in the database.
			Meteor.call("updateChat", chat._id, chat);
		}
	}
});