; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Flow's map editor v0.48 (Alpha)
; Developed in 2009 by Guevara-chan.
; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

; TO.DO[
; Добавить проверку тегов разметки в брифингах.
; Улучшить поддержку элеваторов.
; ...Улучшить интерфейс.
; ]TO.DO

; SDK Bugs[
; CopyRect - не работает.
; CopyPixel(Fast) - не копируют значение альфы.
; ]SDK Bugs

;{ Definitions
EnableExplicit

;{ --Enumerations--
Enumeration ; Square states.
#SNone
#SAbsorbtion
#SSpawning
#SAbsAndSpawn
#SActiveBeing
EndEnumeration

Enumeration ; Being states
#BPreparing
#BBorning
#BActive
#BInActive
#BDying
#BDestroyed
EndEnumeration

Enumeration ; ITypes
#IHuman
#INormalAI
#IKamikazeAI
#IGuardianAI
EndEnumeration

Enumeration ; Counter states
#CPreparing
#CNormal
#CDissolving
#CGone
#CNone
EndEnumeration

Enumeration   ; Platform types.
#PVanilla     ; Стандартные платформы с первых build'ов.
#PElevator    ; Менящие высоту блоки.
#PIgnorance   ; Reincarnates not welcome !
#PObservatory ; Отсюда начинается Вознесение.
EndEnumeration

Enumeration ; Alternatives.
; -Shown-
#AVanilla
#AElevator
#AIgnorance
; -Reserve-
#AVanillaPure
#AElevatorPure
; -Gold reserve-
#AVanillaGold
#AElevatorGold
#Array = #PB_Compiler_EnumerationValue - 1
EndEnumeration
;}
;{ --Constants--
#ScreenWidth = 800
#ScreenHeight = 600
#CellSize = 20
#HalfCell = #CellSize / 2
#CellGap = 7
#FullGap = #CellSize + #CellGap
#MaxPlatformsScale = 3
#MinCameraDistance = #CellSize * 6
#MaxCameraDistance = #CellSize * 10
#MapBoundsGap = #HalfCell
#MaxMapWidth = 30
#MaxMapHeight = #MaxMapWidth
#SquareAlpha = 0.5
#FrameStep = 0.025
#MaxFrame = 0.9
#PB_MB_Left = 340
#PB_MB_Right = #PB_MB_Left + 1
#All = -1
#AllReplacer = 30
#QuantStep = 3
#QuantHeight = #HalfCell * 1.25
#EyePointHeight = #HalfCell * 1.5
#NewMap = ":New:"
#MapHeader = "*Flow v0.45 Save*"
#SavePattern = "Flow maps (*.MAP)|*.MAP"
#TableWidth = 30
#TableHeight = 10
#MMOffset = 15
#MMCellSize = 5
#ETButtonOffset = 15
#MAXFPS = 30
#Title = "[Flow] map editor"
#DataBoardXOffset = 10
#DataBoardYOffset = 10
#CountersOffset = 10
#CountersTitleOffset = 2
#NoiseBlock = 200
#NoiseFrames = 10
#TallInfinity = 200
#TubeQuant = #CellGap / 2 + 4
#TenInfinity = #TallInfinity * 10
#InfiniteCell = #HalfCell * #TallInfinity
#TubeSize = #CellSize / 6
#Sky = 1000
#Space = #Sky - 10
#SquareLuft = 0.05
#CurFrames = 10
#MatrixDepth = 3
#Ignoring = -10.11
#NearScreen = 1.33 ; Needs tuning.
#TableMax = 9999
#MaxPlayers = 4
#UnlockMsg = "Input code to unlock this map (ESC\empty to abort):"
#CounterWidth = 110
#CounterHeight = 25
#LSOffset = #CountersOffset * 2
#LAOffset = #LSOffset + #CounterWidth
#VertOffset = #CounterHeight / 2 - 2
#LineFactor = 2
#VicHolez = 26
#NoLink = -1
;}
;{ --Structures--
Structure LevelData
Width.i
Height.i
CurrentPlayer.i
PlayersCount.i
HumanPlayers.i
MultiPlayer.i
ActivationFlag.i ; For AI
WaitForFinish.i ; Пауза перед обьявлением результатов игры.
CurrentTurn.i
NextMapFName.S{#MAX_PATH}
Infestation.i
AIFrame.i
TactsLimit.i
CountersTitleXPos.i
TeamsCount.i
Reserved.i[15]
EndStructure

Structure OptionsData
DisplayMiniMap.i
DisplayTables.i
SelectBeingByModel.i
ResetWarning.i
DisplayCounters.i
BlurFilter.i
EndStructure

Structure Table
ScreenPos.POINT
ZOrder.F
*Image
RMark.i
EndStructure

Structure GUIData
Exit.i
Input.i
MousePos.Point
Optional.i
FPS.i
*PickedEntity
*PickedSquare.Square
MiniMapXPos.i
MiniMapWidth.i
MiniMapHeight.i
MiniMapCursorPos.Point
MiniMapCursorBlink.i
DataBoardYPos.i
DataBoardXCenter.i
CountersTitleYPos.i
SelectedPlayer.i
InsertionBeing.i
MapFName.S
Changed.i
LockSetChanged.i
SinFeeder.i
Noised.i
CurFrame.i
; -Complex data-
List *Matrix()
List *HLSquares()
List TablesOnScreen.Table()
EndStructure

Structure Being
*Entity
*Square.Square
*EyePoint
*Table
EntityYaw.i
State.i
StateFrame.F
Frozen.i
Type.i
Owner.i
EnergyLevel.i
; -Cached-
AbsorbtionRange.i
SpawningRange.i
AbsorbtionCount.i
SpawningCost.i
Posterity.i
Channels.i
ReincarnationCost.i
Reincarnated.i
X.i ; For saves.
Y.i ; For saves.
Infection.i
*DataBoard
; -Ascendance-
Ascended.i
ExtraMode.i
Hatred.i
SwapAR.i
SwapAC.I
SwapSR.I
SwapSC.I
SwapPost.i
; -Special cache-
StoreLink.i
SynthCores.i
Reserved.i[48]
EndStructure

Structure Square;Crown :)
*Entity
ArrayPos.Point
Height.i ; For saves.
Gold.i   ; For saves
*Being.Being
State.i
DangerLevel.i    ; For AI
DangerLevel4Reincarnates.i ; For AI
AttackingLevel.i ; For AI
*TubesPiv
CellType.i
OwnData.i
Array *Visuals(#Array)
Reserved.i[26]
EndStructure

Structure Player
IType.i
BeingsCount.i
MovedBeings.i ; For AI
*FirstBeing ; For AI
Rush.i ; For AI
TotalEnergy.i
*Counter
CounterState.i
CounterPos.POINT
AlliedTeam.i
Reserved.i[21]
EndStructure

Structure Team
R.a : G.a : B.a
PlayersCount.i
EndStructure

Structure SystemData ; Archcontainer.
; -Meshez-
*PlatformRed
*PlatformGreen
*PlatformGold
*ElevatorRed
*ElevatorGreen
*ElevatorGold
*NodeCubes
*NodeCubesGold
*ConnectionTube
*MatrixTube
*Ignorance
*Rotor
*SquareMesh
*QuantMesh
*TreeMesh
*SpectatorMesh
*MeanieMesh
*IdeaMesh
*SentryMesh
*SocietyMesh
*JusticeMesh
*SentinelMesh
*HungerMesh
*JinxMesh
*DefilerMesh
*AgaveMesh
*EnigmaMesh
*AmgineMesh
*FrostBiteMesh
*SeerMesh
*ParadigmaMesh
*DesireMesh
; -Textures & Brushes-
*SkyTex
*PlatformEdgesTex[4]
*ReincarnationTubeTex
*TubeTex
*MatrixTex
*CellRedTex
*CellGreenTex
*CellGoldTex
*BlurTex
; -GUI objects-
*Cursor
*Selection
*MiniMap
*WinText
*LoseText
*AIWinText
*P1WinText
*P2WinText
*P3WinText
*P4WinText
*PressSpace
*RMark
*DataBoard
*AscendantBoard
*CountersTitle
*Counters
*GameWindow
*OldCallBack
*VoidEye
*NothingText
*InsideText
*Noise
*Mixer
*Blurer
; -Main menu-
*MTextLogo
*MRandomMap
*MLoadMap
*MOptions
*MExit
; -Music-
FoundTracks.i
CurrentTrack.i
; -One-piece data-
*CamPiv
*Camera
*Sky
*Space
*LightPiv
*Light
*SyncTimer
CountersData.RECT
; -Fonts-
*TableFont
*DataBoardFont
*PPFont ; For tests.
*CountersFont
; -String variables-
Story.S : AfterStory.S 
LockCode.s : PlayCode.S
; -Containers-
Level.LevelData
Options.OptionsData
GUI.GUIData
; -Arrays & lists-
Array Players.Player(0)
Array Teams.Team(0)
List Beings.Being()
; -Additional variables-
EndStructure
;}
;{ --Varibales--
Global Dim Squares.Square(#MaxMapWidth - 1, #MaxMapWidth - 1)
Global System.SystemData
;}
;} EndDefinition

; --Includes--
IncludeFile "Beingary (shared).PBI" ; Reference.
IncludeFile "B3D.PB" ; B3D SDK Definitions.
IncludeFile "MS.PB"  ; Map generator.

;{ Procedures
;{ --Math&Logic--
Procedure Rnd(Max)
ProcedureReturn Random(Max - 1) + 1
EndProcedure

Procedure.F Deg2Rad(Deg.F)
ProcedureReturn(Deg * (#PI / 180))
EndProcedure

Procedure InInterval(Val, Min, Max)
If Val >= Min And Val <= MAx : ProcedureReturn #True : EndIf
EndProcedure

Procedure Min(A, B)
If A < B : ProcedureReturn A : Else : ProcedureReturn B : EndIf
EndProcedure

Procedure CreateQuad(*Parent = #Null)
Define *Quad = CreateMesh_(*Parent)
Define *Surf = CreateSurface_(*Quad)
Define *v1 = AddVertex_(*Surf, -1, 0, -1, 0, 0)
Define *v2 = AddVertex_(*Surf, 1, 0, -1, 1, 0)
Define *v3 = AddVertex_(*Surf, -1, 0, 1, 0, 1)
Define *v4 = AddVertex_(*Surf, 1, 0, 1, 1, 1)
AddTriangle_(*Surf, *v1, *v3, *v2)
AddTriangle_(*Surf, *v2, *v3, *v4)
ProcedureReturn *Quad
EndProcedure

Procedure SetOn(*Entity, *Target)
PositionEntity_(*Entity, EntityX_(*Target, 1), EntityY_(*Target, 1), EntityZ_(*Target, 1), 1)
EndProcedure

Procedure TextureSurface(*Entity, SurfIdx, *Texture)
Define *Surface = GetSurface_(*Entity, SurfIdx), *Brush = GetSurfaceBrush_(*Surface)
BrushTexture_(*Brush, *Texture)
PaintSurface_(*Surface, *Brush)
FreeBrush_(*Brush)
EndProcedure

Procedure CloneTexture(*Tex)
Define TWidth = TextureWidth_(*Tex)
Define THeight = TextureHeight_(*Tex)
Define *Clone = CreateTexture_(TWidth, THeight, 8)
CopyRect__(0, 0, TWidth, THeight, 0, 0, TextureBuffer_(*Tex), TextureBuffer_(*Clone))
ProcedureReturn *Clone
EndProcedure

Procedure SetupBox(*Entity, *Sizer, Offset = 0)
Define Y, W = MeshWidth_(*Sizer), H = MeshHeight_(*Sizer), D = MeshDepth_(*Sizer)
If Offset : Y = -H + Offset : Else : Y = -H / 2 : EndIf ; Корректировка.
EntityBox_(*Entity, -W / 2, Y, -D / 2, W, H, D)         ; Ставим размер бокса.
EndProcedure

Macro PrepareObstacle(Entity, Offset = 0) ; Pseudo-procedure.
SetupBox(Entity, Entity, Offset) : EntityPickMode_(Entity, 3, #True) : HideEntity_(Entity)
EndMacro

Procedure LoadAnimEtalone(FName.S)
Define *Entity = LoadAnimMesh_(FName.S)
HideEntity_(*Entity)
ProcedureReturn *Entity
EndProcedure

Procedure ScreenTexture(Flag = 1)
Define X = Pow(2, Round(Log10(#ScreenWidth) / Log10(2), #PB_Round_Up))
Define Y = Pow(2, Round(Log10(#ScreenHeight) / Log10(2), #PB_Round_Up))
Define *Tex = CreateTexture_(X, Y, Flag) 
ScaleTexture_(*Tex, X / #ScreenWidth, Y / #ScreenHeight)
ProcedureReturn *Tex
EndProcedure

Procedure ScreenSprite(FX, Order = 0)
Define *Sprite = CreateSprite_(System\Camera)
ScaleSprite_(*Sprite, #ScreenWidth / #ScreenHeight, 1.0)
MoveEntity_(*Sprite, 0, 0, #NearScreen)
EntityFX_(*Sprite, FX) : EntityOrder_(*Sprite, Order)
ProcedureReturn *Sprite
EndProcedure

Macro ComplexEntityPrefix(Corrector = #False) ; Partializer
Define I = CountChildren_(*Entity)
While I : Define *Child = GetChild_(*Entity, I), *Name.Long = _EntityClass_(*Child)
If (*Name\L = 'hseM' Or Corrector)
EndMacro 

Macro ComplexEntityPostfix() ; Partializer
EndIf : I - 1 : Wend
EndMacro

Procedure ComplexEntityAlpha(*Entity, Alpha.F)
ComplexEntityPrefix() : EntityAlpha_(*Child, Alpha) : EndIf ; Ставим Альфу.
If CountChildren_(*Child) : ComplexEntityAlpha(*Child, Alpha)
ComplexEntityPostfix()
EndProcedure

Procedure ComplexEntityColor(*Entity, R, G, B)
ComplexEntityPrefix() : EntityColor_(*Child, R, G, B) : EndIf ; Ставим цвет.
If CountChildren_(*Child) : ComplexEntityColor(*Child, R, G, B) 
ComplexEntityPostfix()
EndProcedure

Procedure ComplexEntityTexture(*Entity, *Texture, Layer = 0)
ComplexEntityPrefix() : EntityTexture_(*Child, *Texture, 0, Layer) : EndIf
If CountChildren_(*Child) : ComplexEntityTexture(*Child, *Texture, Layer)
ComplexEntityPostfix()
EndProcedure

Procedure ComplexEntityBlend(*Entity, Mode)
ComplexEntityPrefix() : EntityBlend_(GetChild_(*Entity, I), Mode) : EndIf
If CountChildren_(*Child) : ComplexEntityBlend(*Child, Mode)
ComplexEntityPostfix()
EndProcedure

Procedure ComplexEntityFX(*Entity, FX)
ComplexEntityPrefix() : EntityFX_(GetChild_(*Entity, I), FX) : EndIf
If CountChildren_(*Child) : ComplexEntityFX(*Child, FX) 
ComplexEntityPostfix()
EndProcedure

Procedure FindChildSafe(*Entity, ChildName.s)
ComplexEntityPrefix(#True) : If EntityName_(*Child) = ChildName : ProcedureReturn *Child
ElseIf CountChildren_(*Child) : Define *Result = FindChildSafe(*Child, ChildName) 
If *Result : ProcedureReturn *Result : EndIf : EndIf
ComplexEntityPostfix()
EndProcedure

Macro LogNot(Val) ; Pseudo-procedure.
Val ! 1
EndMacro

Procedure Invert(Val, Target)
If Val = Target : ProcedureReturn 0
Else : ProcedureReturn Target : EndIf
EndProcedure

Procedure CountFPS()
Static Fps
Static FpsCounter
Static FpsTime
Static FpsTimeOld
FpsCounter+1
FpsTime = MilliSecs_()
If FpsTime - FpsTimeOld >1000
FpsTimeOld = FpsTime
Fps = FpsCounter
FpsCounter = 0
EndIf
ProcedureReturn Fps
EndProcedure

Procedure FindGameWindow() 
Define *DW = GetDesktopWindow_(), *PW, *NW, *ThisThread = GetCurrentThreadId_()
Repeat : *NW = FindWindowEx_(*DW, *PW, #Null, "[Flow] map editor")
If GetWindowThreadProcessId_(*NW, #Null) = *ThisThread : ProcedureReturn *NW : Else : *PW = *NW : EndIf
ForEver
EndProcedure

Macro Quit() ; Partializer.
SetWindowLong_(System\GameWindow, #GWL_WNDPROC, System\OldCallBack)
EndBlitz3d_() : End ; Теперь выходим. Ну, в теории...
EndMacro
;}
;{ --Map management--
Procedure Player2Color(PlayerIdx)
Select PlayerIdx
Case 0 : Color_(245, 245, 245)
Case 1 : Color_(120, 255, 120)
Case 2 : Color_(255, 90, 90)
Case 3 : Color_(235, 209, 57)
Case 4 : Color_(36, 238, 219)
EndSelect
EndProcedure

Procedure MarkMinimap(*Being.Being) ; Доделать !
Define X, Y
With *Being
X = 1 + \Square\ArrayPos\X * #MMCellSize : Y = 1 + \Square\ArrayPos\Y * #MMCellSize
SetBuffer_(ImageBuffer_(System\MiniMap, 0))
Color_(10, 10, 10)
Rect_(X, Y, #MMCellSize, #MMCellSize)
If \State <> #BDying : Player2Color(\Owner) : EndIf 
If \State = #BActive Or \State = #BPreparing
Rect_(X + 1, Y + 1, #MMCellSize - 2, #MMCellSize - 2)
Else : Rect_(X, Y, #MMCellSize, #MMCellSize)
EndIf
Color_(10, 10, 10)
Plot_(X, Y)
Plot_(X + #MMCellSize - 1, Y)
Plot_(X, Y + #MMCellSize - 1)
Plot_(X + #MMCellSize - 1, Y + #MMCellSize - 1)
SetBuffer_(BackBuffer_())
EndWith
EndProcedure

Procedure ScriptCounter(PlayerIdx)
Define Text.S
With System\Players(PlayerIdx)
SetBuffer_(ImageBuffer_(\Counter, 0))
ClsColor_(0, 0, 0) : Cls_()
DrawImage_(System\Counters, 0, 0, PlayerIdx - 1)
SetFont_(System\CountersFont)
If System\Players(PlayerIdx)\BeingsCount
Text = Str(\BeingsCount) + ": " + Str(\TotalEnergy) + "E"
Else : Text = "Not presented."
EndIf
Color_(255, 255, 255)
Text_(System\CountersData\Right, System\CountersData\Bottom, Text, #True, #True)
EndWith
EndProcedure

Procedure.S BeingType2Name(Type.i)
Select Type
Case #BTree      : ProcedureReturn "Tree"
Case #BSpectator : ProcedureReturn "Spectator"
Case #BMeanie    : ProcedureReturn "Meanie"
Case #BIdea      : ProcedureReturn "Idea"
Case #BSentry    : ProcedureReturn "Sentry"
Case #BSociety   : ProcedureReturn "Society"
Case #BJustice   : ProcedureReturn "Justice"
Case #BSentinel  : ProcedureReturn "Sentinel"
Case #BHunger    : ProcedureReturn "Hunger"
Case #BJinx      : ProcedureReturn "Jinx"
Case #BDefiler   : ProcedureReturn "Defiler"
Case #BAgave     : ProcedureReturn "Agave"
Case #BEnigma    : ProcedureReturn "Enigma"
Case #BAmgine    : ProcedureReturn "Amgine"
Case #BFrostBite : ProcedureReturn "Frostbite"
Case #BSeer      : ProcedureReturn "Seer"
Case #BParadigma : ProcedureReturn "Paradigma"
Case #BDesire    : ProcedureReturn "Desire"
EndSelect
EndProcedure

Procedure CanBeInfected(*Being.Being)
With *Being
If \Type <> #BSociety And \Type <> #BDefiler : ProcedureReturn #True : EndIf
EndWith
EndProcedure

Procedure WriteText(*Point.Point, Text.S, Start = 0, XCenter = #False)
With *Point
Text_(\X, \Y, Text, XCenter)
If Start : \X = Start : \Y + StringHeight_(Text)
Else : \X + StringWidth_(Text)
EndIf
EndWith
EndProcedure

Macro WhiteText(Text)
Color_(255, 255, 255) : WriteText(TextPoint, Text)
EndMacro

Macro WhiteTextCR(Text)
Color_(255, 255, 255) : WriteText(TextPoint, Text, #TextBorder)
EndMacro

Macro ColorText(Text, Border = #TextBorder)
Player2Color(Owner) : WriteText(TextPoint, Text, Border)
EndMacro

Procedure.S Amount2Str(Amount)
If Amount <> #All
ProcedureReturn Str(Amount)
Else : ProcedureReturn "All"
EndIf
EndProcedure

Procedure Sacrificer(*Being.Being)
With *Being
If \Type = #BAmgine : ProcedureReturn #True : EndIf
EndWith
EndProcedure

Macro IsEnigmatic(Being) ; Pseudo-procedure.
(Being\Type = #BEnigma Or Being\Type = #BAmgine)
EndMacro

Procedure DeficitSpawner(*Being.Being)
With *Being
If IsEnigmatic(*Being) : ProcedureReturn #True : EndIf
EndWith
EndProcedure

Macro Ignoring(Square) ; Pseudo-procedure.
(Square\CellType = #pIgnorance)
EndMacro

Macro Ignorant(Being) ; Pseudo-procedure
(Ignoring(Being\Square) And IsEnigmatic(Being))
EndMacro

Macro Player2TeamIdx(PlayerIDx) ; Pseudo-procedure.
System\Players(PlayerIDx)\AlliedTeam
EndMacro

Macro PlayerIdx2Team(PlayerIDx) ; Pseudo-procedure.
System\Teams(System\Players(PlayerIDx)\AlliedTeam)
EndMacro

Procedure TeamIdx2Color(Idx)
Define *Team.Team = System\Teams(Idx)
Color_(*Team\R, *Team\G, *Team\B)
EndProcedure

Macro TeamText(Text)
TeamIdx2Color(TeamIDx) : WriteText(TextPoint, Text, #TextBorder)
EndMacro

Procedure ScriptDataBoard(*Being.Being)
#TextBorder = 6
Define TypeName.S, TextPoint.Point, Owner, TeamIdx, *Team.Team
With *Being
; Подготовка к отображению таблицы.
SetBuffer_(ImageBuffer_(\DataBoard, 0))
If \Ascended : DrawImage_(System\AscendantBoard, 0, 0)
Else         : DrawImage_(System\DataBoard, 0, 0) : EndIf
SetFont_(System\DataBoardFont)
Owner = \Owner
TextPoint\X = #TextBorder : TextPoint\Y = #TextBorder
; Определение типа Сущности.
TypeName = BeingType2Name(\Type)
If \Reincarnated : TypeName + " (R)" : ElseIf Ignorant(*Being) : TypeName + " [I]" : EndIf
; Вывод данных.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If \Ascended : WhiteText("Kind: ") 
Else         : WhiteText("Type: ") 
EndIf : ColorText(TypeName)
WhiteText("Owner: ") 
If *Being\Owner ; Если это не нейтрал...
TeamIdx = Player2TeamIdx(\Owner) ; Индекс.
*Team = System\Teams(TeamIdx)    ; Указатель.
If *Team\PlayersCount > 1 : ColorText("Player " + Str(\Owner), 0)
TeamText(" (Team " + Str(TeamIdx) + ")") : Else  : TeamText("Team " + Str(TeamIdx))
EndIf ; иначе рапортуем нейтралитет:
Else : ColorText("Neutral")
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WhiteText("Energy: ") 
TypeName = Str(\EnergyLevel)
If \ReincarnationCost > 0 And Not Ignoring(\Square) : TypeName + "/" + Str(\ReincarnationCost) : EndIf
ColorText(TypeName)
If \Type = #BMeanie Or \Type = #BHunger Or \Type = #BFrostBite Or \Type = #BDesire ; Если Сущность может быть заморожена...
ColorText("Can't be frozen.") 
Else : WhiteTextCR("Not frozen.") 
EndIf
If \Type = #BSociety Or \Type = #BDefiler ; Если Сущность может открывать каналы...
TypeName = "Input " : Else : TypeName = "Output " : EndIf
TypeName + "channels: --" : WhiteTextCR(TypeName)
If \Ascended = #False ; Если сущность не вознесена...
If CanBeInfected(*Being) ; Если Сущность может быть заражена...
WhiteTextCR("Infection level: --")
Else : ColorText("Can't be infected.") 
EndIf
Else : WhiteText("Mood: ") : ColorText("Intraversal")
EndIf
WhiteTextCR("")
TextPoint\X = System\GUI\DataBoardXCenter : WriteText(TextPoint, "Stats:", #TextBorder, #True)
If Sacrificer(*Being) : TypeName = "Sacrification"
Else : TypeName = "Absorbtion"
EndIf
WhiteText(TypeName + " range: ") : ColorText(Amount2Str(\AbsorbtionRange))
WhiteText(TypeName + " count: ")
TypeName = Amount2Str(\AbsorbtionCount)
If \Ascended And Sacrificer(*Being) = #False ; Отдельно - вознесенным.
TypeName + "->" + Str(\AbsorbtionCount * 2)
ElseIf \Reincarnated = #False And \Type <> #BEnigma And Sacrificer(*Being) = #False
TypeName + "/"
If \AbsorbtionCount = #All : TypeName + Str(#AllReplacer)
Else : TypeName + Str(\AbsorbtionCount / 2) : EndIf
EndIf
ColorText(TypeName)
If \Ascended ; Если это аскендант...
WhiteText("Personal matter: ") : ColorText(BeingType2Name(\Hatred))
WhiteText("Transposition range: ") : ColorText(Amount2Str(\SpawningRange))
Else ; Стандартная роспись:
WhiteText("Spawning range: ") : ColorText(Amount2Str(\SpawningRange))
WhiteText("Spawning cost: ")
TypeName = Amount2Str(\SpawningCost) 
If DeficitSpawner(*Being) : TypeName = "1.." + TypeName : EndIf
ColorText(TypeName)
EndIf
EndWith
EndProcedure

Procedure ScriptTable(*Being.Being)
With *Being
Define Text.s
SetFont_(System\TableFont)
Player2Color(\Owner)
SetBuffer_(ImageBuffer_(\Table, 0))
ClsColor_(80, 80, 80) : Cls_()
; ---Уголки---
#Corner = 4 : #InCorner = #Corner - 1
Rect_(0, 0, #TABleWidth, #TABleHeight, #False) : Rect_(0, 0, #Corner, #Corner, #False)
; ---/Уголки--
Rect_(#TableWidth - #Corner, #TableHeight - #Corner, #Corner, #Corner, #False)
If \EnergyLevel > #TableMax : Text = Str(#TableMax) : Else : Text = Str(\EnergyLevel) : EndIf
Text_(#TABleWidth / 2, #TABleHeight / 2, Text, 1, 1) ; Самое главное.
; ---Уголки---
Color_(0, 0, 0) : Rect_(0, 0, #InCorner, #InCorner, #True) 
Rect_(#TableWidth - #InCorner, #TableHeight - #InCorner, #InCorner, #InCorner, #True)
; ---/Уголки--
EndWith
ScriptDataBoard(*Being)
EndProcedure

Procedure HLSquare(*Square.Square, State, Register = #True)
With *Square
EntityAlpha_(\Entity, #SquareAlpha)
If State = #SSpawning And \State = #SAbsorbtion
Register = #False
State = #SAbsAndSpawn
EndIf
\State = State
Select \State
Case #SNone : EntityAlpha_(\Entity, 0.0)
Case #SAbsorbtion : EntityColor_(\Entity, 245, 100, 0)
Case #SSpawning : EntityColor_(\Entity, 0, 0, 180)
Case #SAbsAndSpawn : EntityColor_(\Entity, 142, 26, 113)
Case #SActiveBeing : EntityColor_(\Entity, 170, 170, 170)
EndSelect
EndWith
If Register ; Регистрация:
AddElement(System\GUI\HLSquares())
System\GUI\HLSquares() = *Square
EndIf
EndProcedure

Procedure CollapseHL()
Define *Square.Square
ForEach System\GUI\HLSquares()
*Square = System\GUI\HLSquares()
HLSquare(*Square, #SNone, #False)
DeleteElement(System\GUI\HLSquares())
Next
EndProcedure

Procedure TurnBeing(*Being.Being, Yaw)
With *Being
Select *Being\Type
Case #BMeanie, #BSentry, #BSentinel, #BHunger, #BDefiler, #BFrostBite, #BDesire
Default : RotateEntity_(\Entity, 0, Yaw, 0) : \EntityYaw = Yaw
EndSelect
EndWith
EndProcedure

Procedure ActivePlayers()
Define I, ToFix, ActivePlayers
For I = 1 To System\Level\PlayersCount
If System\Players(I)\BeingsCount : ActivePlayers + 1 : EndIf
Next I : ProcedureReturn ActivePlayers
EndProcedure

Procedure CheckHumans()
Define I, Humans
For I = 1 To System\Level\PlayersCount
If System\Players(I)\IType = #IHuman : Humans + 1 : EndIf
Next I : ProcedureReturn Humans
EndProcedure

Procedure CheckHumanCompetition(HP)
Define I, ToFix = System\Level\PlayersCount
If HP > 1 ; Если есть живые игроки.
For I = 1 To ToFix
If System\Players(I)\IType = #IHuman And System\Players(I)\AlliedTeam <> System\Players(1)\AlliedTeam
ProcedureReturn #True
EndIf
Next I
EndIf
EndProcedure

Procedure.S CanSave()
Define Humans
If ActivePlayers() < System\Level\PlayersCount : ProcedureReturn "can't save map wizout all players present !" : EndIf
ProcedureReturn ""
EndProcedure

Procedure SetChanged()
If System\GUI\LockSetChanged = #False
If CanSave() = "" : System\GUI\Changed = #True : Else : System\GUI\Changed = #False : EndIf
EndIf
EndProcedure

Procedure AssembleTitle(FName.S = "", Changed = #False)
Define Title.S = #Title
If Changed : Title + "*" : EndIf
If FName <> "" : Title + " (" + FName + ")" : EndIf
SetBlitz3DTitle_(Title, "")
EndProcedure

Macro VizualizeChanges() ; Pseudo-procedure
SetChanged() : AssembleTitle(System\GUI\MapFName, System\GUI\Changed)
EndMacro

Procedure MakePickable(*Being.Being, Pickable = #True)
With *Being
Define I, ToFix = CountChildren_(\Entity), *Child
For I = 1 To ToFix
*Child = GetChild_(\Entity, I)
If Pickable
EntityPickMode_(*Child, 2, #False)
SetEntityID_(*Child, \Square)
Else : EntityPickMode_(*Child, 0, #False)
EndIf
Next I
EndWith
EndProcedure

Macro IsReincarnated(Type) ; Pseudo-procedure.
(Type >= #BJustice And Type < #BEnigma)
EndMacro

Macro IsAscended(Type) ; Pseudo-procedure.
(Type >= #BSeer)
EndMacro

Procedure CreateBeing(*Square.Square, Type, Owner, RefreshCounter = #True)
Define I, *Being.Being = #Null, *Mesh
; Добавляем в список:
AddElement(System\Beings()) 
*Being = System\Beings()
With *Being
; -Primary parameters setup-
\Owner = Owner : \Type = Type : \StoreLink = #NoLink ; Essential.
If \Owner = 1 : \State = #BPreparing : Else : \State = #BBorning : EndIf
*Square\Being = *Being : \Square = *Square : \Posterity = \Type
\X = *Square\ArrayPos\X : \Y = *Square\ArrayPos\Y          ; Запоминаем позицию.
If \Owner : System\Players(\Owner)\BeingsCount + 1 : EndIf ; Increse owner's beings count.
If IsReincarnated(Type) : \Reincarnated = #True            ; Установить флаг реинкарнации.
ElseIf IsAscended(Type) : \Ascended = #True : \SpawningCost = #All : EndIf ; Установить флаг вознесения.
; -Secondary parameters setup-
Select Type
Case #BTree
\EnergyLevel = 5 : *Mesh = System\TreeMesh
\SpawningCost = #All
Case #BSpectator
\EnergyLevel = 15     : *Mesh = System\SpectatorMesh
\AbsorbtionRange = 8  : \SpawningRange = 2
\AbsorbtionCount = 10 : \SpawningCost = 15
\ReincarnationCost = 80
Case #BSentry
\EnergyLevel = 20       : *Mesh = System\SentryMesh
\AbsorbtionRange = 2    : \SpawningRange = 2
\AbsorbtionCount = #All : \SpawningCost = #All
\ReincarnationCost = 160
Case #BMeanie
\EnergyLevel = 10    : *Mesh = System\MeanieMesh
\AbsorbtionRange = 3 : \SpawningRange = 4
\AbsorbtionCount = 5 : \SpawningCost = 10
\ReincarnationCost = 50
Case #BIdea
\EnergyLevel = 2     : *Mesh = System\IdeaMesh
\AbsorbtionRange = 2 : \SpawningRange = 7
\AbsorbtionCount = 6 : \SpawningCost = 2
\ReincarnationCost = 30
Case #BSociety
\EnergyLevel = 20    : *Mesh = System\SocietyMesh
\AbsorbtionRange = 4 : \SpawningRange = 3
\AbsorbtionCount = 7 : \SpawningCost = 20
\ReincarnationCost = 100
Case #BEnigma 
\EnergyLevel = 13     : *Mesh = System\EnigmaMesh
\AbsorbtionRange = 3  : \SpawningRange = 3 
\AbsorbtionCount = 13 : \SpawningCost = 13
\ReincarnationCost = #All
Case #BAmgine
\EnergyLevel = 13     : *Mesh = System\AmgineMesh
\AbsorbtionRange = 3  : \SpawningRange = 3
\AbsorbtionCount = 13 : \SpawningCost = 13
\ReincarnationCost = #All
; -Reincarnated Beings-
Case #BJustice
\EnergyLevel = 80     : *Mesh = System\JusticeMesh
\AbsorbtionRange = 20 : \SpawningRange = 4
\AbsorbtionCount = 25 : \SpawningCost = #All
Case #BSentinel
\EnergyLevel = 150      : *Mesh = System\SentinelMesh
\AbsorbtionRange = 4    : \SpawningRange = 4
\AbsorbtionCount = #All : \SpawningCost = 15
\Posterity = #BSentry
Case #BHunger
\EnergyLevel = 50     : *Mesh = System\HungerMesh
\AbsorbtionRange = 5  : \SpawningRange = 6
\AbsorbtionCount = 15 : \SpawningCost = #All
Case #BJinx
\EnergyLevel = 30     : *Mesh = System\JinxMesh
\AbsorbtionRange = 4  : \SpawningRange = 20
\AbsorbtionCount = 20 : \SpawningCost = #All
Case #BDefiler
\EnergyLevel = 100    : *Mesh = System\DefilerMesh
\AbsorbtionRange = 6  : \SpawningRange = 5
\AbsorbtionCount = 10 : \SpawningCost = #All
Case #BAgave
\EnergyLevel = 50     : *Mesh = System\AgaveMesh
\SpawningCost = #All
; -Tools-
Case #BFrostBite
\EnergyLevel = 1      : *Mesh = System\FrostBiteMesh
\SpawningCost = #All
; -Ascendants
Case #BSeer
\EnergyLevel = 80     : *Mesh = System\SeerMesh
\AbsorbtionRange = 10 : \SpawningRange = 3
\AbsorbtionCount = 15 : \Hatred = #BJustice
Case #BParadigma
\EnergyLevel = 30     : *Mesh = System\ParadigmaMesh
\AbsorbtionRange = 3  : \SpawningRange = 9
\AbsorbtionCount = 12 : \Hatred = #BJinx
Case #BDesire
\EnergyLevel = 50     : *Mesh = System\DesireMesh
\AbsorbtionRange = 4  : \SpawningRange = 5
\AbsorbtionCount = 10 : \Hatred = #BHunger
\SynthCores = -1 ; Dirty, yet working trick.
EndSelect
If RefreshCounter And \Owner : System\Players(\Owner)\TotalEnergy + \EnergyLevel : ScriptCounter(\Owner) : EndIf
; -Entity setup-
\Entity = CopyEntity_(*Mesh, *Square\Entity)
SetOn(\Entity, *Square\Entity) ; Ставим на платформу.
TurnBeing(*Being, DeltaYaw_(\Entity, System\Sky) - 180)
; -Optimization-
If \Type = #BDesire
For I = 1 To #VicHolez
HideEntity_(FindChildSafe(\Entity, "Tubus" + RSet(Str(I), 2, "0")))
Next I
EndIf
; -EyePoint setup-
\EyePoint = CreatePivot_(\Entity)
If \Ascended : TranslateEntity_(\EyePoint, 0, #EyePointHeight * 1.5, 0) : EndIf
Select \Type ; Смотрим по типу.
Case #BSentry, #BJinx : TranslateEntity_(\EyePoint, 0, #EyePointHeight * 2.0, 0)
Case #BSentinel : TranslateEntity_(\EyePoint, 0, #EyePointHeight * 3, 0)
Case #BFrostBite : TranslateEntity_(\EyePoint, 0, #EyePointHeight * 0.8, 0)
Default : TranslateEntity_(\EyePoint, 0, #EyePointHeight, 0)
EndSelect
; -Data board setup-
\DataBoard = CreateImage_(ImageWidth_(System\DataBoard), ImageHeight_(System\DataBoard), 1)
; -Table setup-
\Table = CreateImage_(#TableWidth, #TableHeight, 1)
MidHandle_(\Table)
ScriptTable(*Being)
; -Make pickable-
If System\Options\SelectBeingByModel : MakePickable(*Being) : EndIf
; -Отобразить на мини-карте-
MarkMiniMap(*Being)
EndWith
VizualizeChanges()
ProcedureReturn *Being
EndProcedure

Macro MakeAllBeingsPickable() ; Pseudo-procedure
ForEach System\Beings() : MakePickable(System\Beings()) : Next
EndMacro

Macro MakeAllBeingsUnPickable() ; Pseudo-procedure
ForEach System\Beings() : MakePickable(System\Beings(), #False) : Next
EndMacro

Procedure ExcludeBeing(*Being.Being)
With *Being
If \Owner
System\Players(\Owner)\BeingsCount - 1
System\Players(\Owner)\TotalEnergy - \EnergyLevel
EndIf
\State = #BDestroyed
EndWith
EndProcedure

Procedure DestroyBeing()
Define *Being.Being = System\Beings()
With *Being
FreeImage_(\Table)
FreeEntity_(\Entity)
DeleteElement(System\Beings())
EndWith
EndProcedure

Procedure RemoveBeing(*Being.Being)
*Being\State = #BDying
MarkMiniMap(*Being)
ExcludeBeing(*Being)
If *Being\Owner : ScriptCounter(*Being\Owner) : EndIf
*Being\Square\Being = #Null
EndProcedure

Procedure FormRect(*Rectangle.Rect) ; Left = X центра, Top = center Y центра, Right = радиус.
Define Range
With *Rectangle
Range = \Right
\Right = \Left + Range
If \Right >= System\Level\Width : \Right = System\Level\Width - 1 : EndIf
\Bottom = \Top + Range
If \Bottom >= System\Level\Height : \Bottom = System\Level\Height - 1 : EndIf
\Left = \Left - Range
If \Left < 0 : \Left = 0 : EndIf
\Top = \Top - Range
If \Top < 0 : \Top = 0 : EndIf
EndWith
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro NoGoldForMe(Being, Square) ; Pseudo-procedure
(Being\Ascended And (Ignoring(Square) Or Square\Gold = #False))
EndMacro

Macro SimpleLife(Being, Square) ; Pseudo-rpcoedure.
(Being\Ascended = #False And Being\Reincarnated = #False)
EndMacro

Macro NeedsAttention(Being, Square) ; Pseud-procedure
(Being\Reincarnated And (Being\Type = #BSentinel Or Not Ignoring(Square)))
EndMacro

Macro CanVisit(Being, Square) ; Pseudo-procedure.
NoGoldForMe(Being, Square) Or SimpleLife(Being, Square) Or NeedsAttention(Being, Square)
EndMacro

Macro ActionAvailable(Being, Square, SpawnFlag) ; Pseudo-procedure.
(SpawnFlag And CanVisit(Being, Square)) Or (SpawnFlag = #False And EntityVisible_(Being\EyePoint, Square\Entity))
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure BeingHL(*Being.Being, Spawning = #False)
#AngleStep = 5
Define X, Y, HLRect.Rect, Range, HLState, *Square.Square
With *Being
If Spawning 
Range = \SpawningRange
HLState = #SSpawning
Else 
Range = \AbsorbtionRange
HLState = #SAbsorbtion
EndIf
HLRect\Left = \Square\ArrayPos\X
HLRect\Top = \Square\ArrayPos\Y
HLRect\Right = Range
FormRect(HLRect)
For X = HLRect\Left To HLRect\Right
For Y = HLRect\Top To HLRect\Bottom
If (Abs(X - \Square\ArrayPos\X) + Abs(Y - \Square\ArrayPos\Y)) <= Range
*Square = Squares(X, Y) ; Подсвечиваем, если действие допустимо:
If ActionAvailable(*Being, *Square, Spawning) : HLSquare(*Square, HLState, #True) : EndIf
EndIf
Next Y
Next X
EndWith
EndProcedure

Procedure CanReincarnate(*Being.Being)
With *Being
If \ReincarnationCost And \EnergyLevel >= \ReincarnationCost And Not Ignoring(\Square)
ProcedureReturn #True
EndIf
EndWith
EndProcedure

Procedure RegisterTable(*Being.Being)
If System\Options\DisplayTables
Define *Table.Table
With *Being
If EntityInView_(\EyePoint, System\Camera)
; -Setup table-
AddElement(System\GUI\TablesOnScreen()) : *Table = System\GUI\TablesOnScreen()
CameraProject_(System\Camera, EntityX_(\EyePoint, 1), EntityY_(\EyePoint, 1), EntityZ_(\EyePoint, 1))
*Table\ScreenPos\X = ProjectedX_()
*Table\ScreenPos\Y = ProjectedY_()
*Table\ZOrder = EntityDistance_(System\Camera, \EyePoint)
*Table\Image = \Table
; -Check for Reincarnation Mark-
If CanReincarnate(*Being) And \ReincarnationCost <> #All 
*Table\RMark = #True : Else : *Table\RMark = #False
EndIf
EndIf
EndWith
EndIf
EndProcedure

Macro MessageBox(Title, Text, Flags = 0) ; Pseudo-procedure.
ShowPointer_() : MessageRequester(Title, Text, Flags)
EndMacro

Macro ErrorBox(Text, Title = "Erroneous activity:") ; Pseudo-procedure.
MessageBox(Title, "FAIL: " + Text, #MB_ICONSTOP)
EndMacro

Procedure CheckSaving()
Define ErrorText.s = CanSave()
If ErrorText <> "" ; Если сохранить не удастся...
ErrorBox(ErrorText, "Map saving error:")
ProcedureReturn #True
EndIf
EndProcedure

Procedure.s InvalidatePass(Pass.s)
Define *Char.Character = @Pass
While *Char\C : *Char\C ! 255 : *Char + SizeOf(Character) :Wend
ProcedureReturn Pass
EndProcedure

Procedure SaveMap(FName.S) ; Доделать !
; Проверка валидности карты.
Define NewCode.s, X, Y, *Ptr, Header.S = #MapHeader, *ListPos, ErrorText.S, Result
If CheckSaving() : ProcedureReturn #False : EndIf
System\Level\HumanPlayers = CheckHumans()
If CheckHumanCompetition(System\Level\HumanPlayers) : System\Level\MultiPlayer = #True 
Else : System\Level\MultiPlayer = #False : EndIf ; No multiplayer.
; -Actual saving-
If CreateFile(1, FName)
WriteData(1, @Header, Len(Header))
WriteLong(1, #True) ; Map Editor Flag.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WriteLong(1, Len(System\LockCode))           ; Вписываем длину кода.
If System\LockCode : NewCode.s = InvalidatePass(System\LockCode)
WriteData(1, @NewCode, Len(NewCode))         ; Вписываем код на изменение.
EndIf : WriteLong(1, Len(System\PlayCode))   ; Вписываем длину кода.
If System\PlayCode : NewCode.s = InvalidatePass(System\PlayCode)
WriteData(1, @NewCode, Len(NewCode)) : EndIf ; Вписываем код на игру.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WriteData(1, @System\Level, SizeOf(LevelData))
WriteLong(1, Len(System\Story)) ; Запись брифинга карты.
WriteData(1, @System\Story, Len(System\Story))
WriteLong(1, Len(System\AfterStory)) ; Запись эпилога карты.
WriteData(1, @System\AfterStory, Len(System\AfterStory))
; -Записать данных клеток-
For Y = 1 To System\Level\Height
For X = 1 To System\Level\Width
WriteData(1, @Squares(X - 1, Y - 1), SizeOf(Square))
Next X
Next Y
; Записать данных игроков.
WriteLong(1, System\Level\PlayersCount)
For X = 1 To System\Level\PlayersCount ; Пишем все.
WriteData(1, System\Players(X), SizeOf(Player))
Next X
; Записываем данные комманд.
WriteLong(1, System\Level\TeamsCount)
For X = 1 To System\Level\TeamsCount ; Пишем все.
WriteData(1, System\Teams(X), SizeOf(Team))
Next X
; Записать данные Сущностей.
WriteLong(1, ListSize(System\Beings()))
ForEach System\Beings() ; Пишем все.
WriteData(1, System\Beings(), SizeOf(Being))
Next
; Записать данные квантов (Dummy).
WriteLong(1, 0)
; Записать позицию камеры.
WriteLong(1, EntityZ_(System\CamPiv))
WriteLong(1, EntityX_(System\CamPiv))
WriteLong(1, EntityYaw_(System\CamPiv))
WriteLong(1, EntityDistance_(System\Camera, System\CamPiv))
; Записать позицию для выделения.
If System\GUI\PickedSquare <> #Null
WriteLong(1, EntityZ_(System\GUI\PickedSquare\Entity))
WriteLong(1, EntityY_(System\GUI\PickedSquare\Entity))
WriteLong(1, EntityX_(System\GUI\PickedSquare\Entity))
Else
WriteLong(1, EntityZ_(System\Selection))
WriteLong(1, EntityY_(System\Selection))
WriteLong(1, EntityX_(System\Selection))
EndIf
; Записать данные матрицы.
ForEach System\GUI\Matrix() : *Ptr = System\GUI\Matrix()
WriteLong(1, EntityZ_(*Ptr)) : WriteLong(1, EntityX_(*Ptr))
WriteLong(1, EntityPitch_(*Ptr)) ; Другие углы не нужны.
Next
; Записать данные каналов (Dummy).
WriteLong(1, 0)
; Записать данные эффектов перерождения (Dummy).
WriteLong(1, 0)
; Записать данные дождевых искр (Dummy).
WriteLong(1, 0)
WriteLong(1, 0)
; Закрыть файл.
CloseFile(1)
Result = #True
Else : ErrorBox("can't write to '" + FName + "' !", "Map saving error:")
Result = #False
EndIf 
ProcedureReturn Result
EndProcedure

Procedure SaveMapRequester()
Define FName.S
ShowPointer_()
If CheckSaving() = #False ; Если возможно сохранение....
FName = Trim(SaveFileRequester("Choose file to save map:", GetCurrentDirectory(), #SavePattern, 1))
If FName <> "" 
If GetExtensionPart(FName) = "" : FName + ".MAP" : EndIf
If SaveMap(FName) : System\GUI\MapFName = FName
System\GUI\Changed = #False : AssembleTitle(System\GUI\MapFName)
EndIf
EndIf
EndIf
HidePointer_()
EndProcedure

Procedure ShowResetWarning() ; Pseudo-procedure
#YesNoCancel = #PB_MessageRequester_YesNoCancel
If System\GUI\Changed = #True And System\Options\ResetWarning : ShowPointer_()
Select MessageRequester("Warning:", "Map have been changed. Do you want save it before exit ?", #YesNoCancel)
Case #PB_MessageRequester_Yes ; Согласие на сохранение.
If System\GUI\MapFName <> "" : SaveMap(System\GUI\MapFName)
Else : SaveMapRequester() : EndIf
Case #PB_MessageRequester_Cancel ; Отмена действия.
ProcedureReturn #True
EndSelect
EndIf
EndProcedure

Procedure DestroyTubes(*Square.Square)
Define *NewPiv = CreatePivot_(GetParent_(*Square\TubesPiv))
FreeEntity_(*Square\TubesPiv)
*Square\TubesPiv = *NewPiv
EndProcedure

Procedure ConnectionTubes(X, Y, Vert = #False)
With System
Define *Square.Square, *Tube, I, Factor, Count
Define Height = Squares(X, Y)\Height, *Etalone
If Vert : Factor = Y : Else : Factor = X : EndIf
If Factor ; Если мы не в углу....
; -Create connection tube-
If Vert : *Square = Squares(X, Y - 1) : Else : *Square = Squares(X - 1, Y) : EndIf
If *Square\CellType <> Squares(X, Y)\CellType : Count = 0 : Else : Count = Min(Height, *Square\Height) : EndIf
If *Square\CellType = #pVanilla : *Etalone = \ConnectionTube : Else : *Etalone = \Rotor : EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
For I = 1 To Count
*Tube = CopyEntity_(*Etalone, Squares(X, Y)\TubesPiv)
If Vert : TurnEntity_(*Tube, 0, 90, 0) : TranslateEntity_(*Tube, 0, 0, #FullGap / 2)
Else : TranslateEntity_(*Tube, -#FullGap / 2, 0, 0) : EndIf
; -Height translation-
If I > 1 : SetupBox(*Tube, *Tube) : EntityPickMode_(*Tube, 3, #False) : EndIf
TranslateEntity_(*Tube, 0, #InfiniteCell - #HalfCell - (#CellSize * Height) + (#CellSize * I), 0)
Next I
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndIf
EndWith
EndProcedure

Procedure MatrixTubes(X, Y, Angle = 0)
Define I, *Tube
For I = 1 To #MatrixDepth ; Like that...
*Tube = CopyEntity_(System\MatrixTube)               ; Делаем трубу.
AddElement(System\GUI\Matrix()) : System\GUI\Matrix() = *Tube ; Вносим на баланс.
SetOn(*Tube, Squares(X, Y)\TubesPiv)                          ; Ставим на место.
TurnEntity_(*Tube, Random(180) + 0.1, Angle, 0)               ; Разворот для матрицы.
MoveEntity_(*Tube, 0, Random(#TubeQuant), 0)                  ; Небольшой сдвиг.
TranslateEntity_(*Tube, 0, #InfiniteCell + #HalfCell - #CellSize * (I + Squares(X, Y)\Height), 0)
Next I
EndProcedure

Procedure ReConnect(X, Y)
DestroyTubes(Squares(X, Y))
If Squares(X, Y)\CellType = #pVanilla Or Squares(X, Y)\CellType = #PIgnorance
ConnectionTubes(X, Y) : ConnectionTubes(X, Y, #True)
EndIf
EndProcedure

Macro HandleConnections(X, Y, Factor = #True)
Reconnect(X, Y) ; Воссоединяем клетки.
If X < System\Level\Width - 1  And Factor : ReConnect(X + 1, Y) : EndIf
If Y < System\Level\Height - 1 And Factor : ReConnect(X, Y + 1) : EndIf
EndMacro

Macro SetupNodes(Elevator, Scale)
PositionEntity_(GetChild_(Elevator, 1), 0, (Scale - 1) * -#CellSize, 0, 0) ; Сдвиг узлов.
EndMacro

Procedure ReScalePlatform(X, Y, Scale)
Define *Cell.Square = Squares(X, Y), OldHeight = *Cell\Height, *Platform = *Cell\Visuals(#AVanillaPure)
PositionEntity_(*Platform, X * #FullGap + #HalfCell, -#InfiniteCell + #CellSize * Scale, -Y * #FullGap - #HalfCell)
*Cell\Height = Scale : PositionEntity_(*Cell\Entity, 0, #InfiniteCell + #SquareLuft, 0, 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetupNodes(*Cell\Visuals(#AElevatorPure), Scale)
SetupNodes(*Cell\Visuals(#AElevatorGold), Scale)
HandleConnections(X, Y, OldHeight)
EndProcedure

Macro HideVisual(Entity, Flag) ; Pseudo-procedure.
If Flag : HideEntity_(Entity) ; Просто скрываем.
Else : EntityAlpha_(Entity, 0) : EntityPickMode_(Entity, 0, #False) : EndIf
EndMacro

Macro ShowVisual(Entity, Flag) ; Pseudo-procedure.
If Flag : ShowEntity_(Entity) ; Просто показываем.
Else : EntityAlpha_(Entity, 1) : EntityPickMode_(Entity, 3, #True) : EndIf
EndMacro

Procedure GoldInverse(Gold, *Cell.square) ; Pseudo-procedure
If Gold : *Cell\Visuals(#AElevator) = *Cell\Visuals(#AElevatorGold)
*Cell\Visuals(#AVanilla) = *Cell\Visuals(#AVanillaGold)
Else    : *Cell\Visuals(#AElevator) = *Cell\Visuals(#AElevatorPure) 
*Cell\Visuals(#AVanilla) = *Cell\Visuals(#AVanillaPure)
EndIf
EndProcedure

Procedure ChangePlatform(XPos, YPos, Gold, NewScale = 0)
Define *Cell.Square = Squares(XPos, YPos), *Tex
With System
Select *Cell\CellType ; По типу клетки...
Case #pIgnorance : RotateEntity_(*Cell\Visuals(#AIgnorance), 0, Gold * 90, 0)
Case #pVanilla   ; Платформы:
HideVisual(*Cell\Visuals(#AVanilla),*Cell\Gold):GoldInverse(Gold,*Cell):ShowVisual(*Cell\Visuals(#AVanilla),Gold)
Case #pElevator  ; Элеваторы:
HideEntity_(*Cell\Visuals(#AElevator)) : GoldInverse(Gold, *Cell) : ShowEntity_(*Cell\Visuals(#AElevator))
EndSelect ; Выставляем, наконец, флаг:
*Cell\Gold = Gold ; Переставляем масштаб, если есть такая нужда:
If *Cell\CellType <> #PIgnorance And *Cell\Being And *Cell\Being\Ascended : RemoveBeing(*Cell\Being) : EndIf
If NewScale And NewScale <> *Cell\Height : ReScalePlatform(XPos, YPos, NewScale) : EndIf
EndWith
EndProcedure

Procedure ReStructureCell(XPos, YPos, NewType, SkipRemoval = #False)
Define *Cell.Square = Squares(XPos, YPos)
With *Cell ; Начинаем обработку клетки...
If SkipRemoval = #False ; Если нужна переработка.
Select \CellType ; Сначала убираем старое.
Case #pVanilla : HideVisual(\Visuals(#AVanilla), *Cell\Gold) ; Скрываем.
\CellType = #PB_Ignore : HandleConnections(XPos, YPos) ; Убиваем трубы.
Case #pElevator  : HideEntity_(\Visuals(#AElevator))   ; Скрыть элеватор.
Case #pIgnorance : HideEntity_(\Visuals(#AIgnorance))  ; Скрываем обелиск.
EndSelect ; ...И последнее (убиваем позолоту):
If NewType = #pIgnorance Or \CellType = #pIgnorance : GoldInverse(#False, *Cell)
\Gold = #False : \CellType = #PB_Ignore : HandleConnections(XPos, YPos) : EndIf
\CellType = NewType ; Ставим новый тип.
EndIf ; Продолжаем обработку:
Select \CellType ; Устанавливаем графику по типу.
Case #pVanilla  : ShowVisual(\Visuals(#AVanilla), *Cell\Gold) ; Скрываем.
HandleConnections(XPos, YPos)                         ; Ставим трубы на место.
Case #pElevator : ShowEntity_(\Visuals(#AElevator))   ; Показать элеватор.
Case #pIgnorance : ShowEntity_(\Visuals(#AIgnorance)) ; Показать обелиск.
If SkipRemoval = #False : HandleConnections(XPos, YPos) : EndIf
ChangePlatform(XPos, YPos, 0) ; На всякий пожарный заворачиваем в 0.
If \Being And \Being\Reincarnated : RemoveBeing(\Being) : EndIf
EndSelect
EndWith
EndProcedure

Macro CleanUP() ; Pesudo-procedure
; Удаляем всю графику.
ForEach System\Beings() : DestroyBeing() : Next : ToFix = System\Level\PlayersCount
ForEach System\GUI\Matrix() : FreeEntity_(System\GUI\Matrix()) : Next
For I = 1 To ToFix : FreeImage_(System\Players(I)\Counter)
ClearStructure(@System\Players(I), Player) : Next I
; Очищаем игровое поле.
XEnd = System\Level\Width - 1 : YEnd = System\Level\Height - 1
For X = 0 To XEnd : For Y = 0 To YEnd : FreeEntity_(GetParent_(Squares(X, Y)\Entity))
ClearStructure(Squares(X, Y), Square) : Next Y : Next X
; Последние приготовления.
ClearStructure(@System\GUI, GUIData) : ClearStructure(@System\Level, LevelData)
InitializeStructure(@System\GUI, GUIData) ; Дабы активировать списки.
EndMacro

Procedure OpenOptionsFile()
Define Header.S = Space(Len(#CfgFileHeader))
If OpenFile(0, #CfgSaveFile)
ReadData(0, @Header, Len(Header)) 
If Header = #CfgFileHeader
ProcedureReturn #True
Else : CloseFile(0)
EndIf
EndIf
EndProcedure

Macro PerformOptions() ; Partializer.
If System\Options\SelectBeingByModel : MakeAllBeingsPickable()
Else : MakeAllBeingsUnPickable()
EndIf
If System\Options\BlurFilter : ShowEntity_(System\Blurer)
Else : HideEntity_(System\Blurer) : EndIf
EndMacro

Macro ConsumeParams() ; Partializer
System\Story = Params\Story : System\AfterStory = Params\AfterStory
System\LockCode = Params\LockCode : System\PlayCode = Params\PlayCode
System\Level\Width = Params\MapWidth : System\Level\Height = Params\MapHeight
System\Level\NextMapFName = Params\NextMap : System\Level\TactsLimit = Params\TactsLimit
EndMacro

Procedure FindColors(*Team.Team, TeamIdx)
Define I, Pixel.l, NewPixel.l, *Buffer, Factor
*Buffer = ImageBuffer_(System\Mixer, 0)
SetBuffer_(*Buffer) ; Установка буффера.
With *Team ; Обработка комманды
For I = 1 To System\Level\PlayersCount
If System\Players(I)\AlliedTeam = TeamIdx 
Player2Color(I) : Plot_(0, 0) : NewPixel = ReadPixel_(0, 0, *Buffer)
If Pixel : Factor + 2 : Pixel = AlphaBlend(RGBA(Red(NewPixel), Green(NewPixel), Blue(NewPixel), 255 / Factor), Pixel)
Else : Pixel = NewPixel  : EndIf
EndIf
Next I
\B = Red(Pixel)
\G = Green(Pixel)
\R = Blue(Pixel)
EndWith
EndProcedure

Macro UpdatePlayers() ; Partializer
FillMemory(@System\Teams(1), #MaxPlayers * SizeOf(Team))
For I = 1 To Params\PlayersCount ; Проходим по игрокам...
Define *Player.Player = System\Players(I)
If I > 1 ; Задать тип управления игроком.
*Player\IType = Params\ITypes[I - 2]
Else : *Player\IType = #IHuman
EndIf
*Player\AlliedTeam = Params\Teams[I-1]
System\Teams(*Player\AlliedTeam)\PlayersCount + 1
Next I
; Теперь комманды...
System\Level\TeamsCount = 0
For I = 1 To #MaxPlayers ; Проходим по игрокам...
If System\Teams(I)\PlayersCount : System\Level\TeamsCount + 1 : FindColors(System\Teams(I), I) : EndIf
Next I
EndMacro

Macro LoadingErr(Text) ; Pseudo-procedure.
ErrorBox(Text, "Map loading error:")
EndMacro

Procedure LoadMap(FName.S = #NewMap) ; Доделать !
With System
Define X, Y, Code.s, XEnd, YEnd, *Platform, *Elevator, Type, Scale, *Square, *Player.Player, Random
Define Header.S = Space(Len(#MapHeader)), EHeader.S = #MapHeader, I, ToFix
Define Params.MapParams
If FName = #NewMap ; Определение типа загрузки.
ShowPointer_() ; Временно показать курсор мыши.
X = MGRequester(Params, \Options) ; Получение данных от пользователя.
PerformOptions()
HidePointer_() ; Скрыть курсор мыши.
Select X
Case #True : Random = #True
Case #False : Quit() ; Сразу выходим. Да, тут.
Case 2 : ProcedureReturn #True
EndSelect
Else ; Загрузка из файла.
If OpenFile(0, FName.S)
ReadData(0, @Header, Len(#MapHeader))
If CompareMemory(@Header, @EHeader, Len(Header)) = #False
CloseFile(0)
LoadingErr("invalid header !")
ProcedureReturn #False
EndIf
Else : LoadingErr("can't open '" + FName + "' !")
ProcedureReturn #False
EndIf
If ReadLong(0) = #False ; Не грузим сохраненные игры.
LoadingErr("can't load game saves !")
CloseFile(0) : ProcedureReturn #False
EndIf ; Теперь проверяем защитный код:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
I = ReadLong(0) : If I : Code = Space(I) : ReadData(0, @Code, I) ; Читаем защитный код...
Code = InvalidatePass(Code) ; Сразу же, на всякий пожарный.
Select CodeRequester("", #UnlockMsg)
Case "" : CloseFile(0) : ProcedureReturn #False ; Мирно выходим.
Case Code ; Nop. Продолжаем загрузку.
Default ; Неправильный пароль...
LoadingErr("incorrect code - loading aborted !")
CloseFile(0) : ProcedureReturn #False
EndSelect : \LockCode = Code ; ЗАпоминаем код.
EndIf : I = ReadLong(0) : If I : Code = Space(I) : ReadData(0, @Code, I) ; Читаем игровой код...
\PlayCode = InvalidatePass(Code) ; Игровой код.
EndIf ; Показать предупреждение о несохраненных изменениях:
If ShowResetWarning() : ProcedureReturn #False : EndIf
EndIf 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clean-Up
CleanUp() : \GUI\LockSetChanged = #True
; Начинаем генерацию.
If Random ; Если идет слечайный порядок...
ConsumeParams() ; анализируем данные.
Else : ReadData(0, @\Level, SizeOf(LevelData))     ; Загрузить размер поля из файла.
I = ReadLong(0) : \Story = Space(I) : ReadData(0, @\Story, I)           ; Загрузить брифинг.
I = ReadLong(0) : \AfterStory = Space(I) : ReadData(0, @\AfterStory, I) ; Загрузить эпилог.
EndIf
; Настроить мини-карту.
ReSizeImage_(\MiniMap, #MMCellSize * \Level\Width + 2, #MMCellSize * \Level\Height + 2)
SetBuffer_(ImageBuffer_(\MiniMap, 0))
ClsColor_(10, 10, 10) : Cls_()
SetBuffer_(BackBuffer_())
\GUI\MiniMapXPos = #ScreenWidth - ImageWidth_(\MiniMap) - #MMOffset
\GUI\MiniMapWidth = ImageWidth_(\MiniMap)
\GUI\MiniMapHeight = ImageHeight_(\MiniMap)
\GUI\MiniMapCursorPos\X = 1 + \GUI\MiniMapXPos
\GUI\MiniMapCursorPos\Y = 1 + #MMOffset
; -Настроить таблицу данных-
\GUI\DataBoardYPos = #ScreenHeight - ImageHeight_(\DataBoard) - #DataBoardYOffset
\GUI\DataBoardXCenter = #DataBoardXOffset + ImageWidth_(\DataBoard) / 2
; --Floor creation--
XEnd = \Level\Width - 1 : YEnd = \Level\Height - 1
For Y = 0 To YEnd
For X = 0 To XEnd
Define *Cell.Square = Squares(X, Y)
; -Platform creation-
If Type : *Platform = \PlatformRed : *Elevator = \ElevatorRed
Else    : *Platform = \PlatformGreen : *Elevator = \ElevatorGreen : EndIf
*Platform = CopyEntity_(*Platform) ; Создаем платформу и основу на будущее.
If Random : Scale = 1 ; Если случайная генерация.
Else ; Считать высоту из файла
ReadData(0, *Cell, SizeOf(Square))
PokeI(*Cell + OffsetOf(Square\Visuals), 0)
Scale = *Cell\Height
EndIf : *Cell\Height = 0
; -Squares creation-
*Square   = CopyEntity_(\SquareMesh, *Platform) ; -Create square-
*Elevator = CopyEntity_(*Elevator, *Square)
SetEntityID_(*Square, *Cell)
*Cell\Entity   = *Square
*Cell\Being    = #Null
If Random
*Cell\ArrayPos\X = X
*Cell\ArrayPos\Y = Y
*Cell\Gold       = #False
*Cell\CellType   = #pVanilla
*Cell\OwnData    = #Null
EndIf 
InitializeStructure(*Cell, Square) ; Ре-инициализация.
*Cell\Visuals(#AVanilla)     = *Platform ; Вписка платформы.
*Cell\Visuals(#AVanillaPure) = *Platform ; Вписка платформы.
; Настройка альтернатив.
Define *Ignorance = CopyEntity_(\Ignorance, *Square) : HideEntity_(*Ignorance)
TranslateEntity_(*Ignorance, 0, #Ignoring, 0) : HideEntity_(*Elevator)
TranslateEntity_(*Elevator, 0, -#HalfCell - #SquareLuft, 0) ; Небольшое смещение.
CopyEntity_(\NodeCubes, *Elevator) : *Cell\Visuals(#AIgnorance)    = *Ignorance ; Обелиск.
*Cell\Visuals(#AElevator) = *Elevator    : *Cell\Visuals(#AElevatorPure) = *Elevator  ; Элеватор.
Define *Gold = CopyEntity_(\PlatformGold, *Platform) ; Создание золотой платформы.
*Cell\Visuals(#AVanillaGold) = *Gold : HideEntity_(*Gold)  ; Вписка золотой платформы.
*Gold = CopyEntity_(\ElevatorGold, *Square) : CopyEntity_(\NodeCubesGold, *Gold) 
SetOn(*Gold, *Elevator) : *Cell\Visuals(#AElevatorGold) = *Gold : HideEntity_(*Gold) ; Вписка золота.
; Установка размера платформы:
*Cell\TubesPiv = CreatePivot_(*Platform)
Define Gold = *Cell\Gold : *Cell\Gold = #False ; Сохраняем на будущее.
If *Cell\CellType : EntityAlpha_(*Platform, 0) ; Сразу скрываем.
RestructureCell(X, Y, *Cell\CellType, #True)   ; Реструктуризуем.
EndIf : ChangePlatform(X, Y, Gold, Scale) ; Ремасштабируем.
; Матрица.
If Y = 0 : MatrixTubes(X, Y, -90) : EndIf
If X = 0 : MatrixTubes(X, Y, 0)   : EndIf
Type = ~Type ; Красно-зеленное.
Next X
If \Level\Width % 2 = 0 : Type = ~Type : EndIf
Next Y
; --Players setup--
If Random ; Если создаем новую карту...
; Создать заданных пользователем игроков.
ReDim \Players.Player(Params\PlayersCount)
\Level\PlayersCount = Params\PlayersCount
UpdatePlayers() ; Правим данные игроков.
Else ; Загрузить данные о игроках из файла.
ToFix = ReadLong(0) ; Кол-во игроков.
ReDim \Players.Player(ToFix)
For I = 1 To ToFix ; Обрабатываем каждого.
ReadData(0, \Players(I), SizeOf(Player))
\Players(I)\BeingsCount = 0
\Players(I)\TotalEnergy = 0
Next I ; Загрузить данные о коммандах...
ToFix = ReadLong(0) ; Количество комманд.
For I = 1 To ToFix ; Обрабатываем каждую.
ReadData(0, \Teams(I), SizeOf(Team))
Next I
EndIf
#CountersInter = 4
; --Настроить счетчики Сущностей--
ToFix = \Level\PlayersCount
X = ImageHeight_(\CountersTitle) + 7
Y = (#ScreenHeight - ((\CountersData\Top + #CountersInter) * ToFix - #CountersInter + X)) / 2
\GUI\CountersTitleYPos = Y : Y + X
\Level\CountersTitleXPos = -\CountersData\Left + #CountersTitleOffset
For I = 1 To ToFix
\Players(I)\Counter = CreateImage_(ImageWidth_(\Counters), ImageHeight_(\Counters), 1)
\Players(I)\CounterPos\Y = Y
\Players(I)\CounterPos\X = -\CountersData\Left
\Players(I)\CounterState = #CPreparing
Y + \CountersData\Top + #CountersInter
Next I
; --Positioning--
; -"Sky"-
XEnd = \Level\Width * #FullGap - #CellGap ; Real map width.
YEnd = \Level\Height * #FullGap - #CellGap ; Real map height.
PositionEntity_(\Sky, XEnd / 2, 0, -YEnd / 2)
PositionEntity_(\Space, XEnd / 2, 0, -YEnd / 2)
; -Beings-
If Random = #False ; Загрузка данных о Сущностях из файла
Define *Ptr, Being.Being, *CreatedBeing.Being
ToFix = ReadLong(0)
For I = 1 To ToFix
ReadData(0, @Being, SizeOf(Being))
*CreatedBeing = CreateBeing(Squares(Being\X, Being\Y), Being\Type, Being\Owner, #False)
*CreatedBeing\EnergyLevel = Being\EnergyLevel
*CreatedBeing\State = Being\State
If *CreatedBeing\Owner:\Players(Being\Owner)\TotalEnergy+Being\EnergyLevel:ScriptCounter(Being\Owner):EndIf
MarkMiniMap(*CreatedBeing)
ScriptTable(*CreatedBeing)
*CreatedBeing\StateFrame = Being\StateFrame
RotateEntity_(*CreatedBeing\Entity, 0, 0, 0)
TurnBeing(*CreatedBeing, Being\EntityYaw)
Next I
; Загрузка данных о квантах из файла (Dummy).
ReadLong(0)
EndIf
If Random ; Настраиваем камеру.
PositionEntity_(\CamPiv, #MapBoundsGap, 0, -#MapBoundsGap)
RotateEntity_(\CamPiv, 0, 45, 0)  ; Iso-view.
SetOn(\Camera, \CamPiv)     ; Ставим в начало.
MoveEntity_(\Camera, 0, 0, -25-#MinCameraDistance) ; Better view.
SetOn(\Selection, Squares(0, 0)\Entity)
\Level\CurrentPlayer = 0
Else : PositionEntity_(\CamPiv, ReadLong(0), 0, ReadLong(0))
RotateEntity_(\CamPiv, 0, ReadLong(0), 0)
MoveEntity_(\Camera, 0, 0, EntityDistance_(\Camera, \CamPiv) - ReadLong(0))
PositionEntity_(\Selection, ReadLong(0), ReadLong(0), ReadLong(0))
; Загрузить данные матрицы из файла.
ForEach \GUI\Matrix() : *Ptr = \GUI\Matrix() ; Корректируем смещения.
PositionEntity_(*Ptr, ReadLong(0), EntityY_(*Ptr), ReadLong(0))       ; Пространство.
RotateEntity_(*Ptr, ReadLong(0), EntityYaw_(*Ptr), EntityRoll_(*Ptr)) ; Углы.
Next
; Загрузка данных о каналах из файла (Dummy).
ReadLong(0)
; Загрузка данных о эффектах перерождения из файла (Dummy).
ReadLong(0)
; Загрузка данных о искрах из файла (Dummy).
ReadLong(0)
ReadLong(0)
CloseFile(0)
EndIf
SetOn(\LightPiv, \Selection)
\GUI\SelectedPlayer = 1
\GUI\InsertionBeing = #BSpectator
\GUI\LockSetChanged = #False
\GUI\Changed = #False
If FName = #NewMap : \GUI\MapFName = ""
Else : \GUI\MapFName = FName
EndIf
AssembleTitle(\GUI\MapFName)
\GUI\PickedSquare = #Null ; ???
; -Update counters-
For I = 1 To \Level\PlayersCount
ScriptCounter(I)
Next I
; -Настроить размытие-
EntityAlpha_(\Blurer, 0.35) : EntityTexture_(\Blurer, \BlurTex)
EntityFX_(\Blurer, 1) : If \Options\BlurFilter : ShowEntity_(\Blurer) : EndIf
; -Немного шума для красоты-
\GUI\Noised = 5
ProcedureReturn #True
EndWith
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro GotoMainPanel() ; Partializer
If ShowResetWarning() = #False : System\GUI\Changed = #False
SetBlitz3DTitle_(#Title, "") : ShowNothing() : LoadMap()
EndIf
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro CopyScreen(Src, Target) ; Pseudo-procedure.
CopyRect__(0, 0, #ScreenWidth, #ScreenHeight, 0, 0, Src, Target)
EndMacro

Macro UpdateBlur() ; Pseudo-procedure.
CopyScreen(BackBuffer_(), TextureBuffer_(System\BlurTex))
EndMacro

Procedure DrawAllTables()
Define *Table.Table
SortStructuredList(System\GUI\TablesOnScreen(), 1, OffsetOf(Table\ZOrder), #PB_Float)
ForEach System\GUI\TablesOnScreen()
*Table = System\GUI\TablesOnScreen()
With *Table
DrawImage_(\Image, \ScreenPos\X, \ScreenPos\Y)
If \RMark 
DrawImage_(System\RMark, \ScreenPos\X, \ScreenPos\Y + 19)
EndIf
EndWith
Next
ClearList(System\GUI\TablesOnScreen())
EndProcedure

Macro InfoHL() ; Pseudo-procedure.
CollapseHL()
If System\GUI\Input = #PB_Key_I
If System\GUI\PickedSquare
If System\GUI\PickedSquare\Being
BeingHL(System\GUI\PickedSquare\Being)
BeingHL(System\GUI\PickedSquare\Being, #True)
EndIf
EndIf
EndIf
EndMacro

Procedure SelectedBeing()
If System\GUI\PickedSquare
ProcedureReturn System\GUI\PickedSquare\Being
EndIf
EndProcedure

Procedure GetNextType(Type)
Select Type
Case #BSpectator, #BJustice : ProcedureReturn #BMeanie
Case #BMeanie, #BHunger : ProcedureReturn #BIdea
Case #BIdea, #BJinx : ProcedureReturn #BSentry
Case #BSentry, #BSentinel : ProcedureReturn #BSociety
Case #BSociety, #BDefiler : ProcedureReturn #BEnigma
Default : ProcedureReturn #BSpectator
EndSelect
EndProcedure

Procedure SelectPlayer(PlayerIdx)
If PlayerIdx <= System\Level\PlayersCount
Define *Being.Being
System\GUI\SelectedPlayer = PlayerIdx
*Being = SelectedBeing()
If *Being
With *Being
If \Owner And PlayerIdx <> \Owner
System\Players(\Owner)\BeingsCount - 1
System\Players(\Owner)\TotalEnergy - \EnergyLEvel
ScriptCounter(\Owner)
\Owner = System\GUI\SelectedPlayer
System\Players(\Owner)\BeingsCount + 1
System\Players(\Owner)\TotalEnergy + \EnergyLEvel
ScriptCounter(\Owner)
If \Owner = 1 And \State = #BBorning : \State = #BPreparing : EndIf
If \Owner <> 1 And \State = #BPreparing : \State = #BBorning : EndIf
ScriptTable(*Being)
MarkMiniMap(*Being)
VizualizeChanges()
EndIf
EndWith
EndIf
EndIf
EndProcedure

Macro TransformationTemplate(Switcher, Infix1, Infix2) ; Partializer.
Define NewType
If Switcher : NewType = Get#Infix1#Type(*Being\Type)
Else : NewType = Get#Infix2#Type(*Being\Type)
EndIf
If NewType <> *Being\Type ; Если Сущность можно реинкарнировать...
ExcludeBeing(*Being)
CreateBeing(*Being\Square, NewType, *Being\Owner)
EndIf
EndMacro

Procedure ReincarnateBeing(*Being.Being, Degradate = #False)
TransformationTemplate(Degradate, Degradated, Reincarnated)
EndProcedure

Procedure AscendBeing(*Being.Being, Descend = #False)
TransformationTemplate(Descend, Descended, Ascended)
EndProcedure
;}
;{ --Input/Output--
Procedure GetInput()
Define Ctrl = KeyDown_(29) | KeyDown_(157)
Define MZSpeed = MouseZSpeed_()
Define MXSpeed = MouseXSpeed_()
System\GUI\Optional = 1
If KeyDown_(200) : ProcedureReturn #PB_Key_Up : EndIf
If KeyDown_(205) : ProcedureReturn #PB_Key_Right : EndIf
If KeyDown_(203) : ProcedureReturn #PB_Key_Left : EndIf
If KeyDown_(208) : ProcedureReturn #PB_Key_Down : EndIf
If KeyDown_(023) : ProcedureReturn #PB_Key_I : EndIf
If MZSpeed > 0 : System\GUI\Optional = MZSpeed : ProcedureReturn #PB_Key_Up : EndIf
If MZSpeed < 0 : System\GUI\Optional = -MZSpeed : ProcedureReturn #PB_Key_Down : EndIf
If MouseDown_(3)
MoveMouse_(System\GUI\MousePos\X, System\GUI\MousePos\Y)
If MXSpeed > 0 : System\GUI\Optional = Round(MXSpeed / 5, 1) : ProcedureReturn #PB_Key_Right : EndIf
If MXSpeed < 0 : System\GUI\Optional = Round(-MXSpeed / 5, 1) : ProcedureReturn #PB_Key_Left : EndIf
EndIf
If MouseHit_(1) : ProcedureReturn #PB_MB_Left : EndIf
If MouseHit_(2) : ProcedureReturn #PB_MB_Right : EndIf
If KeyHit_(001) : ProcedureReturn #PB_Key_Escape : EndIf
If KeyHit_(057) : ProcedureReturn #PB_Key_Space : EndIf
If KeyHit_(020) : ProcedureReturn #PB_Key_T : EndIf
If KeyHit_(030) : ProcedureReturn #PB_Key_A : EndIf
If KeyHit_(048) : ProcedureReturn #PB_Key_B : EndIf
If KeyHit_(002) : ProcedureReturn #PB_Key_1 : EndIf
If KeyHit_(003) : ProcedureReturn #PB_Key_2 : EndIf
If KeyHit_(004) : ProcedureReturn #PB_Key_3 : EndIf
If KeyHit_(005) : ProcedureReturn #PB_Key_4 : EndIf
If KeyHit_(022) : ProcedureReturn #PB_Key_U : EndIf
If KeyHit_(015) : ProcedureReturn #PB_Key_Tab : EndIf
If KeyHit_(034) : ProcedureReturn #PB_Key_G : EndIf
If KeyHit_(033) : ProcedureReturn #PB_Key_F : EndIf
If KeyHit_(049) : ProcedureReturn #PB_Key_N : EndIf
If KeyHit_(199) : ProcedureReturn #PB_Key_Home : EndIf
If KeyHit_(210) : ProcedureReturn #PB_Key_Insert : EndIf
If KeyHit_(078) Or KeyHit_(013) : ProcedureReturn #PB_Key_Add : EndIf
If KeyHit_(074) Or KeyHit_(012) : ProcedureReturn #PB_Key_Subtract : EndIf
If KeyHit_(038) And Ctrl : ProcedureReturn #PB_Key_L : EndIf
If KeyHit_(031) And Ctrl : ProcedureReturn #PB_Key_S : EndIf
If KeyHit_(019) And Ctrl : ProcedureReturn #PB_Key_R : EndIf
If KeyHit_(045) And Ctrl : ProcedureReturn #PB_Key_X : EndIf
If KeyHit_(046) And Ctrl : ProcedureReturn #PB_Key_C : EndIf
If KeyHit_(016) And Ctrl : ProcedureReturn #PB_Key_Q : EndIf
If KeyHit_(025) And Ctrl : ProcedureReturn #PB_Key_P : EndIf
If KeyHit_(018) And Ctrl : ProcedureReturn #PB_Key_E : EndIf
If KeyHit_(024) And Ctrl : ProcedureReturn #PB_Key_O : EndIf
If KeyHit_(050) And Ctrl : ProcedureReturn #PB_Key_M : EndIf
If KeyHit_(011) Or KeyHit_(082) : ProcedureReturn #PB_Key_0 : EndIf
If (KeyHit_(055) Or KeyHit_(9)) And Ctrl : ProcedureReturn #PB_Key_Multiply : EndIf
If (KeyHit_(053) Or KeyHit_(8)) And Ctrl : ProcedureReturn #PB_Key_Slash : EndIf
EndProcedure

Procedure PickSquare(*PickedEntity)
Define *Ptr, *Square
If *PickedEntity <> #Null
*Ptr = EntityID_(*PickedEntity)
If *Ptr <> #Null : *Square = *Ptr : EndIf
EndIf
ProcedureReturn *Square
EndProcedure

Procedure.i MouseScroll()
#ScrollGap = 14
Define Dir.i, *Direction.Word = @Dir
If System\GUI\MousePos\Y >= #ScreenHeight - #ScrollGap - 1 : *Direction\W = #PB_Key_Down
ElseIf System\GUI\MousePos\Y <= #ScrollGap : *Direction\W = #PB_Key_Up : EndIf
*Direction + SizeOf(Word)
If System\GUI\MousePos\X >= #ScreenWidth  - #ScrollGap - 1 : *Direction\W = #PB_Key_Right
ElseIf System\GUI\MousePos\X <= #ScrollGap : *Direction\W = #PB_Key_Left : EndIf
ProcedureReturn Dir
EndProcedure

Procedure ScrollMap(Dir.i)
#ScrollStep = 2
Define X, Z, Edge, *Direction.Word = @Dir
If *Direction\W = #PB_Key_Up   : MoveEntity_(System\CamPiv, 0, 0, #ScrollStep) : EndIf
If *Direction\W = #PB_Key_Down : MoveEntity_(System\CamPiv, 0, 0, -#ScrollStep) : EndIf
*Direction + SizeOf(Word)
If *Direction\W = #PB_Key_Left : MoveEntity_(System\CamPiv, -#ScrollStep, 0, 0) : EndIf
If *Direction\W = #PB_Key_Right : MoveEntity_(System\CamPiv, #ScrollStep, 0, 0) : EndIf
; --Check bounds--
X = EntityX_(System\CamPiv) : Z = EntityZ_(System\CamPiv)
If X < #MapBoundsGap : X = #MapBoundsGap : EndIf
If Z > -#MapBoundsGap : Z = -#MapBoundsGap : EndIf
Edge = System\Level\Width * #FullGap - #MapBoundsGap : If X > Edge : X = Edge : EndIf
Edge = -System\Level\Height * #FullGap + #MapBoundsGap : If Z < Edge : Z = Edge : EndIf
PositionEntity_(System\CamPiv, X, EntityY_(System\CamPiv), Z)
EndProcedure

Macro DrawMiniMap() ; Pseudo-Procedure
#TwistSize = 4
#MMCursorCycle = 11
Define X, Y
If System\Options\DisplayMiniMap
; -Draw border-
Player2Color(System\Level\CurrentPlayer)
Rect_(System\GUI\MiniMapXPos - 1, #MMOffset - 1, System\GUI\MiniMapWidth + 2, System\GUI\MiniMapHeight + 2, #False)
Rect_(System\GUI\MiniMapXPos - #TwistSize, #MMOffset - #TwistSize, #TwistSize, #TwistSize, #False)
Rect_(System\GUI\MiniMapXPos + System\GUI\MiniMapWidth, #MMOffset - #TwistSize, #TwistSize, #TwistSize, #False)
Rect_(System\GUI\MiniMapXPos - #TwistSize, #MMOffset + System\GUI\MiniMapHeight, #TwistSize, #TwistSize, #False)
Rect_(System\GUI\MiniMapXPos + System\GUI\MiniMapWidth, #MMOffset + System\GUI\MiniMapHeight, #TwistSize, #TwistSize, #False)
; -Draw MiniMap-
DrawImage_(System\MiniMap, System\GUI\MiniMapXPos, #MMOffset, 0)
; -Draw selection-
If System\GUI\PickedSquare
System\GUI\MiniMapCursorPos\X = 1 + System\GUI\PickedSquare\ArrayPos\X * #MMCellSize + System\GUI\MiniMapXPos
System\GUI\MiniMapCursorPos\Y = 1 + System\GUI\PickedSquare\ArrayPos\Y * #MMCellSize + #MMOffset
EndIf
If System\GUI\MiniMapCursorBlink < #MMCursorCycle
System\GUI\MiniMapCursorBlink + 1
Else : System\GUI\MiniMapCursorBlink = 0
EndIf
If System\GUI\MiniMapCursorBlink < (#MMCursorCycle + 1) / 2
Color_(130, 130, 130)
Rect_(System\GUI\MiniMapCursorPos\X, System\GUI\MiniMapCursorPos\Y, #MMCellSize, #MMCellSize)
EndIf
EndIf
EndMacro

Procedure CheckMiniMap() ; Доделать.
If System\Options\DisplayMiniMap
Define X, Y : X = System\GUI\MiniMapXPos + 1 : Y = #MMOffset + 1
Define XEnd : XEnd = X + System\GUI\MiniMapWidth - 3
Define YEnd : YEnd = Y + System\GUI\MiniMapHeight - 3
Define *PSquare.Square
With System\GUI\MousePos
If \X >= X And \Y >= Y And \X <= XEnd And \Y <= YEnd
X = (\X - X) / #MMCellSize : Y = (\Y - Y) / #MMCellSize
*PSquare = Squares(X, Y)
If *PSquare\entity = #Null
EndIf
System\GUI\PickedSquare = *PSquare
If System\GUI\Input = #PB_MB_Left
PositionEntity_(System\CamPiv, EntityX_(*PSquare\Entity, 1), 0, EntityZ_(*PSquare\Entity, 1))
System\GUI\Input = #Null
EndIf
EndIf
EndWith
EndIf
EndProcedure

Procedure CheckBeing(*Being.Being)
If *Being
With *Being
If \State <> #BDying : ProcedureReturn #True : EndIf
EndWith
EndIf
EndProcedure

Macro DrawDataBoard()
Define *Being.Being
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Color_(255, 255, 255)
SetFont_(System\DataBoardFont)
Define TypeName.S
Text_(10, 10, "FPS: " + Str(System\GUI\FPS))
Text_(10, 20, "Tri's rendered: " + Str(TrisRendered_()))
Text_(10, 30, "Used player: " + Str(System\GUI\SelectedPlayer))
Text_(10, 40, "InsertionBeing: " + BeingType2Name(System\GUI\InsertionBeing))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If System\GUI\PickedSquare : *Being = System\GUI\PickedSquare\Being ; Если выделена платформа...
If CheckBeing(*Being) ; Если на ней есть Сущность...
; Отображение таблицы.
DrawImage_(*Being\DataBoard, #DataBoardXOffset, System\GUI\DataBoardYPos)
EndIf
EndIf
EndMacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro DrawCounters() ; Partializer.
If System\Options\DisplayCounters
Dim Lineup.Point(#MaxPlayers)
Define ToFix = System\Level\PlayersCount, *Plr.Player
Define Ally, FromY, OldToX, Y, ToX = #LAOffset
For I = 1 To ToFix : *Plr = System\Players(I)
If System\Teams(*Plr\AlliedTeam)\PlayersCount > 1 
TeamIDx2Color(*Plr\AlliedTeam)
Y = *Plr\CounterPos\Y + #VertOffset
If LineUp(*Plr\AlliedTeam)\X = 0
If I => ToFix - 1 : ToX = #LAOffset : EndIf
Line_(#LSOffset, Y - 1, ToX, Y - 1)
Line_(#LSOffset, Y + 1, ToX - #LineFactor, Y + 1)
LineUp(*Plr\AlliedTeam)\Y = ToX ; Запоминаеми
ToX + #CountersOffset           ; Сдвигаем.
Else : OldToX = LineUp(*Plr\AlliedTeam)\Y
FromY = System\Players(LineUp(*Plr\AlliedTeam)\X)\CounterPos\Y + #VertOffset
Line_(OldToX, FromY, OldToX, Y + 1) : Line_(OldToX - #LineFactor, FromY + #LineFactor, OldToX - #LineFactor, Y - 1)
Line_(#LSOffset, Y - 1, OldToX - #LineFactor, Y - 1)
Line_(#LSOffset, Y + 1, OldToX - #LineFactor, Y + 1)
EndIf
LineUp(*Plr\AlliedTeam)\X = I ; В любом случае отмечаем последнее.
EndIf 
; -Draw counter-
DrawImage_(*Plr\Counter, #CountersOffset, *Plr\CounterPos\Y)
Next I
; -Uplinking teams
For I = 1 To ToFix : *Plr = System\Players(I) : Ally = *Plr\AlliedTeam
If Lineup(Ally)\X = I : Y = *Plr\CounterPos\Y + #VertOffset + #LineFactor / 2
TeamIDx2Color(Ally) : ToX = Lineup(Ally)\Y : Line_(Tox-1, Y, Tox, Y)
EndIf
Next I
; -Draw counter's title-
DrawImage_(System\CountersTitle, #CountersOffset + #CountersTitleOffset, System\GUI\CountersTitleYPos)
EndIf
EndMacro

Macro DrawCursor() ; Partializer.
If System\GUI\CurFrame = (#CurFrames * 2 - 1) : System\GUI\CurFrame = 0 : Else : System\GUI\CurFrame + 1 : EndIf
DrawImage_(System\Cursor, System\GUI\MousePos\X, System\GUI\MousePos\Y, (System\GUI\CurFrame >> 1))
EndMacro

Procedure RegisterWindow(*WindowID, Dummy.i) ; Callback
System\GameWindow = *WindowID ; Should be called only once.
EndProcedure

Procedure QuitDialog()
SaveOptions()
If ShowResetWarning() = #False : Quit() : EndIf
HidePointer_()
EndProcedure

Macro CheckExitFlag() ; Partializer
If System\GUI\Exit : QuitDialog() : System\GUI\Exit = #False : EndIf
EndMacro

Macro ShowNothing() ; Partializer.
ClsColor_(0, 0, 0) : Cls_() ; Сразу очищаем экран и показываем:
DrawImage_(System\NothingText, #ScreenWidth / 2, #ScreenHeight / 2 - 200)
DrawImage_(System\VoidEye, #ScreenWidth / 2, #ScreenHeight / 2) 
DrawImage_(System\InsideText, #ScreenWidth / 2, #ScreenHeight / 2  + 200)
Flip_() ; Finally showing nothing.
EndMacro

Macro NoiseGarden() ; Partializer
TileBlock_(System\Noise, Random(#NoiseBlock-1), Random(#NoiseBlock-1), Random(#NoiseFrames-1))
EndMacro
;}
;{ --Paralleling--
Procedure GameCB(*Window, Event.i, lParam.i, wParam.i) ; Callback.
Select Event ; Анализируем событие...
Case #WM_SETFOCUS, #WM_KILLFOCUS : MouseZSpeed_()
Case #WM_CLOSE : System\GUI\Exit = #True : ProcedureReturn ; Выход без обработки.
EndSelect
ProcedureReturn CallWindowProc_(System\OldCallBack, *Window, Event, lParam, wParam.i)
EndProcedure

Procedure ErrorHandler() ; Last resort.
Define Diagnose.s
Select ErrorCode() ; Определяем причину.
Case #PB_OnError_InvalidMemory          : Diagnose = "invalid memory access at $"+Hex(ErrorTargetAddress())+" !"
Case #PB_OnError_Floatingpoint          : Diagnose = "floating point error !"
Case #PB_OnError_Breakpoint             : Diagnose = "unknown debugger's breakpoint reached !"
Case #PB_OnError_IllegalInstruction     : Diagnose = "attempt to execute an illegal instruction !"
Case #PB_OnError_PriviledgedInstruction : Diagnose = "attempt to execute a priviledged instruction !"
Case #PB_OnError_DivideByZero           : Diagnose = "integer division by zero !"
EndSelect : ErrorBox(Diagnose + " It's irreparable." + #CR$ + "Application would now be terminated.")
EndProcedure
;}
;} EndProcedures

;{ MainMacros
Macro Initialization()
Define I, *Texture
; -System init-
While CreateMutex_(0, 0, "=[Flow.Editor]=") = #Null : Delay(100) : Wend ; Идентификатор.
If GetLastError_() : ErrorBox("Flow map editor is already running !" + #CR$ + "Press 'OK' to exit.") : End : EndIf
CompilerIf Not #PB_Compiler_Debugger : OnErrorCall(@ErrorHandler())
CompilerEndIf
Define FixDir.s = GetPathPart(ProgramFilename()) ; На случай cmd и тому подобного.
If FixDir <> GetTemporaryDirectory() : SetCurrentDirectory(FixDir) : EndIf
; -Legacy-
CompilerIf #PB_Compiler_Version => 540
UseCRC32Fingerprint() ; Legacy codec.
UseMD5Fingerprint()   ; Legacy codec.
CompilerEndIf
; -Blitz init-
BeginBlitz3D_() : SetBlitz3DDebugMode_(0)
Graphics3D_(#ScreenWidth, #ScreenHeight, 32, 2)
AssembleTitle()
SetBlitz3DTitle_(#Title, "")
HidePointer_()
SetCurrentDirectory("Media\")
AmbientLight_(100, 100, 100)
System\GameWindow = FindGameWindow()
System\OldCallBack = GetWindowLong_(System\GameWindow, #GWL_WNDPROC)
SetWindowLong_(System\GameWindow, #GWL_WNDPROC, @GameCB())
; --Screen filler--
System\VoidEye = LoadImage__("VoidEye.png") 
System\NothingText = LoadImage__("Nothing.png") 
System\InsideText  = LoadImage__("Inside.png") 
MidHandle_(System\InsideText) : MidHandle_(System\NothingText)
MidHandle_(System\VoidEye)   : setbuffer_(BackBuffer_()) : ShowNothing()
; --Preparing etalones--
; -Platforms-
System\PlatformRed   = LoadMesh_("Platform.B3D")
System\PlatformGreen = CopyMesh_(System\PlatformRed)
System\PlatformGold  = CopyMesh_(System\PlatformRed)
; -Platforms textures preparation-
System\CellRedTex   = LoadTexture_("Red_Cell.JPG")
System\CellGreenTex = LoadTexture_("Green_Cell.JPG")
System\CellGoldTex  = LoadTexture_("Gold_Cell.JPG")
System\PlatformEdgesTex[0] = LoadTexture_("Edge.JPG")
System\PlatformEdgesTex[1] = CloneTexture(System\PlatformEdgesTex[0])
ScaleTexture_(System\PlatformEdgesTex[1], 1, 1 / #TallInfinity)
System\PlatformEdgesTex[2] = LoadTexture_("Gold_Edge.JPG")
System\PlatformEdgesTex[3] = CloneTexture(System\PlatformEdgesTex[2])
ScaleTexture_(System\PlatformEdgesTex[3], 1, 1 / #TallInfinity)
; -Platform texturing-
TextureSurface(System\PlatformGreen, 2, System\CellGreenTex)
TextureSurface(System\PlatformGold,  2, System\CellGoldTex)
TextureSurface(System\PlatformRed,   1, System\PlatformEdgesTex[1])
TextureSurface(System\PlatformGreen, 1, System\PlatformEdgesTex[1])
TextureSurface(System\PlatformGold,  1, System\PlatformEdgesTex[3])
; -Connection tube-
System\TubeTex = LoadTexture_("TubeTex.JPG")
System\ConnectionTube = CreateCylinder_(7, 0)
ScaleMesh_(System\ConnectionTube, #TubeSize, #TubeQuant, #TubeSize)
RotateEntity_(System\ConnectionTube, 0, 0, 90)
EntityTexture_(System\ConnectionTube, System\TubeTex)
HideEntity_(System\ConnectionTube)
; -Elevators-
System\ElevatorRed = CopyMesh_(System\PlatformRed)     : PrepareObstacle(System\ElevatorRed)
System\ElevatorGreen = CopyEntity_(System\ElevatorRed) : HideEntity_(System\ElevatorGreen)
System\ElevatorGold = CopyEntity_(System\ElevatorRed)  : HideEntity_(System\ElevatorGold)
EntityTexture_(System\ElevatorGreen, System\CellGreenTex)
EntityTexture_(System\ElevatorRed, System\CellRedTex)
EntityTexture_(System\ElevatorGold, System\CellGoldTex)
; -Node cubes-
System\NodeCubes = CreatePivot_() ; Изначальное крепление.
For I = 1 To #MatrixDepth : *Texture = CopyEntity_(System\ElevatorRed, System\NodeCubes)
ScaleEntity_(*Texture, 0.5, 0.5, 0.5) : EntityTexture_(*Texture, System\PlatformEdgesTex[0])
TranslateEntity_(*Texture, 0, -#CellSize * I, 0) : Next I : HideEntity_(System\NodeCubes)
System\NodeCubesGold = CopyEntity_(System\NodeCubes) : HideEntity_(System\NodeCubesGold)
ComplexEntityTexture(System\NodeCubesGold, System\PlatformEdgesTex[2]) ; Тоже текстурируем.
; -Relative resizing-
ScaleMesh_(System\PlatformRed, 1, #TallInfinity, 1)   : PrepareObstacle(System\PlatformRed)
ScaleMesh_(System\PlatformGreen, 1, #TallInfinity, 1) : PrepareObstacle(System\PlatformGreen)
ScaleMesh_(System\PlatformGold, 1, #TallInfinity, 1)  : PrepareObstacle(System\PlatformGold)
; -Ignorance setup-
System\Ignorance = LoadMesh_("Ignorance.b3d") : PrepareObstacle(System\Ignorance, #HalfCell)
System\Rotor = LoadMesh_("Rotor.b3d") : HideEntity_(System\Rotor)
; -Matrix tubes-
System\MatrixTex = LoadTexture_("MatrixTex.JPG")
ScaleTexture_(System\MatrixTex, 1, 1 / #TenInfinity)
System\MatrixTube = CopyEntity_(System\ConnectionTube)
ScaleEntity_(System\MatrixTube, 1, #TenInfinity, 1)
EntityTexture_(System\MatrixTube, System\MatrixTex)
HideEntity_(System\MatrixTube)
; -Square-
System\SquareMesh = CreateQuad()
ScaleMesh_(System\SquareMesh, #HalfCell, 0, #HalfCell)
EntityPickMode_(System\SquareMesh, 2, #False)
EntityAlpha_(System\SquareMesh, 0.0)
EntityFX_(System\SquareMesh, 1)
HideEntity_(System\SquareMesh)
; -"Sky"-
System\Sky   = CreateSphere_(14)
System\Space = CopyEntity_(System\Sky)
ScaleEntity_(System\Sky, #Sky, #Sky, #Sky)
ScaleEntity_(System\Space, #Space, #Space, #Space)
System\SkyTex = LoadTexture_("Marble.JPG")
EntityTexture_(System\Sky, System\SkyTex)
ScaleTexture_(System\SkyTex, 0.1, 0.1)
*Texture = LoadTexture_("Nebula.jpg")
EntityTexture_(System\Space, *Texture)
ScaleTexture_(*Texture, 0.1, 0.1)
EntityAlpha_(System\Space, 0.25)
EntityOrder_(System\Space, 10000)
EntityOrder_(System\Sky, 10001)
EntityFX_(System\Space, 1)
FlipMesh_(System\Sky)
; -Light-
System\LightPiv = CreatePivot_()
System\Light = CreateLight_(2, System\LightPiv)
TranslateEntity_(System\Light, 0, #HalfCell, 0)
LightRange_(System\Light, #FullGap)
; -Beings-
System\TreeMesh      = LoadAnimEtalone("Tree.B3D")
System\SpectatorMesh = LoadAnimEtalone("Spectator.B3D")
System\MeanieMesh    = LoadAnimEtalone("Meanie.B3D")
System\IdeaMesh      = LoadAnimEtalone("Idea.B3D")
System\SentryMesh    = LoadAnimEtalone("Sentry.B3D")
System\SocietyMesh   = LoadAnimEtalone("Society.B3D")
System\EnigmaMesh    = LoadAnimEtalone("Enigma.B3D")
System\AmgineMesh    = LoadAnimEtalone("Amgine.B3D")
; -Reinacarnated beings-
System\JusticeMesh  = LoadAnimEtalone("Justice.B3D")
System\SentinelMesh = LoadAnimEtalone("Sentinel.B3D")
System\HungerMesh   = LoadAnimEtalone("Hunger.B3D")
System\JinxMesh     = LoadAnimEtalone("Jinx.B3D")
System\DefilerMesh  = LoadAnimEtalone("Defiler.B3D")
System\AgaveMesh    = LoadAnimEtalone("Agave.B3D")
; -Tools-
System\FrostBiteMesh = LoadAnimEtalone("FrostBite.B3D")
; -Ascendants-
; .Seer.
System\SeerMesh = LoadAnimEtalone("Seer.B3D")
EntityBlend_(FindChildSafe(System\SeerMesh, "SubBody"), 3)
For I = 1 To 4 ; Еще немного альфы.
EntityBlend_(FindChildSafe(System\SeerMesh, "Window" + Str(I)), 3)
Next I
; .Paradigma.
System\ParadigmaMesh  = LoadAnimEtalone("Paradigma.B3D")
ComplexEntityFX(System\ParadigmaMesh, 16)
ComplexEntityBlend(System\ParadigmaMesh, 3)
EntityFX_(FindChildSafe(System\ParadigmaMesh, "Spine"), 1)
; .Desire.
System\DesireMesh = LoadanimEtalone("Desire.B3D")
EntityBlend_(FindChildSafe(System\DesireMesh, "LScrewer_Blend"), 3)
EntityBlend_(FindChildSafe(System\DesireMesh, "UScrewer_Blend"), 3)
EntityBlend_(FindChildSafe(System\DesireMesh, "Hatchery_Blend"), 3)
EntityBlend_(FindChildSafe(System\DesireMesh, "WatchGlass"), 3)
For I = 1 To #VicHolez
EntityBlend_(FindChildSafe(System\DesireMesh, "PressRing" + RSet(Str(I), 2, "0")), 3)
Next I
For I = 1 To 12
EntityAlpha_(FindChildSafe(System\DesireMesh, "CoreGlass" + RSet(Str(I), 2, "0")), 0)
EntityAlpha_(FindChildSafe(System\DesireMesh, "ProtoCore" + RSet(Str(I), 2, "0")), 0)
Next I
; --Setup camera--
System\CamPiv = CreatePivot_()
System\Camera = CreateCamera_(System\CamPiv)
TurnEntity_(System\Camera, 50, 0, 0)
CameraRange_(System\Camera, 1, 1500)
; --Preparing GUI--
System\Cursor = LoadAnimImage_("Cursor.PNG", 32, 32, 0, #CurFrames)
MaskImage_(System\Cursor, 5, 7, 6)
System\MiniMap = CreateImage_(1, 1, 1)
System\RMark = LoadImage__("RMark.PNG")
MidHandle_(System\RMark)
System\Mixer = CreateImage_(1, 1, 1)
System\CountersTitle = LoadImage__("CountersTitle.PNG")
System\DataBoard = LoadImage__("DataBoard.PNG")
System\AscendantBoard = LoadImage__("AscendantBoard.PNG")
System\Counters = LoadAnimImage_("Counters.PNG", #CounterWidth, #CounterHeight, 0, #MaxPlayers)
System\CountersData\Left = ImageWidth_(System\Counters)
System\CountersData\Top = ImageHeight_(System\Counters)
System\CountersData\Right = (System\CountersData\Left - 26 - 5) / 2 + 5
System\CountersData\Bottom = (System\CountersData\Top - 4) / 2
; -Selection-
System\Selection = LoadAnimMesh_("Selection.B3D")
Animate_(System\Selection, 1)
; --Prepare fonts--
System\TableFont = LoadFont_("Courier")
System\DataBoardFont = LoadFont_("Lucida Console", 10)
System\PPFont = LoadFont_("FixedSys", 10)
System\CountersFont = LoadFont_("Tahoma", 13)
; --Eye candy--
System\Noise = LoadAnimImage_("noise.jpg", #NoiseBlock, #NoiseBlock, 0, #NoiseFrames)
System\BlurTex = ScreenTexture(256) : System\Blurer = ScreenSprite(1, -10000) ; Blur.
; --Synchronizer--
System\SyncTimer = CreateTimer_(#MaxFPS)
; --Options--
If OpenOptionsFile() = #False ; Если не удалось загрузить настроек...
System\Options\DisplayMiniMap     = #True
System\Options\DisplayTables      = #True
System\Options\DisplayCounters    = #True
System\Options\SelectBeingByModel = #False
System\Options\BlurFilter         = #True
System\Options\ResetWarning       = #True
SaveOptions()
Else ; Загружаем настройки.
ReadData(0, @System\Options, SizeOf(OptionsData))
CloseFile(0)
EndIf
; --Just a little optimization-
Dim System\Teams.Team(#MaxPlayers)
; --Select "Maps" directory--
SetCurrentDirectory("..\Maps")
EndMacro

Macro RegisterInput()
System\GUI\Input = GetInput()
System\GUI\MousePos\X = MouseX_()
System\GUI\MousePos\Y = MouseY_()
System\GUI\FPS = CountFPS()
EndMacro

Macro CameraControl()
Define Amount, Dist : Amount = System\GUI\Optional
ScrollMap(MouseScroll())
Select System\GUI\Input
Case #PB_Key_Left : TurnEntity_(System\CamPiv, 0, Amount, 0)
Case #PB_Key_Right : TurnEntity_(System\CamPiv, 0, -Amount, 0)
Case #PB_Key_Up
Dist = EntityDistance_(System\CamPiv, System\Camera) - Amount
If Dist < #MinCameraDistance : Amount - (#MinCameraDistance - Dist) : EndIf
If Amount > 0 : MoveEntity_(System\Camera, 0, 0, Amount) : EndIf
Case #PB_Key_Down
Dist = EntityDistance_(System\CamPiv, System\Camera) + Amount
If Dist > #MaxCameraDistance : Amount - (Dist - #MaxCameraDistance) : EndIf
If Amount > 0 : MoveEntity_(System\Camera, 0, 0, -Amount) : EndIf
EndSelect
; -Picking-
System\GUI\PickedEntity = CameraPick_(System\Camera, System\GUI\MousePos\X, System\GUI\MousePos\Y)
System\GUI\PickedSquare = PickSquare(System\GUI\PickedEntity)
EndMacro

Macro BringEditor(Var, Flag = #False) ; Partializer.
ShowPointer_() : Test = Var : Var = ESRequester(Var, #Null, Flag)
If Var <> Test : VizualizeChanges() : EndIf : HidePointer_()
EndMacro

Macro EditorControl()
CheckMiniMap()
Define FName.S, Test.S, *Being.Being, *PSquare.Square = System\GUI\PickedSquare
Select System\GUI\Input
Case #PB_MB_Left ; Изменить сущность на платформе.
If *PSquare <> #Null
Define Type = #BSpectator
*Being = *PSquare\Being
If *Being <> #Null : Type = GetNextType(*Being\Type) : ExcludeBeing(*Being) : EndIf
CreateBeing(*PSquare, Type, System\GUI\SelectedPlayer)
EndIf
Case #PB_MB_Right ; Удалить Сущность на платформе.
*Being = SelectedBeing() : If *Being : RemoveBeing(*Being) : VizualizeChanges() : EndIf
Case #PB_Key_Space ; Изменить высоту платформы.
If *PSquare <> #Null
Define Height : Height = *PSquare\Height
Define *AP.Point : *AP = *PSquare\ArrayPos
If Height = #MaxPlatformsScale : Height = 1 : Else : Height + 1 : EndIf
ReScalePlatform(*AP\X, *AP\Y, Height) : VizualizeChanges()
EndIf
Case #PB_Key_Add ; Увеличить энергетический потенциал Сущности.
*Being = SelectedBeing()
If SelectedBeing() : VizualizeChanges()
*Being\EnergyLevel + 1 : ScriptTable(*Being)
If *Being\Owner : System\Players(*Being\Owner)\TotalEnergy + 1 
ScriptCounter(*Being\Owner)
EndIf
EndIf
Case #PB_Key_Subtract ; Уменьшить энергетический потенциал Сущности.
*Being = SelectedBeing()
If *Being
If *Being\EnergyLevel > 1 : *Being\EnergyLevel - 1 : ScriptTable(*Being)
If *Being\Owner : System\Players(*Being\Owner)\TotalEnergy - 1 
ScriptCounter(*Being\Owner)
EndIf
VizualizeChanges()
EndIf
EndIf
Case #PB_Key_T ; Поставить на платформу дерево.
If *PSquare <> #Null : *Being = SelectedBeing()
If *Being <> #Null : ExcludeBeing(*Being) : EndIf
CreateBeing(*PSquare, #BTree, 0)
EndIf
Case #PB_Key_A ; Поставить на платформу Agave.
If *PSquare <> #Null And Not Ignoring(*PSquare)
*Being = SelectedBeing()
If *Being <> #Null : ExcludeBeing(*Being) : EndIf
CreateBeing(*PSquare, #BAgave, 0)
EndIf
Case #PB_Key_0 ; Поставить на платформу FrostBite.
If *PSquare <> #Null : *Being = SelectedBeing()
If *Being <> #Null : ExcludeBeing(*Being) : EndIf
CreateBeing(*PSquare, #BFrostBite, 0)
EndIf
Case #PB_Key_1 : SelectPlayer(1)
Case #PB_Key_2 : SelectPlayer(2)
Case #PB_Key_3 : SelectPlayer(3)
Case #PB_Key_4 : SelectPlayer(4)
Case #PB_Key_L : ShowPointer_() : LoadMapRequester() : HidePointer_()
Case #PB_Key_S : SaveMapRequester()
Case #PB_Key_B : BringEditor(System\Story)
Case #PB_Key_P : BringEditor(System\AfterStory, #True)
Case #PB_Key_Multiply : ShowPointer_() : Test = System\LockCode
System\LockCode = CodeRequester(System\LockCode) : HidePointer_()
If Test <> System\LockCode : VizualizeChanges() : EndIf
Case #PB_Key_Slash : ShowPointer_() : Test = System\PlayCode
System\PlayCode = CodeRequester(System\PlayCode, #PlayCode) : HidePointer_()
If Test <> System\PlayCode : VizualizeChanges() : EndIf
Case #PB_Key_X : ShowPointer_() : Test = System\Level\NextMapFName
System\Level\NextMapFName = ChainMapRequester(System\Level\NextMapFName)
If Test <> System\Level\NextMapFName : VizualizeChanges() : EndIf
HidePointer_()
Case #PB_Key_Q
Define Params.MapParams : ShowPointer_()
If MGRequester(Params, System\Options, #True) = #True
Define I : UpdatePlayers() : ConsumeParams()
ForEach System\Beings() : ScriptTable(System\Beings()) : Next
VizualizeChanges() ; Визуализация изменений.
EndIf : PerformOptions() : HidePointer_()
Case #PB_Key_R
If System\GUI\MapFName <> "" ; Если есть куда сохранять...
If SaveMap(System\GUI\MapFName) : System\GUI\Changed = #False 
AssembleTitle(System\GUI\MapFName, System\GUI\Changed) : EndIf
HidePointer_() ; На всякий случай скрываем курсор.
EndIf
Case #PB_Key_U ; Reincarnation.
*Being = SelectedBeing()
If *Being <> #Null And (IsEnigmatic(*Being) Or Not Ignoring(*Being\Square))
If *Being\Reincarnated : ReincarnateBeing(*Being, #True) : Else : ReincarnateBeing(*Being) : EndIf
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Case #PB_Key_Tab ; Ascension.
*Being = SelectedBeing()
If *Being <> #Null And (Ignoring(*Being\Square) Or *Being\Square\Gold = #False)
If *Being\Ascended : AscendBeing(*Being, #True) : Else : AscendBeing(*Being) : EndIf
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Case #PB_Key_G
If *PSquare ; Если что-то подсвечено...
If *PSquare\CellType = #pIgnorance
Define NewGold = (*PSquare\Gold + 1) % 4 ; Поворот на месте.
Else : NewGold = LogNot(*PSquare\Gold) : EndIf
ChangePlatform(*PSquare\ArrayPos\X, *PSquare\ArrayPos\Y, NewGold)
VizualizeChanges()
EndIf
Case #PB_Key_F
If *PSquare
RestructureCell(*PSquare\ArrayPos\X, *PSquare\ArrayPos\Y, Invert(*PSquare\CellType, #pElevator))
VizualizeChanges()
EndIf
Case #PB_Key_N
If *PSquare
RestructureCell(*PSquare\ArrayPos\X, *PSquare\ArrayPos\Y, Invert(*PSquare\CellType, #pIgnorance))
If *PSquare\Being : ScriptDataBoard(*PSquare\Being) : EndIf ; Отражаем.
VizualizeChanges()
EndIf
Case #PB_Key_Home
*Being = SelectedBeing()
If *Being : System\GUI\InsertionBeing = *Being\Type : EndIf
Case #PB_Key_Insert
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If *PSquare <> #Null And Not (Ignoring(*PSquare) And IsReincarnated(System\GUI\InsertionBeing))
If Or Ignoring(*PSquare) Or *PSquare\Gold = #False Or Not IsAscended(System\GUI\InsertionBeing) 
*Being = *PSquare\Being : If *Being : ExcludeBeing(*Being) : EndIf
If System\GUI\InsertionBeing = #BTree Or System\GUI\InsertionBeing = #BAgave : *Being = 0
Else : *Being = System\GUI\SelectedPlayer : EndIf ; Выставляем будущего хозяина.
CreateBeing(*PSquare, System\GUI\InsertionBeing, *Being) : EndIf : EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Case #PB_Key_O
ShowPointer_()
OptionsRequester(System\Options)
HidePointer_()
PerformOptions()
EndSelect
InfoHL()
EndMacro

Macro AnimateWorld()
UpdateWorld_()
; -Update Selection & Light.
If System\GUI\PickedSquare <> #Null 
SetOn(System\Selection, System\GUI\PickedSquare\Entity)
SetOn(System\LightPiv, System\GUI\PickedSquare\Entity)
EndIf
; -Update feeder-
If System\GUI\SinFeeder = 180 : System\GUI\SinFeeder = 0
Else : System\GUI\SinFeeder + 1 : EndIf
; -Update "Sky"-
TurnEntity_(System\Sky, 0, 0.1, 0)
TurnEntity_(System\Space, 0, -0.3, 0)
EntityAlpha_(System\Space, 0.15 + 0.15 * Sin(Radian(System\GUI\SinFeeder)))
; -Update beings-
ForEach System\Beings() : Define *Being.Being = System\Beings()
If *Being\State = #BDestroyed : DestroyBeing()
Else : RegisterTable(*Being)
EndIf
Next
EndMacro

Macro Vizualization()
SetBuffer_(BackBuffer_())
If System\GUI\Noised = 0
RenderWorld_()
DrawAllTables()
DrawDataBoard()
DrawMiniMap()
DrawCounters()
DrawCursor()
Else : NoiseGarden() : System\GUI\Noised - 1 : EndIf
UpdateBlur()
Flip_()
EndMacro

Macro SystemControls()
Select System\GUI\Input
Case #PB_Key_Escape : GotoMainPanel() ; Возврат на панель созданий карты.
Case #PB_Key_M : System\Options\DisplayMiniMap  = LogNot(System\Options\DisplayMiniMap)
Case #PB_Key_E : System\Options\DisplayTables   = LogNot(System\Options\DisplayTables)
Case #PB_Key_C : System\Options\DisplayCounters = LogNot(System\Options\DisplayCounters)
EndSelect
; -Additional controls-
CheckExitFlag()
EndMacro
;} EndMainMacros
; ==Main Code==
Initialization()
LoadMap() : Repeat 
RegisterInput()
CameraControl()
EditorControl()
AnimateWorld()
Vizualization()
SystemControls()
WaitTimer_(System\SyncTimer)
; ^Задержка, если скорость программы слишком большая.^
ForEver
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; Folding = h+--v--------4-+
; UseIcon = ..\Media\Blank_Eye.ico
; Executable = ..\Map editor.exe
; DisableDebugger
; CurrentDirectory = ..\