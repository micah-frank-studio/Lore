<Cabbage>
; link channels

form caption("Spectral Delay") size(830, 660), colour(37,54,63), guiMode("queue"), pluginId("4973")
#define KNOB1 outlineColour(255,255,255,40) trackerColour(171,179,203), trackerInsideRadius (0.8), colour(210, 215, 211, 0), textColour(90,90,90, 200), textColour("171,179,203"), textBoxOutlineColour("200, 200, 200"), markerColour("171,179,203"), popupText(0)
#define GROUPBOX lineThickness(0.5), outlineThickness(0.5), colour("5,500,0")
; color scheme [255,161,150] [171,179,203] [203,210,251] [90,99,241] [37,54,63]
// Signal Display In
signaldisplay bounds(10, 10, 400, 70), displayType("spectrogram"), backgroundColour(0,0,0), zoom(-1), signalVariable("afftInL"), skew(3)
signaldisplay bounds(420, 10, 400, 70), displayType("spectrogram"), backgroundColour(0,0,0), zoom(-1), signalVariable("afftInR"), skew(3)


groupbox bounds(10,90,600,100), colour(0,0,0,0), lineThickness(0),outlineThickness(0){
filebutton bounds (0, 0, 100, 20), populate("*.wav *.aif", "."), mode("file"), channel("File"), text("SOURCE")
button bounds(110, 0, 60, 20), latched(1), channel("PlayMode"), text("PLAY", "STOP"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 100, 100, 255)
;button bounds(180, 0, 60, 20), channel("Render"), text("RENDER"), fontColour:0(255, 255, 255), colour:0(50, 150, 255, 235), colour:1(200, 19, 19, 255)

rslider bounds(0,40, 50, 50), channel("Gain"), range(0,2,1,1), text ("GAIN") $KNOB1
rslider bounds(120,40, 50, 50), channel("ModRate1"), range(0,10,1,1,0.001), text ("RATE") $KNOB1
rslider bounds(180,40, 50, 50), channel("ModAmount1"), range(0,1,0.2,1), text ("AMOUNT") $KNOB1
combobox bounds(240, 40, 50, 20), items("Sine", "Saw", "Tri", "Square", "Saw Up", "Saw Down"), channel("LFOShape1")
combobox bounds(240, 65, 100, 20), items("Filter L", "Filter R", "Filter L/R", "Delay L", "Delay R", "Delay L/R", "Feedback L", "Feedback R", "Feedback L/R"), channel("LFODest1")
rslider bounds(400,40, 50, 50), channel("Mix"), range(0,1,0.5,1), text ("MIX") $KNOB1
rslider bounds(460,40, 50, 50), channel("Output"), range(0,2,0.5,0.7,0.001), text ("OUTPUT") $KNOB1

}
button bounds(150, 200, 60, 20), latched(0), channel("Random"), text("RANDOM"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255,120,140, 255)

button bounds(10, 200, 60, 20), latched(1), channel("ChanSelect"), text("LEFT", "RIGHT"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 228, 100, 255)
button bounds(80, 200, 60, 20), latched(0), channel("CopyAttenL"), text("COPY>R"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 228, 100, 255)
button bounds(80, 200, 60, 20), latched(0), channel("CopyAttenR"), text("COPY>L"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 228, 100, 255), visible(0)
gentable tableNumber(97) bounds(10,225,810,140) ampRange(0,1, 97, 0.01) tableGridColour(50,50,50), channel("attenGraphL"), tableColour:N(90,99,241,100) tableBackgroundColour(0, 0, 0), active(1);, visible(1)

