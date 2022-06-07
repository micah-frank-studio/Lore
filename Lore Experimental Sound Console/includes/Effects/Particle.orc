giParticleRecBuf1L ftgen	0,0,131072,2,0 
giParticleRecBuf1R ftgen	0,0,131072,2,0
giparticlewin ftgen 0, 0, 8192, 20, 2, 1  ;Hanning window
gkparticlesemitones [] fillarray -24, -12, -10, -9, -8, -7, -5, 0, 2, 3, 4, 5, 7, 12, 24
giEffectNumber = 12 ;set instrument number for triggering in Synth-Host.orc

instr 12, Particle
print p1
        ; set effect icon
        Sicon = sprintfk("Effect_Icon%i", p4)
        ;prints gSEffectDir
        SiconPath = sprintf("\"%s\/%s\"", gSEffectDir, "images/Particle.svg")
        cabbageSet Sicon, sprintf("visible(1), file(\"%s\")", SiconPath)
;prints SiconPath
        Smacro1 = sprintf("EffectMacro1_%i", p4)
        Scombo1 = sprintf("EffectCombo1_%i", p4)
        Smacro2 = sprintf("EffectMacro2_%i", p4)
        Smacro3 = sprintf("EffectMacro3_%i", p4)
        Smacro4 = sprintf("EffectMacro4_%i", p4)
        Smacro5 = sprintf("EffectMacro5_%i", p4)
        Smacro6 = sprintf("EffectMacro6_%i", p4)
           
prints "Particle Delay Loaded\n"
    cabbageSet Smacro1, {{ text("CHOP"),  popupPostfix("Particle") }}
    cabbageSet Smacro2, {{ text("STRETCH"), popupPostfix("Particle") }}
    cabbageSet Smacro3, {{ text("DENSITY"), popupPostfix("Particle") }}
    cabbageSet Smacro4, {{ text("TIME"), popupPostfix("Particle")  }}
    cabbageSet Smacro5, {{ text("FEEDBACK"), popupPostfix("Particle") }}
    cabbageSet Smacro6, {{ text("BLEND"), popupPostfix("Particle") }}
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
        cabbageSetValue Smacro1, 0.2
         cabbageSetValue Smacro2,  0.3
          cabbageSetValue Smacro3, 0.5
            cabbageSetValue Smacro4, 0.7
              cabbageSetValue Smacro5, 0.7
                cabbageSetValue Smacro6, 0.5
    endif

//#INPUT SECTION

/*
iinput = p4
if iinput == 1 then ;if this is the first channel then get input 
	SinputL = "effectsSendL"
	SinputR = "effectsSendR"
else       
                                         ; else get previous channel's effect send
    SinputL = sprintf("effectsChainL%i", iinput-1)
    SinputR = sprintf("effectsChainR%i", iinput-1)
endif

   ainL chnget SinputL
   ainR chnget SinputR
*/

//#INPUT SECTION
    kinput = p4
    kinL = (kinput * 2)-1 
    kinR = kinput * 2 
    ainL zar kinL
    ainR zar kinR
    
