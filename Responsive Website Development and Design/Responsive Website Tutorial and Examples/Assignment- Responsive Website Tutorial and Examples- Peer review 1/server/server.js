Meteor.startup(function() {
    // MusicMachine.remove({});
    if(!MusicMachine.findOne()) {
        console.log("No music machine yet. Creating starter data.");
        MusicMachine.insert({
            start: 0,
            drums: {
	            status: 0,
                speed: 50,
                volume: 50
            },
            bassline: {
	            status: 0,
                speed: 50,
                volume: 50
            },
            bassline24bit: {
	            status: 0,
                speed: 50,
                volume: 50
            },
            bassline32bit: {
 	            status: 0,
                speed: 50,
                volume: 50
            },
            arp: {
	            status: 0,
                speed: 50,
                volume: 50
            },
            hihat: {
 	            status: 0,
                speed: 50,
                volume: 50
            },
            snaredrum: {
 	            status: 0,
                speed: 50,
                volume: 50
            },
            cymbal: {
	            status: 0,
                speed: 50,
                volume: 50
            }
        });        
    } 
});