button bounds(10, 400, 60, 20), latched(1), channel("TimeFeedMode"), text("TIME", "FDBACK"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 228, 100, 255)
button bounds(80, 400, 60, 20), latched(0), channel("CopyTimeL"), text("COPY>R"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 228, 100, 255)
button bounds(80, 400, 60, 20), latched(0), channel("CopyFBL"), text("COPY>R"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 228, 100, 255), visible(0)
button bounds(80, 400, 60, 20), latched(0), channel("CopyTimeR"), text("COPY>L"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 228, 100, 255), visible(0)
button bounds(80, 400, 60, 20), latched(0), channel("CopyFBR"), text("COPY>L"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 228, 100, 255), visible(0)

gentable tableNumber(97) bounds(10,425,810,140) ampRange(0,4,97,0.01) tableGridColour(50,50,50), channel("DelGraphL"), tableColour:N(241, 196, 15, 100) tableBackgroundColour(0, 0, 0), active(1)
;gentable tableNumber(105) bounds(10,425,810,140) ampRange(0,4,105,0.01) tableGridColour(50,50,50), channel("DelGraphR"), tableColour:N(80, 200, 200, 100) tableBackgroundColour(0, 0, 0), active(1),visible(0)
gentable tableNumber(97) bounds(10,425,810,140) ampRange(0,1,97,0.01) tableGridColour(50,50,50), channel("FBGraphL"), tableColour:N(241, 0, 15, 100) tableBackgroundColour(0, 0, 0), active(1),visible(0)
;gentable tableNumber(109) bounds(10,425,810,140) ampRange(0,1,109,0.01) tableGridColour(50,50,50), channel("FBGraphR"), tableColour:N(80, 200, 0, 100) tableBackgroundColour(0, 0, 0), active(1),visible(0)

image bounds(10,225,810,140), channel("attenMatrixR"), colour(200,100,0,0), visible(0)
image bounds(10,225,810,140), channel("attenMatrixL"), colour(255,120,140,0)
image bounds(10,425,810,140), channel("DelMatrixR"), colour(0,200,200,0), visible(0)
image bounds(10,425,810,140), channel("FBMatrixR"), colour(41,129,188,0), visible(0)
image bounds(10,425,810,140), channel("DelMatrixL"), colour(250,250,0,0)
image bounds(10,425,810,140), channel("FBMatrixL"), colour(200,0,100,0), visible(0)


// Signal Display Out
signaldisplay bounds(10, 580, 400, 70), displayType("spectrogram"), backgroundColour(0,0,0), zoom(-1), signalVariable("afftOutL"), skew(0.5)
signaldisplay bounds(420, 580, 400, 70), displayType("spectrogram"), backgroundColour(0,0,0), zoom(-1), signalVariable("afftOutR"), skew(0.5)
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
seed 0

gifftsize = 1024
gibinpts = 513
gibands = 64
gidefaultVal = 0.7

giEmptyGrid ftgen 97, 0, gibands, 7, gibands

gimaskL ftgen 98, 0, gibinpts, -2, 0
gimaskR ftgen 99, 0, gibinpts, -2, 0
gigraphL ftgen 101, 0, gibands, -7, gidefaultVal*0.7, gibands/2, gidefaultVal*0.3, gibands/2, gidefaultVal*0.7
gigraphR ftgen 102, 0, gibands, -7, gidefaultVal*0.7, gibands/2, gidefaultVal*0.3, gibands/2, gidefaultVal*0.7

giDelTableL ftgen 103, 0, gibands, -7, gidefaultVal*0.7, gibands/4, gidefaultVal*0.3, gibands/4, gidefaultVal*0.5, gibands/4, gidefaultVal*0.3, gibands/4, gidefaultVal*0.5
gidelL ftgen 104, 0, 1024, -2, 0
giDelTableR ftgen 105, 0, gibands, -7, gidefaultVal*0.3, gibands/4, gidefaultVal*0.7, gibands/4, gidefaultVal*0.5, gibands/4, gidefaultVal*0.7, gibands/4, gidefaultVal*0.5
gidelR ftgen 106, 0, 1024, -2, 0

