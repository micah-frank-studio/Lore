giEffectNumber = 17 ;set instrument number for triggering in Synth-Host.orc

opcode Vocoder, a, aakkkpp
    ;ibands - number of filter bands between kminf and kmaxf
    ;asig - output
    ;aexc - excitation signal, generally a broadband source (ie. lots of spectral components)
    ;ain - input signal, generally a signal with a strong spectral envelope or contour, formants, etc. (such as vocal sound)
    ;kminf - lowest analysis frequency
    ;kmaxf - highest analysis frequency
    ;kq - filter Q
    as1,as2,kmin,kmax,kq,ibnd,icnt  xin

    if kmax < kmin then
        ktmp = kmin
        kmin = kmax
        kmax = ktmp
    endif

    if kmin == 0 then 
        kmin = 1
    endif

    if (icnt >= ibnd) goto bank
    abnd   Vocoder as1,as2,kmin,kmax,kq,ibnd,icnt+1

    bank:
    kfreq = kmin*(kmax/kmin)^((icnt-1)/(ibnd-1))
    kbw = kfreq/kq
    an  butterbp  as2, kfreq, kbw
    an  butterbp  an, kfreq, kbw
    as  butterbp  as1, kfreq, kbw
    as  butterbp  as, kfreq, kbw
    ao balance as, an

    amix = ao + abnd

    xout amix

endop

instr 17, Orbiter
print p1
        ; set effect icon
        Sicon = sprintfk("Effect_Icon%i", p4)
        ;prints gSEffectDir
        SiconPath = sprintf("\"%s\/%s\"", gSEffectDir, "images/Orbiter.svg")
        cabbageSet Sicon, sprintf("visible(1), file(\"%s\")", SiconPath)
;prints SiconPath
        Smacro1 = sprintf("EffectMacro1_%i", p4)
        Scombo1 = sprintf("EffectCombo1_%i", p4)
        Smacro2 = sprintf("EffectMacro2_%i", p4)
        Smacro3 = sprintf("EffectMacro3_%i", p4)
        Smacro4 = sprintf("EffectMacro4_%i", p4)
        Smacro5 = sprintf("EffectMacro5_%i", p4)
        Smacro6 = sprintf("EffectMacro6_%i", p4)
           
prints "Orbiter Loaded\n"
    cabbageSet Smacro1, {{ text("RANGE"),  popupPostfix("Orbiter") }}
    cabbageSet Smacro2, {{ text("WIDTH"), popupPostfix("Orbiter") }}
    cabbageSet Smacro3, {{ text("SHIFT"), popupPostfix("Orbiter") }}
    cabbageSet Smacro4, {{ text("SPEED"), popupPostfix("Orbiter")  }}
    cabbageSet Smacro5, {{ text("SPACE"), popupPostfix("Orbiter") }}
    cabbageSet Smacro6, {{ text("BLEND"), popupPostfix("Orbiter") }}

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


kwave chnget Smacro1 ;Vocoder Analysis Range
kvector chnget Smacro2 ;Filter series Q
kvel chnget Smacro3 ; waveshaper amount
krepeat chnget Smacro4 ; Modulator speed
kspace chnget Smacro5 ;Blur and distance
kmix chnget Smacro6 ;Dry/Wet Mix

kenergy scale kwave, 1, 0.01
kvector scale kvector, 1, 0.01
kvel scale kvel, 1, 0.001
krepeat scale krepeat, 1, 0.001
kspace scale kspace, 1, 0.001
kmix scale kmix, 1, 0.001


kbpm chnget "HOST_BPM"

kbeat = kbpm/60

kspeed scale kvel, 2, 0.001
kmod lfo kvel*0.5, kspeed
aex noise 0.7, 0.9
kmax = (7000*kwave+10)
kmaxmod = kmax-(kmax*kmod)
kmin = kwave*500+10
kminmod = kmin-(kmin*kmod)
kbw = round(50*kvector)+10
ibands = 10

avocL Vocoder aex, ainL*4, kminmod, kmaxmod, kbw, ibands
avocR Vocoder aex, ainR*4, kminmod, kmaxmod, kbw, ibands

;mute for delay line to avoid noice when changing delay in realtime
    if changed:k(krepeat) == 1 then
        kDelayGain = 0
    endif
    
    kDelayTime = (kbeat*0.25)*1000 ;milliseconds
    ;delay method 
    aDelayL vdelay avocL*2, kDelayTime, 5001
    aDelayR vdelay avocR*2, kDelayTime*0.97, 5001

    kDelayGain = kDelayGain<1 ? kDelayGain+.0001 : 1
    
    ;add feedback
    aDelMixL = avocL+(aDelayL*krepeat)
    aDelMixR = avocR+(aDelayR*krepeat)
  
averbL, averbR freeverb aDelMixL, aDelMixR, 0.8, 0.9, 0.001

averbmixL ntrpol aDelMixL, averbL, kspace
averbmixR ntrpol aDelMixR, averbR, kspace
amixL ntrpol ainL, averbmixL, kmix
amixR ntrpol ainR, averbmixR, kmix

amixLimitL limit amixL, -0.98, 0.98
amixLimitR limit amixR, -0.98, 0.98

	//# Send section
	koutL = (kinput * 2) + 1
	koutR = (kinput * 2) + 2
	zaw amixLimitL, koutL
	zaw amixLimitR, koutR

	zacl kinL, kinR
	
	giEffectDefault = 1 ; set back to load effect defaults

endin