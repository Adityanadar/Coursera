// method definitions
Meteor.methods({
	addChat:function(users) {
		if (!this.userId) {
			return;
		} else {
			var id = Chats.insert(users);
			return id;
		}
	},
	updateChat: function(chatId, chat) {
		Chats.update(chatId, chat);
	}
});