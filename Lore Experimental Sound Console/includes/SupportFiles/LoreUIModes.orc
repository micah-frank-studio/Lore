
opcode changeLightDarkMode, 0, S[]Sk
    setksmps 1
    Schannel[], Sident, kreset xin
    iControlslen lenarray Schannel
    kControlsidx init 0
    if changed(kreset) > 0 then
        kControlsidx = 0
    endif
    if kControlsidx < iControlslen then
        cabbageSet 1, Schannel[kControlsidx], sprintfk("%s", Sident)
        kControlsidx +=1
    endif
endop

instr 98
SdarkSlider = "trackerColour(50,50,50), textColour(50,50,50,200), trackerBackgroundColour(100,100,100,50), colour(50,50,50)"
SdarkButton= "fontColour:0(50,50,50,200), fontColour:1(255,255,255), outlineColour(50,50,50), colour:0(213,216,220), colour:1(0,0,0)"
SdarkLabel = "fontColour(50,50,50)"
SdarkCombo = "colour(213,216,220), fontColour(255,255,255)"
SdarkImageBlock = "backgroundColour(200,200,200)"

SlightSlider = "trackerColour(255,255,255), textColour(255,255,255,200), colour(250,250,250), trackerBackgroundColour(250,250,250,80)"
SlightButton= "fontColour:0(250,250,250,200), fontColour:1(0,0,0), outlineColour(250,250,250), colour:0(0,0,0), colour:1(255,255,255)"
SlightLabel = "fontColour(250,250,250)"
SlightCombo = "colour(0,0,0),fontColour(250,250,250,200)"
SlightImageBlock = "backgroundColour(50,50,50)"

Sbgcolor[] fillarray "bgcolor"
Ssliders[] cabbageGetWidgetChannels $SLIDER1
SButton[] cabbageGetWidgetChannels "_abutton(1)"
Slabel[] cabbageGetWidgetChannels $LABEL
Scombo[] cabbageGetWidgetChannels "_combox(1)"
SSpecDisplay[] cabbageGetWidgetChannels  "_imageBlock(1)"

kLightDarkmode, kLDChanged cabbageGet "LightDarkMode"
    if kLightDarkmode > 0 then
        changeLightDarkMode Ssliders, SdarkSlider, kLDChanged
        changeLightDarkMode SButton, SdarkButton, kLDChanged
        changeLightDarkMode Sbgcolor, "colour(213,216,220)", kLDChanged
        changeLightDarkMode Slabel, SdarkLabel, kLDChanged
        changeLightDarkMode Scombo, SdarkCombo, kLDChanged
        changeLightDarkMode SSpecDisplay, SdarkImageBlock, kLDChanged

    else
        changeLightDarkMode Ssliders, SlightSlider, kLDChanged
        changeLightDarkMode SButton, SlightButton, kLDChanged
        changeLightDarkMode Sbgcolor, "colour(0,0,0)", kLDChanged
        changeLightDarkMode Slabel, SlightLabel, kLDChanged
        changeLightDarkMode Scombo, SlightCombo, kLDChanged
        changeLightDarkMode SSpecDisplay, SlightImageBlock, kLDChanged
    endif
endin