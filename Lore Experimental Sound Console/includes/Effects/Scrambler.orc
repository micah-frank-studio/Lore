
giEffectNumber = 15 ;set instrument number for triggering in Synth-Host.orc

giScramblerBuf1L ftgen	0,0,131072,2,0 ; 3 seconds at 44.1 khz
giScramblerBuf1R ftgen	0,0,131072,2,0
giScramblerwin ftgen 0, 0, 8192, 20, 2, 1  ;Hanning window

instr 15, Scrambler
print p1
        ; set effect icon
        Sicon = sprintfk("Effect_Icon%i", p4)
        ;prints gSEffectDir
        SiconPath = sprintf("\"%s\/%s\"", gSEffectDir, "images/Scrambler.svg")
        cabbageSet Sicon, sprintf("visible(1), file(\"%s\")", SiconPath)
;prints SiconPath
        Smacro1 = sprintf("EffectMacro1_%i", p4)
        Scombo1 = sprintf("EffectCombo1_%i", p4)
        Smacro2 = sprintf("EffectMacro2_%i", p4)
        Smacro3 = sprintf("EffectMacro3_%i", p4)
        Smacro4 = sprintf("EffectMacro4_%i", p4)
        Smacro5 = sprintf("EffectMacro5_%i", p4)
        Smacro6 = sprintf("EffectMacro6_%i", p4)
           
prints "Scrambler Loaded\n"
    cabbageSet Smacro1, {{ text("FILT TYPE"),  popupPostfix("Scrambler") }}
    cabbageSet Smacro2, {{ text("FILT FREQ"), popupPostfix("Scrambler") }}
    cabbageSet Smacro3, {{ text("PLACEMENT"), popupPostfix("Scrambler") }}
    cabbageSet Smacro4, {{ text("WINDOW"), popupPostfix("Scrambler")  }}
    cabbageSet Smacro5, {{ text("SPEED"), popupPostfix("Scrambler") }}
    cabbageSet Smacro6, {{ text("AMOUNT"), popupPostfix("Scrambler") }}
    icomboIsOn = 0
    if icomboIsOn > 0 then
        cabbageSet Scombo1, "visible(1)"
        cabbageSet Smacro1, "visible(0)"
        cabbageSet Smacro3, "visible(1)"
        cabbageSet Scombo1, {{text("LPF", "HPF", "BPF"), popupPostfix("Scrambler")}}
        cabbageSetValue Scombo1, 1
    else 
        cabbageSet Scombo1, "visible(0)"
        cabbageSet Smacro1, "visible(1)"
        cabbageSet Smacro3, "visible(1)"
    endif 
    
     if giEffectDefault > 0 then ;load default values if this is not recalled from a snapshot
        cabbageSetValue Smacro1, 0.0
         cabbageSetValue Smacro2,  0.8
          cabbageSetValue Smacro3, 0.5
            cabbageSetValue Smacro4, 0.7
              cabbageSetValue Smacro5, 0.7
                cabbageSetValue Smacro6, 0.5
    endif


//#INPUT SECTION
    kinput = p4
   
    kinL = (kinput * 2)-1 
    kinR = kinput * 2 
    ainL zar kinL
    ainR zar kinR
    
kfiltertype chnget Smacro1   
kfilter chnget Smacro2
iSkew = 0.5
kfilter = pow(kfilter, 1/iSkew)
ifreqmax = gisr*0.5
kfilter scale kfilter, 8000, 80
kwindow chnget Smacro4
kwindow scale kwindow, 1, 0.08
kwindowSpeed chnget Smacro5
kwindowSpeed scale kwindowSpeed, 8, 0
kwindowAmount chnget Smacro6

kstart chnget Smacro3
kplacementAmount = rspline(0,1,0.1,4)

itablelength = ftlen(giScramblerBuf1L)
imaxlength = itablelength/sr ; get table length in seconds

    ;isr = sr
	kndx = (1/(itablelength/gisr)) ;speed calculation for phasor
	andx		phasor kndx
	tablew   ainL, andx, giScramblerBuf1L,1 ; write audio to function table
 	tablew   ainR, andx, giScramblerBuf1R,1 ; write audio to function table
 
iolaps = 3
ips     = 1/iolaps

kstr = 1
kamp = 0.6
kdens = 20
kpitch = 1
kgdur = 0.25

kbpm chnget "HOST_BPM"

kwinspline = rspline(0.1,kwindowAmount, 0.01, kwindowSpeed)
kplacespline = rspline(0.1,kplacementAmount, 0.01, kwindowSpeed*0.5)

kplacement = imaxlength*kstart ;kplacement is a scaled version of kstart. kstart only goes from 0 - 1  
kplacement = kplacement - (kplacement*kplacespline)
kwindow = kwindow - (kwindow*kwinspline)
kwindow = (kplacement + kwindow) < imaxlength ? kwindow : (imaxlength - kplacement)+0.1 ; don't let kwindow go beyond total buffer
kloopend = kplacement + kwindow 
kcrossfade = 0.04

		a1L syncloop kamp, kdens, kpitch, kgdur, ips*kstr, kplacement, kloopend, giScramblerBuf1L, giScramblerwin, iolaps
		a1R syncloop kamp, kdens, kpitch, kgdur, ips*kstr, kplacement, kloopend, giScramblerBuf1R, giScramblerwin, iolaps 

alowL, ahighL, abandL svfilter a1L, kfilter, 1
alowR, ahighR, abandR svfilter a1R, kfilter, 1

if kfiltertype < 0.5 then
    afiltersigL ntrpol alowL, abandL, kfiltertype*2
    afiltersigR ntrpol alowR, abandR, kfiltertype*2
else 
    afiltersigL ntrpol abandL, ahighL, (kfiltertype-0.5)*2
    afiltersigR ntrpol abandR, ahighR, (kfiltertype-0.5)*2
endif

amixL = afiltersigL
amixR = afiltersigR
	//# Send section
	koutL = (kinput * 2) + 1
	koutR = (kinput * 2) + 2
	zaw amixL, koutL
	zaw amixR, koutR

	zacl kinL, kinR
	
	giEffectDefault = 1 ; set back to load effect defaults
	
	

endin

