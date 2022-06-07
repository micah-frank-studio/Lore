giEffectNumber = 11 ;set instrument number for triggering in Synth-Host.orc
giCassetteBuf1L ftgen    0,0,131072,2,0
giCassetteBuf1R ftgen    0,0,131072,2,0

instr 11, Cassette

print p1
        ; set effect icon
        Sicon = sprintfk("Effect_Icon%i", p4)
        ;prints gSEffectDir
        SiconPath = sprintf("\"%s\/%s\"", gSEffectDir, "images/Cassette.svg")
        cabbageSet Sicon, sprintf("visible(1), file(\"%s\")", SiconPath)
        
        Smacro1 = sprintfk("EffectMacro1_%i", p4)
        Scombo1 = sprintf("EffectCombo1_%i", p4)
        Smacro2 = sprintfk("EffectMacro2_%i", p4)
        Smacro3 = sprintfk("EffectMacro3_%i", p4)
        Smacro4 = sprintfk("EffectMacro4_%i", p4)
        Smacro5 = sprintfk("EffectMacro5_%i", p4)
        Smacro6 = sprintfk("EffectMacro6_%i", p4)
      
    prints "Cassette Loaded\n"
    cabbageSet Smacro1, {{ text("AGE"), popupPostfix("Cassette") }}
    cabbageSet Smacro2, {{ text("DIRT"), popupPostfix("Cassette")  }}
    cabbageSet Smacro3, {{ text("DROP"), popupPostfix("Cassette")  }}
    cabbageSet Smacro4, {{ text("SPREAD"),  popupPostfix("Cassette")  }}
    cabbageSet Smacro5, {{ text("OUTPUT"), popupPostfix("Cassette")   }}
    cabbageSet Smacro6, {{ text("--"),  popupPostfix("")  }}
    icomboIsOn = 0
    if icomboIsOn > 0 then
        cabbageSet Scombo1, "visible(1)"
        cabbageSet Smacro1, "visible(0)"
        cabbageSet Smacro3, "visible(0)"
    else 
        cabbageSet Scombo1, "visible(0)"
        cabbageSet Smacro1, "visible(1)"
        cabbageSet Smacro3, "visible(1)"
    endif 
    
 if giEffectDefault > 0 then ;load default values if this is not recalled from a snapshot
        cabbageSetValue Smacro1, 0.5
         cabbageSetValue Smacro2,  0.3
          cabbageSetValue Smacro3, 0.5
            cabbageSetValue Smacro4, 0.5
              cabbageSetValue Smacro5, 0.5
                cabbageSetValue Smacro6, 0.5
    endif

 
//#INPUT SECTION
    kinput = p4
    kinL = (kinput * 2)-1 
    kinR = kinput * 2 
    ainL zar kinL
    ainR zar kinR

kage chnget Smacro1
kcrack chnget Smacro2
kdrop chnget Smacro3
kanim chnget Smacro4
koutput chnget Smacro5
koutput scale koutput, 2, 0


kFadeReadIndex, kFadeGain init 0
kFadeInSamples = sr*0.002 ;seconds to fade
itablelength = ftlen(giCassetteBuf1L)
; fade in/out. follow pointer and fade at greater and less than "kFadeInSamples"
if (kFadeReadIndex < kFadeInSamples) then
            kFadeGain = kFadeReadIndex/(kFadeInSamples)
        elseif (kFadeReadIndex > itablelength - kFadeInSamples) then
            kFadeGain = (itablelength-kFadeReadIndex)/kFadeInSamples
        else
            kFadeGain = 1
        endif


    isr = sr
	kndx = (isr/itablelength) ;speed calculation for phasor
	andx		phasor kndx
	tablew   ainL, andx, giCassetteBuf1L,1 ; write audio to function table
	tablew   ainR, andx, giCassetteBuf1R,1 ; write audio to function table

kFadeReadIndex = itablelength*andx           

imaxpvar = 0.015 ;maximum pitch variation 0 to 1
krandrate random 1, 1 ;trigger kpmod at random rates
kpmod randh kage*imaxpvar, abs(krandrate), 1
kpmod portk abs(kpmod), 0.5 ;interpolate btween pitch vars n seconds
;kampmod randh 1, 1, 2
;kampmod scale kampmod, 0.9, 0.6 ;scale amplitude modulation factor
;kampmod portk kampmod, 0.5 ;interpolate btween vol mod in seconds

adust dust2 0.6*kcrack, 2*kcrack
anoise noise 0.01*kage, -0.4

aSignalL table andx*(1-kpmod), giCassetteBuf1L, 1, 0, 1
aSignalR table andx*(1-kpmod), giCassetteBuf1R, 1, 0, 1

kfclow = (15000*(1-kage))+1000
kfchigh = (400*0.83)*kage
kdist = kage
imaxdelay = 3

aDelayL      vdelay   aSignalL, 0.2, imaxdelay     ; Tap 4
aDelayR      vdelay   aSignalR, 0.2, imaxdelay     ; Tap 4

   ;delayw  aSignalL                         ; Input signal into delay
;add feedback
aDelL = aSignalL+(aDelayL*kanim/23)
aDelR = aSignalL+(aDelayR*kanim/23)
    
alowL lpf18 aDelL, kfclow, 0.1, kdist
alowR lpf18 aDelR, kfclow, 0.1, kdist


alowL2, ahighL, abandL svfilter alowL, kfchigh, 0
alowR2, ahighR, abandR svfilter alowR, kfchigh, 0


aAgedL = (ahighL + anoise*0.3 + adust*0.5)*kFadeGain
aAgedR = (ahighR + anoise*0.3 + adust*0.5)*kFadeGain

imode = 2 ;pwm square
kcps = 6*kdrop ; freq of dropouts
kpw = 0.5 ;+ randh(0.6, 1)

kpulserate = abs(round(randh(1, kdrop*5)))
kmetro  metro kpulserate ;generate pulses at a random rate
kdropfade lineto 1-kmetro, 0.05

amixL =  (aAgedL)*koutput*kdropfade
amixR =  (aAgedR)*koutput*kdropfade
    
 //# Send section
 /*
    if iinput == 4 then ;if this is the last channel then send signal to mixer
	    SbusL = "effectsReturnL"
	    SbusR = "effectsReturnR"
    else                                                ; else send channel to next effect	
	    SbusL = sprintf("effectsChainL%i", p4)
	    SbusR = sprintf("effectsChainR%i", p4)
	endif
*/
	;chnset amixL, SbusL
	;chnset amixR, SbusR

	//# Send section
	koutL = (kinput * 2) + 1
	koutR = (kinput * 2) + 2
	zaw amixL, koutL
	zaw amixR, koutR
	;printks "instr #%f, Input 1 = %i, Output 1 = %i\n", 1, p1, (kinput * 2)-1, koutL
	/*if koutR < gieffectchannels then ;is this the last send in the chain?
	    printk 1, koutR
	    zacl koutL, koutR ; then clear it inline, otherwise it gets cleared in the mixer section in Silo.csd
	endif 
	   */ 
	;zacl koutL, koutR
	zacl kinL, kinR
		

endin

