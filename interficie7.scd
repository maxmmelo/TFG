s.quit;
s.boot;
Platform.systemExtensionDir;

SynthDef.new(\bin6, {
	arg out = 0, buf, coarse = #[0,0,0,0,0,0], amp = 1;
	var sigL, sigR, source, sumL, sumR, sig, bl0, br0, bl180, br180, bl90, br90, bl270, br270, bltop, brtop, blbot, brbot;

	bl0 = Buffer.read(s, Platform.userExtensionDir ++ "/HRTFnova/0az0el_left.wav");
	br0 = Buffer.read(s, Platform.userExtensionDir ++ "/HRTFnova/0az0el_right.wav");

	bl90 = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/90az0el_left.wav");
	br90 = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/90az0el_right.wav");

	bl180 = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/180az0el_left.wav");
	br180 = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/180az0el_right.wav");

	bl270 = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/270az0el_left.wav");
	br270 = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/270az0el_right.wav");

	bltop = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/0az90el_left.wav");
	brtop = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/0az90el_right.wav");

	blbot = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/0azneg45el_left.wav");
	brbot = Buffer.read(s,Platform.userExtensionDir ++ "/HRTFnova/0azneg45el_right.wav");

	sig = buf;

	source = PlayBuf.ar(numChannels: 1, bufnum: sig)*coarse[0]*amp;

	sumL = Convolution2.ar(source, bl0,0,256, 1);
	sumR = Convolution2.ar(source, br0,0,256, 1);

	source = PlayBuf.ar(numChannels: 1, bufnum: sig)*coarse[1]*amp;

	sigL = Convolution2.ar(source, bl180,0,256, 1);
	sigR = Convolution2.ar(source, br180,0,256, 1);

	sumL = sumL + sigL;
	sumR = sumR + sigR;

	source = PlayBuf.ar(numChannels: 1, bufnum: sig)*coarse[2]*amp;

	sigL = Convolution2.ar(source, bl90,0,256, 1);
	sigR = Convolution2.ar(source, br90,0,256, 1);

	sumL = sumL + sigL;
	sumR = sumR + sigR;

	source = PlayBuf.ar(numChannels: 1, bufnum: sig)*coarse[3]*amp;

	sigL = Convolution2.ar(source, bl270,0,256, 1);
	sigR = Convolution2.ar(source, br270,0,256, 1);

	sumL = sumL + sigL;
	sumR = sumR + sigR;

	source = PlayBuf.ar(numChannels: 1, bufnum: sig)*coarse[4]*amp;

	sigL = Convolution2.ar(source, bltop,0,256, 1);
	sigR = Convolution2.ar(source, brtop,0,256, 1);

	sumL = sumL + sigL;
	sumR = sumR + sigR;

	source = PlayBuf.ar(numChannels: 1, bufnum: sig)*coarse[5]*amp;

	sigL = Convolution2.ar(source, blbot,0,256, 1);
	sigR = Convolution2.ar(source, brbot,0,256, 1);

	sumL = sumL + sigL;
	sumR = sumR + sigR;

	Out.ar(out, [sumL, sumR]);
}).add;

SynthDef(\reverb, {
		|in, predelay = 1, revtime = 5, lpf = 400, mix = 0.5, amp = 1, out = 0|
		var dry, wet, temp, sig;
		dry = In.ar(in, 2);
	    temp = In.ar(in, 2);
		wet =0 ;
		temp = DelayN.ar(temp, 0.2, predelay);
	    temp = AllpassN.ar(temp, 0.05, 0.001,revtime);
		temp = LPF.ar(temp, lpf);
		wet = wet + wet + temp;
		sig = XFade2.ar(dry, wet, mix*2-1, amp * 2 / 3);
	    Out.ar(out, sig);
}).add;



