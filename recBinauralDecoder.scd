s.quit;
s.boot;
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

x = SWFEncoder.new();
c = x.getCoarses_lvl0(0,-90);
~veu = Buffer.read(s,"D:/UNI/4t/TFG/musica/veu.wav");

Routine({
	s.record(duration: 80);
	wait(0.02);
	x = Synth.new(\bin6, [\buf, ~veu, \coarse, c]);
}).play;

s.stopRecording;
