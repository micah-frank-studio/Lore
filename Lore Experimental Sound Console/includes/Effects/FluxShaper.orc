
;FLUXSHAPER

giEffectNumber = 17 ;set instrument number for triggering in Synth-Host.orc
instr 17, FluxShaper
        Smacro1 = sprintf("EffectMacro1_%i", p4)
        Scombo1 = sprintf("EffectCombo1_%i", p4)
        Smacro2 = sprintf("EffectMacro2_%i", p4)
        Smacro3 = sprintf("EffectMacro3_%i", p4)
        Smacro4 = sprintf("EffectMacro4_%i", p4)
        Smacro5 = sprintf("EffectMacro5_%i", p4)
        Smacro6 = sprintf("EffectMacro6_%i", p4)
    
    prints "FluxShaper Loaded\n"
    
    cabbageSet Smacro1, {{ text("DEPTH"), popupPostfix("FluxShaper") }}
    cabbageSet Smacro2, {{ text("RATE"), popupPostfix("FluxShaper")  }}
    cabbageSet Smacro3, {{ text("FLUX"),  popupPostfix("FluxShaper")   }}
    cabbageSet Smacro4, {{ text("BRIDGE"), popupPostfix("FluxShaper")  }}
    cabbageSet Smacro5, {{ text("RANGE"),  popupPostfix("FluxShaper")  }}
    cabbageSet Smacro6, {{ text("MOTION"), popupPostfix("FluxShaper")  }}
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
        cabbageSetValue Smacro1, 0.3
         cabbageSetValue Smacro2,  0.3
          cabbageSetValue Smacro3, 0.2
            cabbageSetValue Smacro4, 0.1
              cabbageSetValue Smacro5, 0.2
                cabbageSetValue Smacro6, 0.3
    endif
    
kdiv chnget Smacro5 ;range
kmanrate chnget Smacro2;rate
kanim chnget Smacro6 ;Motion
kdepth chnget Smacro1 ;Depth
kflux chnget Smacro3 ;Flux
koc chnget Smacro4 ;Bridge

kdepth scale kdepth, 1, 0.001
kmanrate scale kmanrate, 10, 0.005
kflux scale kflux, 1, 0.001
koc scale koc, 10, 1 

iSkew = 0.5
kfilter = pow(kdiv, 1/iSkew)
kfilter scale kfilter, 1500, 200


/*
rslider bounds(15, 195, 80, 80), channel("Amount"), text("AMOUNT"), range(0.001, 1, 0.3, 1, 0.001), popupText(0), $KNOB1 
rslider bounds(165, 195, 80, 80), channel("ManRate"), text("RATE"), range(0.005, 10, 3, 1, 0.001), popupText(0), $KNOB1 
rslider bounds(315, 195, 80, 80), channel("Flux"), text("FLUX"), range(0.001,1, 0.2, 1, 0.001), popupText(0), $KNOB1 ;trackerColour(32,185,218)
rslider bounds(15, 310, 80, 80), channel("Overclock"), text("OVERCLOCK"), range(1, 10, 1, 1, 1), popupText(0), $KNOB1
rslider bounds(115, 310, 80, 80), channel("Crossover"), text("CROSSOVER"), range(200, 1500, 500, 0.5, 1), $KNOB1 ;trackerColour(32,185,218)
rslider bounds(215, 310, 80, 80), channel("Animate"), text("ANIMATE"), range(0, 1, 0.3, 1, 0.001), popupText(0) $KNOB1 ;trackerColour(32,185,218)
*/


;kbpm = 60
;kbeat = kbpm/60

;kbeatfactor[] fillarray 0.25, 0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16

//#INPUT SECTION
    kinput = p4
    kinL = (kinput * 2)-1 
    kinR = kinput * 2 
    ainL zar kinL
    ainR zar kinR

 

;if kmode == 2 then
       ; cabbageSet metro(20), "ManRate", "visible(0)"
       ; cabbageSet metro(20),"SyncRate", "visible(1)"
       ; krate = kbeat*kbeatfactor[ksyncrate]
;elseif kmode == 1 then
       ; cabbageSet metro(20), "ManRate", "visible(1)"
       ; cabbageSet metro(20), "SyncRate", "visible(0)"
        ;krate = kmanrate
;endif

kfluxlfo lfo kflux, kmanrate*0.8
kdepth = kdepth-(kdepth*kfluxlfo) 
kmanrate = kmanrate*koc
;if kshape == 1 then
    iwave = 1    ; triangle
    ;kdisplfo lfo kdepth*0.5, 300*kmanrate, iwave
    kmod lfo kdepth, kmanrate, iwave
/*elseif kshape == 2 then
    iwave = 4     ;sawtooth
    kdisplfo lfo kdepth*0.5, 300*krate, iwave
    kmod lfo kdepth, krate, iwave
elseif kshape ==  3 then
    iwave = 3  ;square
    kdisplfo lfo kdepth*0.5, 300*krate, iwave
    kmod lfo kdepth, krate, iwave
elseif kshape = 4 then             
    kmod randi kdepth, krate ;random
    kdisplfo randi kdepth*0.5, 300*krate ;random
endif
*/

kanimlfo lfo kanim, kmanrate
kmodsmoothed portk kmod, 0.008 ;smooth signal
klfohalf lfo kdepth, (kmanrate*0.5)*koc, 1
;alfo limit alfo, -0.98, 0.98


alpfL butterlp ainL, kdiv-(kdiv*kanimlfo)
alpfR butterlp ainR, kdiv-(kdiv*kanimlfo)
ahpfL butterhp ainL, kdiv-(kdiv*kanimlfo)
ahpfR butterhp ainR, kdiv-(kdiv*kanimlfo)
asigL = alpfL*(1-klfohalf) + ahpfL*(1-kmodsmoothed); modulate low freqs at half speed
asigR = alpfR*(1-klfohalf) + ahpfR*(1-kmodsmoothed)
        
    	//# Send section
	koutL = (kinput * 2) + 1
	koutR = (kinput * 2) + 2
	zaw asigL, koutL
	zaw asigR, koutR

	zacl kinL, kinR
	giEffectDefault = 1 ; set back to load effect defaults
  
endin