(
Window.closeAll;
~encoder = SWFEncoder.new();
~coarsing =  ~encoder.getCoarses_lvl0(0,0);

// Rect: x, y, tamany_X, tamany_Y)
// Creem el fondo
w = Window.new("GUI", Rect.new(Window.screenBounds.width/2-200,
	Window.screenBounds.height/2-300,620,690)).front;
w.alwaysOnTop = true;


//botó play
~playButton = Button.new(w.view, Rect(20,20,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["STOP", Color.black, Color.red],
	["PLAY", Color.black, Color.green]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			x = Synth.new(\bin6, [\amp, 0, \buf, ~sound1.bufnum,	\coarse, ~coarsing]).register;
			y = Synth.new(\bin6, [\amp, 0, \buf, ~sound2.bufnum,	\coarse, ~coarsing]).register;
			z = Synth.new(\bin6, [\amp, 0, \buf, ~sound3.bufnum,	\coarse, ~coarsing]).register;
			t = Synth.new(\bin6, [\amp, 0, \buf, ~sound4.bufnum,	\coarse, ~coarsing]).register;
		},{
			x.free;
			y.free;
			z.free;
			t.free;
		}
	);
});

//Etiquetes
~track1Label = StaticText(w, Rect.new(20,50,55,20))
.string_("Track 1");
~track1Label2 = StaticText(w, Rect.new(170,50,55,20))
.string_("Track 2");
~track1Label3 = StaticText(w, Rect.new(320,50,55,20))
.string_("Track 3");
~track1Label4 = StaticText(w, Rect.new(470,50,55,20))
.string_("Track 4");


//Botons de solo
~soloButton = Button.new(w.view, Rect(20,75,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["S", Color.black],
	["S", Color.black, Color.yellow]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			y.set(\amp, 0);
			z.set(\amp, 0);
			t.set(\amp, 0);
		},{
			y.set(\amp, ~volumeSlider2.value.linlin(0,1,0,6));
			z.set(\amp, ~volumeSlider3.value.linlin(0,1,0,6));
			t.set(\amp, ~volumeSlider4.value.linlin(0,1,0,6));
		}
	);
});
~soloButton2 = Button.new(w.view, Rect(170,75,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["S", Color.black],
	["S", Color.black, Color.yellow]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			x.set(\amp, 0);
			z.set(\amp, 0);
			t.set(\amp, 0);
		},{
			x.set(\amp, ~volumeSlider.value.linlin(0,1,0,6));
			z.set(\amp, ~volumeSlider3.value.linlin(0,1,0,6));
			t.set(\amp, ~volumeSlider4.value.linlin(0,1,0,6));
		}
	);
});
~soloButton3 = Button.new(w.view, Rect(320,75,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["S", Color.black],
	["S", Color.black, Color.yellow]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			x.set(\amp, 0);
			y.set(\amp, 0);
			t.set(\amp, 0);
		},{
			x.set(\amp, ~volumeSlider.value.linlin(0,1,0,6));
			y.set(\amp, ~volumeSlider2.value.linlin(0,1,0,6));
			t.set(\amp, ~volumeSlider4.value.linlin(0,1,0,6));
		}
	);
});
~soloButton4 = Button.new(w.view, Rect(470,75,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["S", Color.black],
	["S", Color.black, Color.yellow]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			x.set(\amp, 0);
			y.set(\amp, 0);
			z.set(\amp, 0);
		},{
			x.set(\amp, ~volumeSlider.value.linlin(0,1,0,6));
			y.set(\amp, ~volumeSlider2.value.linlin(0,1,0,6));
			z.set(\amp, ~volumeSlider3.value.linlin(0,1,0,6));
		}
	);
});