giFBTableL ftgen 107, 0, gibands, -7, gidefaultVal*0.2, gibands, gidefaultVal*0.2
gifbL ftgen 108, 0, 1024, -2, 0
giFBTableR ftgen 109, 0, gibands, -7, gidefaultVal*0.2, gibands, gidefaultVal*0.2
gifbR ftgen 110, 0, 1024, -2, 0

gimask ftgen 111, 0, gibands, -2, 0

opcode updateTable, 0, kS
    kTable, SVGChannel xin
    kCnt init 0
    kAmp init 1
    kBounds[] cabbageGet SVGChannel, "bounds"
    kcolour[] cabbageGet SVGChannel, "colour"
    kLength = gibands
    kRectWidth = kBounds[2] / kLength
    SPath init ""
    draw:
   if kCnt < kLength then      
        kAmp = 1-table(kCnt, i(kTable))
        SPath strcatk SPath, sprintfk({{
        <rect x="%d" y="%f" width="%d" height="%d" style="fill:rgba(90,99,241,0.0);stroke-width:1;stroke:rgba(%d,%d,%d,0.8)" />}}, 
        kCnt/kLength * kBounds[2], kBounds[3]*kAmp, kRectWidth, kBounds[3]-kBounds[3]*kAmp, kcolour[0], kcolour[1], kcolour[2])  
        kCnt += 1
        kgoto draw
    endif
    cabbageSet 1, SVGChannel, "svgElement", SPath
    kCnt = 0 
    SPath strcpyk "" 
endop

opcode mouseListen, 0, iS
    iTable, SVGChannel xin
    iTableBounds[] cabbageGet SVGChannel, "bounds"
    iLength = gibands
    kMouseX chnget "MOUSE_X"
    kMouseY chnget "MOUSE_Y"
    kMouseDown chnget "MOUSE_DOWN_LEFT"
    SWidget, kTrigWidgetChange cabbageGet "CURRENT_WIDGET" 

    if strcmpk(SWidget, SVGChannel) == 0 && kMouseDown == 1 && kMouseX > iTableBounds[0] && kMouseX < iTableBounds[2] then
        kYAmp = 1 - int(((kMouseY-iTableBounds[1])/iTableBounds[3])*10 + .5) / 10
        kXIndex = int(((kMouseX-iTableBounds[0]) / iTableBounds[2])*iLength)
        tabw kYAmp, kXIndex, iTable
        if changed:k(kXIndex) == 1 then
            updateTable iTable, SVGChannel
        endif
    endif
endop


instr 1
kinitTables init 0

if kinitTables < 1 then
    updateTable 102, "attenMatrixR"
    updateTable 101, "attenMatrixL"
    updateTable 105, "DelMatrixR"
    updateTable 103, "DelMatrixL"
    updateTable 109, "FBMatrixR"
    updateTable 107, "FBMatrixL"
    kinitTables = 100
endif
 
gSfile=chnget:S("File")

if changed(gSfile) > 0 then 
    turnoff2 2, 0, 0
    printf "%s\n", k(1), gSfile
        kpos  strrindexk gSfile, "/"  ;look for the rightmost '/'
        Snam   strsubk    gSfile, kpos+1, -1    ;extract the substring
        SMessage sprintfk "text(\"%s\") ", Snam
        cabbageSet 1, "File", SMessage
endif 



ki2 active 2
if ki2 > 0 && chnget:k("PlayMode") < 1 then; if instr 2 is running and stop mode is activated, turnoff 2
    turnoff2 2, 0, 0
endif   
if strlenk(gSfile) > 1 && ki2 < 1 && chnget:k("PlayMode") > 0 then ;if a file is loaded and play mode is activated
    event "i", 2, 0, 500000    
endif 
 
mouseListen 101, "attenMatrixL"
mouseListen 102, "attenMatrixR"
mouseListen 103, "DelMatrixL"
mouseListen 105, "DelMatrixR"
mouseListen 107, "FBMatrixL"
mouseListen 109, "FBMatrixR"

