<Cabbage>
; LORE Experimental Sound Console
; Written by Micah Frank (http://micahfrank.com)
; Puremagnetik » Brooklyn, NYC 2022
; Special thanks to Rory Walsh for support and code (https://cabbageaudio.com/)

; Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
; Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
; NonCommercial — You may not use the material for commercial purposes.
; No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

; Impulse Response Files by OpenAir Library, https://www.openair.hosted.york.ac.uk, University of York and licensed under Attribution 4.0 International (CC BY 4.0).


form caption("Lore") size(860, 675), channel("form"), colour(0,0,0), guiMode("queue"), pluginId("2084"), openGL(1), opcodeDir("."), bundle("./includes"), typeface("includes/SupportFiles/SourceSansPro-Regular.ttf")
image bounds(0,0,860,675), channel("bgcolor"), colour(0,0,0)
#define SLIDER1 trackerColour(50,255,255), textColour(255,255,255,200), colour(250,250,250), trackerBackgroundColour(250,250,250,40), trackerThickness(0.05), popupText(0), _isSlider("yes")
#define BUTTON1 fontColour:0(250,250,250,200), fontColour:1(250,250,250), outlineColour(250,250,250), colour:0(0,0,0), outlineThickness(1), corners(0), automatable(1), _abutton(1)
#define LABEL fontStyle("Regular")
#define GROUPBOX lineThickness(0.5), outlineThickness(0.5), colour("5,500,0,0")
label bounds(20,-20,300,100), fontColour(200,200,200), text("LORE"), fontSize(40), align("top"), align("left"), channel("LoreTitle") $LABEL
label bounds(20,5,300,100), fontColour(200,200,200), text("EXPERIMENTAL SOUND CONSOLE"), fontSize(18), align("top"), align("left"), channel("LoreDesc") $LABEL
label bounds(100,32,300,15), fontColour(200,200,200), text("Ver 1.0.31"), fontSize(14), align("left"), channel("VersionNumber") $LABEL


image bounds(20,101,400,75), channel("DelMatrixL"), colour(66,97,238,0), alpha(0.4)
image bounds(440,100,400,75), channel("DelMatrixR"), colour(255,0,84,0), alpha(0.4)
image bounds(20,100,400,75), channel("FBMatrixL"), colour(246,126,0,0), alpha(0.4)
image bounds(440,100,400,75), channel("FBMatrixR"), colour(254,112,2,0), alpha(0.4)
image bounds(20,100,400,75), channel("attenMatrixL"), colour(26,211,176,0)
image bounds(440,100,400,75), channel("attenMatrixR"), colour(0,150,254,0)


label bounds(3000,23,200,15), fontColour(200,200,200), fontSize(12), text(""), channel("SliderValue"), colour(0,0,0,0), fontStyle("Regular")

label bounds(240,23,200,15), fontColour(200,200,200), text("SET A SOURCE FILE --->"), alpha(0), channel("SampleWarning")

groupbox bounds(440,0,400,100), colour(0,0,0,0), lineThickness(0),outlineThickness(0){

button bounds(0, 20, 20, 20), latched(1), channel("InputMode"), text("F", "I"), automatable(0), $BUTTON1
filebutton bounds (25, 20, 100, 20), populate("*.wav *.aif", "."), mode("file"), channel("File"), text("SOURCE"), automatable(0), $BUTTON1
button bounds(130, 20, 60, 20), latched(1), channel("PlayMode"), text("PLAY", "PLAY"), automatable(0) $BUTTON1
button bounds(3000, 20, 60, 20), latched(0), channel("StopMode"), text("STOP") outlineColour(185,31,88), fontColour:0(250,250,250), fontColour:1(250,250,250), automatable(0), $BUTTON1
filebutton bounds(195, 20, 60, 20), latched(0), mode("save"), text("RENDER"), populate("*.wav", "."), channel("RecordMode"), automatable(0) $BUTTON1
button bounds(260, 20, 60, 20), latched(0), text("HELP"), channel("HelpButtonText"), automatable(0) $BUTTON1
infobutton bounds(260, 20, 60, 20), latched(0), text(""), channel("HelpButton"), file("https://ec2.puremagnetik.com/LoreManual.html"), colour("0,0,0,0"), automatable(0), alpha(0)
button bounds(325, 20, 20, 20), latched(1), text(""), channel("LightDarkMode"), automatable(0),  colour:1(0,0,0), colour:0(200,200,200), value(0), corners(0)
combobox bounds(350, 20, 80, 20), mode("resize"), channel("zoomMode"), value(3), automatable(0) _combox(1)
hslider bounds(0,50,248, 20), channel("Gain"), range(0,2,1,1), text ("INPUT GAIN"), $SLIDER1, automatable(0)

}

groupbox bounds(16,235,410,150), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100){
    label bounds(5,0,400,16), align("left"), text("SPECTRAL MODULATIONS ------------------------------------------------------------------------------------"), fontSize(15), fontStyle("Regular")

    button bounds(342, 0, 60, 18), latched(1), channel("SpectralModMode"), text("LFO","SPLINE"), automatable(0), $BUTTON1
    //Spectral LFO PANEL
    groupbox bounds(0,0,410,150), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100), channel("SpectralLFO"), visible(1) {
    hslider bounds(0,30, 200, 20), channel("SpectralModRate1"), range(0,10,1,0.5,0.001), text ("RATE") $SLIDER1
    hslider bounds(0,55, 200, 20), channel("SpectralModAmount1"), range(0,1,0.2,0.5,0.001), text ("AMOUNT") $SLIDER1
    combobox bounds(103, 88, 70, 20), items("Sine","Tri","Square","Saw Up","Saw Dn","Random"), channel("SpectralLFOShape1"), value(1), _scrambleCombo(1), _combox(1)
    hslider bounds(210,30, 200, 20), channel("SpectralModRate2"), range(0,10,1,0.5,0.001), text ("RATE") $SLIDER1
    hslider bounds(210,55, 200, 20), channel("SpectralModAmount2"), range(0,1,0.2,0.5,0.001), text ("AMOUNT") $SLIDER1
    combobox bounds(313, 88, 70, 20), items("Sine","Tri","Square","Saw Up","Saw Dn","Random"), channel("SpectralLFOShape2"), value(6), _scrambleCombo(1), _combox(1)

    }
    //Spectral Spline Panel
    groupbox bounds(0,0,410,150), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100) channel("SpectralSpline"), visible(0){
    hslider bounds(0,30, 200, 20), channel("SpectralSplineRange1"), range(0,1,0.6,0.5,0.001), text ("RANGE") $SLIDER1
    hslider bounds(0,55, 200, 20), channel("SpectralSplineSpeed1"), range(0,10,1,0.5,0.001), text ("SPEED") $SLIDER1
    hslider bounds(210,30, 200, 20), channel("SpectralSplineRange2"), range(0,1,0.2,0.5,0.001), text ("RANGE") $SLIDER1
    hslider bounds(210,55, 200, 20), channel("SpectralSplineSpeed2"), range(0,10,3,0.5,0.001), text ("SPEED") $SLIDER1
    }
    combobox bounds(0, 88, 100, 20), items("Filter L", "Filter R", "Filter L/R", "Time L", "Time R", "Time L/R", "Feedback L", "Feedback R", "Feedback L/R"), channel("SpectralLFODest1"), value(1), _scrambleCombo(1), _combox(1)
    combobox bounds(210, 88, 100, 20), items("Filter L", "Filter R", "Filter L/R", "Time L", "Time R", "Time L/R", "Feedback L", "Feedback R", "Feedback L/R"), channel("SpectralLFODest2"), value(2), _scrambleCombo(1), _combox(1)

}