//Botons de mute
~muteButton = Button.new(w.view, Rect(75,75,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["M", Color.black],
	["M", Color.black, Color.yellow]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			x.set(\amp, 0);
		},{
			x.set(\amp, ~volumeSlider.value.linlin(0,1,0,6));

		}
	);
});
~muteButton2 = Button.new(w.view, Rect(225,75,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["M", Color.black],
	["M", Color.black, Color.yellow]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			y.set(\amp, 0);
		},{
			y.set(\amp, ~volumeSlider2.value.linlin(0,1,0,6));
		}
	);
});
~muteButton3 = Button.new(w.view, Rect(375,75,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["M", Color.black],
	["M", Color.black, Color.yellow]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			z.set(\amp, 0);
		},{
			z.set(\amp, ~volumeSlider3.value.linlin(0,1,0,6));

		}
	);
});
~muteButton4 = Button.new(w.view, Rect(525,75,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["M", Color.black],
	["M", Color.black, Color.yellow]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			t.set(\amp, 0);
		},{
			t.set(\amp, ~volumeSlider4.value.linlin(0,1,0,6));
		}
	);
});



//Etiquetes azimut panning
~azimutLabel = StaticText(w, Rect.new(20,110,80,20))
.string_("Azimut Panner");
~azimutLabel2 = StaticText(w, Rect.new(170,110,80,20))
.string_("Azimut Panner");
~azimutLabel3 = StaticText(w, Rect.new(320,110,80,20))
.string_("Azimut Panner");
~azimutLabel4 = StaticText(w, Rect.new(470,110,80,20))
.string_("Azimut Panner");


//Potenciòmetre azimut
~azimutKnob = Knob.new(w.view, Rect.new(20,130,50,50))
.action_({
	arg obj;
	var angle;
	angle = obj.value.linlin(0,1,-180,180);
	//~elevationSlider.value.linlin(0,1,-45,90).postln;
	~coarsingA =  ~encoder.getCoarses_lvl0(angle, ~elevationSlider.value.linlin(0,1,-45,90));
	if(
		x.isPlaying,
		{x.set(\coarse, ~coarsingA)}
	);
	~numberBox.value_(obj.value.linlin(0,1,-180,180));
});
~azimutKnob2 = Knob.new(w.view, Rect.new(170,130,50,50))
.action_({
	arg obj;
	var angle;
	angle = obj.value.linlin(0,1,-180,180);
	//~elevationSlider.value.linlin(0,1,-45,90).postln;
	~coarsingA2 =  ~encoder.getCoarses_lvl0(angle, ~elevationSlider2.value.linlin(0,1,-45,90));
	if(
		y.isPlaying,
		{y.set(\coarse, ~coarsingA2)}
	);
	~numberBox2.value_(obj.value.linlin(0,1,-180,180));
});
~azimutKnob3 = Knob.new(w.view, Rect.new(320,130,50,50))
.action_({
	arg obj;
	var angle;
	angle = obj.value.linlin(0,1,-180,180);
	//~elevationSlider.value.linlin(0,1,-45,90).postln;
	~coarsingA3 =  ~encoder.getCoarses_lvl0(angle, ~elevationSlider3.value.linlin(0,1,-45,90));
	if(
		z.isPlaying,
		{z.set(\coarse, ~coarsingA3)}
	);
	~numberBox3.value_(obj.value.linlin(0,1,-180,180));
});
~azimutKnob4 = Knob.new(w.view, Rect.new(470,130,50,50))
.action_({
	arg obj;
	var angle;
	angle = obj.value.linlin(0,1,-180,180);
	//~elevationSlider.value.linlin(0,1,-45,90).postln;
	~coarsingA4 =  ~encoder.getCoarses_lvl0(angle, ~elevationSlider4.value.linlin(0,1,-45,90));
	if(
		t.isPlaying,
		{t.set(\coarse, ~coarsingA4)}
	);
	~numberBox4.value_(obj.value.linlin(0,1,-180,180));
});


//Etiquetes nombre de l'elevation
~azimutNumber = StaticText(w, Rect.new(20,190,80,30))
.string_("Azimut        number:");
~azimutNumber2 = StaticText(w, Rect.new(170,190,80,30))
.string_("Azimut        number:");
~azimutNumber3 = StaticText(w, Rect.new(320,190,80,30))
.string_("Azimut        number:");
~azimutNumber4 = StaticText(w, Rect.new(470,190,80,30))
.string_("Azimut        number:");