//# RANDOM Function
if chnget:k("Random") > 0 then
    krandcnt = 0
    loadRandVals:
    if krandcnt < gibands then
        kval101 = abs(rand(1,0))
        kval102 = abs(rand(1,1))
        kval103 = abs(rand(1,2))
        kval105 = abs(rand(1,3))
        kval107 = abs(rand(1,4))
        kval109 = abs(rand(1,0.5))
        tabw kval101, krandcnt, 101
        tabw kval102, krandcnt, 102
        tabw kval103, krandcnt, 103
        tabw kval105, krandcnt, 105
        tabw kval107, krandcnt, 107
        tabw kval109, krandcnt, 109
        krandcnt += 1
        kgoto loadRandVals
    endif
    updateTable 102, "attenMatrixR"
    updateTable 101, "attenMatrixL"
    updateTable 105, "DelMatrixR"
    updateTable 103, "DelMatrixL"
    updateTable 109, "FBMatrixR"
    updateTable 107, "FBMatrixL"   
endif

kChanSelVal, kChanTrig cabbageGet "ChanSelect"
kFBModeVal, kFBTrig cabbageGet "TimeFeedMode"
StateToggle[] fillarray "ChanSelect", "TimeFeedMode"
SChannel, kstateTrig cabbageChanged StateToggle
cabbageSet kstateTrig, "attenMatrixL", sprintfk("visible(%i)", 1-kChanSelVal)
cabbageSet kstateTrig, "CopyAttenL", sprintfk("visible(%i)", 1-kChanSelVal)

cabbageSet kstateTrig, "attenMatrixR", sprintfk("visible(%i)", kChanSelVal)
cabbageSet kstateTrig, "CopyAttenR", sprintfk("visible(%i)",  kChanSelVal)

if kstateTrig > 0 && kFBModeVal > 0 then ; show Feedback Matrix
    cabbageSet kstateTrig, "FBMatrixL", sprintfk("visible(%i)", 1-kChanSelVal)
    cabbageSet kstateTrig, "FBMatrixR", sprintfk("visible(%i)", kChanSelVal)
    cabbageSet kstateTrig, "DelMatrixL", sprintfk("visible(%i)", 1-kstateTrig)
    cabbageSet kstateTrig, "DelMatrixR", sprintfk("visible(%i)", 1-kstateTrig)
    
    cabbageSet kstateTrig, "CopyFBL", sprintfk("visible(%i)", 1-kChanSelVal)
    cabbageSet kstateTrig, "CopyFBR", sprintfk("visible(%i)", kChanSelVal)
    cabbageSet kstateTrig, "CopyTimeL", sprintfk("visible(%i)", 1-kstateTrig)
    cabbageSet kstateTrig, "CopyTimeR", sprintfk("visible(%i)", 1-kstateTrig)
    
elseif kstateTrig > 0 && kFBModeVal < 1 then ; Show delay time matrix
    cabbageSet kstateTrig, "FBMatrixL", sprintfk("visible(%i)", 1-kstateTrig)
    cabbageSet kstateTrig, "FBMatrixR", sprintfk("visible(%i)", 1-kstateTrig)
    cabbageSet kstateTrig, "DelMatrixL", sprintfk("visible(%i)", 1-kChanSelVal)
    cabbageSet kstateTrig, "DelMatrixR", sprintfk("visible(%i)", kChanSelVal)
    
    
    cabbageSet kstateTrig, "CopyFBL", sprintfk("visible(%i)", 1-kstateTrig)
    cabbageSet kstateTrig, "CopyFBR", sprintfk("visible(%i)", 1-kstateTrig)
    cabbageSet kstateTrig, "CopyTimeL", sprintfk("visible(%i)", 1-kChanSelVal)
    cabbageSet kstateTrig, "CopyTimeR", sprintfk("visible(%i)", kChanSelVal)
endif