// EFFECTS MODULES GROUP
groupbox bounds(437,235,410,250), channel("EffectsModulesGroup"), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100){
    label bounds(5,0,400,16), align("left"), text("EFFECTS CHAIN ----------------------------------------"), fontSize(15), fontStyle("Regular")

groupbox bounds(0, 0, 410, 202) channel("EffectsControls1"), text("") $GROUPBOX {
;image bounds(183, 0, 20, 20) channel("Effect_Icon1")
combobox bounds(220, 0, 100, 20), channel("EffectList1"), channelType("string"), value("Empty") $EFFECTLIST, _combox(1)
combobox bounds(0, 30, 140, 20), channel("EffectCombo1_1"), visible(0), _combox(1)
hslider bounds(0, 30, 200, 20), channel("EffectMacro1_1"), text("MACRO 1"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(210, 30, 200, 20), channel("EffectMacro2_1"), text("MACRO 2"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(0, 55, 200, 20), channel("EffectMacro3_1"), text("MACRO 3"), range(0, 1, 0.1, 1, 0.001)  $SLIDER1
hslider bounds(210, 55, 200, 20), channel("EffectMacro4_1"), text("MACRO 4"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(0, 80, 200, 20), channel("EffectMacro5_1"), text("MACRO 5"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(210, 80, 200, 20), channel("EffectMacro6_1"), text("MACRO 6"), range(0, 1, 0.1, 1, 0.001) $SLIDER1

}

groupbox bounds(0, 0, 410, 202) channel("EffectsControls2"), text("") visible(0) $GROUPBOX {
;image bounds(183, 0, 20, 20) channel("Effect_Icon2")
combobox bounds(220, 0, 100, 20) channel("EffectList2"), channelType("string"), value("Empty") $EFFECTLIST, _combox(1)
combobox bounds(0, 30, 140, 20), channel("EffectCombo1_2"), visible(0), _combox(1)
hslider bounds(0, 30, 200, 20), channel("EffectMacro1_2"), text("MACRO 1"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(210, 30, 200, 20), channel("EffectMacro2_2"), text("MACRO 2"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(0, 55, 200, 20), channel("EffectMacro3_2"), text("MACRO 3"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(210, 55, 200, 20), channel("EffectMacro4_2"), text("MACRO 4"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(0, 80, 200, 20), channel("EffectMacro5_2"), text("MACRO 5"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(210, 80, 200, 20), channel("EffectMacro6_2"), text("MACRO 6"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
}

groupbox bounds(0, 0, 410, 202) channel("EffectsControls3"), text("") visible(0) $GROUPBOX {
;image bounds(183, 0, 20, 20) channel("Effect_Icon3")
combobox bounds(220, 0, 100, 20) channel("EffectList3"), channelType("string"), value("Empty") $EFFECTLIST, _combox(1)
combobox bounds(0, 30, 140, 20), channel("EffectCombo1_3"), visible(0), _combox(1)
hslider bounds(0, 30, 200, 20), channel("EffectMacro1_3"), text("MACRO 1"), range(0, 1, 0.1, 1, 0.001)  $SLIDER1
hslider bounds(210, 30, 200, 20), channel("EffectMacro2_3"), text("MACRO 2"), range(0, 1, 0.1, 1, 0.001)  $SLIDER1
hslider bounds(0, 55, 200, 20), channel("EffectMacro3_3"), text("MACRO 3"), range(0, 1, 0.1, 1, 0.001)  $SLIDER1
hslider bounds(210, 55, 200, 20), channel("EffectMacro4_3"), text("MACRO 4"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(0, 80, 200, 20), channel("EffectMacro5_3"), text("MACRO 5"), range(0, 1, 0.1, 1, 0.001)  $SLIDER1
hslider bounds(210, 80, 200, 20), channel("EffectMacro6_3"), text("MACRO 6"), range(0, 1, 0.1, 1, 0.001)  $SLIDER1

}

groupbox bounds(0, 0, 410, 202) channel("EffectsControls4"), text("") visible(0) $GROUPBOX {
;image bounds(183, 0, 20, 20) channel("Effect_Icon4")
combobox bounds(220, 0, 100, 20) channel("EffectList4"), channelType("string"), value("Empty") $EFFECTLIST, _combox(1)
combobox bounds(0, 30, 140, 20), channel("EffectCombo1_4"), visible(0), _combox(1)
hslider bounds(0, 30, 200, 20), channel("EffectMacro1_4"), text("MACRO 1"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(210, 30, 200, 20), channel("EffectMacro2_4"), text("MACRO 2"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(0, 55, 200, 20), channel("EffectMacro3_4"), text("MACRO 3"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(210, 55, 200, 20), channel("EffectMacro4_4"), text("MACRO 4"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(0, 80, 200, 20), channel("EffectMacro5_4"), text("MACRO 5"), range(0, 1, 0.1, 1, 0.001) $SLIDER1
hslider bounds(210, 80, 200, 20), channel("EffectMacro6_4"), text("MACRO 6"), range(0, 1, 0.1, 1, 0.001) $SLIDER1

}
optionbutton bounds(340, 0, 60, 20), latched(1), channel("EffectSelect"), items(" 1 >", " 2 >", " 3 >", " 4 >"), $BUTTON1




} //End Effects Group


// Spectral Effects Control Group
groupbox bounds(437,235,410,250), channel("SpectsGroup"), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100), visible(0){
button bounds(5, 0, 60, 20), latched(1), channel("Arp"), text("ARP") $BUTTON1, colour:1(250,250,250), fontColour:1(0,0,0), automatable(0)
hslider bounds(0, 25, 200, 20), channel("ArpDepth"), text("ARP DEPTH"), range(0, 0.3, 0.1, 0.5, 0.001), alpha(0.5), active(0) $SLIDER1, _scrambleCombo(1)
hslider bounds(0, 50, 200, 20), channel("ArpSpeed"), text("ARP SPEED"), range(0.001, 0.5, 0.005, 0.5, 0.001), alpha(0.5), active(0) $SLIDER1, _scrambleCombo(1)
label bounds(215,2,95,16), align("left"), text("SPECTRAL FREEZE"), fontSize(13) $LABEL
combobox bounds(320, 0, 80, 20), latched(1), channel("SpectralFreeze"), items("Off", "Amp", "Freq", "Amp/Freq", "Blur"), value(1), automatable(1), _scrambleCombo(1), _combox(1)
hslider bounds(210, 25, 200, 20), channel("BlurTime"), text("BLUR TIME"), range(0.005, 2, 0.8, 0.5, 0.001), automatable(1), alpha(0.5), active(0) $SLIDER1

}

// ROUTING Group
groupbox bounds(437,235,410,250), channel("RoutingGroup"), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100), visible(0){

label bounds(5,2,90,16), align("left"), text("MODULE CHAIN"), fontSize(12), fontStyle("Regular")
combobox bounds(100, 0, 100, 20), items("Parallel","Spec > Grain","Grain > Spec"), channel("audioRouting"), value(1), automatable(0), _scrambleCombo(1), _combox(1)
label bounds(5,27,90,16), align("left"), text("STEREO MODE"), fontSize(12) $LABEL
image bounds(210, 0, 150, 90), channel("BinXYPad"), colour(120,120,120), _imageBlock(1)
image bounds(300, 25, 20, 20), channel("BinPan"), colour(250,250,250), shape("ellipse")
combobox bounds(100, 25, 100, 20), channel("StereoMode"), text("Left/Right", "Binaural"), value (1), automatable(0), _combox(1)
label bounds(205,90,90,16), align("left"), text("-90°"), fontSize(12), fontColour(200,200,0) $LABEL
label bounds(350,90,50,16), align("left"), text("450°"), fontSize(12), fontColour(200,200,0) $LABEL
label bounds(278,90,50,16), align("left"), text("180°"), fontSize(12), fontColour(200,200,0) $LABEL
label bounds(365,75,50,16), align("left"), text("-40°"), fontSize(12), fontColour(0,200,200) $LABEL
label bounds(365,0,50,16), align("left"), text("90°"), fontSize(12),  fontColour(0,200,200) $LABEL

}

button bounds(85, 190, 60, 20), latched(0), channel("CopyL"), text("COPY>R"), automatable(0), $BUTTON1

button bounds(505, 190, 60, 20), latched(0), channel("CopyR"), text("COPY>L"), automatable(0), $BUTTON1

button bounds(150, 190, 60, 20), latched(0), channel("Random"), text("RNDM"), automatable(0), $BUTTON1
button bounds(215, 190, 60, 20), latched(0), channel("Jumble"), text("JUMBLE"), automatable(0), vlaue(0), $BUTTON1

;combobox bounds(168, 190, 70, 20), items("Hamming", "von Hamm", "Kaiser"), channel("WindowType"), automatable(0)
combobox bounds(280, 190, 60, 20), items("64","128","256","512","1024"), channel("AnalysisBands"), value(3), automatable(0), _scrambleCombo(1), _combox(1)

button bounds(647, 190, 60, 20), latched(1), channel("Page_Spects"), text("FUNCT"), colour:1(250,250,250), fontColour:1(0,0,0), automatable(0), value(0) $BUTTON1
button bounds(712, 190, 60, 20), latched(1), channel("Page_Modules"), text("EFFECTS") colour:1(250,250,250), fontColour:1(0,0,0), automatable(0), value(1) $BUTTON1
button bounds(777, 190, 60, 20), latched(1), channel("Page_Routing"), text("DIRECT") colour:1(250,250,250), fontColour:1(0,0,0), automatable(0), value(0) $BUTTON1


optionbutton bounds(20, 190, 60, 20), latched(1), channel("TimeFeedModeL"), items("FILTER", "TIME", "FBACK"), automatable(0), $BUTTON1
optionbutton bounds(440, 190, 60, 20), latched(1), channel("TimeFeedModeR"), items("FILTER", "TIME", "FBACK"), automatable(0), $BUTTON1

//# Granular Control
;CHANNEL 1
groupbox bounds(16,450,855,200), colour(0,0,0,0), lineThickness(0),outlineThickness(0){
label bounds(5,0,400,16), align("left"), text("GRANULAR CONTROLS ------------------------------------------------------------------------------"), fontSize(15) $LABEL
hslider bounds(0, 30, 200, 20), channel("Pitch1"), text("PITCH"), range(-2, 2, 1, 1, 0.0)  $SLIDER1
hslider bounds(0, 55, 200, 20), channel("Stretch1"), text("STRETCH"), range(0.01, 2, 0.287, 1, 0.001) $SLIDER1
hslider bounds(210, 30, 200, 20), channel("Density1"), text("DENSITY"), range(2, 20, 8, 1, 0.001) $SLIDER1
hslider bounds(210, 55, 200, 20), channel("Size1"), text("SIZE"), range(0.01, 1, 0.43, 0.5, 0.001) $SLIDER1
hslider bounds(420, 30, 200, 20), channel("Start"), text("START"), range(0, 1, 0, 1, 0.001) $SLIDER1
hslider bounds(420, 55, 200, 20), channel("End"), text("END"), range(0, 1, 1, 1, 0.001) $SLIDER1
hslider bounds(630, 30, 200, 20), channel("Filter1"), text("FREQ"), range(10, 9000, 4000, 0.5, 0.001) $SLIDER1
combobox bounds(633, 55, 70, 20), channel("Type1"), items("LPF", "HPF"), value(1), _scrambleCombo(1), _combox(1)
}



groupbox bounds(16,545,410,150), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100){
    label bounds(5,0,400,16), align("left"), text("GRANULAR MODULATIONS -----------------------------------------------------------------"), fontSize(15) $LABEL
     button bounds(342, 0, 60, 18), latched(1), channel("GranularModMode"), text("LFO","SPLINE"),  automatable(0) $BUTTON1
    //Granular LFO PANEL
    groupbox bounds(0,0,410,150), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100), channel("GranularLFO"), visible(1) {
    hslider bounds(0,30, 200, 20), channel("GrainModRate1"), range(0,10,1,0.5,0.001), text ("RATE") $SLIDER1
    hslider bounds(0,55, 200, 20), channel("GrainModAmount1"), range(0,1,0.3,1,0.001), text ("AMOUNT") $SLIDER1
    combobox bounds(103, 88, 70, 20), items("Sine","Tri","Square","Saw Up","Saw Dn","Random"), channel("GrainLFOShape1"), value(2), _scrambleCombo(1), _combox(1)
    hslider bounds(210,30, 200, 20), channel("GrainModRate2"), range(0,10,1,0.5,0.001), text ("RATE") $SLIDER1
    hslider bounds(210,55, 200, 20), channel("GrainModAmount2"), range(0,1,0,1,0.001), text ("AMOUNT"), value(0.3), $SLIDER1
    combobox bounds(313, 88, 70, 20), items("Sine","Tri","Square","Saw Up","Saw Dn","Random"), channel("GrainLFOShape2"), value(6), _scrambleCombo(1), _combox(1)
        }
    // Granular Spline Panel
    groupbox bounds(0,0,410,150), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100), channel("GranularSpline"), visible(0) {
    hslider bounds(0,30, 200, 20), channel("GranularSplineRange1"), range(0,1,0.3,1,0.001), text ("RANGE") $SLIDER1
    hslider bounds(0,55, 200, 20), channel("GranularSplineSpeed1"), range(0,10,1,0.5,0.001), text ("SPEED") $SLIDER1
    hslider bounds(210,30, 200, 20), channel("GranularSplineRange2"), range(0,1,0.1,1,0.001), text ("RANGE") $SLIDER1
    hslider bounds(210,55, 200, 20), channel("GranularSplineSpeed2"), range(0,10,3,0.5,0.001), text ("SPEED") $SLIDER1
    }
    combobox bounds(0, 88, 100, 20), items("Pitch", "Stretch", "Density", "Grain Size", "Start", "End", "Filter Freq"), channel("GrainLFODest1"), value(3), _scrambleCombo(1), _combox(1)
    combobox bounds(210, 88, 100, 20), items("Pitch", "Stretch", "Density", "Grain Size", "Start", "End", "Filter Freq"), channel("GrainLFODest2"), value(2), _scrambleCombo(1), _combox(1)

}


//# MIXER CONTROLS
groupbox bounds(437,545,500,150), colour(0,0,0,0), lineThickness(0),outlineThickness(0), outlineColour(255,255,255,100){
    label bounds(0,0,400,16), align("left"), text("MASTER BUS -----------------------------------------------------------------------------------------------------------------"), fontSize(15) $LABEL
    hslider bounds(0,30, 200, 20), channel("InputMix"), range(0,1,0.5,1), text ("INPUT") $SLIDER1
    hslider bounds(0,55, 200, 20), channel("SpectralMix"), range(0,1,0.5,1), text ("SPECTRAL") $SLIDER1
    hslider bounds(0,80, 200, 20), channel("GrainMix"), range(0,1,0.5,1), text ("GRAIN") $SLIDER1
    hslider bounds(210,30, 200, 20), channel("EffectsSend"), text("EFFECTS SEND"), range(0, 1, 0.2, 0.5, 0.001) $SLIDER1
    hslider bounds(210,55, 200, 20), channel("EffectsMix"), text("EFFECTS MIX"), range(0, 1, 0.25, 1, 0.001) $SLIDER1
    hslider bounds(210,80, 200, 20), channel("Output"), range(0,2,0.5,0.7,0.001), text ("OUTPUT") $SLIDER1, automatable(0)

}

// Signal Display Out
signaldisplay bounds(17, 360, 400, 70), displayType("spectrogram"), backgroundColour(120,120,120), zoom(-1), signalVariable("afftOutL"), skew(0.5), _imageBlock(1)
signaldisplay bounds(440, 360, 400, 70), displayType("spectrogram"), backgroundColour(120,120,120), zoom(-1), signalVariable("afftOutR"), skew(0.5),  _imageBlock(1)
}
;csoundoutput bounds(14, 198, 345, 172) channel("csoundoutput1"), fontColour(147, 210, 0)



</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5 --displays
</CsOptions>
<CsInstruments>
; Initialize the global variables.
ksmps = 16
nchnls = 2
0dbfs = 1
seed 0

gifftsize = 1024
gibinpts = 513
gibands = gifftsize/16
gidefaultVal = 0.7
giMatrixOpacity = 0.4
gSEffectDir = "includes/Effects/"
giEffectDefault = 1 ; load effect defaults
gieffectchannels = 10
zakinit gieffectchannels, 2

#include "includes/SupportFiles/ImpulseTables.orc"

#include "includes/SupportFiles/EffectsManager.orc"

#include "includes/SupportFiles/LoreUIModes.orc"

massign 0, 0

// # TABLE ALLOCATIONS
giEmptyGrid ftgen 97, 0, gibands, 7, gibands
gimaskL ftgen 98, 0, gibinpts, -2, 0
gimaskR ftgen 99, 0, gibinpts, -2, 0
gigraphL ftgen 101, 0, gibands, -7, gidefaultVal*0.7, gibands/2, gidefaultVal*0.4, gibands/2, gidefaultVal*0.3
gigraphR ftgen 102, 0, gibands, -7, gidefaultVal*0.7, gibands/2, gidefaultVal*0.3, gibands/2, gidefaultVal*0.3

giDelTableL ftgen 103, 0, gibands, -7, gidefaultVal*0.5, gibands/4, gidefaultVal*0.8, gibands/4, gidefaultVal*0.5, gibands/4, gidefaultVal*0.3, gibands/4, gidefaultVal*0.5
gidelL ftgen 104, 0, 1024, -2, 0
giDelTableR ftgen 105, 0, gibands, -7, gidefaultVal*0.3, gibands/4, gidefaultVal*0.7, gibands/4, gidefaultVal*0.5, gibands/4, gidefaultVal*0.7, gibands/4, gidefaultVal*0.5
gidelR ftgen 106, 0, 1024, -2, 0

giFBTableL ftgen 107, 0, gibands, -7, gidefaultVal*0.2, gibands/2, gidefaultVal*0.4, gibands/2, gidefaultVal
gifbL ftgen 108, 0, 1024, -2, 0
giFBTableR ftgen 109, 0, gibands, -7, gidefaultVal*0.5, gibands/2, gidefaultVal*0.6, gibands/2, gidefaultVal
gifbR ftgen 110, 0, 1024, -2, 0

;gimask ftgen 111, 0, gibands, -2, 0
giwin ftgen 1, 0, 8192, 20, 2, 1  ;Hanning window

giRecBuf1L ftgen	0,0,262144,2,0 ; circular buffer for live input
giRecBuf1R ftgen	0,0,262144,2,0

gisr = sr

opcode updateTable, 0, kS
    kTable, SVGChannel xin
    kCnt init 0
    kAmp init 1
    kBounds[] cabbageGet SVGChannel, "bounds"
    kcolour[] cabbageGet SVGChannel, "colour"
    kLength = gibands
    kRectWidth = kLength < 64 ? (kBounds[2] / kLength) : 0.1
    SPath init ""
   while kCnt < kLength do
        kAmp = 1-table(kCnt, i(kTable))
        SPath strcatk SPath, sprintfk({{
        <rect x="%d" y="%f" width="%d" height="%d" style="fill:rgba(90,99,241,0.0);stroke-width:1;stroke:rgba(%d,%d,%d,0.8)" />}},
        kCnt/kLength * kBounds[2], kBounds[3]*kAmp, kRectWidth, kBounds[3]-kBounds[3]*kAmp, kcolour[0], kcolour[1], kcolour[2])
        kCnt += 1
    od
    cabbageSet 1, SVGChannel, "svgElement", SPath
    kCnt = 0
    SPath strcpyk ""
endop

opcode saveTableState, 0, ikk 
     iTable, kIndex, kVal xin
     Sindex = sprintfk("%i%i", iTable, kIndex)
     cabbageSetStateValue Sindex, kVal
endop

opcode getTableState, 0, ik
        iTable, kIndex xin
        Sindex = sprintfk("%i%i", iTable, kIndex)
        kVal cabbageGetStateValue Sindex
        tabw kVal, kIndex, iTable
        Sval=sprintfk("%f", kVal)
        kvalLen strlenk Sval
        printks2 "kvalleng=%i", kvalLen
        updateTable 102, "attenMatrixR"
        updateTable 101, "attenMatrixL"
        updateTable 105, "DelMatrixR"
        updateTable 103, "DelMatrixL"
        updateTable 109, "FBMatrixR"
        updateTable 107, "FBMatrixL"
endop

opcode mouseListen, 0, iS
    iTable, SVGChannel xin
    iTableBounds[] cabbageGet SVGChannel, "bounds"
    iLength = gibands
    kMouseX chnget "MOUSE_X"
    kMouseY chnget "MOUSE_Y"
    kMouseDown chnget "MOUSE_DOWN_LEFT"
    SWidget, kTrigWidgetChange cabbageGet "CURRENT_WIDGET"
    itableRight = iTableBounds[0] + iTableBounds[2]
    if strcmpk(SWidget, SVGChannel) == 0 && kMouseDown == 1 && kMouseX > iTableBounds[0] && kMouseX < itableRight then
        if kMouseY > iTableBounds[1] then ;&& kMouseY < itableTop then
        kYAmp = 1 - int(((kMouseY-iTableBounds[1])/iTableBounds[3])*10)/ 10
        kXIndex = int(((kMouseX-iTableBounds[0]) / iTableBounds[2])*iLength)
        tabw kYAmp, kXIndex, iTable
            if changed:k(kXIndex) == 1 || changed:k(kYAmp) == 1 then
                updateTable iTable, SVGChannel
                saveTableState iTable, kXIndex, kYAmp
            endif
        endif
    endif
endop


//# AUDIO ROUTER
opcode audioRoute, aaaa, aaaaaak
    ainL, ainR, aSpecL, aSpecR, aGrainL, aGrainR, kroute xin ;1 = line in, 2 = spectral, 3 = granular
    if kroute == 1 then
        aSpecInL = ainL
        aSpecInR = ainR
        aGrainInL = ainL
        aGrainInR = ainR
        ;printks "Parallel\n", 2
    elseif kroute == 2 then
        aSpecInL = ainL
        aSpecInR = ainR
        aGrainInL = aSpecL
        aGrainInR = aSpecR
        ;printks "Spec>Grain\n", 2
    elseif kroute == 3 then
        aGrainInL = ainL
        aGrainInR = ainR
        aSpecInL = aGrainL
        aSpecInR = aGrainR
        ;printks "Spec>Grain\n", 2
    endif
    xout aSpecInL, aSpecInL, aGrainInL, aGrainInR
endop

//# MODROUTER
opcode modroute, kkkkkkkk, kkkkkk ; only 7 of 8 are used. mod intended for arp is not used
    kmodAmt, kmodRate, kmodDest, kshape, kmethod, kspline xin ; kmethod, which routing matrix is it? 1 = spectral, 2 = granular
    kout1, kout2, kout3, kout4, kout5, kout6, kout7 init 0
    if kspline < 1 then ; if LFO mode is chosen
        if kshape == 1 then
            klfo = abs(lfo(kmodAmt, kmodRate, 0)) ; sine
        elseif kshape == 2 then
            klfo = abs(lfo(kmodAmt, kmodRate, 1)) ; triangle
        elseif kshape == 3 then
            klfo = abs(lfo(kmodAmt, kmodRate, 3)) ; square
        elseif kshape == 4 then
            klfo = abs(lfo(kmodAmt, kmodRate, 5)) ; saw up
        elseif kshape == 5 then
            klfo = abs(lfo(kmodAmt, kmodRate, 4)) ; saw down
    else ; if spline curve is chosen
        klfo = kmodAmt
    endif
    endif
    
    if  kshape == 6 then ; if random lfo is chosen
        ksampHold = abs(randh(kmodAmt, kmodRate))
        klfo = portk(ksampHold, 0.01) ; smooth sample & hold 10ms
    endif

    if kmethod == 1 then
        kmod1 = kmodDest < 4 ? klfo : 1     ;kmod1 = filter
        if kmodDest > 3  && kmodDest < 7 then
            kmod2 = klfo            ; kmod2 = delay
        else
            kmod2 = 1
        endif
        if kmodDest > 6 && kmodDest < 10 then
            kmod3 = klfo            ; kmod3 = feedback
        else
            kmod3 = 0
        endif
        kmod4 = kmodDest > 9 ? klfo : 0  ;kmod4 = arp
    // Is the right or left channel routed to mod?
    //Left Channel
     if kmodDest == 1 || kmodDest == 3 then
        kout1 = kmod1 ;filter mod
     else
        kout1 = 0
     endif
     if kmodDest == 4 || kmodDest == 6 then
        kout2 = kmod2 ;del mod
     else
        kout2 = 0
     endif
     if kmodDest == 7 || kmodDest == 9 then
        kout3 = kmod3 ;fb mod
     else
        kout3 = 0
     endif
     if kmodDest == 10 || kmodDest == 12 then
        kout4 = kmod4 ;arp mod
     else
        kout4 = 0
     endif

     //Right Channel
     if kmodDest == 2 || kmodDest == 3 then
        kout5 = kmod1       ;filter mod
     else
        kout5 = 0
     endif
     if kmodDest == 5 || kmodDest == 6 then
        kout6 = kmod2       ;delay mod
     else
        kout6 = 0
     endif
     if kmodDest == 8 || kmodDest == 9 then
        kout7 = kmod3       ;feedback mod
     else
        kout7 = 0
     endif
     if kmodDest == 11 || kmodDest == 12 then
        kout8 = kmod4 ;arp mod
     else
        kout8 = 0
     endif
     
    elseif kmethod == 2 then                    ;Outputs 1=pitch, 2=stretch, 3=dens, 4=size, 5=start, 6=end, 7=freq
        kout1 = kmodDest == 1 ? klfo : 0
        kout2 = kmodDest == 2 ? klfo : 0
        kout3 = kmodDest == 3 ? klfo : 0
        kout4 = kmodDest == 4 ? klfo : 0
        kout5 = kmodDest == 5 ? klfo : 0
        kout6 = kmodDest == 6 ? klfo : 0
        kout7 = kmodDest == 7 ? klfo : 0
        kout8 = kmodDest == 8 ? klfo : 0
    endif

    xout kout1, kout2, kout3, kout4, kout5, kout6, kout7, kout8

endop

//# XY Pad Opcode
opcode XYPad, kk, SS
SPadName, SControl xin
iXYPadBounds[] cabbageGet sprintfk("%s", SPadName), "bounds"
    iXmargin = 437 ;offsets because of Groupbox
    iYmargin = 235
    iPadLeft = iXYPadBounds[0] + iXmargin
    iPadTop = iXYPadBounds[1] + iYmargin
    iPadWidth = iXYPadBounds[2]
    iPadHeight = iXYPadBounds[3]
    iPadCentreX = iPadLeft + iPadWidth/2
    iPadCentreY = iPadTop + iPadHeight/2
    iBallSize = 20
    iBallBounds[] fillarray iPadWidth/2-iBallSize/2, iPadHeight/2-iBallSize/2, 30, 30
    iballXYpos[] cabbageGet SControl, "bounds"
    kCurrentX init iballXYpos[0] ;initialize x,y vals to actual ball poaition
    kCurrentY init iballXYpos[1]
    kBallSize init iBallSize  
    kXDown, kYDown, kXUp, kYUp init 0
    kIncrY, kIncrX init 0
    
   
        kMouseLeftDown chnget "MOUSE_DOWN_LEFT"
        kMouseRightDown chnget "MOUSE_DOWN_RIGHT"        
        kXPos chnget "MOUSE_X"
        kYPos chnget "MOUSE_Y"
           
    kAutomation init 0
    iSensitivity = 0.4
    kDistanceFromCentre init 0
    				
   if kMouseLeftDown==1 || kMouseRightDown == 1 && kXPos > iPadLeft && kXPos < iPadLeft + iPadWidth && kYPos > iPadTop && kYPos < iPadHeight + iPadTop then 
        kBallX limit kXPos, iPadLeft+kBallSize/2, iPadLeft+iXYPadBounds[2]-kBallSize/2
        kBallY limit kYPos, iPadTop+kBallSize/2, iPadTop+iPadHeight-kBallSize/2
        kCurrentX = kBallX
        kCurrentY = kBallY
        cabbageSet 1, SControl, "bounds", kBallX-kBallSize/2-iXmargin, kBallY-kBallSize/2-iYmargin, kBallSize, kBallSize
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

    
    kOutX = (kCurrentX-iPadLeft-iBallSize/2)/(iPadWidth-iBallSize)
    kOutY = (kCurrentY-iPadTop-iBallSize/2)/(iPadHeight-iBallSize)

    xout tonek(kOutX, 10), tonek(kOutY, 10)  
    
    cabbageSetValue "x", kOutX
    cabbageSetValue "y", kOutY
    ;cabbageSet metro(50), SControl, "alpha",  kOutX*0.1+(1-kOutY*0.5) ;, 255-kOutY
endop 

opcode renderFile, 0, aaS
    setksmps 1
    ainL, ainR, Sfilename xin
    fout Sfilename, 18, ainL, ainR
endop

instr 1

cabbageSet "RecordMode", sprintf("populate(\"*\", \"%s\")", chnget:S("USER_HOME_DIRECTORY"))

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

kinitState init 0 

kinitState delayk kinitState, 0.05
if kinitState < 1 then
    kHaveState = cabbageHasStateData()
    kinitState = 1 
endif

kRecallIndex init 0
   if kHaveState > 0 then
       if kRecallIndex < gibands  then
            getTableState 102, kRecallIndex
            getTableState 101, kRecallIndex
            getTableState 105, kRecallIndex
            getTableState 103, kRecallIndex
            getTableState 109, kRecallIndex
            getTableState 107, kRecallIndex
            kRecallIndex += 1
        endif
    endif 

SDroppedFile, kDroppedTrig cabbageGet "LAST_FILE_DROPPED"
SBrowsedFile, kBrowsedTrig cabbageGet "File"

if kDroppedTrig == 1 then
    gSFile strcpyk SDroppedFile
endif
if kBrowsedTrig == 1 then
    gSFile strcpyk SBrowsedFile
endif

kvalo init 0
if changed(gSFile) == 1 then
    turnoff2 2, 0, 0
        kpos  strrindexk gSFile, "/"  ;look for the rightmost '/'
        Snam   strsubk    gSFile, kpos+1, -1    ;extract the substring
        Snam   strsubk    Snam, 0, 12 ; truncate string to x characters so it fits in display
        gSMessage sprintfk "text(\"%s\") ", Snam
        cabbageSet 1, "File", gSMessage
        ;event "i", 50, 0, 1
       kvalo +=1
        printks2 "kvalo=%i\n", kvalo
endif

// play logic, is sample loaded? is it in live or file input etc....

kinputmode, kinputChange cabbageGet "InputMode"

if kinputmode < 1 then ; if file input is selected
    cabbageSet kinputChange, "File", sprintfk("active(%i), alpha(1)", 1)
    cabbageSet kinputChange, "PlayMode", sprintfk("active(%i), alpha(1)", 1)
    ki2 active 2
    if ki2 > 0 && chnget:k("PlayMode") < 1 then; turn off running instance of 2
        turnoff2 2, 0, 0
    endif
    if strlenk(gSFile) > 1 && ki2 < 1 && chnget:k("PlayMode") > 0  then ;if a file is loaded and play mode is activated
        event "i", 2, 0, 500000
        cabbageSet metro(20), "SampleWarning", "alpha", "0"
    elseif strlenk(gSFile) < 1 && ki2 < 1 && chnget:k("PlayMode") > 0 then ;if no sample is loaded
        cabbageSetValue "PlayMode", 0, metro(20)
        cabbageSet metro(20), "SampleWarning", "alpha", "1"
    endif
elseif kinputmode > 0 && kinputChange > 0 then
    event "i", 2, 0, 500000  ; run intr 2 for live input
    cabbageSet kinputChange, "File", sprintfk("active(%i), alpha(0.5)", 0)
    cabbageSet kinputChange, "PlayMode", sprintfk("active(%i), alpha(0.5)", 0)
    cabbageSet kinputChange, "SampleWarning", "alpha", "0"
endif

//# RANDOM Function
if changed(chnget:k("Random")) > 0 then
    if chnget:k("Random") > 0 then
    krandcnt = 0
    loadRandVals:
    if krandcnt < gibands then
        kval101 = abs(rand(0.9,0))
        kval102 = abs(rand(0.9,1))
        kval103 = abs(rand(0.9,5))
        kval105 = abs(rand(0.9,3))
        kval107 = abs(rand(0.9,4))
        kval109 = abs(rand(0.9,0.5))
        tabw kval101, krandcnt, 101
            saveTableState 101, krandcnt, kval101
        tabw kval102, krandcnt, 102
            saveTableState 102, krandcnt, kval102
        tabw kval103, krandcnt, 103
            saveTableState 103, krandcnt, kval103
        tabw kval105, krandcnt, 105
            saveTableState 105, krandcnt, kval105
        tabw kval107, krandcnt, 107
            saveTableState 107, krandcnt, kval107
        tabw kval109, krandcnt, 109
            saveTableState 109, krandcnt, kval109
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
endif

kLModeVal, kLmode cabbageGet "TimeFeedModeL"
if kLModeVal == 0 then
    cabbageSet kLmode, "attenMatrixL", sprintfk("toFront(%i), alpha(%f)", 1, 1)
    cabbageSet kLmode, "DelMatrixL", sprintfk("alpha(%f)", giMatrixOpacity)
    cabbageSet kLmode, "FBMatrixL", sprintfk("alpha(%f)", giMatrixOpacity)
elseif kLModeVal == 1 then
    cabbageSet kLmode, "DelMatrixL", sprintfk("toFront(%i), alpha(%f)", 1, 1)
    cabbageSet kLmode, "attenMatrixL", sprintfk("alpha(%f)", giMatrixOpacity)
    cabbageSet kLmode, "FBMatrixL", sprintfk("alpha(%f)", giMatrixOpacity)
elseif kLModeVal == 2 then
    cabbageSet kLmode, "FBMatrixL", sprintfk("toFront(%i), alpha(%f)", 1, 1)
    cabbageSet kLmode, "DelMatrixL", sprintfk("alpha(%f)", giMatrixOpacity)
    cabbageSet kLmode, "attenMatrixL", sprintfk("alpha(%f)", giMatrixOpacity)
endif


kRModeVal, kRmode cabbageGet "TimeFeedModeR"
if kRModeVal == 0 then
    cabbageSet kRmode, "attenMatrixR", sprintfk("toFront(%i), alpha(%f)", 1, 1)
    cabbageSet kRmode, "DelMatrixR", sprintfk("alpha(%f)", giMatrixOpacity)
    cabbageSet kRmode, "FBMatrixR", sprintfk("alpha(%f)", giMatrixOpacity)
elseif kRModeVal == 1 then
    cabbageSet kRmode, "DelMatrixR", sprintfk("toFront(%i), alpha(%f)", 1, 1)
    cabbageSet kRmode, "attenMatrixR", sprintfk("alpha(%f)", giMatrixOpacity)
    cabbageSet kRmode, "FBMatrixR", sprintfk("alpha(%f)", giMatrixOpacity)
elseif kRModeVal == 2 then
    cabbageSet kRmode, "FBMatrixR", sprintfk("toFront(%i), alpha(%f)", 1, 1)
    cabbageSet kRmode, "DelMatrixR", sprintfk("alpha(%f)", giMatrixOpacity)
    cabbageSet kRmode, "attenMatrixR", sprintfk("alpha(%f)", giMatrixOpacity)
endif

//# Table Copy Function
if changed(chnget:k("CopyL")) > 0 || changed(chnget:k("CopyR")) > 0 then
if chnget:k("CopyL") > 0 &&  kLModeVal == 0 then ; Left copy button is activated and its in filter mode
    tablecopy gigraphR, gigraphL
    updateTable 102, "attenMatrixR"
elseif chnget:k("CopyR") > 0 &&  kRModeVal == 0 then
    tablecopy gigraphL, gigraphR
    updateTable 101, "attenMatrixL"
elseif chnget:k("CopyL") > 0 &&  kLModeVal == 1 then
    tablecopy giDelTableR, giDelTableL
    updateTable 105, "DelMatrixR"
elseif chnget:k("CopyR") > 0 && kRModeVal == 1 then
    tablecopy giDelTableL, giDelTableR
    updateTable 103, "DelMatrixL"
elseif chnget:k("CopyL") > 0 && kLModeVal == 2 then
    tablecopy giFBTableR, giFBTableL
    updateTable 109, "FBMatrixR"
elseif chnget:k("CopyR") > 0 && kRModeVal == 2 then
    tablecopy giFBTableL, giFBTableR
    updateTable 107, "FBMatrixL"
endif
endif

//# RENDERING
gSSaveFile, kTrigRecord cabbageGetValue "RecordMode"
schedkwhennamed kTrigRecord, 0, 1, 100, 0, 500000
gkStopButton, kTrigStop cabbageGetValue "StopMode"
    krecordIsOn active 100
    if kTrigStop > 0 then
    turnoff2 100, 0, 0
    cabbageSet kTrigStop, "RecordMode", sprintfk("bounds(%i, 20, 60, 20)", 195)
    cabbageSet kTrigStop, "StopMode", sprintfk("bounds(%i, 20, 60, 20)", 3000)
    cabbageSetValue "StopMode", 0, kTrigStop
    endif

    cabbageSet kTrigRecord, "RecordMode", sprintf("bounds(%i, 20, 60, 20)", 3000)
    cabbageSet kTrigRecord, "StopMode", sprintf("bounds(%i, 20, 60, 20)", 195)

//# Widget value text
    kMouseX chnget "MOUSE_X"
    kMouseY chnget "MOUSE_Y"

    SliderChannels[] cabbageGetWidgetChannels "_isSlider(\"yes\")"
    Scontrol, krsliderChanged cabbageChanged SliderChannels
    kRsliderVal, kvalChanged cabbageGetValue Scontrol
    SnewText = sprintfk("%.2f", kRsliderVal)
    if krsliderChanged > 0 then
    cabbageSet krsliderChanged, "SliderValue", sprintfk{{ bounds(%d, %d, 100, 20) text(%s) visible(1) }}, kMouseX-40, kMouseY-30, SnewText)
    else
    cabbageSet metro(0.7), "SliderValue", sprintfk{{ bounds(%d, %d, 100, 20) text(%s) visible(0) }}, 3000, kMouseY-30, SnewText)
    endif

//# Modulation Windows  - toggle between LFO and Spline views
    kspectralmodmode, kspecModModeChanged cabbageGet "SpectralModMode"
    cabbageSet kspecModModeChanged, "SpectralLFO", sprintfk("visible(%i)", 1-kspectralmodmode)
    cabbageSet kspecModModeChanged, "SpectralSpline", sprintfk("visible(%i)", kspectralmodmode)

    kgranularmodmode, kgranModModeChanged cabbageGet "GranularModMode"
    cabbageSet kgranModModeChanged, "GranularLFO", sprintfk("visible(%i)", 1-kgranularmodmode)
    cabbageSet kgranModModeChanged, "GranularSpline", sprintfk("visible(%i)", kgranularmodmode)

//# FFT Settings
    kbandsize, kbandSizeChanged cabbageGet "AnalysisBands"
    if kbandSizeChanged > 0 then
        if ki2 > 0 || kinputmode > 0 then ;&& chnget:k("PlayMode") > 0 then; turn off running instance of 2
            turnoff2 2, 0, 0
            event "i", 2, 0, 500000 ; reinstance instr 2 with new window size
        endif
    endif

//# Effects Panels

    gkeffectselect chnget "EffectSelect"
    gkeffectselect += 1 ;add one for indexing

     if (gkeffectselect == 1) then
        cabbageSet metro(10), "EffectsControls1", "visible(1)"
        cabbageSet metro(10), "EffectsControls2", "visible(0)"
        cabbageSet metro(10), "EffectsControls3", "visible(0)"
        cabbageSet metro(10), "EffectsControls4", "visible(0)"
     elseif (gkeffectselect == 2) then
        cabbageSet metro(10), "EffectsControls1", "visible(0)"
        cabbageSet metro(10), "EffectsControls2", "visible(1)"
        cabbageSet metro(10), "EffectsControls3", "visible(0)"
        cabbageSet metro(10), "EffectsControls4", "visible(0)"
     elseif (gkeffectselect == 3) then
        cabbageSet metro(10), "EffectsControls1", "visible(0)"
        cabbageSet metro(10), "EffectsControls2", "visible(0)"
        cabbageSet metro(10), "EffectsControls3", "visible(1)"
        cabbageSet metro(10), "EffectsControls4", "visible(0)"
     elseif (gkeffectselect == 4) then
        cabbageSet metro(10), "EffectsControls1", "visible(0)"
        cabbageSet metro(10), "EffectsControls2", "visible(0)"
        cabbageSet metro(10), "EffectsControls3", "visible(0)"
        cabbageSet metro(10), "EffectsControls4", "visible(1)"
    endif

    cabbageSet "EffectList1", sprintf("populate(\"*.orc\", \"%s\")", gSEffectDir)
    cabbageSet "EffectList2", sprintf("populate(\"*.orc\", \"%s\")", gSEffectDir)
    cabbageSet "EffectList3", sprintf("populate(\"*.orc\", \"%s\")", gSEffectDir)
    cabbageSet "EffectList4", sprintf("populate(\"*.orc\", \"%s\")", gSEffectDir)


//# Module Window Management

kmodPageVal, kmodPageChanged cabbageGet "Page_Modules"
kroutePageVal, kroutePageChanged cabbageGet "Page_Routing"
karpPageVal, karpPageChanged cabbageGet "Page_Spects"

    if kmodPageChanged > 0 && kmodPageVal > 0 then
        cabbageSet kmodPageChanged, "SpectsGroup", "visible(0)"
        cabbageSet kmodPageChanged, "RoutingGroup", "visible(0)"
        cabbageSet kmodPageChanged, "EffectsModulesGroup", "visible(1)"            
        cabbageSetValue "Page_Spects", 0, kmodPageChanged
        cabbageSetValue "Page_Routing", 0, kmodPageChanged
    endif
    if karpPageChanged > 0 && karpPageVal > 0 then
        cabbageSet karpPageChanged, "SpectsGroup", "visible(1)"
        cabbageSet karpPageChanged, "RoutingGroup", "visible(0)"
        cabbageSet karpPageChanged, "EffectsModulesGroup", "visible(0)"   
        cabbageSetValue "Page_Routing", 0, karpPageChanged
        cabbageSetValue "Page_Modules", 0, karpPageChanged   
    endif
    if kroutePageChanged > 0 && kroutePageVal > 0 then
        cabbageSet kroutePageChanged, "SpectsGroup", "visible(0)"
        cabbageSet kroutePageChanged, "RoutingGroup", "visible(1)"
        cabbageSet kroutePageChanged, "EffectsModulesGroup", "visible(0)"   
        cabbageSetValue "Page_Spects", 0, kroutePageChanged
        cabbageSetValue "Page_Modules", 0, kroutePageChanged   
    endif

kscramidx init 50000
kscramComboidx init 0
SscramCombo[] init 100
ScramChnNames[] cabbageGetWidgetChannels "type(\"hslider\"), automatable(1)"
ScramComboNames[] cabbageGetWidgetChannels "type(\"combobox\"), _scrambleCombo(1)"
    //check array sizes
        iscramLen lenarray ScramChnNames
        iscramComboLen lenarray ScramComboNames

// Jumble — Randomize everything
kScramVal, kScram cabbageGet "Jumble" 
    if kScram > 0 && kScramVal > 0 then      
        jumbleSliders:
        if kscramidx < iscramLen then
            //get range of control
            kscramRange[] cabbageGet ScramChnNames[kscramidx], "range"
            //create new random value within range
            knewScramVal=random(kscramRange[0], kscramRange[1])
            cabbageSetValue ScramChnNames[kscramidx], knewScramVal, kScram
            kscramidx += 1
            kgoto jumbleSliders
        endif
        //After sliders are jumbled, operate comboboxes
        kscramidx = 0
        kscramComboidx = 0
        kgoto scrambleCombo
    endif   
       
    scrambleCombo:
           if kscramComboidx < iscramComboLen then
                    SscramRange[] cabbageGet ScramComboNames[kscramComboidx], "text"
                    //get range of control
                    kScramComboItems lenarray SscramRange
                    //create new random value within range
                    knewComboVal=round(random(1, kScramComboItems))
                    cabbageSetValue ScramComboNames[kscramComboidx], knewComboVal, 1
                    kscramComboidx += 1
                    kgoto scrambleCombo 
            endif
endin   

instr 2

kdx init 0
prints "instr 2 begin\n"
ibandsize chnget "AnalysisBands"
    if ibandsize == 1 then
        gifftsize = 64
    elseif ibandsize == 2 then
        gifftsize = 128
    elseif ibandsize == 3 then
        gifftsize = 256
    elseif ibandsize == 4 then
        gifftsize = 512
    elseif ibandsize == 5 then
        gifftsize = 1024
    endif
gibands = gifftsize/16

gimaskL ftgentmp 98, 0, gifftsize, -2, 0
gimaskR ftgentmp 99, 0, gifftsize, -2, 0

gidelL ftgentmp 104, 0, gifftsize, -2, 0
gidelR ftgentmp 106, 0, gifftsize, -2, 0

ifbL ftgentmp 108, 0, gifftsize, -2, 0
ifbR ftgentmp 110, 0, gifftsize, -2, 0

    mouseListen 101, "attenMatrixL"
    mouseListen 102, "attenMatrixR"
    mouseListen 103, "DelMatrixL"
    mouseListen 105, "DelMatrixR"
    mouseListen 107, "FBMatrixL"
    mouseListen 109, "FBMatrixR"


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

aSpecInL, aSpecInR, aGrainInL, aGrainInR init 0
ioverlap = gifftsize/2 ;needs to be at least ifftsize/4
iwinsize = gifftsize  ;must be at least ifftsize
imaxlen = 5 ;max length of delay buffer

aInputL inch 1
aInputR inch 2

        if strlen(gSFile) > 0 then
        iNChns  filenchnls  gSFile
        if iNChns==2 then
            aDiskL, aDiskR diskin gSFile,1,0,1
        else
            aDiskL diskin gSFile,1,0,1
            aDiskR diskin gSFile,1,0,1
        endif
        endif

if chnget:k("InputMode") < 1 then ;if disk stream mode
    ainputL = aDiskL
    ainputR = aDiskR
else
    ainputL = aInputL
    ainputR = aInputR
endif

ainL = ainputL*chnget:k("Gain")
ainR = ainputR*chnget:k("Gain")

;Write input to buffer
    itablelength = ftlen(giRecBuf1L)
	    kndx = (1/(itablelength/gisr)) ;speed calculation for phasor
	    andx phasor kndx
	    tablew   aGrainInL, andx, giRecBuf1L,1 ; write audio to buffer
 	    tablew   aGrainInR, andx, giRecBuf1R,1

aSpecInLFilt butterhp aSpecInL, 450
aSpecInRFilt butterhp aSpecInR, 450

fanalyL  pvsanal   aSpecInL*2, gifftsize, ioverlap, iwinsize, 0
fanalyR  pvsanal   aSpecInR*2, gifftsize, ioverlap, iwinsize, 0

// Spectral Freeze Logic
;kfreezeState = chnget:k("SpectralFreeze")
kfreezeState, kFreezeTrig cabbageGet "SpectralFreeze"
if kfreezeState == 1 then //no freeze
    kFreezeAmp = 0
    kFreezeFreq = 0
elseif kfreezeState == 2 then
    kFreezeAmp = 1
    kFreezeFreq = 0
elseif kfreezeState == 3 then
    kFreezeAmp = 0
    kFreezeFreq = 1
elseif kfreezeState == 4 then
    kFreezeAmp = 1
    kFreezeFreq = 1
endif  


imaxblurtime = 2.1

//# SPECTRAL BLUR & FREEZE
if kfreezeState > 1 && kfreezeState < 5 then
    fftinL pvsfreeze fanalyL, kFreezeAmp, kFreezeFreq
    fftinR pvsfreeze fanalyR, kFreezeAmp, kFreezeFreq
    cabbageSet kFreezeTrig, "BlurTime", "alpha(0.5), active(0)"
elseif  kfreezeState > 4 then
    fftinL pvsblur fanalyL, chnget:k("BlurTime"), imaxblurtime
    fftinR pvsblur fanalyR, chnget:k("BlurTime"), imaxblurtime
    cabbageSet kFreezeTrig, "BlurTime", "alpha(1), active(1)"
else
    fftinL = fanalyL    
    fftinR = fanalyR
    cabbageSet kFreezeTrig, "BlurTime", "alpha(0.5), active(0)"
endif


//# SPECTRAL MODULATION
    kSpectralSplineMode chnget "SpectralModMode"
    kshape1_Spectral chnget "SpectralLFOShape1"
    kmodDest1_Spectral = chnget:k("SpectralLFODest1")
    kmodRate1_Spectral = chnget:k("SpectralModRate1")
    kshape2_Spectral chnget "SpectralLFOShape2"
    kmodDest2_Spectral = chnget:k("SpectralLFODest2")
    kmodRate2_Spectral = chnget:k("SpectralModRate2")

    if kSpectralSplineMode > 0 then
        kmodAmt1_Spectral = rspline(0, chnget:k("SpectralSplineRange1"), 0.01, chnget:k("SpectralSplineSpeed1"))
        kmodAmt2_Spectral = rspline(0, chnget:k("SpectralSplineRange2"), 0.01, chnget:k("SpectralSplineSpeed2"))
    else
        kmodAmt1_Spectral = chnget:k("SpectralModAmount1")
        kmodAmt2_Spectral = chnget:k("SpectralModAmount2")
    endif

    kattenmod1L, kdelmod1L, kfbmod1L, karpmod1L, kattenmod1R, kdelmod1R, kfbmod1R, karpmod1R modroute kmodAmt1_Spectral, kmodRate1_Spectral, kmodDest1_Spectral, kshape1_Spectral, 1, kSpectralSplineMode
    kattenmod2L, kdelmod2L, kfbmod2L, karpmod2L, kattenmod2R, kdelmod2R, kfbmod2R, karpmod2R modroute kmodAmt2_Spectral, kmodRate2_Spectral, kmodDest2_Spectral, kshape2_Spectral, 1, kSpectralSplineMode

//copy tables to full res masks
tablecopy gimaskL, gigraphL
tablecopy gidelL, giDelTableL
tablecopy gifbL, giFBTableL

tablecopy gimaskR, gigraphR
tablecopy gidelR, giDelTableR
tablecopy gifbR, giFBTableR

; if FB mod dest is routed then begin modulation
if kfbmod1L > 0 || kfbmod2L > 0 then
    // scale gifbl to modulate it
    kfbarrayL[] init gibands ;create array to store fb values
    copyf2array kfbarrayL, giFBTableL ; copy fb table to array (for scaling)
    kFBModSumL = limit(kfbmod1L+kfbmod2L, 0, 1) ; sum both mod signals and limit to acceptable range
    scalearray kfbarrayL, 0, 1-kFBModSumL ; scale vals in fb table based on lfo val
    copya2ftab kfbarrayL, gifbL ; copy array to gifb masking table
endif

if kfbmod1R > 0 || kfbmod2R > 0 then
    kfbarrayR[] init gibands ;create array to store fb values
    copyf2array kfbarrayR, giFBTableR ; copy fb table to array (for scaling)
    kFBModSumR = limit(kfbmod1R+kfbmod2R, 0, 1) ; sum both mod signals and limit to acceptable range
    scalearray kfbarrayR, 0, 1-kFBModSumR ; scale vals in fb table based on lfo val
    copya2ftab kfbarrayR, gifbR ; copy array to gifb masking table
endif


fdelmaskL pvsinit gifftsize

kAttenModSumL = limit(kattenmod1L+kattenmod2L, 0, 1) ; sum both mod signals and limit to acceptable range
;fmaskL pvsmaska fftinL, gimaskL, 1-kAttenModSumL
karpDepth chnget "ArpDepth"
karpSpeed chnget "ArpSpeed"
kbinLFO=abs(lfo(karpDepth, karpSpeed))
karpState, kArpTrig cabbageGet "Arp"
if karpState > 0 then
    fArpsigL pvsarp fftinL, kbinLFO+0.01, 0.9, 10
    fmaskL pvsmaska fArpsigL, gimaskL, 1-kAttenModSumL
    cabbageSet kArpTrig, "ArpDepth", "alpha(1), active(1)"
    cabbageSet kArpTrig, "ArpSpeed", "alpha(1), active(1)"
else 
    fmaskL pvsmaska fftinL, gimaskL, 1-kAttenModSumL
    cabbageSet kArpTrig, "ArpDepth", "alpha(0.5), active(0)"
    cabbageSet kArpTrig, "ArpSpeed", "alpha(0.5), active(0)"
endif


//Left Delay Line and Buffer
ffbL pvsmix fmaskL, fdelmaskL ; mix feedback mask back into buffer
ibufL, kwriteTimeL pvsbuffer ffbL, imaxlen
fdelL pvsbufread2 kwriteTimeL, ibufL, gidelL, gidelL ;ift 1 & 2 at least n/2 + 1 positions long. n= # bins
kDelModSumL = limit(kdelmod1L+kdelmod2L, 0, 1) ; sum both mod signals and limit to acceptable range
fdelmaskL pvsmaska fdelL, gifbL, 1-(kDelModSumL) ; mask fdelL with feedback table
aSpectralOutL    pvsynth  fdelL



fdelmaskR pvsinit gifftsize
kAttenModSumR = limit(kattenmod1R+kattenmod2R, 0, 1) ; sum both mod signals and limit to acceptable range
;fmaskR pvsmaska fftinR, gimaskR, 1-kAttenModSumR
if chnget:k("Arp") > 0 then
    fArpsigR pvsarp fftinR, kbinLFO+0.01, 0.9, 10
    fmaskR pvsmaska fArpsigR, gimaskR, 1-kAttenModSumR
else 
    fmaskR pvsmaska fftinR, gimaskR, 1-kAttenModSumR
endif
//Right Delay Line and Buffer
ffbR pvsmix fmaskR, fdelmaskR ; mix feedback mask back into buffer
ibufR, kwriteTimeR pvsbuffer ffbR, imaxlen
fdelR pvsbufread2 kwriteTimeR, ibufR, gidelR, gidelR ;ift 1 & 2 at least n/2 + 1 positions long. n= # bins
kDelModSumR = limit(kdelmod1R+kdelmod2R, 0, 1) ; sum both mod signals and limit to acceptable range
fdelmaskR pvsmaska fdelR, gifbR, 1-kDelModSumR ; mask fdelR with feedback table
aSpectralOutR    pvsynth  fdelR


afftOutL = aSpectralOutL
afftOutR = aSpectralOutR
dispfft afftOutL, 0.1, 2048, 0, 1
dispfft afftOutR, 0.1, 2048, 0, 1



  klev1 = 0.5 ;*chnget:k("Gain") ;chnget "Volume1"
  kdens1 chnget "Density1"
  kgrsize1 chnget "Size1"
  kpitch1 chnget "Pitch1"
  kstr1 chnget "Stretch1"
  kstart1 chnget "Start"
  kend1 chnget "End"
  kfiltType1 chnget "Type1"
  kfilt1 chnget "Filter1"
  kverbsend1 chnget "Space"
//# GRANULAR MODULATION
  kGranSplineMode chnget "GranularModMode"
  kshape1_Grain chnget "GrainLFOShape1"
  kmodDest1_Grain = chnget:k("GrainLFODest1")
  kmodRate1_Grain = chnget:k("GrainModRate1")
  kshape2_Grain chnget "GrainLFOShape2"
  kmodDest2_Grain = chnget:k("GrainLFODest2")
  kmodRate2_Grain = chnget:k("GrainModRate2")

      if kGranSplineMode > 0 then
        kmodAmt1_Grain = rspline(0, chnget:k("GranularSplineRange1"), 0.01, chnget:k("GranularSplineSpeed1"))
        kmodAmt2_Grain = rspline(0, chnget:k("GranularSplineRange2"), 0.01, chnget:k("GranularSplineSpeed2"))
    else
        kmodAmt1_Grain = chnget:k("GrainModAmount1")
        kmodAmt2_Grain = chnget:k("GrainModAmount2")
    endif

      kPitchMod1, kStretchMod1, kDensityMod1, kSizeMod1, kStartMod1, kEndMod1, kFilterMod1, kplaceholder modroute kmodAmt1_Grain, kmodRate1_Grain, kmodDest1_Grain, kshape1_Grain, 2, kGranSplineMode
      kPitchMod2, kStretchMod2, kDensityMod2, kSizeMod2, kStartMod2, kEndMod2, kFilterMod2, kplaceholder modroute kmodAmt2_Grain, kmodRate2_Grain, kmodDest2_Grain, kshape2_Grain, 2, kGranSplineMode
        iolaps  = 2 ; must be no more thn max(kfreq)*max(kgrsize)
	    ips     = 1/iolaps
	    iTableLenInSeconds = itablelength/gisr
	    // Scale and sum mods 1 and 2 if they happen to be routed to same destination
	    kdensSum = limit(kDensityMod1+kDensityMod2, 0, 1)
	    kpitchSum = limit(kPitchMod1+kPitchMod2, 0, 1)
	    kgrsizeSum = limit(kSizeMod1+kSizeMod2, 0, 1)
	    kstartSum = limit(kStartMod1+kStartMod2, 0, 1)
	    kendSum = limit(kEndMod1+kEndMod2, 0, 1)
	    kfilterSum = limit(kFilterMod1+kFilterMod2, 0, 1)

	    kdens1 = kdens1-(kdens1*kdensSum)
	    kpitch1 = kpitch1-(kpitch1*kpitchSum)
	    kgrsize1 = kgrsize1-(kgrsize1*kgrsizeSum)
	    kstart1 = kstart1-(kstart1*kstartSum)
	    kend1 = kend1-(kend1*kendSum)
	    kfilt1 = kfilt1-(kfilt1*kfilterSum)
	    kendInSec = iTableLenInSeconds*kend1
	    kstartInSec = iTableLenInSeconds*kstart1
	    kendInSec_ = kendInSec < kstartInSec+0.1 ? kstartInSec+0.1 : kendInSec ;keep kstart and kend from overtaking each other
	    kstartInSec_ = kstartInSec > kendInSec-0.1 ? kendInSec-0.1 : kstartInSec
        a1L syncloop klev1, kdens1, kpitch1, kgrsize1, ips*kstr1, kstartInSec_, kendInSec_, giRecBuf1L, giwin, iolaps
		a1R syncloop klev1, kdens1, kpitch1, kgrsize1, ips*kstr1, kstartInSec_, kendInSec_, giRecBuf1R, giwin, iolaps
		kseglenInHz = 1/(kendInSec_ - kstartInSec_)
	    kfade loopseg kseglenInHz, 0, 0, 0, 0.2, 1, 0.6, 1, 0.2 ; might need fade on table write?
        print iTableLenInSeconds
        kq = 0
  	    alow1L, ahigh1L, aband1L svfilter a1L*kfade, kfilt1, 1
  	    alow1R, ahigh1R, aband1R svfilter a1R*kfade, kfilt1, 1

        if kfiltType1 == 1 then
            agrainmixL = alow1L * chnget:k("GrainMix")
		    agrainmixR = alow1R * chnget:k("GrainMix")
		else
		    agrainmixL = ahigh1L * chnget:k("GrainMix")
		    agrainmixR = ahigh1R * chnget:k("GrainMix")
        endif

aSpecmixL = aSpectralOutL*chnget:k("SpectralMix")
aSpecmixR = aSpectralOutR*chnget:k("SpectralMix")
aInputMixL = ainL*chnget:k("InputMix")
aInputMixR = ainR*chnget:k("InputMix")
aSpecInL, aSpecInR, aGrainInL, aGrainInR audioRoute ainL, ainR, aSpecmixL, aSpecmixR, agrainmixL, agrainmixR, chnget:k("audioRouting")

amixL = agrainmixL+aSpecmixL+aInputMixL
amixR = agrainmixR+aSpecmixR+aInputMixR

amixL_limit = limit(amixL, -0.98, 0.98)
amixR_limit = limit(amixR, -0.98, 0.98)
chnmix amixL_limit, "drymixL"
chnmix amixR_limit, "drymixR"
chnset amixL_limit*kverbsend1, "verbsendL"
chnset amixR_limit*kverbsend1, "verbsendR"

endin

instr mixer, 99


adryL chnget "drymixL"
adryR chnget "drymixR"

    keffectsend chnget "EffectsSend"
    keffectsmix chnget "EffectsMix"

    zaw adryL*keffectsend, 1
    zaw adryR*keffectsend, 2

    aefxL zar 9
    aefxR zar 10

    zacl 9,10



gkX, gkY XYPad "BinXYPad", "BinPan"
kazim scale gkX, 450, -90
kalt scale gkY, -40, 90

aEffectMixL ntrpol adryL, aefxL, keffectsmix
aEffectMixR ntrpol adryR, aefxR, keffectsmix


if (gisr = 44100) then
SfileL = "includes/HRTF/hrtf-44100-left.dat"
SfileR = "includes/HRTF/hrtf-44100-right.dat"
elseif (gisr = 48000) then
SfileL = "includes/HRTF/hrtf-48000-left.dat"
SfileR = "includes/HRTF/hrtf-48000-right.dat"
elseif (gisr = 96000) then
SfileL = "includes/HRTF/hrtf-96000-left.dat"
SfileR = "includes/HRTF/hrtf-96000-right.dat"
endif

ahrtfL, ahrtfR hrtfmove2 aEffectMixL+aEffectMixR, kazim, kalt, SfileL, SfileR, 4, 9, gisr

if chnget:k("StereoMode") == 1 then
amixL = aEffectMixL
amixR = aEffectMixR
else
amixL = ahrtfL
amixR = ahrtfR
endif

koutput chnget "Output"

chnset amixL*koutput, "RecordBusL"
chnset amixR*koutput, "RecordBusR"

outs amixL*koutput, amixR*koutput

chnclear "drymixL"
chnclear "drymixR"
chnclear "verbReturnL"
chnclear "verbReturnR"

endin

instr 100 ;recorder

    prints "recording started\n"

	amixL chnget "RecordBusL"
    amixR chnget "RecordBusR"
	renderFile amixL, amixR, gSSaveFile

endin


</CsInstruments>
<CsScore>
i1 0 500000
i5 0 500000 ;Effects Listener
i99 0 500000 ;mixer
i98 0 500000 ;color modes
</CsScore>
</CsoundSynthesizer>