;chop also should control sample and hold rate for "Random" control
;Probablity affects chance of grain playing forward or backwards
;LFO controls time stretch Modulation amount. CHop should control rate?

    kchop chnget Smacro1					;Grain Size
    krate chnget Smacro2					;Stretch
    kdens chnget Smacro3					; Grain Frequency (Density)
    ;klength chnget Smacro4				; Length of buffer
    klfo = 0 ; chnget "LFO"
    kdelay chnget Smacro4 ; Delay Time
    kfeedback chnget Smacro5					;Delay Feedback
    kmix chnget Smacro6
    krand = 0 ;chnget "Random"
    kprob = 0 ;chnget "Chance"
	imaxdelay = 2.0 ; seconds
	kamp = 0.5
	ifn = 1 ;
	iolaps = 2 
	ips     = 1/iolaps	
	
	;kpitch scale kpitch, 14, 0
	kdens scale kdens, 20, 2
	
	kdelay scale kdelay, 3000, 1
	kfeedback scale kfeedback, 0.8, 0
	

	/*	
rslider bounds(15, 190, 70, 70), channel("Chop"), text("CHOP/RATE"), range(0, 1, 0.8, 1, 0.001) $KNOB1, popuptext(0)
rslider bounds(105, 190, 70, 70), channel("Pitch"), text("PITCH"), range(0, 14, 7, 1, 1), identchannel("pitchIdent") $KNOB1
rslider bounds(195, 190, 70, 70), channel("Chance"), text("CHANCE"), range(0.001, 1, 0.6, 1, 0.001)  $KNOB1, popuptext(0)

rslider bounds(15, 265, 70, 70), channel("Density"), text("DENSITY"), range(2, 20, 5, 1, 0.001)  $KNOB1, popuptext(0)
rslider bounds(105, 265, 70, 70), channel("Length"), text("LENGTH"), range(0.01, 3, 1, 1, 0.001)  $KNOB1, popuptext(0)
rslider bounds(195, 265, 70, 70), channel("LFO"), text("LFO"), range(0.01, 3, 2, 1, 0.01)  $KNOB1, popuptext(0)
rslider bounds(285, 265, 70, 70), channel("Stretch"), text("STRETCH"), range(0.001, 10, 1, 1, 0.001)  $KNOB1, popuptext(0)
rslider bounds(15, 340, 70, 70), channel("Time"), text("TIME"), range(1, 3000, 1500, 1, 0.01)  $KNOB1, popuptext(0) ;max should be equal to imaxdelay
rslider bounds(105, 340, 70, 70), channel("Feedback"), text("FEEDBACK"), range(0.00, 0.8, 0.25, 1, 0.001)  $KNOB1, popuptext(0)
rslider bounds(195, 340, 70, 70), channel("Random"), text("RANDOM"), range(0, 1, 0, 1, 0.001)  $KNOB1, popuptext(0) ;2 seconds max at 96k. this is dependent on buffer table length!
rslider bounds(285, 340, 70, 70), channel("Blend"), text("BLEND"), range(0.00, 1, 0.2, 0.5, 0.001)  $KNOB1, popuptext(0)
rslider bounds(375, 340, 70, 70), channel("Output"), text("OUTPUT"), range(0.00, 2, 0.5, 0.5, 0.001)  $KNOB1, popuptext(0)
*/	
	itablelength = ftlen(giParticleRecBuf1L)

	kndx = (1/(itablelength/gisr)) ;speed calculation for phasor
	andx		phasor kndx
	tablew   ainL, andx, giParticleRecBuf1L,1 ; write audio to function table
 	tablew   ainR, andx, giParticleRecBuf1R,1 ; write audio to function table
 		
    kchop portk kchop, 0.01
	
	klstart = 0
	klforate scale 5, 0.01, kchop
	kdir randh 1, klforate, 2
	kdir = abs(kdir)
	
	kgrsize scale 1, 0.1, kchop
	 
	ips     = 1/iolaps
	kprand randh krand, klforate
	kpmod = round(abs(14*kprand))
    
    klength = 1
	kmod lfo klfo, klforate
	kmod portk kmod, 0.01
	klengthmod = klength*abs(kmod)

	ifn = giparticlewin
    agrainL syncloop 0.8, kdens, 1, kgrsize, krate, klstart, klength-klengthmod, giParticleRecBuf1L, ifn, iolaps
	agrainR syncloop 0.8, kdens, 1, kgrsize, krate, klstart, klength-klengthmod, giParticleRecBuf1R, ifn, iolaps

    ;mute for delay line to avoid noice when changing delay in realtime
    if changed:k(kdelay) == 1 then
        kDelayGain = 0
    endif
    
    ;kDelayTime = (kbeat*0.25)*1000 ;milliseconds
    ;delay method 
    kdelayp portk kdelay, 0.01
    aDelayL vdelay agrainL, kdelayp, 5001
    aDelayL = aDelayL*kDelayGain
    aDelayR vdelay agrainR, kdelayp*0.97, 5001
    aDelayR = aDelayR*kDelayGain

    kDelayGain = kDelayGain<1 ? kDelayGain+.0001 : 1
    
    ;add feedback
    aDelMixL = agrainL+(aDelayL*kfeedback)
    aDelMixR = agrainR+(aDelayR*kfeedback)

	amixL ntrpol ainL, aDelMixL, kmix
	amixR ntrpol ainR, aDelMixR, kmix

	//# Send section
	koutL = (kinput * 2) + 1
	koutR = (kinput * 2) + 2
	zaw amixL, koutL
	zaw amixR, koutR

	zacl kinL, kinR
	
	giEffectDefault = 1 ; set back to load effect defaults
	
	

endin

