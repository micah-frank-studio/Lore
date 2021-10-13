; Klome
; Sound Design by Micah Frank (http://micahfrank.com)
; Artwork by Dan Meth (http://danmeth.com)
; Puremagnetik » Brooklyn, NYC 2021
; XY Pad Opcode by Rory Walsh 

;Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
;Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
;NonCommercial — You may not use the material for commercial purposes.
;No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

<Cabbage>

form caption("Klome") size(500, 500), pluginId("pm44"), guiMode("queue"), opcodeDir("."), bundle("./includes"), typeface("includes/Oxygen-Light.ttf")
image bounds(5, 20, 244, 350), channel("XYPad1")
image bounds(251, 20, 244, 350), channel("XYPad2")
image bounds(0, 0, 500, 500), colour(255, 255, 255) file("includes/Klome.png")
signaldisplay bounds(50, 390, 450, 40), colour(123, 194, 247, 90), backgroundColour(41,40,43,0), displayType("waveform"), signalVariable("adisplay"), zoom(-1)
image bounds(105, 70, 60, 60), channel("Phoen"), alpha(0.9), colour(0,0,0,0), file("includes/ControlLeft.png"), active(0)
image bounds(330, 270, 75, 75), channel("Gleis"), alpha(0.9), colour(0,0,0,0), file("includes/ControlRight.png"), active(0)
#define KNOB1 outlineColour(255,255,255,40) trackerColour(142,176,245,200), trackerThickness (0.11), style ("normal"), trackerOutsideRadius(1), trackerInsideRadius (0.1), colour(210, 215, 211, 0), textColour(218,218,218, 200), popupText(0)
#define GROUPBOX fontColour(30, 30, 30), outlineColour(30, 30, 30, 0), colour(0, 0, 0, 0), outlineThickness(1), lineThickness(0)
#define BUTTON1 fontColour:0("30,30,30"), fontColour:1("30,30,30"), colour:0("245,245,245,200"), colour:1("245,245,245,200"), outlineColour("30,30,30,250"), outlineThickness(2), corners(0)
groupbox bounds(0, 0, 500, 436) channel("Settings"), text(""), visible(0) $GROUPBOX {
    image bounds(0, 0, 500, 436), colour("0,0,0,220")
    texteditor bounds(30, 30, 450, 400), text(""), fontSize(15), channel("InfoText"), scrollbars(0), wrap(1), fontColour(255, 255, 255, 200), colour(0, 0, 0, 0), readOnly(1)
    button bounds(390, 398, 45, 22), latched(1), text("SELF", "SYNC"), channel("SyncMode") $BUTTON1
    rslider bounds(60, 362, 60, 60), channel("Drone"), text("DRONE"), range(0, 1, 0.6, 1, 0.001)  $KNOB1
    rslider bounds(130, 362, 60, 60), channel("Bubbles"), text("BUBBLES"), range(0.001, 80, 30, 1, 0.001)  $KNOB1
    rslider bounds(200, 362, 60, 60), channel("Width"), text("WIDTH"), range(0, 1, 0.8, 1, 0.001)  $KNOB1
    rslider bounds(270, 362, 60, 60), channel("Space"), text("SPACE"), range(0, 1, 0.7, 1, 0.001)  $KNOB1
    button bounds(345, 355, 30, 30), latched(1), text("A", "A"), channel("ControlMode") $BUTTON1, colour:1("245,245,0,200")
    filebutton bounds(345, 390, 30, 30), text("R", "R"), channel("RecordMode"), mode("save"), colour:1("245,0,245,200"), $BUTTON1
    button bounds(1000, 390, 30, 30), latched(0), text("R", "R"), channel("StopMode"), $BUTTON1, colour:0("245,0,245,200"), fontColour:0("245,245,0,200")

}
button bounds(20, 400, 20, 20), imgFile("off","includes/menu_light.png"), imgFile("on","includes/menu_on.png"), text(""), channel("menuButton")

</Cabbage>
 
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5 --displays
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2
0dbfs = 1.0
seed 0 

gistk ftgen 0, 0, 256, 1, "includes/marmstk1.wav", 0, 0, 0
gisine ftgen 0, 0, 128, 10, 1
schedule "seq", 0, 500000

opcode randoPan, aa, a
	ain xin
	kpan=gauss(0.5)
	asigL, asigR pan2 ain, 0.5+kpan
	xout asigL, asigR
endop

massign 0, 0 ; mute incoming MIDI from instr triggering.

//# XY Pad Opcode
opcode XYPad, kk, SSSSi
SPadName, SControl, Simage1, Simage2, iBallSize xin
iXYPadBounds[] cabbageGet sprintfk("%s", SPadName), "bounds"  
    
    iPadLeft = iXYPadBounds[0]
    iPadTop = iXYPadBounds[1]
    iPadWidth = iXYPadBounds[2]
    iPadHeight = iXYPadBounds[3]
    iPadCentreX = iPadLeft + iPadWidth/2
    iPadCentreY = iPadTop + iPadHeight/2
    ;iBallSize = 70

    iBallBounds[] fillarray iPadWidth/2-iBallSize/2, iPadHeight/2-iBallSize/2, 30, 30
    iballXYpos[] cabbageGet SControl, "bounds"
    kCurrentX init iballXYpos[0] ;initialize x,y vals to actual ball poaition
    kCurrentY init iballXYpos[1]
    kBallSize init iBallSize  
    kradians init 0
    kXDown, kYDown, kXUp, kYUp init 0
    kIncrY, kIncrX init 0
    
    kcontrolmode cabbageGet "ControlMode"
    if kcontrolmode == 1 then 
            kXPos=rspline(iXYPadBounds[0],iXYPadBounds[0]+iXYPadBounds[2], 0.1, 0.3)
            kYPos=rspline(iXYPadBounds[1],iXYPadBounds[1]+iXYPadBounds[3], 0.1, 0.3)
            kMouseLeftDown=1				
    else
        kMouseLeftDown chnget "MOUSE_DOWN_LEFT"
        kXPos chnget "MOUSE_X"
        kYPos chnget "MOUSE_Y"
   endif

  
    cabbageSet metro(80), SControl, sprintfk("rotate(%f,%f,%f)", kradians, kBallSize/2, kBallSize/2)
    kradians = kradians+rspline(-0.001, 0.001, 0.1, 1)
      
    kAutomation init 0
    iSensitivity = 0.4
    kDistanceFromCentre init 0				
   if kMouseLeftDown==1 && kXPos > iPadLeft && kXPos < iPadLeft + iPadWidth && kYPos > iPadTop && kYPos < iPadHeight + iPadTop then 
        kBallX limit kXPos, iPadLeft+kBallSize/2, iPadLeft+iXYPadBounds[2]-kBallSize/2
        kBallY limit kYPos, iPadTop+kBallSize/2, iPadTop+iPadHeight-kBallSize/2
        kCurrentX = kBallX
        kCurrentY = kBallY
        cabbageSet 1, SControl, "bounds", kBallX-kBallSize/2, kBallY-kBallSize/2, kBallSize, kBallSize
        kDistanceFromCentre = 1 - (sqrt(pow:k(iPadCentreX-kBallX, 2)+pow:k(iPadCentreY-kBallY, 2)))/(iPadWidth/2)
        kAutomation = 0
        kimageRate = abs(round(randh(1, 20))) ; create image jitter on movement
        cabbageSet kimageRate, SControl, "file", Simage1 ;image 1
        cabbageSet 1-kimageRate, SControl, "file", Simage2 ;image 2
   endif 

    kOutX = (kCurrentX-iPadLeft-iBallSize/2)/(iPadWidth-iBallSize)
    kOutY = (kCurrentY-iPadTop-iBallSize/2)/(iPadHeight-iBallSize)
    xout tonek(kOutX, 10), tonek(kOutY, 10)  
    cabbageSetValue "x", kOutX
    cabbageSetValue "y", kOutY
             
endop 

instr UIcontrol   
 cabbageSet "RecordMode", sprintf("populate(\"*\", \"%s\")", chnget:S("USER_HOME_DIRECTORY"))
 if (chnget:k("menuButton") > 0) then      
        cabbageSet 1, "Settings", "visible(1)"
   else
        cabbageSet 1, "Settings", "visible(0)"
        gkXTop, gkYTop XYPad "XYPad1", "Phoen", "includes/ControlLeft.png", "includes/ControlLeftb.png", 60
        gkXBot, gkYBot XYPad "XYPad2", "Gleis", "includes/ControlRight.png", "includes/ControlRightb.png", 75
    endif  
    
    cabbageSet "InfoText", "text",{{Klome is a generative, texture synthesizer that creates cluster pulses of wooden and metallic idiophones. It combines filters and physically-modeled voices with tonal subtractive synthesis drones.

Move the left and right cystals to get variations in timbre, generation rate, filters and tonality.

- Self/Sync will enable generation only when the host transport is running.  
- MIDI note input will change the base pitch of the sequence
- Drone controls the level of the subtractive sustained tone.
- Bubbles is a sharp LFO that can create rapid tonal changes in the percussive voices.
- Width controls the width of auto-panning.
- Space changes feedback, reflections and room size.
- (A)utomate will automate crystal movement.
- (R)ecord will render the output to an audio file on disk.

Sound design & programming by Micah Frank
Artwork by Dan Meth
Puremagnetik - Brooklyn, NYC

}}

kplaying chnget "IS_PLAYING"
ksync chnget "SyncMode"
if (ksync > 0) then ; if sync to host is on
    if (active(2)) > 0 && changed:k(ksync) == 1 then ;if it's already playing and sync mode changed
        turnoff2 2, 0, 0 ;turnoff seq
        turnoff2 99, 0, 0 ;turnoff drone
    endif
    if (kplaying = 1) then ; if transport is playing start seq instrument
        schedkwhennamed kplaying, 0, 1, 2, 0, 500000
    else
        turnoff2 2, 0, 0 ; turnoff seq
        turnoff2 99, 0, 0 ; turnoff drone
    endif
endif
if ksync < 1 then ; if sync to host is off
    schedkwhennamed 1, 0, 1, 2, 0, 500000 ; start sequencer
endif
endin

instr 2
//# BPM Sync and Sequence Trigger
kbpm chnget "HOST_BPM" ; get host bpm
kQuarterNoteInHz = kbpm/60 ; calculate quarter notes
idiv[] fillarray 0.25, 0.5, 1, 2, 4 ;beat divisions - whole to 16th
kdivSelect=rspline(0, 4, 0.1, 2) ; controller to change length of beat divisions
kpulse = kQuarterNoteInHz*idiv[kdivSelect] 
    ktrig = metro(kpulse,0)
    kbarRate=metro(kpulse*2*gkXBot) ; bar trigger is 4x and scaled by Left X
    
    kSpurPulse = rspline(3, 30*(1-gkYTop), 2, 0.05)
    ktrigKlome=metro(kpulse*8*(1-gkYTop))
    ktrigSpur=metro(kSpurPulse)
    //# MIDI note handling
    inoteinit = random(48, 56)
    krootnote init inoteinit 
    kstatus, kchan, knote, kdata2 midiin
    if (changed:k(knote)) == 1 && kstatus == 144 then ; if it's a new note
        krootnote = knote
        turnoff2 99, 1, 0
        event "i", 99, 0, 500000, krootnote ; reset drone to new root
    endif
    schedkwhennamed ktrigKlome, 0, 30, "Klome", 0, 0.5, krootnote
    schedkwhennamed ktrigSpur, 0, 30, "Spur", 0, 0.5, krootnote ; init Spur with krootnote
    schedule 99, 0, 500000, krootnote
endin

instr Klome
/*
iK -- dimensionless stiffness parameter. If this parameter is negative then the initialisation is skipped and the previous state of the bar is continued.
ib -- high-frequency loss parameter (keep this small).
iT30 -- 30 db decay time in seconds.
ipos -- position along the bar that the strike occurs.
ivel -- normalized strike velocity.
iwid -- spatial width of strike.

Performance
A note is played on a metalic bar, with the arguments as below.
kbcL -- Boundary condition at left end of bar (1 is clamped, 2 pivoting and 3 free).
kbcR -- Boundary condition at right end of bar (1 is clamped, 2 pivoting and 3 free).
kscan -- Speed of scanning the output location.
Note that changing the boundary conditions during playing may lead to glitches and is made available as an experiment. The use of a non-zero kscan can give apparent re-introduction of sound due to modulation.
*/

inote = int(linrand(7))
iNotes[] fillarray -12, -7, 3, 7, 10, 12, 15, 19 ;minor
kfreq = cpsmidinn(p4+iNotes[inote])



kbcL = int(random(1,3))
kbcR = int(random(1,3))
iK = random(1, 3)
iT30 = random(0.1, 2)
ib = random(0.01, 0.001)
kscan = random(0.01, 0.03)
ipos = random(0.01,1) 
ivel = random(600, 1000)
iwid = random(0.01, 0.1)
abar barmodel kbcL, kbcR, iK, ib, kscan, iT30, ipos, ivel, iwid
afiltBar butterhp abar, 60
ibaramp=random(0.6, 0.9)
kbarenv=linen(ibaramp, 0, 0.5, 0.1)
kamp = random(0.5, 0.8)
ihrd = random(0, 1)
ipos = random(0, 1)
kvibf = random(0, 4)
kvamp = random(0, 1)
ivibfn = gisine
idec = 1
idoubles = 30
itriples = 30

amar marimba kamp, kfreq, ihrd, ipos, gistk, kvibf, kvamp, ivibfn, idec, idoubles, itriples
kdelsend = rspline(0.4, 1, 0.2, 0.01)
atype=ntrpol(amar, afiltBar, gkXBot)

kpanrand=jspline(0.5, 0.1, 0.5)
atypeL, atypeR pan2 atype, 0.5 + (kpanrand*chnget:k("Width"))
    chnmix atypeL*kdelsend, "delaySendL"
    chnmix atypeR*kdelsend, "delaySendR"
    chnmix atypeL, "mixBusL"
    chnmix atypeR, "mixBusR"
endin

instr Spur
kbubbles chnget "Bubbles"
kcps = cpsmidinn(p4)
idecay = random(0.1, 0.3)
kamp = expseg(0.001, 0.01, random(0.1, 0.5), idecay, 0.001) 
kpw = rspline(0.01, 0.99, 0.1, 0.3)
ktun = jspline(10, 0.1, 1)
asynth1 vco2 kamp, kcps
asynth2 vco2 kamp, kcps+ktun
asynth3 vco2 kamp, kcps+ktun*0.2 
asynthmix = (asynth1+asynth2+asynth3)*0.5
kshape=rspline(1, 4, 0.1, 2)
apowersynth powershape asynthmix, kshape
kfiltsawLFO lfo gkXTop, kbubbles, 5 ; sawtooth LFO 
klfpf=rspline(800, (10000*(1-gkYTop))*kfiltsawLFO, 0.1, 0.3)
kq=rspline(0, 0.6, 0.1, 0.3)
alpfsynth moogvcf2 asynthmix, klfpf, kq
ksend = abs(randi(0.9, 0.5))
kpanrand=jspline(0.5, 0.1, 0.5)
alpfL, alpfR pan2 alpfsynth, 0.5 + (kpanrand*chnget:k("Width"))

chnmix alpfL, "mixBusL"
chnmix alpfR, "mixBusR"
chnmix alpfL*ksend, "verbSendL"
chnmix alpfR*ksend, "verbSendR"

endin

instr 99
kdrone chnget "Drone"
kcps = cpsmidinn(p4)
ksegrate = abs(rspline(0.3, 2, 0.1, 0.001))
kamp = loopseg(ksegrate, 1, 0, 1, 0.3, 0.1, 0.5, 0.01)
asig poscil .9*kdrone*kamp, kcps*0.25, gisine
kmod=rspline(0.9, 1.1, 0.1, 0.2)
asig2 vco2 0.7*kdrone*kamp, kcps*kmod*0.5
aphm = asig*(asig-(asig2*gkYTop))
aphmf = butterlp(aphm, rspline(100, 400, 0.2, 0.05))
ksend = abs(jspline(1, 0.01, 0.2))
chnmix aphmf*ksend, "verbSendL"
chnmix aphmf*ksend, "verbSendR"
chnmix aphmf, "mixBusL"
chnmix aphmf, "mixBusR"
endin

instr verb

aDelinL chnget "delaySendL"
aDelinR chnget "delaySendR"
aVerbinL chnget "verbSendL"
aVerbinR chnget "verbSendR"
adelL init 0
adelR init 0
kfb = abs(jspline(0.6*chnget:k("Space"), 0.1, 0.01))
adel = rspline(100, 1000, 0.1, 0.5)
aoffset = rspline(30, 200, 0.1, 0.5)
adelL vdelay aDelinL+(adelL*kfb), adel, 1000
adelR vdelay aDelinR+(adelR*kfb), adel+aoffset, 1000
averbL, averbR reverbsc aVerbinL, aVerbinR, 0.9*chnget:k("Space"), 10000
chnmix adelL+averbL, "mixBusL"
chnmix adelR+averbR, "mixBusR"
chnclear "delaySendL"
chnclear "delaySendR"
chnclear "verbSendL"
chnclear "verbSendR"
endin

instr mixer
amixL chnget "mixBusL"
amixR chnget "mixBusR"
alowcutL butterhp amixL, 60
alowcutR butterhp amixR, 60
outs alowcutL, alowcutR
    kdisprel linsegr 1, 1, 1, 0.3, 0  
    adisplay limit alowcutR, -0.8, 0.8
    adisplay = adisplay*kdisprel
    display adisplay, .1, 1

chnclear "mixBusL"
chnclear "mixBusR"

//# bounce recorded audio
gSSaveFile, kTrigRecord cabbageGetValue "RecordMode"
schedkwhennamed kTrigRecord, 0, 1, 100, 0, 500000
gkStopButton, kTrigStop cabbageGetValue "StopMode"
    if kTrigStop > 0 then
    turnoff2 100, 0, 0
    cabbageSet kTrigStop, "RecordMode", sprintfk("bounds(%i, 390, 30, 30)", 345)
    cabbageSet kTrigStop, "StopMode", sprintfk("bounds(%i, 390, 30, 30)", 1000)
    endif
endin

instr 100
cabbageSet "RecordMode", sprintf("bounds(%i, 390, 30, 30)", 1000)
cabbageSet "StopMode", sprintf("bounds(%i, 390, 30, 30)", 345)
prints "recording started\n"
allL, allR monitor
Sfilename strcat  gSSaveFile, ".wav"
fout Sfilename, 18, allL, allR 
endin


</CsInstruments>
<CsScore> 
i "UIcontrol" 0 500000
i "verb" 0 500000
i "mixer" 0 500000
</CsScore>
</CsoundSynthesizer>