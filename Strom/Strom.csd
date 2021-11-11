<Cabbage>
; Strom
; Sound Design and programming by Micah Frank (http://micahfrank.com)
; Artwork by Dan Meth (http://danmeth.com)
; Puremagnetik » Brooklyn, NYC 2021
; XY Pad Opcode by Rory Walsh 

;Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
;Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
;NonCommercial — You may not use the material for commercial purposes.
;No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

<Cabbage>
form caption("Strom") size(500, 500), guiMode("queue"), pluginId("pm45"), opcodeDir("."), bundle("./includes"), typeface("includes/Oxygen-Light.ttf")
image bounds(5, 20, 244, 350), channel("XYPad1")
image bounds(251, 20, 244, 350), channel("XYPad2")
image bounds(0, 0, 500, 500), file("includes/Strom_BG.png")
signaldisplay bounds(50, 390, 450, 40), colour(173, 204, 199), backgroundColour(41,40,43,0), displayType("waveform"), signalVariable("adisplay"), zoom(-1)
image bounds(105, 70, 60, 60), channel("Phoen"), alpha(0.8), colour(0,0,0,0), file("includes/Strom_controlLeft.png"), active(0) 
image bounds(330, 270, 60, 60), channel("Gleis"), alpha(0.5), colour(0,0,0,0), file("includes/Strom_controlRight.png"), alpha(0.8)
#define KNOB1 outlineColour(255,255,255,40) trackerColour(88,157,114,200), trackerThickness (0.11), style ("normal"), trackerOutsideRadius(1), trackerInsideRadius (0.1), colour(210, 215, 211, 0), textColour(218,218,218, 200)
#define GROUPBOX fontColour(30, 30, 30), outlineColour(30, 30, 30, 0), colour(0, 0, 0, 0), outlineThickness(1), lineThickness(0)
#define BUTTON1 fontColour:0("30,30,30"), fontColour:1("30,30,30"), colour:0("245,245,245,200"), colour:1("245,245,245,200"), outlineColour("30,30,30,250"), outlineThickness(2), corners(0)
groupbox bounds(0, 0, 500, 436) channel("Settings"), text(""), visible(0) $GROUPBOX {
    image bounds(0, 0, 500, 436), colour("0,0,0,220")
    texteditor bounds(30, 30, 450, 400), text(""), fontSize(15), channel("InfoText"), scrollbars(0), wrap(1), fontColour(255, 255, 255, 200), colour(0, 0, 0, 0), readOnly(1)
    button bounds(390, 398, 45, 22), latched(1), text("SELF", "SYNC"), channel("SyncMode") $BUTTON1
    rslider bounds(60, 362, 60, 60), channel("Distance"), text("DISTANCE"), range(0, 1, 0.2, 1, 0.001),, popupText(0)  $KNOB1
    rslider bounds(130, 362, 60, 60), channel("Octave"), text("OCTAVE"), range(-2, 2, 1, 1, 1)  $KNOB1
    rslider bounds(200, 362, 60, 60), channel("Grain"), text("GRAIN"), range(0, 1, 0.3, 1, 0.001), popupText(0)  $KNOB1
    rslider bounds(270, 362, 60, 60), channel("Space"), text("SPACE"), range(0, 1, 0.7, 1, 0.001), popupText(0)  $KNOB1
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

massign 0, 0 ; mute incoming MIDI from instr triggering.
giRecBuf1L ftgen	0,0,131072,2,0 
giRecBuf1R ftgen	0,0,131072,2,0
giwin ftgen 1, 0, 8192, 20, 2, 1  ;Hanning window

schedule 2, 0, 500000
schedule "UIcontrol", 0, 500000
schedule "Verb", 0, 500000
schedule "Mixer", 0, 500000

opcode randoPan, aa, a
	ain xin
	kpan=gauss(0.5)
	asigL, asigR pan2 ain, 0.5+kpan
	xout asigL, asigR
endop

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
        gkXBot, gkYBot XYPad "XYPad2", "Gleis", "includes/ControlRight.png", "includes/ControlRightb.png", 60
    endif  
    
    cabbageSet "InfoText", "text",{{Strom is a self-generating synthesizer with a physically modeled string and plucked voice combined with a filtered noise generator. The synthesis section sums into a granular processor for advanced micro texture creation.

Move the left and right orbs/eyes to control pluck/string timbre and grain attributes.

- Self/Sync will enable generation only when the host transport is running.  
- MIDI note input will change the base pitch of the sequence.
- Distance offsets a duplicate sequence to be 
    octave-shifted by the Octave control.
- Octave changes the secondary sequence from -2 to +2 octaves. 
    In the center position there is no octave change.
- Grain controls the balance between natural and granular processes.
- Space increases and decreases reflections and room size.
- (A)utomate will automate sphere movement.
- (R)ecord will render the output to an audio file on disk.
- Scales includes a collection of scales that the sequence will conform to.

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
kbpm chnget "HOST_BPM" ; get host bpm
kQuarterNoteInHz = kbpm/60 ; calculate quarter notes
idiv[] fillarray 0.25, 0.5, 1, 2, 4 ;beat divisions - whole to 16th
kdivSelect=rspline(0, 4, 0.1, 2) ; controller to change length of beat divisions
kpulse = kQuarterNoteInHz*idiv[kdivSelect] 
    ktrig = metro(kpulse,0)
    kbarRate=metro(kpulse*2) ; bar trigger is 4x and scaled by Left X
    //# MIDI note handling
    inoteinit = random(36, 47)
    krootnote init inoteinit 
    kstatus, kchan, knote, kdata2 midiin
    if (changed:k(knote)) == 1 && kstatus == 144 then ; if it's a new note
        krootnote = knote
    endif
    klen trandom kpulse, 0.2, 4*gkXTop+0.3 
    kdistance chnget "Distance"
    kdistance scale kdistance, 2, 0
    koctave chnget "Octave"
    schedkwhennamed kpulse, 0, 4, "Strom", 0, klen+0.1, krootnote
    schedkwhennamed kpulse, 0, 4, "Strom", kdistance, klen+0.1, krootnote+(12*koctave)  
endin

instr Strom
ilength = p3
iroot = p4
inote = int(random(0,7))
kcps = cpsmidinn(iroot+giNotes[inote])
irel = random(0.005, 0.1)
ipasstype = round(random(0,1)) ; hi or lo pass filter?
idir = round(random(0,1)) ; forwards or rev envelope?
ionset=random(0.01, ilength-irel)
if idir>0 then
    kamp expseg 0.0001, ionset, 0.999, irel, 0.0001
else 
    kamp expseg 0.0001, irel, 0.999, ionset, 0.0001
endif
kbeta = random(-0.3, 0.5)
ifiltfreq=random(0, 1)
iSkew = 0.5 ; factor for exponential scaling
kfiltfreq = pow(ifiltfreq, 1/iSkew)
kfiltfreq scale kfiltfreq, 9000, 50
anoise noise (0.4*gkXBot)+0.1, kbeta
avco=vco2(kamp, kcps)
iplk=random(0.5,0.9)
ipluckfreq = p4
kpick = random(0.1, 0.5)
krefl = random(0.7, (0.7*gkYTop)+0.1)
apluck = repluck(iplk, 1, ipluckfreq, kpick, krefl, anoise)
apluckL, apluckR randoPan apluck
avcoL, avcoR randoPan avco
anoiseL, anoiseR randoPan anoise
alowL, ahighL, aband svfilter anoiseL+avcoL+apluckL, kfiltfreq, 0
alowR, ahighR, aband svfilter anoiseR+avcoR+apluckR, kfiltfreq, 0
amixL = ipasstype > 0 ? alowL : ahighL
amixR = ipasstype > 0 ? alowR : ahighR
   
    ifn = 1
	iolaps = 2 
	
	itablelength = ftlen(giRecBuf1L)
    isr = sr
	kndx = (1/(itablelength/isr)) ;speed calculation for phasor
	andx		phasor kndx
	tablew   amixL, andx, giRecBuf1L,1 ; write audio to function table
 	tablew   amixR, andx, giRecBuf1R,1 ; write audio to function table
    kdens = (gkYBot*20) + 2
    kchop portk gkXBot, 0.01
	
	klstart = 0
	kpitch = 1
	kgrsize=scale(1, 0.1, kchop)
	krate = scale(gkXTop, 1, -1)
	;ips     = 1/iolaps
	
    agrainL syncloop 0.8, kdens, 1, kgrsize, krate, klstart, itablelength, giRecBuf1L, ifn, iolaps
	agrainR syncloop 0.8, kdens, 1, kgrsize, krate, klstart, itablelength, giRecBuf1L, ifn, iolaps

    kgrainmix chnget "Grain"
    agrainmixL ntrpol amixL, agrainL, kgrainmix
    agrainmixR ntrpol amixR, agrainR, kgrainmix
    chnmix agrainmixL*kamp*0.5, "mixBusL"
    chnmix agrainmixR*kamp*0.5, "mixBusR"
    
    idelsend = random(0,0.4)
    chnmix agrainmixL*idelsend*0.5, "delaySendL"
    chnmix agrainmixR*idelsend*0.5, "delaySendR"
endin

instr Verb

aDelinL chnget "delaySendL"
aDelinR chnget "delaySendR"
aVerbinL chnget "verbSendL"
aVerbinR chnget "verbSendR"
adelL init 0
adelR init 0
kfb = abs(jspline(0.6*chnget:k("Space"), 0.1, 0.01))
adel = rspline(100, (600*gkYBot)+200, 0.01, 0.2)
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

instr Mixer
amixL chnget "mixBusL"
amixR chnget "mixBusR"
alowcutL butterhp amixL, 60
alowcutR butterhp amixR, 60
alowcutLd dcblock alowcutL
alowcutRd dcblock alowcutR
alowcutLl limit alowcutLd, -0.9, 0.9
alowcutRl limit alowcutRd, -0.9, 0.9
outs alowcutLl, alowcutRl
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
f0 z
</CsScore>
</CsoundSynthesizer>