//# Table Copy Function
if chnget:k("CopyAttenL") > 0 then 
    tablecopy gigraphR, gigraphL
    updateTable 102, "attenMatrixR"
elseif chnget:k("CopyAttenR") > 0 then 
    tablecopy gigraphL, gigraphR
    updateTable 101, "attenMatrixL"
elseif chnget:k("CopyTimeL") > 0 then 
    tablecopy giDelTableR, giDelTableL
    updateTable 105, "DelMatrixR"
elseif chnget:k("CopyTimeR") > 0 then 
    tablecopy giDelTableL, giDelTableR
    updateTable 103, "DelMatrixL"
elseif chnget:k("CopyFBL") > 0 then 
    tablecopy giFBTableR, giFBTableL
    updateTable 109, "FBMatrixR"
elseif chnget:k("CopyFBR") > 0 then 
    tablecopy giFBTableL, giFBTableR
    updateTable 107, "FBMatrixL"
endif


endin

instr 2
kdx init 0
ioverlap = gifftsize*0.25
iwinsize = gifftsize*2
imaxlen = 5 ;max length of delay buffer

iNChns  filenchnls  gSfile
    if iNChns==2 then
        ainL, ainR diskin gSfile,1,0,1
    else
        ainL diskin gSfile,1,0,1
        ainR diskin gSfile,1,0,1
    endif

fftinL  pvsanal   ainL, gifftsize, ioverlap, iwinsize, 1
fftinR  pvsanal   ainR, gifftsize, ioverlap, iwinsize, 1


kshape1 chnget "LFOShape1" 
ktype1 = kshape1 == 0 ? 0 : kshape1 ; sine
ktype1 = kshape1 == 1 ? 1 : kshape1 ; triangle
ktype1 = kshape1 == 2 ? 2 : kshape1 ; square
ktype1 = kshape1 == 3 ? 4 : kshape1 ; saw up
ktype1 = kshape1 == 4 ? 5 : kshape1 ; saw down

//# MODULATION
refreshLFO:
itype1 = i(ktype1)
rireturn
if changed(ktype1) == 1 then
reinit refreshLFO
endif 

kmodDest1 = chnget("LFODest1")
kmodAmt1 = chnget("ModAmount1")
kmodRate1 = chnget("ModRate1")
kattenmod = kmodDest1==3 ? lfo(kmodAmt1, kmodRate1, itype1) : 0
kdelmod = kmodDest1==6 ? lfo(kmodAmt1, kmodRate1, itype1) : 0
kfbmod = kmodDest1==9 ? lfo(kmodAmt1, kmodRate1, itype1) : 0
kattenmod = abs(kattenmod)
kdelmod = abs(kdelmod)
kfbmod = abs(kfbmod)
kmodleft = kmodDest1 == 1 ? 1 : 0
kmodleft = kmodDest1 == 4 ? 1 : 0
kmodleft = kmodDest1 == 7 ? 1 : 0

kmodright = kmodDest1 == 2 ? 1 : 0
kmodright = kmodDest1 == 5 ? 1 : 0
kmodright = kmodDest1 == 8 ? 1 : 0

//copy tables to full res masks
tablecopy gimaskL, gigraphL
tablecopy gidelL, giDelTableL
;tablecopy gifbL, giFBTableL
tablecopy gimaskR, gigraphR
tablecopy gidelR, giDelTableR
tablecopy gifbR, giFBTableR

if kfbmod > 0 then
// scale gifbl to modulate it
kfbarrayL[] init gibands ;create array to store fb values
copyf2array kfbarrayL, giFBTableL ; copy fb table to array (for scaling)
scalearray kfbarrayL, 0, 1-(kfbmod*kmodleft) ; scale vals in fb table based on lfo val
copya2ftab kfbarrayL, gifbL ; copy array to gifb masking table

