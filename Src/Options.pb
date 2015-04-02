; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Flow's setup interface v0.3
; Developed in 2007 by Chrono Syndrome.
; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

;{ Definitions
; --Constants--
#Window_Options = 1
#Escape_Event = 1
#LegacyAlpha = 0.92499965429306

; --Structures--
Structure OptionsData
AutoSave.i
PlayMusic.i
DisplayMiniMap.i
DisplayETButton.i
DisplaySAButton.i
DisplayTables.i
SelectBeingByModel.i
AIDelay.i
MusicVolume.F
InstableOut.i
DisplayCounters.i
SparksRain.i
NoiseFilter.i
BlurFilter.i
OmniAlpha.F
EndStructure
;} EndDefinitions

;{ FormDefinitions
Enumeration
#Frame_4
#Frame_5
#Frame_6
#Button_OK
#Button_Cancel
#CB_AutoSave
#CB_DisplayMiniMap
#CB_DisplayETButton
#CB_DisplaySAButton
#CB_DisplayTables
#CB_OmniAlpha
#CB_InstableOut
#CB_DisplayCounters
#CB_SparksRain
#CB_NoiseFilter
#CB_BlurFilter
#CB_PlayMusic
#Text_16
#TrackBar_MusicVolume
#CB_SelectByModel
#Text_17
#Spin_AIDelay
#Text_19
EndEnumeration

Procedure OpenOptionsWindow()
Static FontID1
If FontID1 = 0 : FontID1 = LoadFont(1, "Arial", 10) : EndIf
OpenWindow(#Window_Options, 236, 20, 325, 480, "Options:", 281542657)
FrameGadget(#Frame_4, 10, 10, 305, 230, "Video")
FrameGadget(#Frame_5, 10, 250, 305, 80, "Sound")
FrameGadget(#Frame_6, 10, 340, 305, 100, "Game")
CheckBoxGadget(#CB_DisplayMiniMap, 20, 30, 120, 20, "Display MiniMap")
SetGadgetFont(#CB_DisplayMiniMap, FontID1)
CheckBoxGadget(#CB_DisplayETButton, 20, 50, 160, 20, "Display 'End turn' button")
SetGadgetFont(#CB_DisplayETButton, FontID1)
CheckBoxGadget(#CB_DisplaySAButton, 20, 70, 230, 20, "Display 'Search active Being' button")
SetGadgetFont(#CB_DisplaySAButton, FontID1)
CheckBoxGadget(#CB_DisplayTables, 20, 90, 260, 20, "Display Energy indicators (recommended)")
SetGadgetFont(#CB_DisplayTables, FontID1)
CheckBoxGadget(#CB_OmniAlpha, 20, 110, 285, 20, "Legacy Beings transparency (may slow down)")
SetGadgetFont(#CB_OmniAlpha, FontID1)
CheckBoxGadget(#CB_DisplayCounters, 20, 130, 240, 20, "Display counters of player's Beings")
SetGadgetFont(#CB_DisplayCounters, FontID1)
CheckBoxGadget(#CB_SparksRain, 20, 150, 285, 20, "'Sparks rain' effect (may be slow on big maps)")
SetGadgetFont(#CB_SparksRain, FontID1)
CheckBoxGadget(#CB_NoiseFilter, 20, 170, 285, 20, "'Noise' screen filtration (experimental)")
SetGadgetFont(#CB_NoiseFilter, FontID1)
CheckBoxGadget(#CB_InstableOut, 20, 190, 250, 20, "Artifical output instability (diverting)")
SetGadgetFont(#CB_InstableOut, FontID1)
CheckBoxGadget(#CB_BlurFilter, 20, 210, 285, 20, "Blur screen filtration (stop hating it)")
SetGadgetFont(#CB_BlurFilter, FontID1)
CheckBoxGadget(#CB_PlayMusic, 20, 270, 90, 20, "Play music")
SetGadgetFont(#CB_PlayMusic, FontID1)
TextGadget(#Text_16, 20, 300, 90, 20, "Music volume:")
SetGadgetFont(#Text_16, FontID1)
TrackBarGadget(#TrackBar_MusicVolume, 110, 300, 195, 20, 1, 1000)
CheckBoxGadget(#CB_AutoSave, 20, 360, 90, 20, "Auto saving")
SetGadgetFont(#CB_AutoSave, FontID1)
CheckBoxGadget(#CB_SelectByModel, 20, 380, 245, 20, "Legacy Beings picking by model (slow)")
SetGadgetFont(#CB_SelectByModel, FontID1)
TextGadget(#Text_17, 20, 410, 160, 20, "Pause between AI actions:")
SetGadgetFont(#Text_17, FontID1)
SpinGadget(#Spin_AIDelay, 180, 410, 50, 20, 0, 30, #PB_Spin_Numeric)
SetGadgetFont(#Spin_AIDelay, FontID1)
TextGadget(#Text_19, 240, 410, 50, 20, "(frames)")
SetGadgetFont(#Text_19, FontID1)
ButtonGadget(#Button_OK,  245, 450, 70, 20, "OK")
SetGadgetFont(#Button_OK, FontID1)
ButtonGadget(#Button_Cancel, 10, 450, 70, 20, "CANCEL")
SetGadgetFont(#Button_Cancel, FontID1)
AddKeyboardShortcut(#Window_Options, #PB_Shortcut_Escape, #Escape_Event)
HideWindow(#Window_Options, #False)
EndProcedure
;} EndFormDefinitions

Procedure CheckMusic()
Define State = GetGadgetState(#CB_PlayMusic) ! 1
DisableGadget(#Text_16, State)
DisableGadget(#TrackBar_MusicVolume, State)
EndProcedure

Procedure OptionsRequester(*Options.OptionsData)
OpenOptionsWindow()
; -Gadgets setup-
SetGadgetState(#CB_DisplayMiniMap,    *Options\DisplayMiniMap)
SetGadgetState(#CB_DisplayTables,     *Options\DisplayTables)
SetGadgetState(#CB_DisplayETButton,   *Options\DisplayETButton)
SetGadgetState(#CB_DisplaySAButton,   *Options\DisplaySAButton)
SetGadgetState(#CB_InstableOut,       *Options\InstableOut)
SetGadgetState(#CB_DisplayCounters,   *Options\DisplayCounters)
SetGadgetState(#CB_SparksRain,        *Options\SparksRain)
SetGadgetState(#CB_NoiseFilter,       *Options\NoiseFilter)
SetGadgetState(#CB_BlurFilter,        *Options\BlurFilter)
SetGadgetState(#CB_PlayMusic,         *Options\PlayMusic) : CheckMusic()
SetGadgetState(#CB_AutoSave,          *Options\AutoSave)
SetGadgetState(#Spin_AIDelay,         *Options\AIDelay)
SetGadgetState(#CB_SelectByModel,     *Options\SelectBeingByModel)
SetGadgetState(#TrackBar_MusicVolume, *Options\MusicVolume * 1000)
SetGadgetState(#CB_OmniAlpha,         1.5 - *Options\OmniAlpha)
Repeat
Select WaitWindowEvent()
Case #PB_Event_Gadget 
Select EventGadget()
Case #CB_PlayMusic
CheckMusic()
Case #Button_Cancel
CloseWindow(#Window_Options)
ProcedureReturn #False
Case #Button_OK
*Options\DisplayMiniMap     = GetGadgetState(#CB_DisplayMiniMap)
*Options\DisplayTables      = GetGadgetState(#CB_DisplayTables)
*Options\DisplayETButton    = GetGadgetState(#CB_DisplayETButton)
*Options\DisplaySAButton    = GetGadgetState(#CB_DisplaySAButton) 
*Options\DisplayCounters    = GetGadgetState(#CB_DisplayCounters)
*Options\InstableOut        = GetGadgetState(#CB_InstableOut)
*Options\SparksRain         = GetGadgetState(#CB_SparksRain)
*Options\NoiseFilter        = GetGadgetState(#CB_NoiseFilter)
*Options\BlurFilter         = GetGadgetState(#CB_BlurFilter)
*Options\PlayMusic          = GetGadgetState(#CB_PlayMusic)
*Options\AutoSave           = GetGadgetState(#CB_AutoSave)
*Options\AIDelay            = GetGadgetState(#Spin_AIDelay)
*Options\SelectBeingByModel = GetGadgetState(#CB_SelectByModel)
*Options\MusicVolume        = GetGadgetState(#TrackBar_MusicVolume) / 1000
*Options\OmniAlpha          = 1 - GetGadgetState(#CB_OmniAlpha) * (1 - #LegacyAlpha)
CloseWindow(#Window_Options)
ProcedureReturn #True ; Все готово к генерации.
Case #Spin_AIDelay : HandleSpin(#Spin_AIDelay)
EndSelect
Case #PB_Event_Menu ; Обработка 'меню' окна.
Select EventMenu()  ; Обработка сигнала.
Case #Escape_Event  : CloseWindow(#Window_Options) : ProcedureReturn #False
EndSelect ; Обработка закрытия с креста:
Case #PB_Event_CloseWindow 
CloseWindow(#Window_Options) : ProcedureReturn #False
EndSelect
ForEver
EndProcedure
; IDE Options = PureBasic 5.21 LTS (Windows - x86)
; Folding = -