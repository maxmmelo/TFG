# TFG
Development of a tool to be able to distribute the sound in the 3D space in real time
# Dependencies:
the SWFEncoder class (https://github.com/quiMkonG/tfg-swf) and the HRTFnova folders and arrays must be in the extensions folder.
# Usage:
Open the program interface 7.
First, run (shift + enter) on the second line of the program (s.boot) to start the SuperCollider server.
Then you need to run both Synth (bin6 and reverb).
Finally, run the rest of the program.
# SC_SynthRecorder:
It contains the Synth used to decode SWF sound to binaural and a function to record any demo.
# offlineBinauralDecoder:
Contains three programs made in python.
binauralDecoder: decodes from SWF to binaural offline.
EncDecBin: given a sound source and a position, encode this source to SWF, decode from SWF to binaural and play it.
ON-OFF comparison: compares the two sound sources.
# SRecs2:
Contains recordings and demos of the decoders.
# utis:
contains various sound sources for using the program.

# TFG
Desenvolupament d'una eina per a poder distribuir espaialment el so a temps real
# Dependències: 
cal tenir dins la carpeta d'extensions la classe SWFEncoder (https://github.com/quiMkonG/tfg-swf) i les carpetes de HRTFnova i matrices.
# Ús: 
Obrir el programa interficie 7.
Primer, córrer (shift+enter) a la segona línia del programa (s.boot) per engegar el servidor de SuperCollider.
A continuació, cal córrer els dos Synth (bin6 i reverb).
Finalment, córrer la resta del programa.
# SC_SynthRecorder:
Conté el Synth utilitzat per descodificar el so de SWF a binaural i una funció per enregistrar qualsevol demo.
# offlineBinauralDecoder:
Conté tres programes fets en python. 
binauralDecoder: descodifica de SWF a binaural de forma offline.
EncDecBin: donada una font sonora i una posició, codifica aquesta font a SWF, descodifica de SWF a binaural i la reprodueix.
comparacióON-OFF: compara les dues fonts sonores.
# SRecs2:
Conté enregistraments i demos dels descodificadors.
# utis:
conté diverses fonts sonores per utilitzar el programa.
