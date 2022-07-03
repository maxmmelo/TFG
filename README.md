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
