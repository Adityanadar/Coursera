Schemas = {};

Schemas.WebsiteFields = new SimpleSchema({
	url: {
		type: String,
		label: 'URL',
		regEx: SimpleSchema.RegEx.Url,
		autoform: {
			type: 'url',
			placeholder: 'http://www.mysite.com'
		}
	},
	title: {
		type: String,
		label: 'Title',
		max: 50,
		autoform: {
			placeholder: 'My Site'
		}
	},
	description: {
		type: String,
		label: 'Description',
		max: 1000,
		autoform: {
			placeholder: 'Enter a description...'
		}
	}
});

Schemas.CommentsFields = new SimpleSchema({
	comment: {
		type: String,
		label: 'Comments',
		autoform: {
			type: 'textarea',
			placeholder: 'Write your comments here...'
		}
	}
});