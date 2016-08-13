Template.navbar.events({
    'click button.startButton': function(event) {
        var machine = MusicMachine.findOne();
        if(machine.start === 1) {
            MusicMachine.update({ _id: machine._id }, {$set: {start: 0}});
            Session.set('startdac', 0);
        } else if(machine.start === 0) {
            MusicMachine.update({ _id: machine._id }, {$set: {start: 1}});
            Session.set('startdac', 1);            
        }
    }
});