~numberBox = NumberBox.new((w.view), Rect.new(100,190,30,30))
.value_(-180)
.clipLo_(-180)
.clipHi_(180)
.decimals_(0)
.action_({
	arg obj;
	~azimutKnob.valueAction_(obj.value.linlin(-180,180,0,1))
});
~numberBox2 = NumberBox.new((w.view), Rect.new(250,190,30,30))
.value_(-180)
.clipLo_(-180)
.clipHi_(180)
.decimals_(0)
.action_({
	arg obj;
	~azimutKnob2.valueAction_(obj.value.linlin(-180,180,0,1))
});
~numberBox3 = NumberBox.new((w.view), Rect.new(400,190,30,30))
.value_(-180)
.clipLo_(-180)
.clipHi_(180)
.decimals_(0)
.action_({
	arg obj;
	~azimutKnob3.valueAction_(obj.value.linlin(-180,180,0,1))
});
~numberBox4 = NumberBox.new((w.view), Rect.new(550,190,30,30))
.value_(-180)
.clipLo_(-180)
.clipHi_(180)
.decimals_(0)
.action_({
	arg obj;
	~azimutKnob4.valueAction_(obj.value.linlin(-180,180,0,1))
});


//Etiqueta elevation panning
~elevationLabel = StaticText(w, Rect.new(20,230,80,30))
.string_("Elevation Panner");
~elevationLabel2 = StaticText(w, Rect.new(170,230,80,30))
.string_("Elevation Panner");
~elevationLabel3 = StaticText(w, Rect.new(320,230,80,30))
.string_("Elevation Panner");
~elevationLabel4 = StaticText(w, Rect.new(470,230,80,30))
.string_("Elevation Panner");


//Potenciòmetre elevation panning
~elevationSlider = Slider.new(w.view, Rect.new(20,270,20,60))
.action_({
	arg obj;
	var angle;
	angle = obj.value.linlin(0,1,-45,90);
	~coarsing =  ~encoder.getCoarses_lvl0(~azimutKnob.value.linlin(0,1,-180,180),angle);
	//~azimutKnob.value.linlin(0,1,-180,180).postln;
	if(
		x.isPlaying,
		{x.set(\coarse, ~coarsing)}
	);
	~numberElevation.value_(obj.value.linlin(0,1,-180,180));
});
~elevationSlider2 = Slider.new(w.view, Rect.new(170,270,20,60))
.action_({
	arg obj;
	var angle;
	angle = obj.value.linlin(0,1,-45,90);
	~coarsing2 =  ~encoder.getCoarses_lvl0(~azimutKnob2.value.linlin(0,1,-180,180),angle);
	//~azimutKnob.value.linlin(0,1,-180,180).postln;
	if(
		y.isPlaying,
		{y.set(\coarse, ~coarsing2)}
	);
	~numberElevation2.value_(obj.value.linlin(0,1,-180,180));
});
~elevationSlider3 = Slider.new(w.view, Rect.new(320,270,20,60))
.action_({
	arg obj;
	var angle;
	angle = obj.value.linlin(0,1,-45,90);
	~coarsing3 =  ~encoder.getCoarses_lvl0(~azimutKnob3.value.linlin(0,1,-180,180),angle);
	//~azimutKnob.value.linlin(0,1,-180,180).postln;
	if(
		z.isPlaying,
		{z.set(\coarse, ~coarsing3)}
	);
	~numberElevation3.value_(obj.value.linlin(0,1,-180,180));
});
~elevationSlider4 = Slider.new(w.view, Rect.new(470,270,20,60))
.action_({
	arg obj;
	var angle;
	angle = obj.value.linlin(0,1,-45,90);
	~coarsing4 =  ~encoder.getCoarses_lvl0(~azimutKnob4.value.linlin(0,1,-180,180),angle);
	//~azimutKnob.value.linlin(0,1,-180,180).postln;
	if(
		t.isPlaying,
		{t.set(\coarse, ~coarsing4)}
	);
	~numberElevation4.value_(obj.value.linlin(0,1,-180,180));
});

