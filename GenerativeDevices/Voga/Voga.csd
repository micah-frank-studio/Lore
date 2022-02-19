<Cabbage>
; Voga
; Sound Design by Micah Frank (http://micahfrank.com)
; Artwork by Dan Meth (http://danmeth.com)
; Puremagnetik » Brooklyn, NYC 2021
; XY Pad Opcode by Rory Walsh 

;Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
;Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
;NonCommercial — You may not use the material for commercial purposes.
;No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

<Cabbage>
form caption("Voga") size(500, 500), guiMode("queue"), pluginId("pm46"), opcodeDir("."), bundle("./includes"), typeface("includes/Oxygen-Light.ttf")
image bounds(5, 20, 244, 350), channel("XYPad1")
image bounds(251, 20, 244, 350), channel("XYPad2")
image bounds(0, 0, 500, 500), file("includes/VogaBG.png")
signaldisplay bounds(50, 390, 450, 40), colour(147, 196, 222, 90), backgroundColour(41,40,43,0), displayType("waveform"), signalVariable("adisplay"), zoom(-1)
image bounds(370, 220, 70, 70), channel("Gleis"), alpha(1), colour(0,0,0,0), file("includes/VogaControlRight.png"), alpha(0.8)
#define KNOB1 outlineColour(255,255,255,40) trackerColour(142,176,245,200), trackerThickness (0.11), style ("normal"), trackerOutsideRadius(1), trackerInsideRadius (0.1), colour(210, 215, 211, 0), textColour(218,218,218, 200), popupText(0)
#define GROUPBOX fontColour(30, 30, 30), outlineColour(30, 30, 30, 0), colour(0, 0, 0, 0), outlineThickness(1), lineThickness(0)
#define BUTTON1 fontColour:0("30,30,30"), fontColour:1("30,30,30"), colour:0("245,245,245,200"), colour:1("245,245,245,200"), outlineColour("30,30,30,250"), outlineThickness(2), corners(0)
image bounds(70, 130, 360, 134), file("includes/VogaBird.png")
image bounds(100, 60, 60, 60), channel("Phoen"), alpha(1), colour(0,0,0,0), file("includes/VogaControlLeft.png"), active(0) 

groupbox bounds(0, 0, 500, 436) channel("Settings"), text(""), visible(0) $GROUPBOX {
    image bounds(0, 0, 500, 436), colour("0,0,0,220")
    texteditor bounds(30, 30, 450, 400), text(""), fontSize(15), channel("InfoText"), scrollbars(0), wrap(1), fontColour(255, 255, 255, 200), colour(0, 0, 0, 0), readOnly(1)
    button bounds(390, 398, 45, 22), latched(1), text("SELF", "SYNC"), channel("SyncMode") $BUTTON1
    rslider bounds(60, 362, 60, 60), channel("Band"), text("BAND"), range(0, 1, 0.9, 0.5, 0.001)  $KNOB1
    rslider bounds(130, 362, 60, 60), channel("Strum"), text("STRUM"), range(0.25, 4, 1, 1, 0.001)  $KNOB1
    rslider bounds(200, 362, 60, 60), channel("Spread"), text("SPREAD"), range(0, 1, 0.5, 1, 0.001)  $KNOB1
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
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5 --displays
</CsOptions>
<CsInstruments>

; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1
massign 0, 0 ; mute incoming MIDI from instr triggering.
seed 0 

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

    iBallBounds[] fillarray iPadWidth/2-iBallSize/2, iPadHeight/2-iBallSize/2, 30, 30
    iballXYpos[] cabbageGet SControl, "bounds"
    kCurrentX init iballXYpos[0] ;initialize x,y vals to actual ball poaition
    kCurrentY init iballXYpos[1]
    kBallSize init iBallSize  
    kXDown, kYDown, kXUp, kYUp init 0
    kIncrY, kIncrX init 0
    
    kcontrolmode cabbageGet "ControlMode"
    if kcontrolmode == 1 then 
            kXPos=rspline(iXYPadBounds[0],iXYPadBounds[0]+iXYPadBounds[2], 0.07, 0.15)
            kYPos=rspline(iXYPadBounds[1],iXYPadBounds[1]+iXYPadBounds[3], 0.07, 0.15)
            kMouseLeftDown=1				
    else
        kMouseLeftDown chnget "MOUSE_DOWN_LEFT"
        kXPos chnget "MOUSE_X"
        kYPos chnget "MOUSE_Y"
   endif

      
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
   endif 

    kOutX = (kCurrentX-iPadLeft-iBallSize/2)/(iPadWidth-iBallSize)
    kOutY = (kCurrentY-iPadTop-iBallSize/2)/(iPadHeight-iBallSize)
    xout tonek(kOutX, 10), tonek(kOutY, 10)  
    cabbageSetValue "x", kOutX
    cabbageSetValue "y", kOutY
             
endop 


schedule 2, 0, 500000
schedule "UIcontrol", 0, 500000
schedule "Verb", 0, 500000
schedule "Mixer", 0, 500000

instr UIcontrol   
 cabbageSet "RecordMode", sprintf("populate(\"*\", \"%s\")", chnget:S("USER_HOME_DIRECTORY"))
 if (chnget:k("menuButton") > 0) then      
        cabbageSet 1, "Settings", "visible(1)"
   else
        cabbageSet 1, "Settings", "visible(0)"
        gkXTop, gkYTop XYPad "XYPad1", "Phoen", "includes/ControlLeft.png", "includes/ControlLeftb.png", 60
        gkXBot, gkYBot XYPad "XYPad2", "Gleis", "includes/ControlRight.png", "includes/ControlRightb.png", 70
    endif  
    
    cabbageSet "InfoText", "text",{{Voga is a physically modeled self-generating ambience synthesizer. It creates newly strummed chords that can be altered with two moons that control timbre, filters and effects.

Move the left and right spheres to get variations in timbre, generation rate, filters and tonality.

- Self/Sync will enable generation only when the host transport is running.  
- MIDI note input will change the base pitch of the sequence
- Band adjusts the bandwidth of the strummed chord - its center freq is 700hz.
- Strum adjusts the BPM-synced strumming speed from 16th notes to whole notes.
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

instr 2
//# BPM Sync and Sequence Trigger
kbpm = 100 ;chnget "HOST_BPM" ; get host bpm
kQuarterNoteInHz = kbpm/60 ; calculate quarter notes in hz
kQuarterNoteInSec = 60/kbpm ; calculate quarter notes in seconds
ksixteenthInSec = kQuarterNoteInSec*0.25
idiv[] fillarray 0.25, 0.5, 1, 2, 4 ;beat divisions
kdivSelect= round(rspline(0, 4, 0.1, 2)) ; controller to change length of beat divisions
kpulse = kQuarterNoteInHz*(idiv[kdivSelect])

    ktrig = metro(kpulse)
    printk2 ktrig
    //# MIDI note handling
    inoteinit = random(36, 60)
    krootnote init inoteinit 
    kstatus, kchan, knote, kdata2 midiin
    if (changed:k(knote)) == 1 && kstatus == 144 then ; if it's a new note
        krootnote = knote
    endif
    krel trandom kpulse, 0.2, 0.2+(2*gkXBot) ;gkXBot controls release
    konset trandom kpulse, 0.001, 0.01
    kvariance = ksixteenthInSec*((chnget:k("Strum"))+(0.1*gkXTop)) ; strumming speed controlled by 16th note calculation + variance introduced by Left X position
        
    schedkwhennamed ktrig, 0, 14, "Filament", 0, konset+krel+3, krootnote, krel, konset
    schedkwhennamed ktrig, 0, 14, "Filament", kvariance, konset+krel+1, krootnote, krel, konset
    schedkwhennamed ktrig, 0, 14, "Filament", kvariance*2, konset+krel+1, krootnote, krel, konset
    schedkwhennamed ktrig, 0, 14, "Filament", kvariance*3, konset+krel+1, krootnote, krel, konset
    schedkwhennamed ktrig, 0, 14, "Filament", kvariance*4, konset+krel+1, krootnote, krel, konset
    schedkwhennamed ktrig, 0, 14, "Filament", kvariance*5, konset+krel+1, krootnote, krel, konset

endin

instr Filament
iroot = p4
inote = int(random(0,7))
icps = cpsmidinn(iroot+giNotes[inote])
irel = p5
idir = round(random(0,1)) ; forwards or rev envelope?
ionset=p6
isus = random(0.5, 0.9)
itype = idir > 0 ? 0.5 : -0.5 ; randomize envelope curve
kamp transeg 0.01, ionset, itype, isus, irel, -0.2, 0.01
iplk= random(0.5,0.9)
kpick = random(0.01, 0.5)
krefl = random(0.1, 0.7*gkYTop) 
apluck = wgpluck2(iplk, kamp, icps, kpick, krefl)
avcf moogvcf apluck*kamp, 200+(gkXBot*7000), 0.1
aband butterbp avcf, 700, 200+chnget:k("Band")*2000
ipanrand=random(-0.5, 0.5)
apluckL, apluckR pan2 aband, 0.5+(ipanrand*chnget:k("Spread"))

chnmix apluckL, "mixBusL"
chnmix apluckR, "mixBusR"
idelsend = random(0.2, 0.7)
iverbsend = 0.5 ;random(0.1, 0.5)

chnmix apluckL*idelsend, "delaySendL"
chnmix apluckR*idelsend, "delaySendR"
chnmix apluckL*iverbsend, "verbSendL"
chnmix apluckR*iverbsend, "verbSendR"
endin

instr Verb

aDelinL chnget "delaySendL"
aDelinR chnget "delaySendR"
aVerbinL chnget "verbSendL"
aVerbinR chnget "verbSendR"
adelL init 0
adelR init 0
kfb = scale(gkYTop, 0.1, 0.7) ;abs(jspline(gkYTop, 0.1, 0.01))
kdel = 200+(50*gkYBot) ;(chnget:k("Space")) ;rspline(100, 800*, 0.01, 0.2)
adel = interp(portk(kdel, 0.05))
aoffset = rspline(-20, 20, 0.05, 0.3)
adelL vdelay aDelinL+(adelL*kfb), adel, 1000
adelR vdelay aDelinR+(adelR*kfb), adel+aoffset, 1000
kdecay = 0.9*chnget:k("Space")
averbL, averbR reverbsc aVerbinL, aVerbinR, kdecay, 10000
chnmix adelL+averbL, "mixBusL"
chnmix adelR+averbR, "mixBusR"
chnclear "delaySendL"
chnclear "delaySendR"
chnclear "verbSendL"
chnclear "verbSendR"
endin

instr Mixer
amixL chnget "mixBusL"
amixR chnget "mixBusR"
alowcutL butterhp amixL, 100
alowcutR butterhp amixR, 100
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
;causes Csound to run for about 7000 years...
</CsScore>
</CsoundSynthesizer>
