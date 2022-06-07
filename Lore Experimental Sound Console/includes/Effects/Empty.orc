giEffectNumber = 10 ;set instrument number for triggering in Synth-Host.orc

instr 10, Empty
print p1
        ; set effect icon
        Sicon = sprintf("Effect_Icon%i", p4)
        ;prints gSEffectDir
        SiconPath = sprintf("\"%s\/%s\"", gSEffectDir, "images/Empty.svg")
        cabbageSet Sicon, sprintf("visible(1), file(\"%s\")", SiconPath)
        
        Smacro1 = sprintf("EffectMacro1_%i", p4)
        Scombo1 = sprintf("EffectCombo1_%i", p4)
        Smacro2 = sprintf("EffectMacro2_%i", p4)
        Smacro3 = sprintf("EffectMacro3_%i", p4)
        Smacro4 = sprintf("EffectMacro4_%i", p4)
        Smacro5 = sprintf("EffectMacro5_%i", p4)
        Smacro6 = sprintf("EffectMacro6_%i", p4)
        Smacro7 = sprintf("EffectMacro7_%i", p4)
        Smacro8 = sprintf("EffectMacro8_%i", p4)
      
    prints "Empty Loaded\n"
    cabbageSet Smacro1, {{ text("--"), popupPostfix("--") }}
    cabbageSet Smacro2, {{ text("--"), popupPostfix("--") }}
    cabbageSet Smacro3, {{ text("--"), popupPostfix("--") }}
    cabbageSet Smacro4, {{ text("--"), popupPostfix("--") }}
    cabbageSet Smacro5, {{ text("--"), popupPostfix("--") }}
    cabbageSet Smacro6, {{ text("--"), popupPostfix("--") }}
    cabbageSet Smacro7, {{ text("--"), popupPostfix("--") }}
    cabbageSet Smacro8, {{ text("--"), popupPostfix("--") }}
    
    cabbageSet Smacro1, "value", 0.5
    cabbageSet Smacro2, "value", 0.5
    cabbageSet Smacro3, "value", 0.5
    cabbageSet Smacro4, "value", 0.5
    cabbageSet Smacro5, "value", 0.5
    cabbageSet Smacro6, "value", 0.5
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
    
    //#INPUT SECTION
    kinput = p4
    kinL = (kinput * 2)-1 
    kinR = kinput * 2 
    amixL zar kinL
    amixR zar kinR

	//# Send section
	koutL = (kinput * 2) + 1
	koutR = (kinput * 2) + 2
	zaw amixL, koutL
	zaw amixR, koutR

	zacl kinL, kinR

endin