//Etiqueta nombre d'elevation
~elevationLabel = StaticText(w, Rect.new(20,340,80,30))
.string_("Elevation number:");
~elevationLabel2 = StaticText(w, Rect.new(170,340,80,30))
.string_("Elevation number:");
~elevationLabel3 = StaticText(w, Rect.new(320,340,80,30))
.string_("Elevation number:");
~elevationLabel4 = StaticText(w, Rect.new(470,340,80,30))
.string_("Elevation number:");


//Nombre d'elevation
~numberElevation = NumberBox.new((w.view), Rect.new(100,340,30,30))
.value_(0)
.clipLo_(-45)
.clipHi_(90)
.decimals_(0)
.action_({
	arg obj;
	~elevationSlider.valueAction_(obj.value.linlin(-45,90,0,1))
});
~numberElevation2 = NumberBox.new((w.view), Rect.new(250,340,30,30))
.value_(0)
.clipLo_(-45)
.clipHi_(90)
.decimals_(0)
.action_({
	arg obj;
	~elevationSlider2.valueAction_(obj.value.linlin(-45,90,0,1))
});
~numberElevation3 = NumberBox.new((w.view), Rect.new(400,340,30,30))
.value_(0)
.clipLo_(-45)
.clipHi_(90)
.decimals_(0)
.action_({
	arg obj;
	~elevationSlider3.valueAction_(obj.value.linlin(-45,90,0,1))
});
~numberElevation4 = NumberBox.new((w.view), Rect.new(550,340,30,30))
.value_(0)
.clipLo_(-45)
.clipHi_(90)
.decimals_(0)
.action_({
	arg obj;
	~elevationSlider4.valueAction_(obj.value.linlin(-45,90,0,1))
});



//Etiquetes volum
~volumeLabel = StaticText(w, Rect.new(20,380,340,15))
.string_("Volume:");
~volumeLabel2 = StaticText(w, Rect.new(170,380,340,15))
.string_("Volume:");
~volumeLabel3 = StaticText(w, Rect.new(320,380,340,15))
.string_("Volume:");
~volumeLabel4 = StaticText(w, Rect.new(470,380,340,15))
.string_("Volume:");


~volumeSlider = Slider.new(w.view, Rect.new(20,405,80,20))
.action_({
	arg obj;
	if(
		x.isPlaying,
		{x.set(\amp, obj.value.linlin(0,1,0,10))}
	);
});

~volumeSlider2 = Slider.new(w.view, Rect.new(170,405,80,20))
.action_({
	arg obj;
	if(
		y.isPlaying,
		{y.set(\amp, obj.value.linlin(0,1,0,10))}
	);
});
~volumeSlider3 = Slider.new(w.view, Rect.new(320,405,80,20))
.action_({
	arg obj;
	if(
		z.isPlaying,
		{z.set(\amp, obj.value.linlin(0,1,0,10))}
	);
});

~volumeSlider4 = Slider.new(w.view, Rect.new(470,405,80,20))
.action_({
	arg obj;
	if(
		t.isPlaying,
		{t.set(\amp, obj.value.linlin(0,1,0,10))}
	);
});


//Reverb bus
~reverbBus = Bus.audio(s,2);
~reverbSynth = Synth.new(\reverb, [\in, ~reverbBus]);
~reverbSynth2 = Synth.new(\reverb, [\in, ~reverbBus]);
~reverbSynth3 = Synth.new(\reverb, [\in, ~reverbBus]);
~reverbSynth4 = Synth.new(\reverb, [\in, ~reverbBus]);


