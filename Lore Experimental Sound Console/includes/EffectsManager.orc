
;gifxsno init 10
gislots[] init 5
gkgetmacronames init 1
gSelectedEffect init 0
;gieffectselect init 0
giEffectNumber init 10
gkinitstate init 0 
gkImpulseInstance init 0
gkImpulseTable init 0
gkImpulseVerbEffectSlot init 0

opcode loadeffects, 0, Si
    SselectedMenu, ieffectselect xin
    if changed(SselectedMenu) == 1 then // if a menu o the selected page changed...
              SelectedEffect cabbageGetValue sprintfk("EffectList%i", ieffectselect)  ;...get the value
              SeffectName cabbageGetFileNoExtension SelectedEffect ; get name of effect w/o extention - for instr reference
              ;turnoff2 9, 0, 1 
              ifract = ieffectselect/100      ; make fraction for when multiple instr 9s are called at once (on recall) 
              Sinstr9 = sprintfk("i %f 0 1 %i \"%s\" \"%s\"", 9+ifract, ieffectselect, SelectedEffect, SeffectName)    
              scoreline Sinstr9, 1
              
              ;event "i", 9+ifract, 0, 1, ieffectselect ; send 
              ;print gislots[ieffectselect]   
        endif 
        ;printks "New Effect Loaded - %s\n",  0.1, gSeffectName         
endop

instr 5
       
         Seffect1, kmenuchange1 cabbageGetValue "EffectList1" ;get each effect slot menu
         Seffect2, kmenuchange2 cabbageGetValue "EffectList2"
         Seffect3, kmenuchange3 cabbageGetValue "EffectList3"
         Seffect4, kmenuchange4 cabbageGetValue "EffectList4"
         if kmenuchange1 > 0 then ; if the effect memu changes, load effect
             loadeffects Seffect1, 1 
         endif
        if kmenuchange2 > 0 then 
             loadeffects Seffect2, 2
         endif
         if kmenuchange3 > 0 then 
            loadeffects Seffect3, 3
         endif
         if kmenuchange4 > 0 then 
            loadeffects Seffect4, 4
         endif 
         
         //# ImpulseVerb Listener & Launcher 
 
        if changed(gkImpulseTable) > 0 then
            turnoff2 gkImpulseInstance, 0, 0
            event "i", gkImpulseInstance, 0.5, -1, gkImpulseVerbEffectSlot, gkImpulseTable
            printk2 gkImpulseTable
                        printks "tablechanged\n", 0.1

        endif
endin

instr 9
            ieffectSlot = p4 
            SeffectName = p5
            SelectedEffectPath strcat gSEffectDir, SeffectName
            SelectedEffectPath strcat SelectedEffectPath, ".orc"
            ifract = ieffectSlot*0.1 ; use ieffectSlot to make a unique fractional number for each instance of the instrument
            prints "SeffectName = %s\n", SeffectName
            prints "EffectPath = %s\n", SelectedEffectPath
            
            if gislots[ieffectSlot] > 0 then ; don't turn anything off on init
                event_i  "i", 0-gislots[ieffectSlot], 0, 1 ;turn off running instance in slot
                prints "turning off slot %f\n", gislots[ieffectSlot]
            endif
            if active(SeffectName) < 1 then ; if the effect isn't already running, compile it and get giEffectNumber
                icomp compileorc SelectedEffectPath ; compile .orc file at path
                prints "compiling %s\n", SeffectName
            else
                //don't recompile just get stored effect number for instrument
            giEffectNumber = nstrnum(SeffectName)
            endif
            gislots[ieffectSlot] = giEffectNumber+ifract ; create new instance number in effect slot

            schedule giEffectNumber+ifract, 0, -1, ieffectSlot ; schedule the instrument (delay start time to get new giEffectNumber run from above)
            ;print giEffectNumber
            
            ; store instr number in effect slot reference 
            
endin
instr 10, Empty
endin

instr 11, Cassette
endin  

instr 12, Particle
endin   

instr 13, Cassette
endin

instr 14, ImpulseVerb
endin

instr 15, Scrambler
endin

instr 16, GhostEcho
endin