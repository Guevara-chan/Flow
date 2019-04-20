; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Flow's map editor setup interface v0.3
; Developed in 2009 by Guevara-chan.
; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

;{ Definitions
; --Constants--
#MaxMapWidth = 30
#MaxMapHeight = #MaxMapWidth
#MSMinPlayers = 2
#MSMaxPlayers = 4
#MSWindow = 0
#ESWindow = 1
#NMWindow = 2
#OptWindow = 3
#PolicyWindow = 4
#PPLeftBorder = 5
#PPRightBorder = 800
#MapHeader = "*Flow v0.45 Save*"
#CfgSaveFile = "..\ME_Options.CFG"
#CfgFileHeader = "-=Flow M.E. Options=-"
#Escape_Event = 1
#Security = "[Security system]"
#PlayCode = "Input new in-game passcode (ESC\empty = none):"

; --Structures--
Structure MapParams ; Параметры для генерируемой карты
MapWidth.L
MapHeight.L
TactsLimit.L
PlayersCount.L
Teams.L[#MSMaxPlayers]
ITypes.L[#MSMaxPlayers - 1]
Story.S
AfterStory.S
LockCode.s
PlayCode.s
NextMap.S{#MAX_PATH}
EndStructure

Structure LinkData
LinkName.S
LinkCRC.Q
EndStructure
;} EndDefinitions

;{ FormDefinitions
Enumeration ; MSGadgets
#Text_0
#Spin_Map_Width
#Text_1
#Spin_Map_Height
#Text_5
#Spin_Warring_Parties
#Button_Next_Map
#Button_Create
#Button_Edit_Story
#Button_Edit_Epilogue
#Text_P2_IType
#Text_P3_IType
#Text_P4_IType
#Combo_P2_IType
#Combo_P3_IType
#Combo_P4_IType
#Text_Editor ; ESGadgets
#Button_Clear
#Button_OK
#Button_Cancel
#NMPath_Field ; NMGadgets
#NMButton_OK
#NMButton_Search
#Button_Load
#Button_Options
#CB_TactsLimit
#Spin_Tacts_Limit
#OptButton_OK
#OptButton_Cancel
#OptCB_DisplayMiniMap
#OptCB_DisplayTables
#OptCB_DisplayCounters
#OptCB_BlurFilter
#OptCB_SelectByModel
#OptCB_ShowResetWarning
#Button_EditCode
#Button_PlayCode
#Button_Policy
#Pol_Player1
#Pol_Player2
#Pol_Player3
#Pol_Player4
#Pol_Team1
#Pol_Team2
#Pol_Team3
#Pol_Team4
#Pol_OK
#Pol_Cancel
EndEnumeration

Enumeration ; ITypes
#IHuman
#INormalAI
#IKamikazeAI
#IGuardianAI
EndEnumeration

Procedure FillITypes(GadgetIdx)
AddGadgetItem(GadgetIdx, -1, "Human")
AddGadgetItem(GadgetIdx, -1, "Normal")
AddGadgetItem(GadgetIdx, -1, "Kamikaze")
AddGadgetItem(GadgetIdx, -1, "Guardian")
SetGadgetState(GadgetIdx, 1)
EndProcedure

Procedure HandleSpin(SpinID.i)
Define Offset, SStart, SEnd, Text.s = GetGadgetText(SpinID)
; -Подготовка-
If Text ; Если в поле вообще что-то есть....
SendMessage_(GadgetID(SpinID), #EM_GETSEL, @SStart, @SEnd)
Define Try = Val(Text), Nulless.s = LTrim(Text, "0")
; -Корректрировка показаний-
If Nulless = "" : SetGadgetText(SpinID, "0") ; Временное решение.
ElseIf Nulless <> Text : SetGadgetText(SpinID, Nulless) : EndIf
If Try < 0 And GetGadgetAttribute(SpinID, #PB_Spin_Minimum) >= 0
SetGadgetState(SpinID, -Try)
Else  : SetGadgetState(SpinID, GetGadgetState(SpinID))
EndIf : Offset = (Len(Text) - Len(GetGadgetText(SpinID)))
; -Корректировка выделения-
If Offset > SStart : SStart = 0 : SEnd = 0
Else  : SStart - Offset : SEnd - Offset
EndIf : SendMessage_(GadgetID(SpinID), #EM_SETSEL, SStart, SEnd)
Else  : SetGadgetText(SpinID, Str(GetGadgetAttribute(SpinID, #PB_Spin_Minimum)))
EndIf : ProcedureReturn GetGadgetState(SpinID)
EndProcedure

Procedure OpenMSWindow()
Static FontID3 ; Шрифт.
If FontID3 = 0 : FontID3 = LoadFont(3, "Arial", 10) : EndIf
OpenWindow(#MSWindow, 216, 0, 215, 315, "", 281542657)
TextGadget(#Text_0, 10, 10, 80, 20, "Map Width:")
SetGadgetFont(#Text_0, FontID3)
SpinGadget(#Spin_Map_Width, 120, 10, 80, 20, 3, #MaxMapWidth, #PB_Spin_Numeric)
SetGadgetFont(#Spin_Map_Width, FontID3)
SetGadgetState(#Spin_Map_Width, 8)
TextGadget(#Text_1, 10, 40, 80, 20, "Map Height:")
SetGadgetFont(#Text_1, FontID3)
SpinGadget(#Spin_Map_Height, 120, 40, 80, 20, 3, #MaxMapHeight, #PB_Spin_Numeric)
SetGadgetFont(#Spin_Map_Height, FontID3)
SetGadgetState(#Spin_Map_Height, 8)
CheckBoxGadget(#CB_TactsLimit, 10, 70, 80, 20, "Tacts limit:")
SetGadgetFont(#CB_TactsLimit, FontID3)
SpinGadget(#Spin_Tacts_Limit, 120, 70, 80, 20, 3, 100, #PB_Spin_Numeric)
SetGadgetState(#Spin_Tacts_Limit, 3)
SetGadgetFont(#Spin_Tacts_Limit, FontID3)
DisableGadget(#Spin_Tacts_Limit, #True)
TextGadget(#Text_5, 10, 100, 180, 20, "Warring parties:")
SetGadgetFont(#Text_5, FontID3)
SpinGadget(#Spin_Warring_Parties, 120, 100, 80, 20, #MSMinPlayers, #MSMaxPlayers, #PB_Spin_Numeric)
SetGadgetFont(#Spin_Warring_Parties, FontID3)
SetGadgetState(#Spin_Warring_Parties, #MSMinPlayers)
TextGadget(#Text_P2_IType, 10, 130, 180, 20, "Player 2 IntType:")
SetGadgetFont(#Text_P2_IType, FontID3)
TextGadget(#Text_P3_IType, 10, 160, 180, 20, "Player 3 IntType:")
SetGadgetFont(#Text_P3_IType, FontID3)
TextGadget(#Text_P4_IType, 10, 190, 180, 20, "Player 4 IntType:")
SetGadgetFont(#Text_P4_IType, FontID3)
ComboBoxGadget(#Combo_P2_IType, 120, 130, 80, 20) 
FillITypes(#Combo_P2_IType)
ComboBoxGadget(#Combo_P3_IType, 120, 160, 80, 20) 
FillITypes(#Combo_P3_IType)
DisableGadget(#Combo_P3_IType, #True)
ComboBoxGadget(#Combo_P4_IType, 120, 190, 80, 20) 
FillITypes(#Combo_P4_IType)
DisableGadget(#Combo_P4_IType, #True)
ButtonGadget(#Button_EditCode, 10, 215, 90, 20, "SET EDIT CODE")
ButtonGadget(#Button_PlayCode, 105, 215, 95, 20, "SET PLAY CODE")
ButtonGadget(#Button_Edit_Story, 10, 240, 90, 20, "EDIT STORY")
ButtonGadget(#Button_Edit_Epilogue, 105, 240, 95, 20, "EDIT EPILOGUE")
ButtonGadget(#Button_Policy, 10, 265, 50, 20, "POLICY")
ButtonGadget(#Button_Next_Map, 65, 265, 135, 20, "SET LINK TO NEXT MAP")
ButtonGadget(#Button_Options, 10, 290, 60, 20, "OPTIONS")
ButtonGadget(#Button_Create, 75, 290, 60, 20, "CREATE")
ButtonGadget(#Button_Load, 140, 290, 60, 20, "LOAD")
DisableGadget(#Button_Policy, #True)
AddKeyboardShortcut(#MSWindow, #PB_Shortcut_Escape, #Escape_Event)
SetActiveGadget(#Button_Create)
EndProcedure

Procedure OpenESWindow(*ParnetID)
OpenWindow(#ESWindow, 0, 0, 300, 300, "", 281870338, *ParnetID)
EditorGadget(#Text_Editor, 10, 10, 10, 10)
ButtonGadget(#Button_Clear, 10, 10, 10, 10, "CLEAR")
ButtonGadget(#Button_OK, 10, 10, 10, 10, "OK")
ButtonGadget(#Button_Cancel, 10, 10, 10, 10, "CANCEL") : SetActiveGadget(#Text_Editor)
SetGadgetText(#Text_Editor, "") : SendMessage_(GadgetID(#Text_Editor), #EM_SETTEXTMODE, #TM_PLAINTEXT, 0)
AddKeyboardShortcut(#ESWindow, #PB_Shortcut_Escape, #Escape_Event)
EndProcedure

Procedure OpenNMWindow(*ParnetID, OldFName.S)
OpenWindow(#NMWindow, 0, 0, 400, 60, "Select path to next map (relative !):", 281542658, *ParnetID)
StringGadget(#NMPath_Field, 10, 5, 380, 20, OldFName.S) 
ButtonGadget(#NMButton_OK, 10, 35, 90, 20, "OK") 
ButtonGadget(#NMButton_Search, 300, 35, 90, 20, "Search...") 
SetActiveGadget(#NMPath_Field)
AddKeyboardShortcut(#NMWindow, #PB_Shortcut_Escape, #Escape_Event)
HideWindow(#NMWindow, #False)
EndProcedure

Procedure OpenOptionsWindow(*Options.OptionsData, *ParentID)
Static FontID1 ; Шрифт.
If FontID1 = 0 : FontID1 = LoadFont(1, "Arial", 10) : EndIf
OpenWindow(#OptWindow, 236, 20, 280, 170, "Options:", 281542657, *ParentID)
ButtonGadget(#OptButton_OK, 200, 140, 70, 20, "OK")
SetGadgetFont(#OptButton_OK, FontID1)
ButtonGadget(#OptButton_Cancel, 10, 140, 70, 20, "CANCEL")
SetGadgetFont(#OptButton_Cancel, FontID1)
CheckBoxGadget(#OptCB_DisplayMiniMap, 10, 10, 120, 20, "Display MiniMap")
SetGadgetFont(#OptCB_DisplayMiniMap, FontID1)
CheckBoxGadget(#OptCB_DisplayTables, 10, 30, 260, 20, "Display Energy indicators (recommended)")
SetGadgetFont(#OptCB_DisplayTables, FontID1)
CheckBoxGadget(#OptCB_BlurFilter, 10, 50, 285, 20, "Blur screen filtration (stop hating it)")
SetGadgetFont(#OptCB_BlurFilter, FontID1)
CheckBoxGadget(#OptCB_DisplayCounters, 10, 70, 240, 20, "Display counters of player's Beings")
SetGadgetFont(#OptCB_DisplayCounters, FontID1)
CheckBoxGadget(#OptCB_SelectByModel, 10, 90, 240, 20, "Select Beings by model picking (slow)")
SetGadgetFont(#OptCB_SelectByModel, FontID1)
CheckBoxGadget(#OptCB_ShowResetWarning, 10, 110, 190, 20, "Warn about unsaved changes")
SetGadgetFont(#OptCB_ShowResetWarning, FontID1)
AddKeyboardShortcut(#OptWindow, #PB_Shortcut_Escape, #Escape_Event)
HideWindow(#OptWindow, #False)
EndProcedure

Macro CodeRequester(Code, Trivia = "Input new edition lock-down code (ESC\empty = none):") ; Pseudo-procedure.
ReplaceString(Trim(InputRequester(#Security, Trivia, Code)), " ", " ")
EndMacro

Procedure OpenPolicyWindow(*ParentID, Players)
Static FontID3
If FontID3 = 0 : FontID3 = LoadFont(95, "Arial", 10) : EndIf
OpenWindow(#PolicyWindow, 0, 0, 150, 155, "Policy setup:", 281542657, *ParentID)
TextGadget(#Pol_Player1, 10, 10,  120, 20, "Player 1's team:") : SetGadgetFont(#Pol_Player1, FontID3) 
TextGadget(#Pol_Player2, 10, 40,  120, 20, "Player 2's team:") : SetGadgetFont(#Pol_Player2, FontID3) 
TextGadget(#Pol_Player3, 10, 70,  120, 20, "Player 3's team:") : SetGadgetFont(#Pol_Player3, FontID3) 
TextGadget(#Pol_Player4, 10, 100, 120, 20, "Player 4's team:") : SetGadgetFont(#Pol_Player4, FontID3) 
SpinGadget(#Pol_Team1, 110, 10, 30, 20, 1, Players, #PB_Spin_Numeric)  : SetGadgetFont(#Pol_Team1, FontID3) 
SpinGadget(#Pol_Team2, 110, 40, 30, 20, 1, Players, #PB_Spin_Numeric)  : SetGadgetFont(#Pol_Team2, FontID3) 
SpinGadget(#Pol_Team3, 110, 70, 30, 20, 1, Players, #PB_Spin_Numeric)  : SetGadgetFont(#Pol_Team3, FontID3) 
SpinGadget(#Pol_Team4, 110, 100, 30, 20, 1, Players, #PB_Spin_Numeric) : SetGadgetFont(#Pol_Team4, FontID3) 
ButtonGadget(#Pol_OK, 10, 130, 60, 20, "OK") : ButtonGadget(#Pol_Cancel, 80, 130, 60, 20, "CANCEL")
AddKeyboardShortcut(#PolicyWindow, #PB_Shortcut_Escape, #Escape_Event)
If Players < 4 : DisableGadget(#Pol_Player4, #True) : DisableGadget(#Pol_Team4, #True) : EndIf
EndProcedure
;} EndFormDefinitions

; --Main procedure--
Procedure.S ESRequester(Story.S, *ParentID = #Null, Epilogue = #False)
Define NewStory.S, I, ToFix, Counter, Lines, Factor
OpenESWindow(*ParentID)
SetGadgetText(#Text_Editor, Story)
If Epilogue : SetWindowTitle(#ESWindow, "Edit epilogue:")
Else        : SetWindowTitle(#ESWindow, "Edit story:")
EndIf
Repeat
WindowBounds(#ESWindow, 250, 150, #PB_Ignore, #PB_Ignore)
SetWindowLong_(WindowID(#ESWindow),#GWL_EXSTYLE,GetWindowLong_(WindowID(#ESWindow), #GWL_EXSTYLE)|#WS_EX_COMPOSITED)
HideWindow(#ESWindow, #False)
Select WaitWindowEvent()
Case #PB_Event_Gadget
Select EventGadget()
Case #Button_Clear : SetGadgetText(#Text_Editor, "")
Case #Button_OK 
NewStory = GetGadgetText(#Text_Editor)
ToFix = Len(NewStory)
SetFont_(System\PPFont) : Factor = StringWidth_("0")
Counter = #PPLeftBorder
For I = 1 To ToFix ; Count lines.
If Mid(NewStory, I, 1) <> #LF$
If Mid(NewStory, I, 1) = #CR$ : Lines + 1 : Counter = #PPLeftBorder 
Else : Counter + Factor
If Counter + Factor > #PPRightBorder : Lines + 1 : Counter = #PPLeftBorder : EndIf
EndIf
EndIf
Next I
If Lines > 200
MessageRequester("Error !", "Too many lines in story !")
Else
CloseWindow(#ESWindow)
ProcedureReturn NewStory
EndIf
Case #Button_Cancel
CloseWindow(#ESWindow)
ProcedureReturn Story
EndSelect
Case #PB_Event_SizeWindow 
#ButtonWidth = 70 : #ButtonHeight = 20
Define Width = WindowWidth(#ESWindow), Height = WindowHeight(#ESWindow)
ResizeGadget(#Text_Editor, 5, 5, Width - 10, Height - 35)
ResizeGadget(#Button_Clear, 5, Height - #ButtonHeight - 5, #ButtonWidth, #ButtonHeight)
ResizeGadget(#Button_OK, Width - #ButtonWidth - 5, Height - #ButtonHeight - 5, #ButtonWidth, #ButtonHeight)
ResizeGadget(#Button_Cancel, (Width-#ButtonWidth) >> 1, Height - #ButtonHeight - 5, #ButtonWidth, #ButtonHeight)
Case #PB_Event_Menu ; Обработка 'меню' окна.
Select EventMenu()  ; Обработка сигнала.
Case #Escape_Event  : CloseWindow(#ESWindow) : ProcedureReturn Story
EndSelect ; Обработка закрытия:
Case #PB_Event_CloseWindow : CloseWindow(#ESWindow) : ProcedureReturn Story
EndSelect
ForEver
EndProcedure

Procedure CheckITypeCombo(GadgetIdx, PlayersCount)
Define State, Idx
If GadgetIdx = #Combo_P3_IType : Idx = 3 : EndIf
If GadgetIdx = #Combo_P4_IType : Idx = 4 : EndIf
If PlayersCount < Idx : State = #True : EndIf
DisableGadget(GadgetIdx, State)
EndProcedure

Procedure GetIType(GadgetIdx)
Select GetGadgetState(GadgetIdx)
Case 0 : ProcedureReturn #IHuman
Case 1 : ProcedureReturn #INormalAI
Case 2 : ProcedureReturn #IKamikazeAI
Case 3 : ProcedureReturn #IGuardianAI
EndSelect
EndProcedure

CompilerIf #PB_Compiler_Version => 560 ; Не было печали - апдейтов накачали.
Macro CRC32Fingerprint(Buffer, Size) ; Pseudo-procedure.
Val("$"+Fingerprint(Buffer, Size, #PB_Cipher_CRC32))
EndMacro
CompilerEndIf

Global NewList MapLinks.LinkData()
Procedure AddLinkData(Link.S)
AddElement(MapLinks()) 
MapLinks()\LinkName = Link
MapLinks()\LinkCRC = CRC32Fingerprint(@Link, Len(Link)) 
EndProcedure

Procedure CheckLink(Link.S)
If Link <> ""
ForEach MapLinks()
If MapLinks()\LinkCRC = CRC32Fingerprint(@Link, Len(Link))
If MapLinks()\LinkName = Link
ProcedureReturn #False
EndIf
EndIf
Next
AddLinkData(Link)
EndIf
ProcedureReturn #True
EndProcedure

Procedure.S RetreiveLink(FName.S, FNum, Mlink.S)
Define Lev.LevelData, Link.S
If LCase(GetCurrentDirectory() + FName) <> LCase(System\GUI\MapFname)
ReadData(FNum, @Lev, SizeOf(LevelData))
CloseFile(FNum)
Link.S = Lev\NextMapFName
ProcedureReturn Link
Else : ProcedureReturn MLink.S
EndIf
EndProcedure

Procedure.S IsValidMap(FName.S, MLink.S)
If FName <> ""
Define I, Header.S = Space(Len(#MapHeader)), EHeader.S = #MapHeader, Link.S
If OpenFile(0, FName.S)
ReadData(0, @Header, Len(#MapHeader))
If CompareMemory(@Header, @EHeader, Len(Header)) = #False
CloseFile(0)
ProcedureReturn "Invalid map in chain !"
EndIf
Else : ProcedureReturn "Can't open '" + Fname + "' !"
EndIf
; -Check for links crossing.
If ReadLong(0) <> #True
CloseFile(0) : ProcedureReturn "Can't link map to save !"
EndIf
; -Consume passwords-
FileSeek(0, ReadLong(0) + Loc(0)) ; Edition pass.
FileSeek(0, ReadLong(0) + Loc(0)) ; Play pass.
; -Extract link-
Link = RetreiveLink(FName, 0, MLink)
If CheckLink(Link)
Header = IsValidMap(Link, MLink)
If Header <> "" : ProcedureReturn Header : EndIf
Else : ProcedureReturn "Infinite chain !"
EndIf
EndIf
ProcedureReturn ""
EndProcedure

Procedure.S ChainMapRequester(OldFName.S, *ParentID = #Null)
#Pattern = "Flow maps (*.MAP)|*.MAP"
Define NewFName.S, RootPath.S = LCase(GetCurrentDirectory()), Error.S
OpenNMWindow(*ParentID, OldFName.S)
Repeat
Select WaitWindowEvent()
Case #PB_Event_Gadget
Select EventGadget()
Case #NMButton_OK
NewFName = Trim(GetGadgetText(#NMPath_Field))
ClearList(MapLinks())
AddLinkData(NewFName)
Error = IsValidMap(NewFName, NewFName)
If Error = ""
CloseWindow(#NMWindow)
ProcedureReturn NewFName.S
Else : MessageRequester("Error !", Error)
EndIf
Case #NMButton_Search
NewFName = GetGadgetText(#NMPath_Field)
NewFName = LCase(Trim(OpenFileRequester("Select map to link with:", RootPath + NewFName, #Pattern, 0)))
If NewFName <> ""
If Left(NewFName, Len(RootPath)) <> RootPath
MessageRequester("Error !", "Don't try to use non-relative path !")
Else : NewFName = Right(NewFName, Len(NewFName) - Len(RootPath))
SetGadgetText(#NMPath_Field, NewFName)
EndIf
EndIf
EndSelect
Case #PB_Event_Menu ; Обработка 'меню' окна.
Select EventMenu()  ; Обработка сигнала.
Case #Escape_Event  : CloseWindow(#NMWindow) : ProcedureReturn OldFName.S
EndSelect ; Обработка закрытия:
Case #PB_Event_CloseWindow : CloseWindow(#NMWindow) : ProcedureReturn OldFName.S
EndSelect
ForEver
EndProcedure

Procedure SetIType(GadgetIdx, IType)
Select IType
Case #IHuman : SetGadgetState(GadgetIdx, 0)
Case #INormalAI : SetGadgetState(GadgetIdx, 1)
Case #IKamikazeAI : SetGadgetState(GadgetIdx, 2)
Case #IGuardianAI : SetGadgetState(GadgetIdx, 3)
EndSelect
EndProcedure

Procedure Player2ITypeCombo(PlayerIdx)
Select PlayerIdx
Case 2 : ProcedureReturn #Combo_P2_IType
Case 3 : ProcedureReturn #Combo_P3_IType
Case 4 : ProcedureReturn #Combo_P4_IType
EndSelect
EndProcedure

Procedure CheckITypeCombos()
Define I = HandleSpin(#Spin_Warring_Parties) 
CheckITypeCombo(#Combo_P3_IType, I)
CheckITypeCombo(#Combo_P4_IType, I)
EndProcedure

Macro CloseMG() ; Partializer.
CloseWindow(#MSWindow)
ProcedureReturn #False
EndMacro

Declare ShowResetWarning()
Declare LoadMap(FName.S = ":New:")
Procedure LoadMapRequester()
Define FName.S
If ShowResetWarning() : ProcedureReturn #False : EndIf
FName = Trim(OpenFileRequester("Choose file to load map:", GetCurrentDirectory(), #SavePattern, 1))
If FName <> "" : System\GUI\Changed = #False ; Снимаем флаг.
If LoadMap(FName) : ProcedureReturn #True : EndIf
EndIf
HidePointer_()
EndProcedure

Procedure SaveOptions()
Define Header.S = #CfgFileHeader
CreateFile(0, #CfgSaveFile)
WriteData(0, @Header, Len(Header))
WriteData(0, @System\Options, SizeOf(OptionsData))
CloseFile(0)
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure ResetTeams(*Param.MApParams)
Define I, Tofix = GetGadgetState(#Spin_Warring_Parties) - 1
For I = 0 To ToFix : *Param\Teams[I] = I + 1 : Next I
EndProcedure

Macro CheckPolicy()
If GetGadgetState(#Spin_Warring_Parties) > 2 : Define I = #False : Else : I = #True : EndIf
DisableGadget(#Button_Policy, I) ; Отключение кнопки.
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure OptionsRequester(*Options.OptionsData, *ParentID = #Null)
OpenOptionsWindow(*Options, *ParentID)
SetGadgetState(#OptCB_DisplayMiniMap  , *Options\DisplayMiniMap)
SetGadgetState(#OptCB_DisplayTables   , *Options\DisplayTables)
SetGadgetState(#OptCB_BlurFilter      , *Options\BlurFilter)
SetGadgetState(#OptCB_SelectByModel   , *Options\SelectBeingByModel)
SetGadgetState(#OptCB_ShowResetWarning, *Options\ResetWarning)
SetGadgetState(#OptCB_DisplayCounters , *Options\DisplayCounters)
Repeat ; Обработка сообщений.
Select WaitWindowEvent()
Case #PB_Event_Gadget 
Select EventGadget()
Case #OptButton_Cancel
CloseWindow(#OptWindow)
ProcedureReturn #False
Case #OptButton_OK
*Options\DisplayMiniMap     = GetGadgetState(#OptCB_DisplayMiniMap)
*Options\DisplayTables      = GetGadgetState(#OptCB_DisplayTables)
*Options\BlurFilter         = GetGadgetState(#OptCB_BlurFilter)
*Options\SelectBeingByModel = GetGadgetState(#OptCB_SelectByModel)
*Options\ResetWarning       = GetGadgetState(#OptCB_ShowResetWarning)
*Options\DisplayCounters    = GetGadgetState(#OptCB_DisplayCounters)
SaveOptions()
CloseWindow(#OptWindow)
ProcedureReturn #True
EndSelect
Case #PB_Event_Menu ; Обработка 'меню' окна.
Select EventMenu()  ; Обработка сигнала.
Case #Escape_Event  : CloseWindow(#OptWindow) : ProcedureReturn #False
EndSelect ; Обработка закрытия:
Case #PB_Event_CloseWindow : CloseWindow(#OptWindow) : ProcedureReturn #False
EndSelect
ForEver
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure UpholdPolicy(Players)
Dim Teams(#MSMaxPlayers)
Define I, Num, Max, Ally
; Проходим по коммандам.
For I = 0 To Players : Num = I + 1
Ally = HandleSpin(#Pol_Team1 + I)
If Ally > Num : Ally = Num : SetGadgetState(#Pol_Team1 + I, Num) : EndIf
If Ally > Max + 1 : Ally = Max + 1 : : SetGadgetState(#Pol_Team1 + I, Ally) : EndIf
If Ally > Max : Max = Ally : EndIf ; Проверка.
Next I ; Запрет монополии:
If Max = 1 : SetGadgetState(#Pol_Team2, 2) : EndIf
EndProcedure

Procedure PolicyRequester(*ParentID, Players, *Params.MapParams)
OpenPolicyWindow(*ParentID, Players) ; Открываем само окно.
Define I : Players - 1 ; Выставляем данные.
For I = 0 To Players : SetGadgetState(#Pol_Team1+I, *Params\Teams[I]) : Next I
HideWindow(#PolicyWindow, #False)
Repeat ; Обработка сообщений.
Select WaitWindowEvent()
Case #PB_Event_Gadget 
Select EventGadget()
Case #Pol_Team1, #Pol_Team2, #Pol_Team3, #Pol_Team4
UpholdPolicy(Players) ; Уточнение политики.
Case #Pol_Cancel ; Отказ.
CloseWindow(#PolicyWindow) : ProcedureReturn #False
Case #Pol_OK ; Генерация результатов.
For I = 0 To Players : *Params\Teams[I] = GetGadgetState(#Pol_Team1+I) : Next I
CloseWindow(#PolicyWindow) : ProcedureReturn #True
EndSelect
Case #PB_Event_Menu ; Обработка 'меню' окна.
Select EventMenu()  ; Обработка сигнала.
Case #Escape_Event  : CloseWindow(#PolicyWindow) : ProcedureReturn #False
EndSelect ; Обработка закрытия:
Case #PB_Event_CloseWindow : CloseWindow(#PolicyWindow) : ProcedureReturn #False
EndSelect
ForEver
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure MGRequester(*Params.MapParams, *Options.OptionsData, Quick = #False)
Define I, ToFix, *Ptr, *PtrEX
ClearStructure(*Params, MapParams) : OpenMSWindow()
If Quick : SetWindowTitle(#MSWindow, "Map parameters:")
*Params\Story = System\Story : *Params\AfterStory = System\AfterStory
*Params\LockCode = System\LockCode : *Params\PlayCode = System\PlayCode
*Params\NextMap = System\Level\NextMapFName
DisableGadget(#Spin_Map_Width, #True)
DisableGadget(#Spin_Map_Height, #True)
DisableGadget(#Spin_Warring_Parties, #True)
SetGadgetState(#Spin_Map_Width, System\Level\Width)
SetGadgetState(#Spin_Map_Height, System\Level\Height)
If System\Level\TactsLimit ; Если пристутвует органичение по тактам..
SetGadgetState(#CB_TactsLimit, #True)
DisableGadget(#Spin_Tacts_Limit, #False)
SetGadgetState(#Spin_Tacts_Limit, System\Level\TactsLimit)
EndIf
SetGadgetState(#Spin_Warring_Parties, System\Level\PlayersCount)
SetGadgetText(#Button_Create, "CHANGE") : CheckITypeCombos() 
For I = 1 To System\Level\PlayersCount ; Выставляем типы интеллекта.
If I > 1 : SetIType(Player2ITypeCombo(I), System\Players(I)\IType) : EndIf
*Params\Teams[I-1] = System\Players(I)\AlliedTeam ; Ставим команду.
Next I ; Продолжаем разговор...
CheckPolicy() ; Выставляем полит. кнопочку.
Else : SetWindowTitle(#MSWindow, "New map parameters:")
ResetTeams(*Params) ; Сразу вписываем команды.
EndIf : HideWindow(#MSWindow, #False) ; Таки показываем окно.
Repeat
Select WaitWindowEvent()
Case #PB_Event_Gadget
Select EventGadget()
Case #CB_TactsLimit : DisableGadget(#Spin_Tacts_Limit, GetGadgetState(#CB_TactsLimit) ! 1)
Case #Spin_Warring_Parties : CheckITypeCombos() ; Проверка настроек интеллекта.
If EventType() = #PB_EventType_Change : ResetTeams(*Params) : CheckPolicy() : EndIf
Case #Button_Create
With *Params
\MapWidth = GetGadgetState(#Spin_Map_Width)   ; Определяем ширину будущей карты.
\MapHeight = GetGadgetState(#Spin_Map_Height) ; Определяем высоту будущей карты.
If GetGadgetState(#CB_TactsLimit) ; Определяем лимит тактов для будущей карты...
\TactsLimit = GetGadgetState(#Spin_Tacts_Limit)
Else : \TactsLimit = 0
EndIf
\PlayersCount = GetGadgetState(#Spin_Warring_Parties) ; Устанавлимаем число враждующих сторон.
; Уcтанавливаем типы интеллекта для игроков.
\ITypes[0] = GetIType(#Combo_P2_IType)
\ITypes[1] = GetIType(#Combo_P3_IType)
\ITypes[2] = GetIType(#Combo_P4_IType)
; Последние приготовления...
CloseWindow(#MSWindow)
ProcedureReturn #True
Case #Button_EditCode
\LockCode = CodeRequester(\LockCode)
SetActiveWindow(#MSWindow)
Case #Button_PlayCode
\PlayCode = CodeRequester(\PlayCode, #PlayCode)
SetActiveWindow(#MSWindow)
Case #Button_Next_Map
DisableWindow(#MSWindow, #True)
\NextMap = ChainMapRequester(\NextMap, WindowID(#MSWindow))
DisableWindow(#MSWindow, #False)
SetActiveWindow(#MSWindow)
Case #Button_Edit_Story
DisableWindow(#MSWindow, #True)
\Story = ESRequester(\Story, WindowID(#MSWindow))
DisableWindow(#MSWindow, #False)
SetActiveWindow(#MSWindow)
Case #Button_Edit_Epilogue
DisableWindow(#MSWindow, #True)
\AfterStory = ESRequester(\AfterStory, WindowID(#MSWindow), #True)
DisableWindow(#MSWindow, #False)
SetActiveWindow(#MSWindow)
Case #Button_Options
DisableWindow(#MSWindow, #True)
OptionsRequester(*Options, WindowID(#MSWindow))
DisableWindow(#MSWindow, #False)
SetActiveWindow(#MSWindow)
Case #Button_Policy
DisableWindow(#MSWindow, #True)
PolicyRequester(WindowID(#MSWindow), GetGadgetState(#Spin_Warring_Parties), *Params)
DisableWindow(#MSWindow, #False)
SetActiveWindow(#MSWindow)
Case #Button_Load 
If LoadMapRequester()
CloseWindow(#MSWindow)
ProcedureReturn 2
EndIf : ShowPointer_()
EndWith
Case #Spin_Map_Width   : HandleSpin(#Spin_Map_Width)
Case #Spin_Map_Height  : HandleSpin(#Spin_Map_Height)
Case #Spin_Tacts_Limit : handlespin(#Spin_Tacts_Limit)
EndSelect
Case #PB_Event_Menu ; Обработка 'меню' окна.
Select EventMenu()  ; Обработка сигнала.
Case #Escape_Event         : CloseMG()
EndSelect ; Обработка закрытия:
Case #PB_Event_CloseWindow : CloseMG()
EndSelect
ForEver
EndProcedure
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; Folding = 9----