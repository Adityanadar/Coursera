//index.js

acontext = new webkitAudioContext() || new AudioContext;  

//Now we can create an instance of our waveform generator and play it.

waveform = new Synth(acontext);
var players = [];
var sound_files = ['drums1.wav', 'bassline.wav', 'bassline24bit.wav', 'bassline32bit.wav', 'arp.wav', 'hihat2.wav', 'snaredrum1.wav', 'cymbal1.wav'];

for (var i = 0; i < sound_files.length; i++) {
    var maxim = new Maxim();
	players[i] = maxim.loadFile(sound_files[i]);
	players[i].loop;
}

function Instrument(name, player) {
    this.name = name;
    this.player = player;
    this.action = function(action) {
        switch(action) {
            case 'play':
            default:
                this.player.play();
                break;
            case 'stop':
                this.player.stop();
                break;
        }         
    };
    this.volume = function(volume) {
        this.player.volume(volume);
    };
    this.speed = function(speed) {
        this.player.speed(speed);
    };
}

var instruments = {
    drums: new Instrument('drums', players[0]),
    bassline: new Instrument('bassline', players[1]),
    bassline24bit: new Instrument('bassline24bit', players[2]),
    bassline32bit: new Instrument('bassline32bit', players[3]),
    arp: new Instrument('arp', players[4]),
    hihat: new Instrument('hihat', players[5]),
    snaredrum: new Instrument('snaredrum', players[6]),
    cymbal: new Instrument('cymbal', players[7])    
};

playInstrument = function(instrument, volume){
	instruments[instrument].volume(volume);
}

stopInstrument = function(instrument){
	instruments[instrument].volume(0);
}

playAllInstruments = function() {
    for(instrument in instruments) {
        instruments[instrument].action('play');
    }
}

stopAllInstruments = function() {
    for(instrument in instruments) {
        instruments[instrument].action('stop');
    }
}

setSpeedInstrument = function(instrument, speed) {
    instruments[instrument].speed(speed);    
}

setVolumeInstrument = function(instrument, volume) {
    instruments[instrument].volume(volume);  
}

Router.configure({
	layoutTemplate: 'ApplicationLayout'
});

Router.route('/', function () {
	this.render('navbar', {to: 'navbar'});
	this.render('playground', {to: 'main'});
});

Router.route('/about', function () {
	this.render('navbar-basic', {to: 'navbar'});
	this.render('about', {to: 'main'});
});