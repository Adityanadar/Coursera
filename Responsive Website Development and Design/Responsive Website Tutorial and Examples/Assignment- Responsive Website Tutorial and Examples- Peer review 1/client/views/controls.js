Template.controls.events({
    'click button.play': function(event) {
        var instrument = $(event.target).data('instrument');
        var machine = MusicMachine.findOne();
        var setModifier = {$set: {}};
        setModifier.$set[instrument + ".status"] = 1;
        Session.set(instrument, 1);
        MusicMachine.update({ _id: machine._id }, setModifier);
    },
    'click button.stop': function(event) {
        var instrument = $(event.target).data('instrument');
        var machine = MusicMachine.findOne();
        var setModifier = {$set: {}};
        setModifier.$set[instrument + ".status"] = 0;
        Session.set(instrument, 0);
        MusicMachine.update({ _id: machine._id }, setModifier);
    }
});

Template.controls.onRendered(function() {
    
    var templateInstance = this;
    
    var handlerSpeed = _.throttle(function(event, ui) {
        var instrument = $(event.target).data('instrument');
        var machine = MusicMachine.findOne();
        var setModifier = {$set: {}};
        setModifier.$set[instrument + ".speed"] = ui.value;        
        MusicMachine.update({_id: machine._id}, setModifier);
    }, 50, {leading: false});
    

    var handlerVolume = _.throttle(function(event, ui) {
        var instrument = $(event.target).data('instrument');
        var machine = MusicMachine.findOne();
        var setModifier = {$set: {}};
        setModifier.$set[instrument + ".volume"] = ui.value;        
        MusicMachine.update({_id: machine._id}, setModifier);
    }, 50, {leading: false});    
    
    $('.speed-slider').each(function() {
        if(!(templateInstance.$(this).data('uiSlider'))) {
            $(this).slider({
                slide: handlerSpeed,
                min: 0,
                max: 100,
                value: 50
            });
        };
    });
    
    $('.volume-slider').each(function() {
        if(!(templateInstance.$(this).data('uiSlider'))) {
            $(this).slider({
                slide: handlerVolume,
                min: 0,
                max: 100,
                value: 50
            });
        };
    });
});