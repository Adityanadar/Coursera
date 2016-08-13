Template.playground.helpers({
    'startdac': function() {
        var machine = MusicMachine.findOne();
        if(machine) {
            if (machine.start === 1) {
                playAllInstruments();
            } else if(machine.start === 0) {
                stopAllInstruments();
            }           
        } else {
	        Session.set('startdac', 0);
        }
        return Session.get('startdac');         
    }      
});

Template.playgroundItem.helpers({
    'instrument': function(instrument) {
        var machine = MusicMachine.findOne();
        if(machine) {
            if(machine[instrument].status === 1) {
                playInstrument(instrument, machine[instrument].volume);	
            } else if(machine[instrument].status === 0) {		
                stopInstrument(instrument);			
            }
        } else {
	        Session.set(instrument, 0);
        }
        return Session.get(instrument);
    },
    'sliderSpeed': function(instrument) { 
        var machine = MusicMachine.findOne();
        if(machine && machine[instrument].status === 1) {
			$('.speed-slider[data-instrument=' + instrument + ']').data('uiSlider').value(machine[instrument].speed);
            setSpeedInstrument(instrument, machine[instrument].speed/50);
            return machine[instrument].speed;
        } else {
            console.log("Instrument off");
            return 0;
        }
    },
    'sliderVolume': function(instrument) { 
        var machine = MusicMachine.findOne();
        if(machine && machine[instrument].status === 1) {
			$('.volume-slider[data-instrument=' + instrument + ']').data('uiSlider').value(machine[instrument].volume);
            setVolumeInstrument(instrument, machine[instrument].volume/100);
            return machine[instrument].volume;
        }  else {
            console.log("Instrument off");
            return 0;
        }
    }       
});