; Ember - Microsound Collage Console
; Sound Design by Micah Frank (http://micahfrank.com)
; Artwork by Dan Meth (http://danmeth.com)
; Puremagnetik » Brooklyn, NYC 2021
; XY Pad Opcode by Rory Walsh

;Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
;Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
;NonCommercial — You may not use the material for commercial purposes.
;No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.


<Cabbage>
form caption("Ember") size(500, 526), guiMode("queue"), pluginId("pm47"), opcodeDir("."), bundle("./includes");, typeface("includes/Oxygen-Light.ttf")
#define KNOB1 outlineColour(255,255,255,40) trackerColour(171,179,203), trackerInsideRadius (0.8), colour(210, 215, 211, 0), textColour(90,90,90, 200), textColour("171,179,203"), textBoxOutlineColour("200, 200, 200"), markerColour("171,179,203"), popupText(0)
image bounds(5, 20, 244, 320), channel("XYPad1")
image bounds(251, 20, 244, 320), channel("XYPad2")
image bounds(0, 0, 500, 526), file("includes/Ember_bg.png")

groupbox bounds(0, 345, 500, 50), colour(0,0,0,0), lineThickness(0), outlineThickness(0) {

label bounds (55,31,100,12), text("Composite Time"), fontColour("200, 200, 200"), align("left")
nslider bounds (10,25,40,25), range(1,7000,100,0.5, 1), channel("CompositeTime")

label bounds (205,31,100,12), text("Min Sound Dur"), fontColour("200, 200, 200"), align("left")
nslider bounds (160,25,40,25), range(0.5,10,4,1), channel("MinDur")

label bounds (355,31,100,12), text("Max Sound Dur"), fontColour("200, 200, 200"), align("left")
nslider bounds (310,25,40,25), range(1,20,7,1), channel("MaxDur")

}

image bounds(370, 250, 90, 90), channel("Gleis"), alpha(1), colour(0,0,0,0), file("includes/EmberControlRight.png"), alpha(0.8)
#define GROUPBOX fontColour(30, 30, 30), outlineColour(30, 30, 30, 0), colour(0, 0, 0, 0), outlineThickness(1), lineThickness(0)
image bounds(80, 170, 90, 90), channel("Phoen"), alpha(1), colour(0,0,0,0), file("includes/EmberControlLeft.png"), active(0)
filebutton bounds (10, 405, 200, 20), mode("directory"), channel("Samples"), text("Sample Folder..."),fontColour(255, 255, 255), colour:0(19, 19, 19, 255), colour:1(19, 19, 19, 200)
filebutton bounds(10, 430, 200, 20), channel("Output"), text("Output Folder..."), mode("directory"), fontColour(255, 255, 255), colour:0(19, 19, 19, 200)
label bounds(270,408,200,15), fontColour(255,255,255), text("Select a sample folder"), alpha(0), channel("SampleWarning")
label bounds(270,433,200,15), fontColour(255,255,255), text("Select an output folder"), alpha(0), channel("FolderWarning")
button bounds(220, 405, 60, 20), latched(1), channel("Binaural"), text("BINARL"), fontColour(255, 255, 255), fontColour:1(0, 0, 0), colour:0(19, 19, 19, 255), colour:1(255, 228, 100, 255)
button bounds(220, 430, 60, 20), channel("Render"), text("RENDER"), fontColour:0(255, 255, 255), colour:0(50, 150, 255, 235), colour:1(200, 19, 19, 255)

// Sample Load Progress Bar
image bounds(288, 415, 200, 3), colour(200,200,200), channel("loadbarbg"), visible(0)
image bounds(288, 415, 200, 3), colour(200,200,200), channel("loadbar"), visible(0)
label bounds(288, 425, 200, 15) channel("loadingtext"), colour(250,250,250,0), text("Loading..."), fontStyle("plain"), fontColour(255, 255, 255), align("left"), visible(0)
groupbox bounds(0, 0, 500, 460) channel("HelpPanel"), text(""), visible(0) $GROUPBOX {
    image bounds(0, 0, 500, 460), colour("30,30,30,250")
    texteditor bounds(30, 30, 450, 400), text(""), fontSize(15), channel("InfoText"), scrollbars(0), wrap(1), fontColour(255, 255, 255, 200), colour(0, 0, 0, 0), readOnly(1)
}
button bounds(450, 430, 20, 20), channel("HelpButton"), latched(0), text("?"), fontColour:0(255, 255, 255), fontColour:1(40, 40, 40), colour:0(40, 40, 40, 200), colour:1(200, 200, 200, 200)


/*
gkXTop = Grain density
gkYTop = Pitch
gkXBot = Rate
gkYBot = Grain Size
*/

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5 -m0d
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2
0dbfs = 1
seed 0

gimaxsounds init 0 ;maximum # of sounds to pull
gilen init 0 ; maximum length in seconds per sound
gitime init 0
giChangeSounds = 0 ; change sound palette after gilen (0=no, 1=yes)
gi1 ftgen 1,0,8192,20,2,1 ;Hanning Window
giL[] init 200 ;one alloc per channel/ftable
giR[] init 200

schedule "verb", 0, 500000
schedule "listener", 0, 500000
gkstop init 0
gkXTop init 0
gkXBot init 0
gkYTop init 0
gkYBot init 0
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


        kMouseLeftDown chnget "MOUSE_DOWN_LEFT"
        kXPos chnget "MOUSE_X"
        kYPos chnget "MOUSE_Y"


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

opcode grainPlayer, aa, i
	setksmps 1
	idur xin
	idx = int(linrand(gimaxsounds)) ; pick a random sample from the array
	ifreq = 4
	kfreq = (ifreq * gkXTop)+1
	kgrsize = (gkYBot*2)+0.1;
	ipsel = random(-1, 1)
	kpitchrand = rspline(0.2, gkYTop*3, 0.1, 0.3)
	kpitch = 0.1+((1-gkYTop)*3)
	;kprate= (2*gkXBot)+0.1
  kprate= scale(gkXBot, 2, -2)
	ifun = gi1
	iolaps =  50 ; must be equal or greater to imaxfreq*imaxgrsize
	;ips     = 1/iolaps
	ilength = ftlen(giL[idx])/sr ;length of sample in seconds
		kstart = ilength*(jspline(0.8, 0.1, 0.3))
	kend = kstart+((ilength-kstart)*jspline(1, 0.1, 0.3))
			agrainL syncloop 1, kfreq, kpitch, kgrsize, kprate, kstart, kend, giL[idx], gi1, iolaps
			agrainR syncloop 1, kfreq, kpitch, kgrsize, kprate, kstart, kend, giR[idx], gi1, iolaps
	aoutL dcblock2 agrainL
	aoutR dcblock2 agrainR
 	xout aoutL, aoutR

endop

opcode varifilter, aa,aakki
	al, ar, kcf, kres, itype xin
	if itype < 1 then
	    kres limit kres, 0.001, 0.999
	    afl moogvcf2 ar, kcf, kres
	    afr moogvcf2 al, kcf, kres
	else
        afl butterhp al, kcf
        afr butterhp ar, kcf
	endif

    xout afl, afr
endop

opcode pdelay, aa, aaakk
	al,ar, adelay, kfeedback, kfbpshift xin ; spectral pshift not used
	imaxdelay = 3; seconds
	;delay L
	alfoL lfo 0.05, 0.2 ; slightly mod the left delay time
	abuf1		delayr	imaxdelay
	atapL  deltap3    adelay +alfoL
	delayw  al+ (atapL * kfeedback)

	;delay R
	alfoR lfo 0.05, 0.1 ; slightly mod the right delay time
	abuf2		delayr	imaxdelay
	atapR  deltap3    adelay +alfoR
	delayw  ar + (atapR * kfeedback)
	xout atapL, atapR
endop

opcode binaural, aa,aa
	ainL, ainR xin
	; Binaural Processing
  ; azimuthrange  -720, 720
  ;altitude range -40, 90
	isr = sr
	if (sr = 44100) then
	SfileL = "includes/HRTF/hrtf-44100-left.dat"
	SfileR = "includes/HRTF/hrtf-44100-right.dat"
	elseif (sr = 48000) then
	SfileL = "includes/HRTF/hrtf-48000-left.dat"
	SfileR = "includes/HRTF/hrtf-48000-right.dat"
	elseif (sr = 96000) then
	SfileL = "includes/HRTF/hrtf-96000-left.dat"
	SfileR = "includes/HRTF/hrtf-96000-right.dat"
	endif
	kazim = rspline(-720, 720, 0.01, 1)
	kalt = rspline(-40, 90, 0.01, 1)
	ahrtfL, ahrtfR hrtfmove2 ainL+ainR, kazim, kalt, SfileL, SfileR, 4, 9, isr
	xout ahrtfL, ahrtfR
endop

instr listener, 1
// Help Panel
        kHelpVal, kHelpTrig cabbageGetValue "HelpButton"
        SpanelState=sprintfk("visible(%i)", kHelpVal)
        cabbageSet kHelpTrig, "HelpPanel", SpanelState

        cabbageSet "InfoText", "text",{{Ember is a microsound processing console that uses granular resynthesis to explore a collage of sounds on the particle level. Select a folder containing any number of samples (the more the better) and an output folder. Ember loads a random number of sounds from the folder and selects a playback slice from each one. Ember also composites all sounds together with various granular time stretching, density and spatial algorithms.

Composite Time - The length of the output recording (in seconds)

Min Sound Dur - the minimum length to slice a sound (in seconds)

Max Sound Dur - the maximum length to slice a sound (in seconds)

BINARL - Create a spatial audio (binaural) mix

RENDER - Load the samples and begin processing. Abort the recording by pressing it again.

You can use the shapes in the UI to manually adjust granular parameters in real time:

Left shape X-axis = Grain density
Left shape Y-axis = Pitch
Right shape X-axis = Grain Rate
Right shape Y-axis = Grain Size

}}
// END HELP PANEL

gkXTop, gkYTop XYPad "XYPad1", "Phoen", "includes/ControlLeft.png", "includes/ControlLeftb.png", 90
gkXBot, gkYBot XYPad "XYPad2", "Gleis", "includes/ControlRight.png", "includes/ControlRightb.png", 90
SampleFolder, kTrigger cabbageGetValue "Samples"
gSdir, kRun cabbageGetValue "Output"
kstrlen strlenk gSdir
gSFiles[] cabbageFindFiles kTrigger, SampleFolder, "files", "*.wav;*.aif"
kNumSamples = lenarray:k(gSFiles)
krender chnget "Render"
//Keep Min and Max Dur within range of each other
if chnget:k("MaxDur") < chnget:k("MinDur") then
	    cabbageSetValue "MinDur", chnget:k("MaxDur"), metro(20)
	endif
if chnget:k("MinDur") > chnget:k("MaxDur") then
	    cabbageSetValue "MaxDur", chnget:k("MinDur"), metro(20)
	endif

if changed(krender) == 1 && krender == 1 then
    if kNumSamples < 1 then ; if no samples are selected display message
        cabbageSet 1, "SampleWarning", "alpha", "1"
        cabbageSetValue "Render", 0, 1
    elseif kstrlen < 1 then ; if no output folder is selected display message
        cabbageSet krender, "SampleWarning", "alpha", "0"
        cabbageSet 1, "FolderWarning", "alpha", "1"
        cabbageSetValue "Render", 0, 1
    else
        cabbageSet krender, "SampleWarning", "alpha", "0"
        cabbageSet krender, "FolderWarning", "alpha", "0"
        schedkwhen krender, 0, 1, 2, 0, 500000
    endif
endif

if changed(krender) == 1 && krender == 0 then
        turnoff2 2, 0, 0 ; turnoff timer
        turnoff2 3, 0, 0 ; turnoff sound engine
        turnoff2 6, 0, 0 ; turnoff recorder
    endif

if kNumSamples > 1 then ; if sample folder has been assigned
     gSFile chnget "Samples"
        ;printf "%s\n", k(1), gSFile
        kpos  strrindexk gSFile, "/"  ;look for the rightmost '/'
        Snam   strsubk    gSFile, kpos+1, -1    ;extract the substring
        SMessage sprintfk "text(\"%s\") ", Snam
        cabbageSet metro(10), "Samples", SMessage
endif


if kstrlen > 1 then ; if output folder has been assigned
        ;kscan = metro(10)
        ;SoutDir, kscan cabbageGetValue "Output"
        ;printf "%s\n", k(1), gSFile
        SoutDir chnget "Output"
        kpos  strrindexk SoutDir, "/"  ;look for the rightmost '/'
        SFolder   strsubk    SoutDir, kpos+1, -1    ;extract the substring
        SOutText sprintfk "text(\"%s\") ", SFolder
        cabbageSet metro(10), "Output", SOutText
endif

endin

instr timer, 2
    prints "Timer initialized\n"
	;koldtime init 0
	kelapsed times
	itime = chnget("CompositeTime")
	prints "Generating New Composite\n"
	gireverbmode = 1 ;1 = modulation of reverb params per sequence. 0 reverb setting is randomly chosen and stays static.
	ginumsounds = int(random(1,lenarray(gSFiles))) ;# of sounds to pull
	gilen = random(chnget("MaxDur"), chnget("MinDur")) ; maximum length in seconds per sound
	giverbfc = random(0.1, 0.9)
	giverbfblvl = random(0.2, 0.7)
	schedule 3, 0, itime
	schedule 6, 0, itime ;recorder
	if kelapsed > gitime then
	    cabbageSetValue "Render", 0, 1 ; turn off render button
	    turnoff
	endif

 endin

instr 3
	idirsize=lenarray(gSFiles) ;number of files in dir
	iselection[] init idirsize
	ibounds[] cabbageGet "loadbar", "bounds"
    imaxlength = ibounds[2]
	knewsounds metro 1/gilen
	if knewsounds == 1 && giChangeSounds = 1 then ; replace sound selection index every gilen seconds
		reinit newSounds
	printks "new sounds selected \n", 0.4
	endif
	newSounds:
	icount init 0
		makenums: ; make an array of indexes to pull file from in the directory
		if icount < ginumsounds && chnget("Render") > 0 then
			irand = int(random(0, idirsize)) ;choose a random index # for the directory
			iselection[icount] = irand		;put the number in the array
			ichn filenchnls gSFiles[irand]
			if ichn = 2 then
				giL[icount] ftgen 0, 0, 0, 1, gSFiles[irand], 0, 0, 1
				giR[icount] ftgen 0, 0, 0, 1, gSFiles[irand], 0, 0, 2
			else
				giL[icount] ftgen 0, 0, 0, 1, gSFiles[irand], 0, 0, 1
				giR[icount] ftgen 0, 0, 0, 1, gSFiles[irand], 0, 0, 1
			endif
			//sample load progress bar
			ipos  strrindex gSFiles[irand], "/"  ;look for the rightmost '/'
            SampleName   strsub    gSFiles[irand], ipos+1, -1    ;extract the substring
		    cabbageSet "loadbar", sprintf("bounds(%i, %i, %i, %i), colour(50, 150, 255), visible(1)", ibounds[0], ibounds[1], ibounds[2]*(icount/ginumsounds), ibounds[3])
		    cabbageSet "loadingtext", sprintf("fontColour(255, 255, 255), visible(1) text(\"Loading... %s\")", SampleName)
			cabbageSet "loadbarbg", "visible(1)"
			icount+=1
			goto makenums
		endif
	rireturn
	icomp = chnget("CompositeTime")
	ielapsed times ;calculate total file length only after files are loaded
	gitime = ielapsed + icomp
	imaxspeed=random(1, 10)
	kspeed=rspline(0.2, imaxspeed, 0.1, 0.3) ;create speed for metro
	ktrig=metro(kspeed)
	kdur1 = abs(rand(gilen))
	schedkwhennamed ktrig, 0, 0, "sound", 0, kdur1
	cabbageSet "loadbar", sprintf("bounds(%i, %i, %i, %i), visible(0)", ibounds[0], ibounds[1], imaxlength, ibounds[3])
	cabbageSet "loadbarbg", "visible(0)"
    cabbageSet "loadingtext", "visible(0)"
endin


instr sound, 4
	idur = p3
	agrainL, agrainR grainPlayer idur ; send file index and duration to grainplayer
	ahpL butterhp agrainL, 50		;filter out low freqs
	ahpR butterhp agrainR, 50
	kcf = rspline(0.1, 0.9, 0.1, 0.5)
	kcf = expcurve(kcf,50) ;add curve to normalized kcf
	kcf = scale(kcf, 20000, 5000); scale kcf to appropriate range
	kres = rspline(0, 0.1, 0.2, 0.5)
	itype=round(random(0,1)) ;high pass or low pass?
	afiltL, afiltR varifilter ahpL, ahpR, kcf, kres, itype
	kvolume = rspline(0.2, 0.5, 0.1, 0.3)
	idec = random(idur*0.2, idur*0.001) ; decay is a factor of total duration
	isuslev = random(0.3, 1)
	kamp = expseg(0.001, 0.001, 1, idur-idec-0.01, isuslev, idec, 0.001)*kvolume ; linen(1, 0.1, idur-idec-0.05, idec)*kvolume ;apply envelope to overall volume to fade in/out quickly
	if chnget:k("Binaural") > 0 then
	    apanL1, apanR1 binaural afiltL, afiltR
	    apanL2 = 0
	    apanR2 = 0
	else
	    kpan=rspline(0.2, 0.8, 0.1, 0.3)
	    apanL1, apanR1 pan2 afiltL, kpan
	    apanL2, apanR2 pan2 afiltR, kpan
	endif
	//DELAY
	kdelaySend=rspline(0.05, 0.3, 0.1, 0.5)
	adelay = abs(randi(1,0.1)+0.1);rspline(0.5, 2, 0.1, 0.3)
	kfeedback = rspline(0.0, 0.3, 0.05, 0.3)
	kfbpshift = rspline(0.1, 2, 0.1, 0.3)						//pitch shift not used b/c processor limits
	adelL, adelR pdelay (apanL1+apanL2)*kdelaySend, (apanR1+apanR2)*kdelaySend, adelay, kfeedback, kfbpshift
	amixL = adelL + apanL1 + apanL2
	amixR = adelR + apanR1 + apanR2
	//REVERB
	kverbSend= rspline(0.0, 0.8, 0.1, 0.5)
	chnmix amixL*kamp*kverbSend, "verbmixL"
	chnmix amixR*kamp*kverbSend, "verbmixR"

	outs amixL*kamp, amixR*kamp
	chnmix amixL*kamp, "DryL"
	chnmix amixR*kamp, "DryR"
endin

instr verb, 5
	ainL chnget "verbmixL"
	ainR chnget "verbmixR"
	if gireverbmode > 0 then
		kfblvl=rspline(0.3, 0.99, 0.1, 2)
		kfc = rspline(0.1, 0.9, 0.1, 0.2)
	else
		kfblvl=giverbfblvl
		kfc=giverbfc
	endif
	kfc = scale(kfc, 10000, 2000); scale kcf to appropriate range
	aRevL,aRevR reverbsc ainL, ainR, kfblvl, 7000


	outs aRevL, aRevR
	chnmix aRevL, "VerbOutL"
	chnmix aRevR, "VerbOutR"
	chnclear "verbmixL"
	chnclear "verbmixR"

endin

instr 6
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
f0 z
e
</CsScore>
</CsoundSynthesizer>
