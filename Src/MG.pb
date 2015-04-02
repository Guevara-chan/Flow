; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Flow's random map generator v0.48
; Developed in 2007 by Guevara-chan.
; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

;{ Definitions
XIncludeFile "Beingary (shared).PBI" ; Reference.

; --Constants--
#MaxMapWidth = 30
#MaxMapHeight = #MaxMapWidth
#MGMinPlayers = 2
#MGMaxPlayers = 4
#MGMinBeingsOnStart = 2
#MaxBeings = #MaxMapWidth * #MaxMapHeight
#MGMaxNeutrals = #MaxBeings - #MGMaxPlayers * #MGMinBeingsOnStart
#MGWindow = 0
#MGEnabled = 0
#MGDisabled = 1
#MinTacts = 3
#MaxTacts = 100
#Escape_Event = 1

; --Structures--
Structure RandomMapParams ; Параметры для генерируемой карты
MapWidth.i
MapHeight.i
StartingBeings.i
NeutralBeings.i
LandScape.i
PlayersCount.i
ElevatorsPercentage.i
IgnorancePercentage.i
TactsLimit.i
ExpertMode.i
Map AllowedBeings.i()
ITypes.i[#MGMaxPlayers - 1]
EndStructure
;} EndDefinitions

;{ FormDefinitions
Enumeration
#Text_0
#CB_Map_Width_Random
#Spin_Map_Width
#Text_1
#Spin_Map_Height
#CB_Map_Height_Random
#CB_Trees_allowed
#CB_Spectators_allowed
#CB_Sentry_Allowed
#CB_Society_allowed
#CB_Meanies_allowed
#CB_Enigmas_Allowed
#CB_Ideas_allowed

#CB_Justices_Allowed
#CB_Hungers_Allowed
#CB_Jinxes_Allowed
#CB_Defilers_Allowed
#CB_Amgines_Allowed
#CB_Sentinels_Allowed

#CB_Agave_Allowed
#CB_Starting_Beings_Random
#Text_3
#Spin_Starting_Beings
#Text_4
#Spin_Neutral_Beings
#CB_Neutral_Beings_Random
#Frame_0
#Radio_LSFlat
#Radio_LSNormal
#Radio_LSMountanous
#Radio_LSCrazy
#Button_Generate
#CheckBox_21
#CheckBox_22
#CheckBox_23
#CheckBox_24
#Text_5
#Spin_Warring_Parties
#CB_Warring_Parties_Random
#CB_P2_Human
#CB_P3_Human
#CB_P4_Human
#CB_ExpertMode
#Spin_Elevators
#Text_Elevators
#Rnd_Elevators
#Text_Percents
#Spin_Ignorance
#Text_Ignorance
#Rnd_Ignorance
#Text_Percents2
#CB_Tacts
#Spin_Tacts
#CB_Tacts_Random
#Paneling
EndEnumeration

Enumeration ; ITypes
#IHuman
#INormalAI
#IKamikazeAI
#IGuardianAI
EndEnumeration

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro CreateAllower(GadgetID, X, Y, Text, BeingID, State = #True)
CheckBoxGadget(GadgetID, X, Y, 140, 20, Text)
SetGadgetFont(GadgetID, FontID3) 
SetGadgetState(GadgetID, State)
SetGadgetData(GadgetID, BeingID)
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Procedure OpenMGWindow()
Static FontID3
If FontID3 = 0 : FontID3 = LoadFont(3, "Arial", 10) : EndIf
OpenWindow(#MGWindow, 0, 0, 293, 577, "Map generartor:", 281542657)
TextGadget(#Text_0, 10, 10, 80, 20, "Map Width:")
SetGadgetFont(#Text_0, FontID3)
SpinGadget(#Spin_Map_Width, 120, 10, 70, 20, 5, #MaxMapWidth, #PB_Spin_Numeric)
SetGadgetFont(#Spin_Map_Width, FontID3)
SetGadgetState(#Spin_Map_Width, 8)
CheckBoxGadget(#CB_Map_Width_Random, 200, 10, 70, 20, "Random")
SetGadgetFont(#CB_Map_Width_Random, FontID3)
TextGadget(#Text_1, 10, 40, 80, 20, "Map Height:")
SetGadgetFont(#Text_1, FontID3)
SpinGadget(#Spin_Map_Height, 120, 40, 70, 20, 5, #MaxMapHeight, #PB_Spin_Numeric)
SetGadgetFont(#Spin_Map_Height, FontID3)
SetGadgetState(#Spin_Map_Height, 8)
CheckBoxGadget(#CB_Map_Height_Random, 200, 40, 70, 20, "Random")
SetGadgetFont(#CB_Map_Height_Random, FontID3)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PanelGadget(#Paneling, 10, 63, 275, 150)
AddGadgetItem(#Paneling, -1, "Origin")
CreateAllower(#CB_Spectators_allowed, 10 , 10 , "Spectators allowed", #BSpectator)
CreateAllower(#CB_Meanies_allowed   , 150, 10 , "Meanies allowed"   , #BMeanie)
CreateAllower(#CB_Ideas_allowed     , 10 , 40, "Ideas allowed"      , #BIdea)
CreateAllower(#CB_Sentry_Allowed    , 150, 40, "Sentry allowed"     , #BSentry)
CreateAllower(#CB_Society_allowed   , 10 , 70, "Society allowed"    , #BSociety)
CreateAllower(#CB_Enigmas_Allowed   , 150, 70, "Enigmas allowed"    , #BEnigma)
CreateAllower(#CB_Trees_allowed     , 80 , 100, "Trees allowed"     , #BTree)
AddGadgetItem(#Paneling, -1, "Impasse")
CreateAllower(#CB_Justices_allowed  , 10 , 10 , "Justices allowed"  , #BJustice , #False)
CreateAllower(#CB_Hungers_allowed   , 150, 10 , "Hungers allowed"   , #BHunger  , #False)
CreateAllower(#CB_Jinxes_allowed    , 10 , 40 , "Jinxes allowed"    , #BJinx    , #False)
CreateAllower(#CB_Sentinels_Allowed , 150, 40 , "Sentinels allowed" , #BSentinel, #False)
CreateAllower(#CB_Defilers_allowed  , 10 , 70 , "Defilers allowed"  , #BDefiler , #False)
CreateAllower(#CB_Amgines_Allowed   , 150, 70 , "Enigmas(?) allowed", #BAmgine  , #False)

CreateAllower(#CB_Agave_Allowed     , 80, 100, "Agaves allowed"     , #BAgave, #False)
CloseGadgetList()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextGadget(#Text_3, 10, 220, 130, 20, "Starting Beings count:")
SetGadgetFont(#Text_3, FontID3)
SpinGadget(#Spin_Starting_Beings, 140, 220, 70, 20, 2, #MaxBeings, #PB_Spin_Numeric)
SetGadgetFont(#Spin_Starting_Beings, FontID3)
SetGadgetState(#Spin_Starting_Beings, 6)
CheckBoxGadget(#CB_Starting_Beings_Random, 220, 220, 70, 20, "Random")
SetGadgetFont(#CB_Starting_Beings_Random, FontID3)
TextGadget(#Text_4, 10, 250, 140, 20, "Neutral Beings count:")
SetGadgetFont(#Text_4, FontID3)
SpinGadget(#Spin_Neutral_Beings, 140, 250, 70, 20, 1, #MGMaxNeutrals, #PB_Spin_Numeric)
SetGadgetFont(#Spin_Neutral_Beings, FontID3)
SetGadgetState(#Spin_Neutral_Beings, 5)
CheckBoxGadget(#CB_Neutral_Beings_Random, 220, 250, 70, 20, "Random")
SetGadgetFont(#CB_Neutral_Beings_Random, FontID3)
FrameGadget(#Frame_0, 50, 280, 190, 80, "Landscape")
OptionGadget(#Radio_LSFlat, 60, 300, 50, 20, "Flat")
SetGadgetFont(#Radio_LSFlat, FontID3)
OptionGadget(#Radio_LSNormal, 170, 300, 60, 20, "Normal")
SetGadgetFont(#Radio_LSNormal, FontID3)
SetGadgetState(#Radio_LSNormal, 1)
OptionGadget(#Radio_LSMountanous, 60, 330, 100, 20, "Mountainous")
SetGadgetFont(#Radio_LSMountanous, FontID3)
OptionGadget(#Radio_LSCrazy, 170, 330, 60, 20, "Crazy")
SetGadgetFont(#Radio_LSCrazy, FontID3)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextGadget(#Text_Elevators, 10, 370, 180, 20, "Elevator blockz:")
SpinGadget(#Spin_Elevators, 120, 370, 57, 20, 0, 100, #PB_Spin_Numeric)
CheckBoxGadget(#Rnd_Elevators, 200, 370, 70, 20, "Random")
TextGadget(#Text_Percents, 180, 372, 20, 20, "%")
SetGadgetState(#Spin_Elevators, 10)
SetGadgetFont(#Spin_Elevators, FontID3)
SetGadgetFont(#Text_Elevators, FontID3)
SetGadgetFont(#Rnd_Elevators, FontID3)
SetGadgetFont(#Text_Percents, FontID3)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextGadget(#Text_Ignorance, 10, 400, 180, 20, "Ignorance 'lisks:")
SpinGadget(#Spin_Ignorance, 120, 400, 57, 20, 0, 100, #PB_Spin_Numeric)
CheckBoxGadget(#Rnd_Ignorance, 200, 400, 70, 20, "Random")
TextGadget(#Text_Percents2, 180, 402, 20, 20, "%")
SetGadgetState(#Spin_Ignorance, 10)
SetGadgetFont(#Spin_Ignorance, FontID3)
SetGadgetFont(#Text_Ignorance, FontID3)
SetGadgetFont(#Rnd_Ignorance, FontID3)
SetGadgetFont(#Text_Percents2, FontID3)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckBoxGadget(#CB_Tacts, 10, 430, 80, 20, "Tacts limit:")
SetGadgetFont(#CB_Tacts, FontID3) : SetGadgetState(#CB_Tacts, #True)
SpinGadget(#Spin_Tacts, 120, 430, 70, 20, #MinTacts, #MaxTacts, #PB_Spin_Numeric)
CheckBoxGadget(#CB_Tacts_Random, 200, 430, 70, 20, "Random")
SetGadgetState(#Spin_Tacts, 20) : SetGadgetFont(#Spin_Tacts, FontID3)
SetGadgetFont(#CB_Tacts_Random, FontID3)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextGadget(#Text_5, 10, 460, 180, 20, "Warring parties:")
SetGadgetFont(#Text_5, FontID3)
SpinGadget(#Spin_Warring_Parties, 120, 460, 70, 20, #MGMinPlayers, #MGMaxPlayers, #PB_Spin_Numeric)
SetGadgetFont(#Spin_Warring_Parties, FontID3)
SetGadgetState(#Spin_Warring_Parties, #MGMinPlayers)
CheckBoxGadget(#CB_Warring_Parties_Random, 200, 460, 70, 20, "Random")
SetGadgetFont(#CB_Warring_Parties_Random, FontID3)
CheckBoxGadget(#CB_P2_Human, 10, 490, 90, 20, "Human Plr2")
SetGadgetFont(#CB_P2_Human, FontID3)
CheckBoxGadget(#CB_P3_Human, 105, 490, 90, 20, "Human Plr3")
SetGadgetFont(#CB_P3_Human, FontID3)
DisableGadget(#CB_P3_Human, #True)
CheckBoxGadget(#CB_P4_Human, 200, 490, 90, 20, "Human Plr4")
SetGadgetFont(#CB_P4_Human, FontID3)
DisableGadget(#CB_P4_Human, #True)
CheckBoxGadget(#CB_ExpertMode, 20, 520, 250, 20, "Enable expert mode (all AI against you)")
SetGadgetFont(#CB_ExpertMode, FontID3)
DisableGadget(#CB_ExpertMode, #True)
ButtonGadget(#Button_Generate, 90, 550, 110, 20, "GENERATE")
SetActiveGadget(#Button_Generate)
AddKeyboardShortcut(#MGWindow, #PB_Shortcut_Escape, #Escape_Event)
HideWindow(#MGWindow, #False)
EndProcedure
;} EndFormDefinitions

Procedure RandomVal(Min, Max)
ProcedureReturn Random(Max - Min) + Min
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

Macro CheckAllowance()
Define I, Allowed = 0, LastAllowed
For I = #CB_Spectators_Allowed To #CB_Sentinels_Allowed
If GetGadgetState(I)
LastAllowed = I
Allowed + 1
EndIf
Next I
If Allowed = 0
SetGadgetState(LastAllowed, #True)
EndIf
EndMacro

Procedure CorrectBeingsCount()
Define MaxBeings = HandleSpin(#Spin_Map_Width) * HandleSpin(#Spin_Map_Height)
Define NeutralsCount, StartingBeings
If GetGadgetData(#Spin_Neutral_Beings) <> #MGDisabled
NeutralsCount = HandleSpin(#Spin_Neutral_Beings)
Else : NeutralsCount = 0
EndIf
If GetGadgetData(#Spin_Starting_Beings) <> #MGDisabled
StartingBeings = HandleSpin(#Spin_Starting_Beings) * #MGMaxPlayers
Else : StartingBeings = 0
EndIf
Define SupposedBeings = NeutralsCount + StartingBeings 
If SupposedBeings > MaxBeings
If StartingBeings > NeutralsCount
Define OverFlow.F = (StartingBeings - (MaxBeings - NeutralsCount)) / 4
SetGadgetState(#Spin_Starting_Beings, GetGadgetState(#Spin_Starting_Beings) - Round(OverFlow, 1))
Else 
Define OverFlow.F = SupposedBeings - MaxBeings
SetGadgetState(#Spin_Neutral_Beings, GetGadgetState(#Spin_Neutral_Beings) - OverFlow)
EndIf
EndIf
EndProcedure

Procedure DisableGadgetEx(GadgetIdx, State)
DisableGadget(GadgetIdx, State)
If State : SetGadgetData(GadgetIdx, #MGDisabled)
Else : SetGadgetData(GadgetIdx, #MGEnabled)
EndIf
EndProcedure

Procedure CheckITypeCB(GadgetIdx, PlayersCount)
Define State, Idx
If GadgetIdx = #CB_P3_Human : Idx = 3 : EndIf
If GadgetIdx = #CB_P4_Human : Idx = 4 : EndIf
If PlayersCount < Idx : State = #True : EndIf
DisableGadgetEX(GadgetIdx, State)
EndProcedure

Macro ManageMapSizeRandomizing(SizeGadget) ; Partializer.
CompilerIf SizeGadget = #Spin_Map_Width ; Let's just assume that map is 2D...
DisableGadget(SizeGadget, GetGadgetState(#CB_Map_Width_Random))
CompilerElse : DisableGadget(SizeGadget, GetGadgetState(#CB_Map_Height_Random))
CompilerEndIf
Define NewState = GetGadgetState(#CB_Map_Width_Random) | GetGadgetState(#CB_Map_Height_Random)
DisableGadgetEx(#Spin_Starting_Beings, NewState)
DisableGadget(#CB_Starting_Beings_Random, NewState)
SetGadgetState(#CB_Starting_Beings_Random, NewState)
If GetGadgetState(#CB_Trees_Allowed) | GetGadgetState(#CB_Agave_Allowed)
DisableGadgetEx(#Spin_Neutral_Beings, NewState)
DisableGadget(#CB_Neutral_Beings_Random, NewState)
EndIf
SetGadgetState(#CB_Neutral_Beings_Random, NewState)
EndMacro

Macro ManageNeutralsRandomizing() ; Partializer.
If (GetGadgetState(#CB_Map_Width_Random) | GetGadgetState(#CB_Map_Height_Random)) = 0
If GetGadgetState(#CB_Starting_Beings_Random) : Define State = #True
Else : State = (GetGadgetState(#CB_Agave_Allowed) | GetGadgetState(#CB_Trees_Allowed)) ! 1
EndIf
DisableGadgetEx(#CB_Neutral_Beings_Random, State)
State = State | GetGadgetState(#CB_Neutral_Beings_Random)
DisableGadgetEx(#Spin_Neutral_Beings, State)
EndIf
EndMacro


Procedure DivideMap(CellSpin) ; Partializer.
Define Factor, Elevators, Ignorance ; Доли состава.
If GetGadgetState(#Rnd_Elevators) = #False : Elevators = HandleSpin(#Spin_Elevators) : EndIf
If GetGadgetState(#Rnd_Ignorance) = #False : Ignorance = HandleSpin(#Spin_Ignorance) : EndIf
If Elevators + Ignorance > 100 ; Если не все в порядке...
Select CellSpin ; В зависимости от изменнного парамаетра...
Case #Spin_Elevators : Factor = 100 - Ignorance
Case #Spin_Ignorance : Factor = 100 - Elevators
EndSelect : SetGadgetState(CellSpin, Factor) ; Ставим новое значение.
EndIf
EndProcedure

Macro RandomDivide(CellSpin, Randomizer) ; Pseudo-procedure.
If GetGadgetState(Randomizer) : SetGadgetState(Randomizer, #False)
SetGadgetState(CellSpin, Random(100)) : DivideMap(CellSpin) : EndIf
EndMacro

Procedure Expertise()
Define I; Счетчик.
If GetGadgetState(#CB_Warring_Parties_Random) = #False And GetGadgetState(#Spin_Warring_Parties) < 3 
ProcedureReturn #True : EndIf ; Возвращаем #True.
For I = #CB_P2_Human To #CB_P4_Human ; No humes allowed !
If GetGadgetData(I) = #MGEnabled And GetGadgetState(I) : ProcedureReturn #True : EndIf
Next I
EndProcedure

Macro CheckExpertise() ; Partializer.
DisableGadgetEx(#CB_ExpertMode, Expertise())
EndMacro


; --Main procedure--
Procedure MGRequester(*Params.RandomMapParams)
Define I, State
OpenMGWindow() ; Создаем окно генератора.
ClearStructure(*Params, RandomMapParams) : InitializeStructure(*PArams, RandomMapParams)
Repeat
Select WaitWindowEvent()
Case #PB_Event_Gadget 
Select EventGadget()
Case #Spin_Elevators : DivideMap(#Spin_Elevators)
Case #Spin_Ignorance : DivideMap(#Spin_Ignorance)
Case #CB_Map_Width_Random  : ManageMapSizeRandomizing(#Spin_Map_Width)
Case #CB_Map_Height_Random : ManageMapSizeRandomizing(#Spin_Map_Height)
Case #CB_Starting_Beings_Random : Define State = GetGadgetState(#CB_Starting_Beings_Random)
DisableGadgetEx(#Spin_Starting_Beings, State) : SetGadgetState(#CB_Neutral_Beings_Random, State)
ManageNeutralsRandomizing()
Case #Spin_Tacts : HandleSpin(#Spin_Tacts)
Case #CB_Tacts : State = GetGadgetState(#CB_Tacts) ! 1
DisableGadget(#Spin_Tacts, State) : DisableGadget(#CB_Tacts_Random, State)
Case #CB_Tacts_Random : State = GetGadgetState(#CB_Tacts_Random)
DisableGadget(#Spin_Tacts, State) : DisableGadget(#CB_Tacts, State)
Case #CB_Neutral_Beings_Random, #CB_Trees_Allowed, #CB_Agave_Allowed
ManageNeutralsRandomizing()
Case #CB_Warring_Parties_Random : State = GetGadgetState(#CB_Warring_Parties_Random)
DisableGadget(#Spin_Warring_Parties, State) : If State = #False : I = HandleSpin(#Spin_Warring_Parties)
CheckITypeCB(#CB_P3_Human, I) : CheckITypeCB(#CB_P4_Human, I) : Else ; Иначе просто отключаем:
DisableGadgetEX(#CB_P3_Human, State) : DisableGadgetEX(#CB_P4_Human, State) : EndIf
CheckExpertise()
Case #Rnd_Elevators : DivideMap(#Spin_Elevators)
DisableGadget(#Spin_Elevators, GetGadgetState(#Rnd_Elevators))
Case #Rnd_Ignorance : DivideMap(#Rnd_Ignorance)
DisableGadget(#Spin_Ignorance, GetGadgetState(#Rnd_Ignorance))
Case #CB_Spectators_Allowed, #CB_Meanies_Allowed, #CB_Ideas_Allowed  , #CB_Sentry_Allowed   , #CB_Society_Allowed , #CB_Enigmas_Allowed,
     #CB_Justices_Allowed  , #CB_Hungers_Allowed, #CB_Jinxes_Allowed , #CB_Sentinels_Allowed, #CB_Defilers_Allowed, #CB_Amgines_Allowed
CheckAllowance()
Case #Spin_Warring_Parties : I = HandleSpin(#Spin_Warring_Parties)
CheckITypeCB(#CB_P3_Human, I) : CheckITypeCB(#CB_P4_Human, I)
CheckExpertise()
Case #CB_P2_Human, #CB_P3_Human, #CB_P4_Human : CheckExpertise()
Case #Spin_Map_Width, #Spin_Map_Height, #Spin_Starting_Beings, #Spin_Neutral_Beings
CorrectBeingsCount()
Case #Button_Generate : HideWindow(#MGWindow, #True)
With *Params
If GetGadgetState(#CB_Map_Width_Random) ; Определяем ширину будущей карты.
Define Min = GetGadgetAttribute(#Spin_Map_Width, #PB_Spin_Minimum)
\MapWidth = RandomVal(Min, GetGadgetAttribute(#Spin_Map_Width, #PB_Spin_Maximum))
Else : \MapWidth = GetGadgetState(#Spin_Map_Width)
EndIf
If GetGadgetState(#CB_Map_Height_Random) ; Определяем высоту будущей карты.
Define Min = GetGadgetAttribute(#Spin_Map_Height, #PB_Spin_Minimum)
\MapHeight = RandomVal(Min, GetGadgetAttribute(#Spin_Map_Height, #PB_Spin_Maximum))
Else : \MapHeight = GetGadgetState(#Spin_Map_Height)
EndIf
If GetGadgetState(#CB_Starting_Beings_Random) ; Определяем стартовое число Сущностей у игроков.
Define Min = GetGadgetAttribute(#Spin_Starting_Beings, #PB_Spin_Minimum)
\StartingBeings = RandomVal(Min, \MapWidth * \MapHeight / 5)
Else : \StartingBeings = GetGadgetState(#Spin_Starting_Beings)
EndIf
If GetGadgetState(#CB_Trees_Allowed) | GetGadgetState(#CB_Agave_Allowed)
; Определяем число нейтральных Сущностей на карте.
If GetGadgetState(#CB_Neutral_Beings_Random)
Define Min = GetGadgetAttribute(#Spin_Neutral_Beings, #PB_Spin_Minimum)
\NeutralBeings = RandomVal(Min, (\MapWidth * \MapHeight / 3) - \StartingBeings)
Else : \NeutralBeings = GetGadgetState(#Spin_Neutral_Beings)
EndIf
Else : \NeutralBeings = 0
EndIf
; Устанавливаем разрешенные Сущности:
;
For I = #CB_Trees_allowed To #CB_Agave_Allowed
If GetGadgetState(I) : \AllowedBeings(Hex(GetGadgetData(i))) = #True : EndIf
Next I
; ; Продолжаем с ландшафтом.
For I = #Radio_LSFlat To #Radio_LSCrazy ; Определяем ландшафт будущей карты.
If GetGadgetState(I) : \LandScape = I - #Radio_LSFlat : Break : EndIf
Next
If GetGadgetState(#CB_Warring_Parties_Random) ; Устанавлимаем число враждующих сторон.
Define RP = #True
Define Min = GetGadgetAttribute(#Spin_Warring_Parties, #PB_Spin_Minimum)
\PlayersCount = RandomVal(Min, GetGadgetAttribute(#Spin_Warring_Parties, #PB_Spin_Maximum))
Else : \PlayersCount = GetGadgetState(#Spin_Warring_Parties)
EndIf
; Устанавливаем состав карты:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RandomDivide(#Spin_Elevators, #Rnd_Elevators) : RandomDivide(#Spin_Ignorance, #Rnd_Ignorance) ; Сразу проверяем элеваторы. И обелиски:
\ElevatorsPercentage = GetGadgetState(#Spin_Elevators) : \IgnorancePercentage = GetGadgetState(#Spin_Ignorance)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ставим лимит тактов.
If GetGadgetState(#CB_Tacts) ; Если необходимо поставить лимит...
If GetGadgetState(#CB_Tacts_Random) : \TactsLimit = RandomVal(#MinTacts, #MaxTacts)
Else : \TactsLimit = GetGadgetState(#Spin_Tacts) : EndIf ; Ставим сколько заказывали...
EndIf
; Устанавлимаем типы интеллекта для враждующих сторон.
If GetGadgetState(#CB_P2_Human) : *Params\ITypes[0] = #IHuman : Else : *Params\ITypes[0] = #INormalAI : EndIf
If GetGadgetState(#CB_P3_Human) And RP = #False : *Params\ITypes[1] = #IHuman : Else : *Params\ITypes[1] = #INormalAI : EndIf
If GetGadgetState(#CB_P4_Human) And RP = #False : *Params\ITypes[2] = #IHuman : Else : *Params\ITypes[2] = #INormalAI : EndIf
If GetGadgetData(#CB_ExpertMode) = #MGEnabled : *Params\ExpertMode = GetGadgetState(#CB_ExpertMode) : EndIf
CloseWindow(#MGWindow)
ProcedureReturn #True
EndWith
EndSelect
Case #PB_Event_Menu ; Обработка 'меню' окна.
Select EventMenu()  ; Обработка сигнала.
Case #Escape_Event  : CloseWindow(#MGWindow) : ProcedureReturn #False
EndSelect ; Обработка закрытия с креста:
Case #PB_Event_CloseWindow : CloseWindow(#MGWindow) : ProcedureReturn #False
EndSelect
ForEver
EndProcedure
; IDE Options = PureBasic 5.30 Beta 4 (Windows - x86)
; Folding = --