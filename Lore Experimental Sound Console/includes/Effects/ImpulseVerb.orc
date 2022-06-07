giEffectNumber = 14 ;set instrument number for triggering in Synth-Host.orc
instr 14, ImpulseVerb

print p1
kImpulseInstance = p1 ;keep track of instance number when Impulse changes
        ; set effect icon
        Sicon = sprintf("Effect_Icon%i", p4)
        ;prints gSEffectDir
        SiconPath = sprintf("\"%s\/%s\"", gSEffectDir, "images/ImpulseVerb.svg")
        cabbageSet Sicon, sprintf("visible(1), file(\"%s\")", SiconPath)
        Smacro1 = sprintf("EffectMacro1_%i", p4)
        Scombo1 = sprintf("EffectCombo1_%i", p4)
        Smacro2 = sprintf("EffectMacro2_%i", p4)
        Smacro3 = sprintf("EffectMacro3_%i", p4)
        Smacro4 = sprintf("EffectMacro4_%i", p4)
        Smacro5 = sprintf("EffectMacro5_%i", p4)
        Smacro6 = sprintf("EffectMacro6_%i", p4)
    
    prints "ImpulseVerb Loaded\n"
    cabbageSet Smacro1, {{ text("--"), popupPostfix("ImpulseVerb") }}
    cabbageSet Smacro2, {{ text("--"), popupPostfix("ImpulseVerb")  }}
    cabbageSet Smacro3, {{ text("--"),  popupPostfix("ImpulseVerb")   }}
    cabbageSet Smacro4, {{ text("--"), popupPostfix("ImpulseVerb")  }}
    cabbageSet Smacro5, {{ text("--"),  popupPostfix("ImpulseVerb")  }}
    cabbageSet Smacro6, {{ text("SIZE"), popupPostfix("ImpulseVerb")  }}
    icomboIsOn = 1
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
         cabbageSetValue Smacro2,  0.5
          cabbageSetValue Smacro3, 0.5
            cabbageSetValue Smacro4, 0.5
              cabbageSetValue Smacro5, 0.5
                cabbageSetValue Smacro6, 0.5
    endif
    
    kinput = p4
   if p5 < 1 then
     cabbageSet Scombo1, {{populate("*.wav", "./includes/IRs"), popupPostfix("ImpulseVerb") }}
     cabbageSetValue Scombo1, 4
   else 
     cabbageSetValue Scombo1, p5
   endif 
   print p5
   
    kImpulseNum, kImpulseChanged cabbageGet Scombo1
        if kImpulseChanged > 0 then
            gkImpulseInstance = kImpulseInstance
            gkImpulseTable = kImpulseNum
            gkImpulseVerbEffectSlot = kinput
        endif
//#INPUT SECTION
    kinL = (kinput * 2)-1 
    kinR = kinput * 2 
    ainL zar kinL
    ainR zar kinR
    iSelectedTable = i(kImpulseNum)
    iImpulseTable =  200+iSelectedTable
    aRevcL ftconv ainL, iImpulseTable, 2048
    aRevcR ftconv ainR, iImpulseTable, 2048 
    aRevL = aRevcL*0.1 ; adjust gain of convol b/c it's loud
    aRevR = aRevcR*0.1
    
    ;kfreq chnget Smacro1					
    ;kreso chnget Smacro2					
   ; kdepth chnget Smacro3					
    ;kspace chnget Smacro4				
    ;kweird chnget Smacro5
   kblend chnget Smacro6
    
	amixL=ntrpol(ainL, aRevL, kblend)
	amixR=ntrpol(ainR, aRevR, kblend)
	
	
    	//# Send section
	koutL = (kinput * 2) + 1
	koutR = (kinput * 2) + 2
	zaw amixL, koutL
	zaw amixR, koutR

	zacl kinL, kinR
	giEffectDefault = 1 ; set back to load effect defaults
endin