//Etiquetes reverb
~volumeLabel = StaticText(w, Rect.new(20,435,80,15))
.string_("Reverb:");
~volumeLabel2 = StaticText(w, Rect.new(170,435,80,15))
.string_("Reverb:");
~volumeLabel = StaticText(w, Rect.new(320,435,80,15))
.string_("Reverb:");
~volumeLabel2 = StaticText(w, Rect.new(470,435,80,15))
.string_("Reverb:");

//botó Reverb
~buttonReverb = Button.new(w.view, Rect(20,460,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["OFF", Color.black, Color.gray],
	["ON", Color.black, Color.gray]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{

			x.set(\out,~reverbBus);
		},{
			x.set(\out, 0);

		}
	);
});
~buttonReverb2 = Button.new(w.view, Rect(170,460,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["OFF", Color.black, Color.gray],
	["ON", Color.black, Color.gray]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{

			y.set(\out,~reverbBus);
		},{
			y.set(\out, 0);

		}
	);
});
~buttonReverb3 = Button.new(w.view, Rect(320,460,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["OFF", Color.black, Color.gray],
	["ON", Color.black, Color.gray]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{

			z.set(\out,~reverbBus);
		},{
			z.set(\out, 0);

		}
	);
});

~buttonReverb4 = Button.new(w.view, Rect(470,460,25,25))
.font_(Font("Helvetica", 8))
.states_([
	["OFF", Color.black, Color.gray],
	["ON", Color.black, Color.gray]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{

			t.set(\out,~reverbBus);
		},{
			t.set(\out, 0);

		}
	);
});

//Etiquetes wet-dry
~wetdryLabel = StaticText(w, Rect.new(20,495,80,15))
.string_("Dry - Wet:");
~wetdryLabel2 = StaticText(w, Rect.new(170,495,80,15))
.string_("Dry - Wet:");
~wetdryLabel3 = StaticText(w, Rect.new(320,495,80,15))
.string_("Dry - Wet:");
~wetdryLabel4 = StaticText(w, Rect.new(470,495,80,15))
.string_("Dry - Wet:");


//Potenciometre wet - dry
~wetSlider = Slider.new(w.view, Rect.new(20,520,80,20))
.action_({
	arg obj;
	if(
		x.isPlaying,
		{~reverbSynth.set(\mix, obj.value.linlin(0,1,0.5,1))}
	);
});
~wetSlider2 = Slider.new(w.view, Rect.new(170,520,80,20))
.action_({
	arg obj;
	if(
		x.isPlaying,
		{~reverbSynth2.set(\mix, obj.value.linlin(0,1,0.5,1))}
	);
});
~wetSlider3 = Slider.new(w.view, Rect.new(320,520,80,20))
.action_({
	arg obj;
	if(
		z.isPlaying,
		{~reverbSynth3.set(\mix, obj.value.linlin(0,1,0.5,1))}
	);
});
~wetSlider4 = Slider.new(w.view, Rect.new(470,520,80,20))
.action_({
	arg obj;
	if(
		t.isPlaying,
		{~reverbSynth4.set(\mix, obj.value.linlin(0,1,0.5,1))}
	);
});


//Etiquetes LPF
~wetdryyLabel1 = StaticText(w, Rect.new(20,550,80,15))
.string_("Low Pass:");
~wetdryyLabel2 = StaticText(w, Rect.new(170,550,80,15))
.string_("Low Pass:");
~wetdryyLabel3 = StaticText(w, Rect.new(320,550,80,15))
.string_("Low Pass:");
~wetdryyLabel4 = StaticText(w, Rect.new(470,550,80,15))
.string_("Low Pass:");


