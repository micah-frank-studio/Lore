giEffectNumber = 13 ;set instrument number for triggering in Synth-Host.orc
instr 13, FilterVerb

print p1
        ; set effect icon
        Sicon = sprintf("Effect_Icon%i", p4)
        ;prints gSEffectDir
        SiconPath = sprintf("\"%s\/%s\"", gSEffectDir, "images/FilterVerb.svg")
        cabbageSet Sicon, sprintf("visible(1), file(\"%s\")", SiconPath)
        Smacro1 = sprintf("EffectMacro1_%i", p4)
        Scombo1 = sprintf("EffectCombo1_%i", p4)
        Smacro2 = sprintf("EffectMacro2_%i", p4)
        Smacro3 = sprintf("EffectMacro3_%i", p4)
        Smacro4 = sprintf("EffectMacro4_%i", p4)
        Smacro5 = sprintf("EffectMacro5_%i", p4)
        Smacro6 = sprintf("EffectMacro6_%i", p4)
    
    prints "Filterverb Loaded\n"
    
    cabbageSet Smacro1, {{ text("FREQ"), popupPostfix("FilterVerb") }}
    cabbageSet Smacro2, {{ text("Q"), popupPostfix("FilterVerb")  }}
    cabbageSet Smacro3, {{ text("DEPTH"),  popupPostfix("FilterVerb")   }}
    cabbageSet Smacro4, {{ text("SPACE"), popupPostfix("FilterVerb")  }}
    cabbageSet Smacro5, {{ text("MOTION"),  popupPostfix("FilterVerb")  }}
    cabbageSet Smacro6, {{ text("BLEND"), popupPostfix("FilterVerb")  }}
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
          cabbageSetValue Smacro3, 0.7
            cabbageSetValue Smacro4, 0.7
              cabbageSetValue Smacro5, 0.2
                cabbageSetValue Smacro6, 0.99
    endif
    
//#INPUT SECTION
    kinput = p4
    kinL = (kinput * 2)-1 
    kinR = kinput * 2 
    ainL zar kinL
    ainR zar kinR

    kfreq chnget Smacro1					
    kreso chnget Smacro2					
    kdepth chnget Smacro3					
    kspace chnget Smacro4				
    kweird chnget Smacro5
    kblend chnget Smacro6
    
    kreso scale kreso, 0.9, 0
    
    iSkew = 0.5
    kfilter = pow(kfreq, 1/iSkew)
    kfilter scale kfilter, 20000, 50
    
    kspace = pow(kspace, 1/iSkew)
    kspace scale kspace, 10000, 50
    
    kfiltmod = rspline(0, 0.5*kweird, 0.1, 0.5)
    kcf = kfilter-(kfilter*kfiltmod)
    afiltL moogvcf2 ainL, kcf, kreso
    afiltR moogvcf2 ainR, kcf, kreso
    
    averbL, averbR reverbsc afiltL, afiltR, kdepth, kspace
	amixL=ntrpol(ainL, averbL, kblend)
	amixR=ntrpol(ainR, averbR, kblend)
	
	
    	//# Send section
	koutL = (kinput * 2) + 1
	koutR = (kinput * 2) + 2
	zaw amixL, koutL
	zaw amixR, koutR

	zacl kinL, kinR
	giEffectDefault = 1 ; set back to load effect defaults
endin