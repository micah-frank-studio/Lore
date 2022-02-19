; Paradigm
; Sound Design by Micah Frank (http://micahfrank.com)
; Artwork by Dan Meth (http://danmeth.com)
; Puremagnetik » Brooklyn, NYC 2021
; XY Pad Opcode by Rory Walsh 

;Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
;Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
;NonCommercial — You may not use the material for commercial purposes.
;No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

<Cabbage>
form caption("Paradigm") size(500, 500), guiMode("queue"), pluginId("pm43"), opcodeDir("."), bundle("./includes"), typeface("includes/Oxygen-Light.ttf")
image bounds(5, 20, 244, 350), channel("XYPad1")
image bounds(251, 20, 244, 350), channel("XYPad2")
image bounds(0, 0, 500, 500), file("includes/Paradigm.png")
signaldisplay bounds(50, 390, 450, 40), colour(255, 104, 168, 90), backgroundColour(41,40,43,0), displayType("waveform"), signalVariable("adisplay"), zoom(-1)
image bounds(105, 70, 70, 70), channel("Phoen"), alpha(0.8), colour(0,0,0,0), file("includes/ControlLeft.png"), active(0) 
image bounds(330, 270, 70, 70), channel("Gleis"), alpha(0.5), colour(0,0,0,0), file("includes/ControlRight.png"), alpha(0.8)
#define KNOB1 outlineColour(255,255,255,40) trackerColour(142,176,245,200), trackerThickness (0.11), style ("normal"), trackerOutsideRadius(1), trackerInsideRadius (0.1), colour(210, 215, 211, 0), textColour(218,218,218, 200), popupText(0)
#define GROUPBOX fontColour(30, 30, 30), outlineColour(30, 30, 30, 0), colour(0, 0, 0, 0), outlineThickness(1), lineThickness(0)
#define BUTTON1 fontColour:0("30,30,30"), fontColour:1("30,30,30"), colour:0("245,245,245,200"), colour:1("245,245,245,200"), outlineColour("30,30,30,250"), outlineThickness(2), corners(0)
groupbox bounds(0, 0, 500, 436) channel("Settings"), text(""), visible(0) $GROUPBOX {
    image bounds(0, 0, 500, 436), colour("0,0,0,220")
    texteditor bounds(30, 30, 450, 400), text(""), fontSize(15), channel("InfoText"), scrollbars(0), wrap(1), fontColour(255, 255, 255, 200), colour(0, 0, 0, 0), readOnly(1)
    button bounds(390, 398, 45, 22), latched(1), text("SELF", "SYNC"), channel("SyncMode") $BUTTON1
    rslider bounds(60, 362, 60, 60), channel("Tone"), text("TONE"), range(0, 1, 0.9, 0.7, 0.001)  $KNOB1
    rslider bounds(130, 362, 60, 60), channel("Pulses"), text("PULSES"), range(0, 1, 0.4, 1, 0.001)  $KNOB1
    rslider bounds(200, 362, 60, 60), channel("Spread"), text("SPREAD"), range(0, 1, 0.8, 1, 0.001)  $KNOB1
    rslider bounds(270, 362, 60, 60), channel("Space"), text("SPACE"), range(0, 1, 0.7, 1, 0.001)  $KNOB1
    button bounds(345, 355, 30, 30), latched(1), text("A", "A"), channel("ControlMode") $BUTTON1, colour:1("245,245,0,200")
    filebutton bounds(345, 390, 30, 30), text("R", "R"), channel("RecordMode"), mode("save"), colour:1("245,0,245,200"), $BUTTON1
    button bounds(1000, 390, 30, 30), latched(0), text("R", "R"), channel("StopMode"), $BUTTON1, colour:0("245,0,245,200"), fontColour:0("245,245,0,200")
    combobox bounds(390, 355, 80, 19), channel("Scale"), items("Major","Minor","Major Pent","Minor Pent","Harm Minor", "Mel Minor", "Hijaz Kar", "Hirajoshi", "Yo","Hungarian","Lydian", "Mixolydian","Dorian","Aeolian","Phrygian","Locrian"), colour(30,30,30,0),fontColour(245,245,245,200)

}
button bounds(20, 400, 20, 20), imgFile("off","includes/menu_light.png"), imgFile("on","includes/menu_on.png"), text(""), channel("menuButton")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5 --displays
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1
seed 0 

gisine ftgen 0, 0, 16384, 10, 1
gisquare  ftgen    7, 0, 2^10, 10, 1, 0, 1/3, 0, 1/5, 0, 1/7, 0, 1/9

massign 0, 0 ; mute incoming MIDI from instr triggering.

//# XY Pad Opcode
opcode XYPad, kk, SS
SPadName, SControl xin
iXYPadBounds[] cabbageGet sprintfk("%s", SPadName), "bounds"  
    
    iPadLeft = iXYPadBounds[0]
    iPadTop = iXYPadBounds[1]
    iPadWidth = iXYPadBounds[2]
    iPadHeight = iXYPadBounds[3]
    iPadCentreX = iPadLeft + iPadWidth/2
    iPadCentreY = iPadTop + iPadHeight/2
    iBallSize = 70

    iBallBounds[] fillarray iPadWidth/2-iBallSize/2, iPadHeight/2-iBallSize/2, 30, 30
    iballXYpos[] cabbageGet SControl, "bounds"
    kCurrentX init iballXYpos[0] ;initialize x,y vals to actual ball poaition
    kCurrentY init iballXYpos[1]
    kBallSize init iBallSize  
    
    kXDown, kYDown, kXUp, kYUp init 0
    kIncrY, kIncrX init 0
    
    kcontrolmode cabbageGet "ControlMode"
    if kcontrolmode == 1 then
        kXPos=rspline(iXYPadBounds[0],iXYPadBounds[0]+iXYPadBounds[2], 0.1, 0.3)
        kYPos=rspline(iXYPadBounds[1],iXYPadBounds[1]+iXYPadBounds[3], 0.1, 0.3)
        kMouseLeftDown=1				
    else
        kMouseLeftDown chnget "MOUSE_DOWN_LEFT"
        kMouseRightDown chnget "MOUSE_DOWN_RIGHT"        
        kXPos chnget "MOUSE_X"
        kYPos chnget "MOUSE_Y"
   endif
           
    kAutomation init 0
    iSensitivity = 0.4
    kDistanceFromCentre init 0
    				
   if kMouseLeftDown==1 || kMouseRightDown == 1 && kXPos > iPadLeft && kXPos < iPadLeft + iPadWidth && kYPos > iPadTop && kYPos < iPadHeight + iPadTop then 
        kBallX limit kXPos, iPadLeft+kBallSize/2, iPadLeft+iXYPadBounds[2]-kBallSize/2
        kBallY limit kYPos, iPadTop+kBallSize/2, iPadTop+iPadHeight-kBallSize/2
        kCurrentX = kBallX
        kCurrentY = kBallY
        cabbageSet 1, SControl, "bounds", kBallX-kBallSize/2, kBallY-kBallSize/2, kBallSize, kBallSize
        kDistanceFromCentre = 1 - (sqrt(pow:k(iPadCentreX-kBallX, 2)+pow:k(iPadCentreY-kBallY, 2)))/(iPadWidth/2)
        kAutomation = 0
   endif  

    if changed(kMouseRightDown) == 1 then
        if kMouseRightDown == 1 then
            kXDown = kXPos
            kYDown = kYPos
        else
            kVel = sqrt(pow:k(kXDown-kXPos, 2)+pow:k(kYDown-kYPos, 2))/iPadWidth
            kAutomation = 1
            kIncrX = (kXPos-kXDown)*kVel*iSensitivity
            kIncrY = (kYPos-kYDown)*kVel*iSensitivity
            kXUp = kXPos-iBallSize/2
            kYUp = kYPos-iBallSize/2
        endif
    endif

    if kAutomation == 1 then 
        kYUp += (kIncrY)
        kXUp += (kIncrX)
        
        cabbageSet 1, SControl, "bounds", kXUp+kIncrX, kYUp+kIncrY, kBallSize, kBallSize 
        
        kCurrentX = kXUp+kIncrX+kBallSize/2
        kCurrentY = kYUp+kIncrY+kBallSize/2
        
        kDistanceFromCentre = 1 - (sqrt(pow:k(iPadCentreX-(kXUp+kIncrX), 2)+pow:k(iPadCentreY-(kYUp+kIncrY), 2)))/(iPadWidth/2)         
        kRight trigger kXUp, iPadLeft+iPadWidth-kBallSize, 0
        kLeft trigger kXUp, iPadLeft, 1
        kBottom trigger kYUp, iPadTop+iPadHeight-kBallSize, 0
        kTop trigger kYUp, iPadTop, 1
    endif
    kOutX = (kCurrentX-iPadLeft-iBallSize/2)/(iPadWidth-iBallSize)
    kOutY = (kCurrentY-iPadTop-iBallSize/2)/(iPadHeight-iBallSize)

    xout tonek(kOutX, 10), tonek(kOutY, 10)  
    
    cabbageSetValue "x", kOutX
    cabbageSetValue "y", kOutY
    cabbageSet metro(20), SControl, "alpha",  kOutX*0.1+(1-kOutY*0.5) ;, 255-kOutY
endop 

instr UIcontrol   
 cabbageSet "RecordMode", sprintf("populate(\"*\", \"%s\")", chnget:S("USER_HOME_DIRECTORY"))
 if (chnget:k("menuButton") > 0) then      
        cabbageSet 1, "Settings", "visible(1)"
   else
        cabbageSet 1, "Settings", "visible(0)"
        gkXTop, gkYTop XYPad "XYPad1", "Phoen"
        gkXBot, gkYBot XYPad "XYPad2", "Gleis"
    endif  
    
    cabbageSet "InfoText", "text",{{Paradigm is a generative, texture synthesizer with a physically modeled percussive voice, a bowed string voice and a filtered noise generator.

Move the left and right spheres to get variations in timbre, generation rate, filters and tonality.

- Self/Sync will enable generation only when the host transport is running.  
- MIDI note input will change the base pitch of the sequence
- Tone adjusts a Moog-style filter on the master bus.
- Pulses attenuates some of Paradigm's PWM voices.
- Spread controls the width of auto-panning.
- Space increases and decreases reflections and room size.
- (A)utomate will automate sphere movement.
- (R)ecord will render Paradigm's output to an audio file on disk.
- Scales includes a collection of scales that Paradigm will conform to.

Sound design & programming by Micah Frank
Artwork by Dan Meth
Puremagnetik - Brooklyn, NYC

}}

kplaying chnget "IS_PLAYING"
ksync chnget "SyncMode"
if (ksync > 0) then
    if (active(2)) > 0 && changed:k(ksync) == 1 then
        turnoff2 2, 0, 0
    endif
    if (kplaying = 1) then
        schedkwhennamed kplaying, 0, 1, 2, 0, 500000
    else
        turnoff2 2, 0, 0 
    endif
endif
if ksync < 1 then
    schedkwhennamed 1, 0, 1, 2, 0, 500000
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
//# MIDI note handling
inoteinit = random(36, 47)
krootnote init inoteinit 
kstatus, kchan, knote, kdata2 midiin
if (changed:k(knote)) == 1 && kstatus == 144 then ; if it's a new note
    krootnote = knote
endif

//
kdecay trandom ktrig, 20, 50
schedkwhennamed ktrig, 0, 5, "tones", 0, kdecay, krootnote
schedkwhennamed ktrig, 0, 5, "noises", 0, kdecay, krootnote
schedkwhennamed kbarRate, 0, 5, "phoen", 0, 2, krootnote
loadScales:
iScaleSelect=chnget("Scale")
if iScaleSelect == 1 then
    giNotes[] fillarray 0, 2, 4, 7, 11, 12, 14, 17 ;Major
 elseif iScaleSelect == 2 then
    giNotes[] fillarray 0, 2, 3, 7, 10, 12, 15, 19 ;minor
 elseif iScaleSelect == 3 then
     giNotes[] fillarray 0, 2, 4, 7, 9, 12, 16, 19 ;Major Pent
 elseif iScaleSelect == 4 then
     giNotes[] fillarray 0, 3, 5, 7, 9, 12, 15, 19  ;minor Pent
 elseif iScaleSelect == 5 then
     giNotes[] fillarray 0, 3, 5, 7, 8, 11, 12, 14  ;Harmonic Minor
 elseif iScaleSelect == 6 then
     giNotes[] fillarray 0, 3, 5, 7, 9, 11, 12, 14  ;Melodic Minor
 elseif iScaleSelect == 7 then
     giNotes[] fillarray 0, 1, 4, 5, 7, 8, 11, 12  ;Hijaz Kar
 elseif iScaleSelect == 8 then
    giNotes[] fillarray 0, 2, 3, 7, 8, 12, 15, 20 ;Hirajoshi
 elseif iScaleSelect == 2 then
    giNotes[] fillarray 0, 2, 5, 7, 9, 12, 2, 14 ;Yo
 elseif iScaleSelect == 9 then
    giNotes[] fillarray 0, 2, 3, 6, 7, 8, 11, 12 ;Hungarian Minor
 elseif iScaleSelect == 10 then
    giNotes[] fillarray 0, 2, 4, 6, 7, 9, 11, 12  ;Lydian
 elseif iScaleSelect == 11 then
    giNotes[] fillarray 0, 2, 4, 5, 7, 9, 10, 12 ;mixolydian
 elseif iScaleSelect == 12 then
    giNotes[] fillarray 0, 2, 3, 5, 7, 9, 10, 12  ;Dorian
 elseif iScaleSelect == 13 then
    giNotes[] fillarray 0, 2, 3, 5, 7, 8, 10, 12 ;Aeolian
 elseif iScaleSelect == 14 then
    giNotes[] fillarray 0, 1, 3, 5, 7, 8, 10, 12  ;Phrygian
 elseif iScaleSelect == 15 then
    giNotes[] fillarray 0, 1, 3, 5, 6, 8, 10, 12 ;Locrian
endif
  
rireturn
    kscale, knewScale cabbageGet "Scale"
    if knewScale > 0 then
        reinit loadScales
    endif
endin  

instr tones

idecay = p3
iroot = p4
ionset = random(2, idecay*0.5)
iBowVol = random(0.1, 0.2)
kamp linseg 0.001, ionset, iBowVol, idecay-ionset, 0.001
inote = int(random(0,7))
ibasfreq = cpsmidinn(iroot+giNotes[inote])
krat = rspline(0.025, 0.23, 0.1, 0.01) ;must be 0-1
kpres = rspline(1, 5, 0.1, 0.01) ; can be neg or positive (eg -4, 2)
kvibf = rspline(0, 1, 0.1, 0.01)
kvamp = rspline(0.001, 0.01, 0.1, 0.01)
kfreqmod = rspline(0.97, 0.99, 3, 2)
abow wgbow kamp*1.3, ibasfreq, kpres, krat, kvibf, kvamp
abowd wgbow kamp*1.3*(1-gkYBot), k(ibasfreq)*kfreqmod, kpres, krat, kvibf, kvamp  
asin poscil kamp, ibasfreq, gisine
amix = (abow + abowd + asin )*0.5
kres = rspline(0.01, 0.3, 0.1, 0.3)
kfreq = rspline(500, 2000, 0.1, 0.3)
afiltermix moogvcf2 amix, kfreq, kres
iverbsend = linrand(0.7)
kpanrand=rspline(0.1, 0.9, 0.1, 0.5)
amixL, amixR pan2 afiltermix, kpanrand
chnmix amixL*iverbsend, "verbSendL"
chnmix amixR*iverbsend, "verbSendR"
chnmix amixL, "mixBusL"
chnmix amixR, "mixBusR"

endin

instr noises
idecay = p3
iroot = p4
kbeta=rspline(-0.5,-0.2,0.1,0.3)
isus = random(0.01, 0.07+(0.01*(1-i(gkXBot))))
ktrigfreq = rspline(5, 0.11, 0.1, 0.5)
knoiseamp=expseg(0.001, p3*0.5, isus, p3*0.9, 0.001)
kloopseg=loopseg(ktrigfreq, 0, 0.01, isus, 0.001, 0.001)
khpfreq=rspline(100, 2000, 0.1, 0.3)
anoise noise knoiseamp, 0.0
kbw=rspline(500, 3000, 0.5, 0.05)
kbpfreq=rspline(1000, 5000, 0.5, 0.05)
afilteredNoise = butterbp(anoise,kbpfreq,kbw)
ipulsenote = int(random(0,7))
icps =cpsmidinn(iroot+giNotes[ipulsenote])
kpwm = abs(jspline((0.5*gkYBot)+0.01, 0.01, 0.1))
apulse=vco2(kloopseg, icps, 2, kpwm)
iverbsend = linrand(0.7)
kdelsend = abs(jspline(1, 0.01, 0.2))
knoisepan=rspline(-0.2, 0.2, 0.1, 0.01)
kpangauss=gauss(0.5)
anoiseL, anoiseR pan2 afilteredNoise*0.25*gkYBot, 0.5 + (knoisepan*chnget:k("Spread"))
apulseL, apulseR pan2 apulse*(chnget:k("Pulses")), 0.5 + (kpangauss*chnget:k("Spread"))

chnmix anoiseL*iverbsend, "verbSendL"
chnmix anoiseR*iverbsend, "verbSendR"
chnmix apulseL*kdelsend, "delaySendL"
chnmix apulseR*kdelsend, "delaySendR"
chnmix anoiseL+(apulseL*0.7*gkXBot), "mixBusL"
chnmix anoiseR++(apulseR*0.7*gkXBot), "mixBusR"
endin

instr phoen
    ichance = random(0,1) > 0.5 ? 1 : 0 ; does chime make a sound on trigger?
    ivol = random(0.1, 0.33)
    konset = scale(gkYTop, 0.005, 0.1)
    kamp = expseg(0.001, i(konset), ivol, 0.8, 0.001)
    inote = cpsmidinn(p4+12+(giNotes[int(linrand(7))]))
    asq poscil kamp*ichance, inote, gisquare
    asqf butterlp asq, 1000
    asine poscil kamp*ichance, inote, gisine
    avco = ntrpol(asqf, asine, gkXTop)
    abar butterlp avco, 700+(3000*gkYTop)
    abar dcblock2 abar						;get rid of DC
    kpanrand=rspline(-0.4, 0.4, 0.1, 0.5)
    abarL, abarR pan2 abar, 0.5 + (kpanrand*chnget:k("Spread"))
    kdelsend = rspline(0.4, 1, 0.2, 0.01)
    chnmix abarL*kdelsend, "delaySendL"
    chnmix abarR*kdelsend, "delaySendR"
    chnmix abarL, "mixBusL"
    chnmix abarR, "mixBusR"
endin

instr verb

aVerbinL chnget "verbSendL"
aVerbinR chnget "verbSendR"
aDelinL chnget "delaySendL"
aDelinR chnget "delaySendR"
adelL init 0
adelR init 0
kfb = abs(jspline(0.8, 0.1, 0.01))
adelL vdelay aDelinL+(adelL*kfb), 300, 1000
adelR vdelay aDelinR+(adelR*kfb), 220, 1000
averbL, averbR reverbsc, aVerbinL+adelL, aVerbinR+adelR, 0.85*(chnget:k("Space")), 10000
chnmix averbL, "mixBusL"
chnmix averbR, "mixBusR"
chnclear "verbSendL"
chnclear "verbSendR"
chnclear "delaySendL"
chnclear "delaySendR"
endin

instr mixer
amixL chnget "mixBusL"
amixR chnget "mixBusR"
kfreq = chnget:k("Tone")
kvcffreq scale kfreq, 10000, 50
afiltermixL moogladder2 amixL, kvcffreq, 0.05
afiltermixR moogladder2 amixR, kvcffreq, 0.05
alowcutL butterhp afiltermixL, 60
alowcutR butterhp afiltermixR, 60
outs alowcutL, alowcutR
    kdisprel linsegr 1, 1, 1, 0.3, 0  
    adisplay limit afiltermixL+amixR, -0.8, 0.8
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