//LPF
~wetdryySlider = Slider.new(w.view, Rect.new(20,575,80,20))
.action_({
	arg obj;
	if(
		x.isPlaying,
		{~reverbSynth.set(\lpf, obj.value.linlin(0,1,100,1000))}
	);
});
~wetdryySlider2 = Slider.new(w.view, Rect.new(170,575,80,20))
.action_({
	arg obj;
	if(
		x.isPlaying,
		{~reverbSynth2.set(\lpf, obj.value.linlin(0,1,100,1000))}
	);
});
~wetdryySlider3 = Slider.new(w.view, Rect.new(320,575,80,20))
.action_({
	arg obj;
	if(
		z.isPlaying,
		{~reverbSynth3.set(\lpf, obj.value.linlin(0,1,100,1000))}
	);
});
~wetdryySlider4 = Slider.new(w.view, Rect.new(470,575,80,20))
.action_({
	arg obj;
	if(
		t.isPlaying,
		{~reverbSynth4.set(\lpf, obj.value.linlin(0,1,100,1000))}
	);
});


//Etiquetes Load
~loadSong = StaticText(w, Rect.new(20, 605, 150, 15))
.string_("Load track:");
~loadSong2 = StaticText(w, Rect.new(170, 605, 150, 15))
.string_("Load track:");
~loadSong = StaticText(w, Rect.new(320, 605, 150, 15))
.string_("Load track:");
~loadSong2 = StaticText(w, Rect.new(470, 605, 150, 15))
.string_("Load track:");


//Drags d'audio
~dropAudio = DragSink(w, Rect(20, 630, 130, 20));
~dropAudio.receiveDragHandler = {arg obj; obj.object = View.currentDrag.shellQuote};
~dropAudio2 = DragSink(w, Rect(170, 630, 130, 20));
~dropAudio2.receiveDragHandler = {arg obj; obj.object = View.currentDrag.shellQuote};
~dropAudio3 = DragSink(w, Rect(320, 630, 130, 20));
~dropAudio3.receiveDragHandler = {arg obj; obj.object = View.currentDrag.shellQuote};
~dropAudio4 = DragSink(w, Rect(470, 630, 130, 20));
~dropAudio4.receiveDragHandler = {arg obj; obj.object = View.currentDrag.shellQuote};


//Buffer
~load = Button.new(w.view, Rect(20, 650, 130, 20))
.states_([
	["LOAD", Color.black, Color.red],
	["XD", Color.black, Color.green]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			~dropAudio.string.postln;
			~sound1 = Buffer.read(s,~dropAudio.string.replace("'",""));
			//~sound1 = Buffer.read(s,"C:/Users/kiko/Downloads/Nueva carpeta/baix.wav");
		},~sound1 = Buffer.free;
	);
});
~load2 = Button.new(w.view, Rect(170, 650, 130, 20))
.states_([
	["LOAD", Color.black, Color.red],
	["XD", Color.black, Color.green]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			~dropAudio2.string.postln;
			~sound2 = Buffer.read(s,~dropAudio2.string.replace("'",""));
			//~sound2 = Buffer.read(s,"C:/Users/kiko/Downloads/Nueva carpeta/drums.wav");
		},~sound2 = Buffer.free;
	);
});
~load3 = Button.new(w.view, Rect(320, 650, 130, 20))
.states_([
	["LOAD", Color.black, Color.red],
	["XD", Color.black, Color.green]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			~dropAudio3.string.postln;
			~sound3 = Buffer.read(s,~dropAudio3.string.replace("'",""));
			//~sound3 = Buffer.read(s,"C:/Users/kiko/Downloads/Nueva carpeta/piano.wav");
		},~sound3 = Buffer.free;
	);
});
~load4 = Button.new(w.view, Rect(470, 650, 130, 20))
.states_([
	["LOAD", Color.black, Color.red],
	["XD", Color.black, Color.green]])
.action_({
	arg obj;
	if(
		obj.value == 1,
		{
			~dropAudio4.string.postln;
			~sound4 = Buffer.read(s,~dropAudio4.string.replace("'",""));
			//~sound4 = Buffer.read(s,"C:/Users/kiko/Downloads/Nueva carpeta/veu.wav");
		},~sound4 = Buffer.free;
	);
});

s.meter;

);