kfbarrayR[] init gibands ;create array to store fb values
copyf2array kfbarrayR, giFBTableR ; copy fb table to array (for scaling)
scalearray kfbarrayR, 0, 1-(kfbmod*kmodright) ; scale vals in fb table based on lfo val
copya2ftab kfbarrayR, gifbR ; copy array to gifb masking table

endif
///

fdelmaskL pvsinit gifftsize
fmaskL pvsmaska fftinL, gimaskL, 1-(1*abs(kattenmod)*kmodleft)
//Left Delay Line and Buffer
ffbL pvsmix fmaskL, fdelmaskL ; mix feedback mask back into buffer
ibufL, kwriteTimeL pvsbuffer ffbL, imaxlen
fdelL pvsbufread2 kwriteTimeL, ibufL, gidelL, gidelL ;ift 1 & 2 at least n/2 + 1 positions long. n= # bins
fdelmaskL pvsmaska fdelL, gifbL, 1-(1*abs(kdelmod)*kmodleft) ; mask fdelL with feedback table

aoutL    pvsynth  fdelL
amixL ntrpol ainL, aoutL*chnget:k("Gain"), chnget:k("Mix") 

fdelmaskR pvsinit gifftsize
fmaskR pvsmaska fftinR, gimaskR, 1-(1*abs(kattenmod)*kmodright)
//Right Delay Line and Buffer
ffbR pvsmix fmaskR, fdelmaskR ; mix feedback mask back into buffer
ibufR, kwriteTimeR pvsbuffer ffbR, imaxlen
fdelR pvsbufread2 kwriteTimeR, ibufR, gidelR, gidelR ;ift 1 & 2 at least n/2 + 1 positions long. n= # bins
fdelmaskR pvsmaska fdelR, gifbR, 1-(1*abs(kdelmod)*kmodright) ; mask fdelR with feedback table

aoutR    pvsynth  fdelR 
amixR ntrpol ainR, aoutR*chnget:k("Gain"), chnget:k("Mix") 


outs amixL*chnget:k("Output"), amixR*chnget:k("Output")
afftInL = ainL
afftInR = ainR
afftOutL = aoutL
afftOutR = aoutR
dispfft afftInL, 0.1, 2048, 0, 1
dispfft afftInR, 0.1, 2048, 0, 1
dispfft afftOutL, 0.1, 2048, 0, 1
dispfft afftOutR, 0.1, 2048, 0, 1
endin

instr recorder
    prints "========NEW RECORDER INSTANCE========\n"
    Sdir init "."
	Sdir=chnget:S("Output")
	;; random word generator
	icount init 0
	iwordLength random 2,4 ; how long will the random word be (when this number is doubled)
	iwordLength = int(iwordLength)
	StringAll =       "bcdfghjklmnpqrstvwxz"
	StringVowels =     "aeiouy"
	Stitle = ""
	cycle:
	if icount < iwordLength then
	irandomLetter  random 1,20
	irandomVowel  random 1,6
	Ssrc1 strsub StringAll, irandomLetter,irandomLetter+1
	Ssrc2 strsub StringVowels, irandomVowel,irandomVowel+1
	Ssrc1 strcat Ssrc1, Ssrc2 ; combine consonants and vowels
	Stitle strcat Stitle, Ssrc1 ;add to previous string iteration
                icount += 1
                goto cycle
endif

	aDL chnget "DryL"
	aDR chnget "DryR"
	aVL chnget "VerbOutL"
	aVR chnget "VerbOutR"

    amixL = aDL + aVL
    amixR = aDR + aVR
	;;file writing

    Sdir strcat Sdir, "/"
	Sfilename strcat Sdir, Stitle
	Sfilename strcat  Sfilename, ".wav"
	fout Sfilename, 18, amixL, amixR

	chnclear "DryL"
	chnclear "DryR"
	chnclear "VerbOutL"
	chnclear "VerbOutR"

endin


</CsInstruments>
<CsScore>
i1 0 500000
</CsScore>
</CsoundSynthesizer>
