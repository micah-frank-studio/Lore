
giEffectNumber = 16 ;set instrument number for triggering in Synth-Host.orc

instr 16, GhostEcho
print p1
        ; set effect icon
        Sicon = sprintfk("Effect_Icon%i", p4)
        ;prints gSEffectDir
        SiconPath = sprintf("\"%s\/%s\"", gSEffectDir, "images/GhostEcho.svg")
        cabbageSet Sicon, sprintf("visible(1), file(\"%s\")", SiconPath)
;prints SiconPath
        Smacro1 = sprintf("EffectMacro1_%i", p4)
        Scombo1 = sprintf("EffectCombo1_%i", p4)
        Smacro2 = sprintf("EffectMacro2_%i", p4)
        Smacro3 = sprintf("EffectMacro3_%i", p4)
        Smacro4 = sprintf("EffectMacro4_%i", p4)
        Smacro5 = sprintf("EffectMacro5_%i", p4)
        Smacro6 = sprintf("EffectMacro6_%i", p4)
           
prints "GhostEcho Loaded\n"
    cabbageSet Smacro1, {{ text("EDGES"),  popupPostfix("GhostEcho") }}
    cabbageSet Smacro2, {{ text("SPACE"), popupPostfix("GhostEcho") }}
    cabbageSet Smacro3, {{ text("FADE"), popupPostfix("GhostEcho") }}
    cabbageSet Smacro4, {{ text("ENERGY"), popupPostfix("GhostEcho")  }}
    cabbageSet Smacro5, {{ text("AURA"), popupPostfix("GhostEcho") }}
    cabbageSet Smacro6, {{ text("GHOST"), popupPostfix("GhostEcho") }}

    icomboIsOn = 0
    if icomboIsOn > 0 then
        cabbageSet Scombo1, "visible(1)"
        cabbageSet Smacro1, "visible(0)"
        cabbageSet Smacro3, "visible(1)"
        cabbageSet Scombo1, {{text("SMOOTH", "SHARP"), popupPostfix("GhostEcho")}}
        cabbageSetValue Scombo1, 1
    else 
        cabbageSet Scombo1, "visible(0)"
        cabbageSet Smacro1, "visible(1)"
        cabbageSet Smacro3, "visible(1)"
    endif 
    
     if giEffectDefault > 0 then ;load default values if this is not recalled from a snapshot
        cabbageSetValue Smacro1, 0.2
         cabbageSetValue Smacro2,  0.3
          cabbageSetValue Smacro3, 0.3
            cabbageSetValue Smacro4, 0.1
              cabbageSetValue Smacro5, 0.7
                cabbageSetValue Smacro6, 0.5
    endif


//#INPUT SECTION
    kinput = p4
   
    kinL = (kinput * 2)-1 
    kinR = kinput * 2 
    ainL zar kinL
    ainR zar kinR


ktime chnget Smacro2 ;delay time
krepeat chnget Smacro3 ;delay feedback
kfuzz chnget Smacro1 ; waveshaper amount
kenergy chnget Smacro4 ; Modulator speed
kdream chnget Smacro6 ;modulator depth
kmodshape chnget Smacro5 ;modulator shape

kenergy scale kenergy, 1, 0.001
kmodshape scale kmodshape, 0.99, 0.01
ktime scale ktime, 1, 0.00002
kdream scale kdream, 0.3, 0


kshape1 = 0.4
kshape2 = 0.1
imode = 1
adistL distort1 ainL, 2, 1, kshape1, kshape2, imode 
adistR distort1 ainR, 2, 1, kshape1, kshape2, imode 

adistmixL = ntrpol(ainL, adistL, kfuzz)
adistmixR = ntrpol(ainR, adistR, kfuzz)

kdreamp = portk(kdream, 0.1)

alfo=vco2(kdreamp, kenergy, 4, kmodshape)
ktimep = portk(ktime, 0.1)
aDeltime=interp(ktimep)

aDeltimeInSeconds=aDeltime*1000

aDelayL vdelay adistmixL, aDeltimeInSeconds-(aDeltimeInSeconds*alfo), 1001
aDelayR vdelay adistmixR, aDeltimeInSeconds-(aDeltimeInSeconds*alfo), 1001

adelL = adistmixL+(aDelayL*krepeat)
adelR = adistmixR+(aDelayR*krepeat)

amixL = adelL
amixR = adelR
	//# Send section
	koutL = (kinput * 2) + 1
	koutR = (kinput * 2) + 2
	zaw amixL, koutL
	zaw amixR, koutR

	zacl kinL, kinR
	
	giEffectDefault = 1 ; set back to load effect defaults
	
	

endin

