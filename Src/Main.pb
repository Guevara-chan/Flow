; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; 'Flow: God is dead' v0.48 (Alpha)
; Developed in 2009 by Guevara-chan.
; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

;{ TODO[
; Improve FPS. Особенно у частиц.
; Повысить разрешение до 1024x768.
; Доделать экстраверсальную анимацию Desire.
; Доделать анимацию смораживания FrostBite'ов.
; Улучшить визуализацию прицела.
; Проверить вылет при перерождении.
; Улучшить визуализацию Аскендантов.
; Добавить возможность отмены действий.
; Улучшить поддержку Обелисков Безразличия.
; Добавить поддержку тегов разметки в брифинги.
; Подумать о сохранениии параметров генерации карт.
; Добавить уникальные эффекты при атаке персональных врагов.
; Поправить зависания при работе с XP/Win7 (помогает совместимость с 9X).
; Сделать визуальное отображение числа открытых каналов.
; Подумать о условиях, при которых AI дожен перерождать Enigma.
; Уменьшить анимационный лаг до смены настроения после переноса.
; Исправить порядок, в котором происходит визуализация отложенного удара по переносимой цели.
; ...Добавить еще Аскендантов.
; ...Начать делать карты для кампании.
; ...Добавить Panoptikum и заставку для него.
; ...Подумать о графическом эффекте для открытия канала.
; ...Добавить минимальную синхронизацию с музыкой.
; ...Подумать о поддержке gamepad'а.
; ...Подумать о сетевом режиме.
; ...Сделать AutoUpdater.
; ...Добавить музыки.
; ...Improve AI.
;} ]TODO

; SDK Bugs[
; CopyPixel(Fast) - не копируют значение альфы.
; 1.01 отправляет на рендер лишние полигоны.
; 1.05 не сортирует прозрачные поверхности.
; ]SDK Bugs

; --Preparations--
EnableExplicit
XIncludeFile "Beingary (shared).PBI" ; Reference.
IncludeFile "B3D.PB"     ; B3D SDK Definitions.
IncludeFile "MG.PB"      ; Map generator.
IncludeFile "Options.PB" ; Options interface.
IncludeFile "FModEX.PB"  ; FMod EX Definitions
Prototype FontLoader(FileName.s, Flag, Dummy)

;{ Definitions
;{ --Enumerations--
Enumeration ; Square states.
#SNone
#SAbsorbtion
#SSpawning
#SAbsAndSpawn
#SActiveBeing
#SRecarn
#SSwitch
EndEnumeration

Enumeration ; Being states
#BPreparing
#BBorning
#BActive
#BInActive
#BDying
#BRecarn
#BRecarnPreparing
EndEnumeration

Enumeration ; ITypes
#IHuman
#INormalAI
#IKamikazeAI
#IGuardianAI
EndEnumeration

Enumeration ; Buttons
#BtnEndTurn
#BtnSearchActive
#LastButton = #PB_Compiler_EnumerationValue - 1
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
#PElevator    ; Менящие высоту блоку.
#PIgnorance   ; Reincarnates not welcome !
#PObservatory ; Отсюда начинается Вознесение.
EndEnumeration
;}
;{ --Constants--
#ScreenWidth = 800
#ScreenHeight = 600
#ScreenDepth = 32
#CellSize = 20.0
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
#QuantFinalHeight = #CellSize * 2
#EyePointHeight = #HalfCell * 1.5
#MapHeader = "*Flow v0.45 Save*"
#SavesDir = "Saves\"
#AutoSave = #SavesDir + "AutoSave.MAP "
#TableWidth = 30
#TableHeight = 10
#HTWidth = #TableWidth / 2
#HTHeight = #TableHeight / 2
#AttentionWidth = #TableWidth + 4
#AttentionHeight = #TableHeight + 4
#MMOffset = 15
#MMCellSize = 5
#ETButtonOffset = 15
#PrettyFPS = 20
#MenuFPS = 50
#GameFPS = 30
#WaitFinish = #GameFPS * 3
#AmbientLight = 100
#CursorLight = 255
#ChannelsFlow = 3
#MaxChannels = 6
#DefMaxChannels = 18 * 3
#EpidemiaStart = 6
#DataBoardXOffset = 10
#DataBoardYOffset = 10
#SecondDataBoardXOffset = 30
#CountersOffset = 10
#CountersTitleOffset = 2
#ASMaxBrightness = 180
#ASMinBrightness = 50
#CfgSaveFile = "..\Options.CFG"
#CfgFileHeader = "-=Flow Options=-"
#TrackPtrSize = 4
#SparksAlpha = 0.5
#SparkFlightStart = 150
#SparkFlightEnd = #HalfCell
#SparksFadingEdge = #CellSize * 3
#SparkSpeed = -4
#SparksSpawningDelay = 4
#NoiseSize = 3
#NoiseBlock = 200
#NoiseFrames = 10
#TallInfinity = 200
#TubeQuant = #CellGap / 2 + 4
#CurFrames = 10
#NoColor = 256
#MaxFlash = 20
#MaxBlink = #MaxFlash
#HalfBlink = #MaxBlink / 2
#ServiceFrames = #GameFPS
#BrightColor = #NoColor * 3.5
#TenInfinity = #TallInfinity * 10
#ElevationStep = #CellSize / #ServiceFrames
#InfiniteCell = #HalfCell * #TallInfinity
#FlashDiff = #BrightColor - #NoColor
#HalfService = #ServiceFrames / 2
#HalfFlash = #MaxFlash / 2
#TubeSize = #CellSize / 6
#CounterWidth = 110
#CounterHeight = 25
#Sky = 1000
#Space = #Sky - 10
#TSpeed = 4
#SquareLuft = 0.05
#MatrixDepth = 3
#VortexSpeed = 15
#Ignoring = -0.06
#MaxFeeder = 180
#HalfFeeder = #MaxFeeder / 2
#NearScreen = 1.33 ; Needs tuning.
#MeanFreeze = 2
#TableMax = 9999
#RomanCount = 12
#MaxPlayers = 4
#MomentumQuant = 4
#MomentShift = 1
#MaxMomentum = 12
#Mirror = #MaxMomentum - 1
#CryoTime = #GameFPS / 2
#OutRing = #HalfCell * 1.25 
#InRing = #HalfCell * 1.24
#SanitySize = 512
#RingHeight = 1.3
#VisionLuft = 4.5
#Visions = 8
#HighVision = 255
#LowVision = 120
#MaxSanity = 30
#InfPoint = 3
#HalfInf = #InfPoint / 2
#HalfInf2 = #InfPoint / 2 + 1
#InfCacheHeight = #TableHeight + #HalfInf2 * 2
#LadderTime = 30
#BlowTime = 20
#CrestShine = 40
#FlectorDance = #CrestShine
#WinOut = 7
#Security = "[Security system]"
#UnlockMsg = "Input code to unlock this map (ESC\empty to abort):"
#CounterSpeed = 4 
#CounterDelta = 12
#ActiveCounterOffset = #CountersOffset + #CounterDelta
#LSOffset = #CountersOffset * 2 + #CounterDelta / 2
#LAOffset = #LSOffset + #CounterWidth 
#VertOffset = #CounterHeight / 2 - 2
#LineFactor = 2
#FlectorSize = 5
#GlimLight = 0.2
#ReincFamily = 5
#Everything = 999
#WhiteFF  = $FFFFFFFF
#CyanFF   = $FFFFFF00
#YellowFF = $FF00FFFF
#PurpleFF = $FFFF00FF
#ShardWiden = #CellSize * 1.1
#HalfWiden = #ShardWiden / 2
#ExpressSize = 22
#FullExpress = 3 * #ExpressSize
#ShardTime = 40
#ShardFade = 15
#ShardIntro = 5
#StoreCells = 10
#NoLink       = -1
#ConnRect     = 3
#TitleWidth   = 17
#TitleHeight  = 13
#RectHeight   = #TitleHeight - 1
#RectWidth    = #TitleWidth - #ConnRect * 2
#AttentionFix = #ConnRect + 3
#DataBoardTipOffset = 17
#MaxCores   = 12
#DesireWide = 4
#VicHolez   = 26
#ShiverMove = 2
#ShiverSize = 2.5
#BiteGas    = 800
#GameTitle  = "[Flow]"
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
ChannelsExamination.i
ServiceTime.i
Reserved.i[13]
EndStructure

Structure Button ; For GUI
*Image
Rect.Rect
Display.i
State.i
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
Infection.u
NeedsTableUpdate.u
*DataBoard
; -Ascendance-
Ascended.i
ExtraMode.I
Hatred.i
SwapAR.i
SwapAC.I
SwapSR.I
SwapSC.I
SwapPost.i
; -Pseudo-cache-
StoreLink.I   ; Actually.
SynthCores.i  ; Actually.
InfChannels.i ; Actually.
; -Special effects-
*CryoTex
*ShockTex
*Vision
*Shield
*Shocker
*SpecialPart
*SpecialPart2
*SpecialPart3
*SpecialPart4
*SpecialPart5
*SpecialTex
*SpecialTex2
*SpecialTex3
*SpecialTex4
*OnceAnim
; -Effects math-
Alpha.f
AnimEdge.f
SwapEdge.f
Transition.f
Temporary.f
Interstate.u
Transfert.u
Special.f
GonnaRide.u
; -Frame counters-
Flash.u
Sanity.u
Momentum.u
ShieldBlink.u
ShockerBlink.u
SeqFrame.f
; -Special fields-
SuicidalStop.u ; For AI
; -Special states-
LockDown.u
BlowPos.Point
Power.Point
*DelayedBlow.Square
Reserved.i[15]
EndStructure

Structure Square;Crown :)
*Entity
ArrayPos.Point
Height.i ; For saves.
Gold.i   ; For saves
*Being.Being
State.i
DangerLevel.i              ; For AI
DangerLevel4Reincarnates.i ; For AI
InstantAbsorbers.i         ; For AI
*TubesPiv
CellType.i
OwnData.i
AdvInstantAbsorbers.i ; For AI
Frozers.u
AdvFrozers.u
Biters.u
*DelayedBlow.Being
; -Cached-
*Vortex
*FVortex
*Projection
*Projection2
*Tube : *TPiv
iKills.u[#ReincFamily]
Reserved.i[15]
EndStructure

Structure Quant
*Entity
*Source.Square
*Destination.Square
Frame.i
ToDestination.i
Height.i             ; For saves.
X.i                  ; For saves.
Z.i                  ; For saves.
SourcePos.Point      ; For saves.
DestinationPos.Point ; For saves.
Reserved.i[10]
EndStructure

Structure Shiver
*Entity
Frame.i
Latency.i
Angle.i
Speeder.f
Invertor.f
X.i          ; For saves.
Y.i          ; For saves.
Z.i          ; For saves.
ScaleMod.f   ; For saves.
Bright.i     ; For saves.
XAngle.i     ; For saves.
YAngle.i     ; For saves.
ZAngle.i     ; For saves.
Parent.Point ; For saves.
Parented.i   ; For saves.
EndStructure

Structure Table
ScreenPos.POINT
ZOrder.F
*Image
RMark.i
Attention.i
Momentum.i
Mirror.i
InfPoints.i
StoreRem.i
EndStructure

Structure ReincEffect
*TubeEntity
TubeCollapsing.i
TubeFrame.F
Position.Point ; For saves.
Fake.i
Reserved.i[9]
EndStructure

Structure Spark
*Entity
Alt.i
X.i ; For saves.
Y.F ; For saves.
Z.i ; For saves.
EndStructure

Structure Ladder
*Entity
Frame.i 
Polarity.i
X.i     ; For saves.
Y.i     ; For saves.
Size.f  ; For saves.
Angle.f ; For saves.
EndStructure

Structure Crest
*Entity
Frame.i
X.i     ; For saves.
Y.i     ; For saves.
Type.i  ; For saves.
Angle.i ; For saves.
EndStructure

Structure Flector
*Entity
Frame.i
Type.i          ; For saves.
ArrayPos.Point  ; For saves.
X.i : Y.i : Z.i ; For saves.
XAngle.i        ; For saves.
YAngle.i        ; For saves.
ZAngle.i        ; For saves.
EndStructure

Structure DBlow
*Square.Square
ArrayPos.Point
Frame.i
EndStructure

Structure Shard
*Entity : Frame.i
*Layer1 : *Layer2
Latency.i : Speeder.f
FadeEdge.i : MaxFrame.i
X.i : Y.i : Z.i ; For saves.
Color.i         ; For saves.
XAngle.i        ; For saves.
YAngle.i        ; For saves.
ZAngle.i        ; For saves.
XFactor.i       ; For saves.
YFactor.i       ; For saves.
ZFactor.i       ; For saves.
XDir.i          ; For saves.
YDir.i          ; For saves.
ZDir.i          ; For saves.
Parent.Point    ; For saves.
Parented.i      ; For saves.
EndStructure

Structure Expresso
Compressed.u : *In : *Out
ColorMode.u  : Frame.i  
*RedTex : *BlueTex : *GreenTex
*TBeing.Being : *DBeing.Being
X.I : Y.I : Z.I    ; For saves.
X2.I : Y2.I : Z2.I ; For saves.
SourcePos.Point    ; For saves.
DestPos.Point      ; For saves.
EndStructure

Structure GUIData
Exit.i
Input.i
MousePos.Point
Optional.i
Control.i
FPS.i
*PickedEntity
*PickedSquare.Square
*SelectedBeing.Being
Ghost.Being
MiniMapXPos.i
MiniMapWidth.i
MiniMapHeight.i
MiniMapCursorPos.Point
MiniMapCursorBlink.i
DataBoardYPos.i
DataBoardXCenter.i
DataBoardTip.Point
CountersTitleYPos.i
*ActiveBeingPos
ASFlashing.i
TCBlink.i
MapWidth.i
MapHeight.i
SparksRainFactor.F
SparksRainTimer.i
LevelResourcesAllocated.i
SinFeeder.i
Noised.i
WaitVideo.i
CurFrame.i
SinCache.d
DoubleCache.d
LightCache.i
LightCache2.i
Targeting.i
SwitchAngle.i
SelectInfo.i
; -Complex data-
List *Rotors()
List *Matrix()
List *HLSquares()
List Quants.Quant()
List Sparks.Spark()
List Shivers.Shiver()
List Ladders.Ladder()
List Shards.Shard()
List Crests.Crest()
List Flectors.Flector()
List BlownSquares.DBlow()
List TablesOnScreen.Table()
List *BeingsToUpdate.Being()
List ReincEffects.ReincEffect()
Map JacobsMatrix.Point()
EndStructure

Structure Player
IType.i
BeingsCount.i
MovedBeings.i ; For AI
*FirstBeing   ; For AI
Rush.i        ; For AI
TotalEnergy.i
*Counter
CounterState.i
CounterPos.POINT
AlliedTeam.i
*Store.Being[#StoreCells]
Reserved.i[11]
EndStructure

Structure Channel
*Source.Being
*Destination.Being
SourcePos.Point      ; For saves.
DestinationPos.Point ; For saves.
Advanced.i
Reserved.i[9]
EndStructure

Structure ARGB ; Colors
;A.a : R.a : G.a : B.b
B.a : G.A : R.a : A.a
EndStructure

Structure RomanNumeral ; Caching.
Symbol.s : Value.i
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
*Void
*SquareMesh
*QuantMesh
*SparkMesh
*ShiverMesh
*VisionMesh
*LadderMesh
*FlectorMesh
*Projection
*ExpressCrest
*ShardMesh
*ExpressMesh
*SwitchSymbol
*CrestMesh
*AltSparkMesh
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
; -Shields-
*EnigmaShield
*AmgineShield
*AgaveShield
*JusticeShield
*HungerShield
*JinxShield
*SentinelShield
*DefilerShield
; -Crests-
*SpectatorCrest
*MeanieCrest
*IdeaCrest   
*SentryCrest
*SocietyCrest
*EnigmaCrest
*JusticeCrest
*HungerCrest
*JinxCrest 
*DefilerCrest
*AmgineCrest
*ParadigmaCrest
; -Flectors-
*CompressFlector
*SeerFlector
*ParadigmaFlector
*DesireFlector
; -Textures & Brushes-
*SkyTex
*PlatformEdgesTex[4]
*ReincarnationTubeTex
*TubeTex
*FakeReincarnationTubeTex
*MatrixTex
*CryoTex
*CaosTex
*RedTex
*GreenTex
*BlueTex
*WhiteTex
*ShockTex
*BlankTex
*BlurTex
*NoiseBuffer
*CellRedTex
*CellGreenTex
*CellGoldTex
*SanityTex
*PlasmaTex
; -GUI objects-
*Cursor
*NotifyCursor
*Selection
*MiniMap
*LoadingText
*WinText
*LoseText
*TimeOutText
*AIWinText
*PressSpace
*RMark
*DataBoard
*AscendantBoard
*CountersTitle
*Counters
*GoneCounters
*GameWindow
*OldCallBack
*VoidEye
*NothingText
*InsideText
*Noise
*Blurer
*Fader
*Target
*SubTarget
*FrostCross
*SubCrosses[#DesireWide]
*GrandCross
*Attention
*Momentum
*InfCache
*StoreCache
*Mixer
*ParaSpine
*SharedHatch
*IChoosen
*ILinked
*IAbsent
*IDepraved
*INeeded
*IOther
; -Buttons-
Buttons.Button[#LastButton + 1]
; -Main menu-
*MBackGroundTex
*MTextLogo
*MSubLogo
*MPanoptikum
*MRandomMap
*MLoadMap
*MOptions
*MExit
*MenuTimer
*MSignature
; -One-piece data-
*CamPiv
*Camera
*Sky
*Space
*LightPiv
*Light
*GameTimer
CountersData.RECT
DataBoardSize.Point
; -Fonts-
*TableFont
*DataBoardFont
*PPFont
*CountersFont
*WinFont
*TactsCounterFont ; Bitmap font
; -Threads-
*SSThread 
*VideoMutex
*MBThread
MaxFPS.i
; -Music-
*FModSystem
*Tracks
FoundTracks.i
CurrentTrack.i
*CurrentChannel
; -Cache-
HardCore.f
*StackAnchor
; -Strings-
Story.S : AfterStory.S : Hinter.s
; -Containers-
Level.LevelData
Options.OptionsData
GUI.GUIData
; -Arrays & lists-
Array refRoman.RomanNumeral(#RomanCount)
Array Players.Player(0)
Array Teams.Team(0)
List *Elevators.Square()
List Channels.Channel()
List Beings.Being()
List Rides.Expresso()
; -Additional API-
FontLoader.FontLoader
EndStructure
;}
;{ --Variables--
Global Dim Squares.Square(#MaxMapWidth - 1, #MaxMapWidth - 1)
Global System.SystemData
;}
;} EndDefinition

;{ Procedures
;{ --Math&Logic--
Procedure Rnd(Max)
ProcedureReturn Random(Max - 1) + 1
EndProcedure

Procedure InInterval(Val, Min, Max)
If Val >= Min And Val <= MAx : ProcedureReturn #True : EndIf
EndProcedure

Procedure Min(A, B)
If A < B : ProcedureReturn A : Else : ProcedureReturn B : EndIf
EndProcedure

Procedure Max(A, B)
If A > B : ProcedureReturn A : Else : ProcedureReturn B : EndIf
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

Macro TakeX(Entity) ; Pseudo-procedure.
EntityX_(Entity, 1)
EndMacro

Macro TakeY(Entity) ; Pseudo-procedure.
EntityY_(Entity, 1)
EndMacro

Macro TakeZ(Entity) ; Pseudo-procedure.
EntityZ_(Entity, 1)
EndMacro

Procedure SetOn(*Entity, *Target)
PositionEntity_(*Entity, TakeX(*Target), TakeY(*Target), TakeZ(*Target), 1)
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
Define *Clone = CreateTexture_(TWidth, THeight, 8+1)
CopyRect__(0, 0, TWidth, THeight, 0, 0, TextureBuffer_(*Tex), TextureBuffer_(*Clone))
ProcedureReturn *Clone
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

Procedure TransferChildren(*Old, *New, GlobalFlag = #False)
Define I = CountChildren_(*Old)
While I : EntityParent_(GetChild_(*Old, I), *New, GlobalFlag) : I - 1 : Wend
EndProcedure

Procedure ExchangeEntity(*Old, *Generator)
Define *New = CopyEntity_(*Generator) : SetOn(*New, *Old)
TransferChildren(*Old, *New) : FreeEntity_(*Old)
ProcedureReturn *New
EndProcedure

Procedure FindChildSafe(*Entity, ChildName.s)
ComplexEntityPrefix(#True) : If EntityName_(*Child) = ChildName : ProcedureReturn *Child
ElseIf CountChildren_(*Child) : Define *Result = FindChildSafe(*Child, ChildName) 
If *Result : ProcedureReturn *Result : EndIf : EndIf
ComplexEntityPostfix()
EndProcedure

Procedure SetupBox(*Entity, *Sizer, Offset = 0)
Define Y, W = MeshWidth_(*Sizer), H = MeshHeight_(*Sizer), D = MeshDepth_(*Sizer)
If Offset : Y = -H + Offset : Else : Y = -H / 2 : EndIf ; Корректировка.
EntityBox_(*Entity, -W / 2, Y, -D / 2, W, H, D)         ; Ставим размер бокса.
EndProcedure

Macro PrepareObstacle(Entity, Offset = 0) ; Pseudo-procedure.
SetupBox(Entity, Entity, Offset) : EntityPickMode_(Entity, 3, #True) : HideEntity_(Entity)
EndMacro
Procedure LoadAnimEtalone(FName.S, Mode = 'Ghost')
Define *Entity = LoadAnimMesh_(FName.S)
Select Mode ; Выбираем по режиму.
Case 'Ghost' : ComplexEntityAlpha(*Entity, 0.5) ; Призрачное представление.
Case 'Hull'  : ComplexEntityBlend(*Entity, 3) : ComplexEntityFX(*Entity, 1)
EndSelect : HideEntity_(*Entity)
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

Procedure AnimTime(*Being.Being)
With *Being ; Обработка.
Select AnimSeq_(\Entity)
Case 0 : ProcedureReturn AnimTime_(\Entity) ; Vanilla one.
Case 1 : ProcedureReturn AnimTime_(\Entity) + \SwapEdge + \Transition ; Extra one.
Case 2 : ProcedureReturn AnimTime_(\Entity) + \Temporary ; Temporary one (reserved num)
EndSelect
EndWith
EndProcedure

Procedure AnimtimeEX(*Being.Being) ; Special cases.
With *Being ; Обработка.
Select AnimSeq_(\Entity)
Case 0, 1 : ProcedureReturn AnimTime_(\Entity) ; Vanilla one.
Case 2 : ProcedureReturn AnimTime_(\Entity) + \Temporary ; Temporary one (reserved num)
EndSelect
EndWith
EndProcedure

Procedure FreezeAnim(*Being.Being)
With *Being
Define ATime.f = AnimTime(*Being)
Animate_(\Entity, 0, 0, 0)
\OnceAnim = #False
SetAnimTime_(\Entity, ATime)
EndWith
EndProcedure

Macro LogNot(Val) ; Pseudo-procedure.
Val ! 1
EndMacro

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

Procedure PointInRect(*Point.Point, *Rect.Rect)
With *Rect
If *Point\X >= \Left And *Point\X <= \Right And *Point\Y >= \Top And *Point\Y <= \Bottom
ProcedureReturn #True
EndIf
EndWith
EndProcedure

Macro AltLockMutex(Mutex) ; Pseudo-procedure.
While TryLockMutex(Mutex) = #False : Delay(2) : Wend
EndMacro

Macro UnlockVideoMutex() ; Pseudo-procedure.
UnlockMutex(System\VideoMutex) : If System\GUI\WaitVideo : Delay(3) : EndIf
EndMacro

Procedure RGB2Gray(RGB)
EnableASM
MOVZX EAX, byte [p.v_RGB]
MOVZX EBX, byte [p.v_RGB+1]
MOVZX ECX, byte [p.v_RGB+2]
XOr DX, DX
ADD AX, BX
ADD AX, CX
MOV CX, 3
DIV CX
DisableASM
ProcedureReturn
EndProcedure

Procedure Gray2RGB(Level.a)
EnableASM
XOr EAX, EAX
MOV byte AH, [p.v_Level]
MOV byte AL, AH
SHL EAX, 8
MOV AL, AH
DisableASM
ProcedureReturn
EndProcedure

Procedure.s Roman(Val)
Define Roman.s, i
If Val ; Если есть, что перобразовывать...
For I = 0 To #RomanCount
While Val >= System\refRoman(I)\Value
Roman.s + System\refRoman(I)\Symbol
Val - System\refRoman(I)\Value
Wend
Next I ; Возвращаем результат:
ProcedureReturn Roman
Else : ProcedureReturn "0"
EndIf
EndProcedure

Procedure LoadFontFile(FName.s, Font.s, Size)
System\FontLoader(FName, 16, 0)
ProcedureReturn LoadFont_(Font, Size)
EndProcedure

Macro UseBuffer(Target = BackBuffer_())
SetBuffer_(Target)
EndMacro

Procedure RandomIElement(List TList.i())
SelectElement(TList(), Random(ListSize(TList()) - 1)) : ProcedureReturn TList()
EndProcedure
;}
;{ --Input/Output--
Procedure GetInput()
Define I, Ctrl = KeyDown_(29) | KeyDown_(157)
Define MZSpeed = MouseZSpeed_()
Define MXSpeed = MouseXSpeed_()
System\GUI\Optional = 1
System\GUI\Control = Ctrl
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
If KeyHit_(015) : ProcedureReturn #PB_Key_Tab : EndIf
If KeyHit_(028) : ProcedureReturn #PB_Key_Return : EndIf
If KeyHit_(050) And Ctrl : ProcedureReturn #PB_Key_M : EndIf
If KeyHit_(038) And Ctrl : ProcedureReturn #PB_Key_L : EndIf
If KeyHit_(031) And Ctrl : ProcedureReturn #PB_Key_S : EndIf
If KeyHit_(030) And Ctrl : ProcedureReturn #PB_Key_A : EndIf
If KeyHit_(019) And Ctrl : ProcedureReturn #PB_Key_R : EndIf
If KeyHit_(018) And Ctrl : ProcedureReturn #PB_Key_E : EndIf
If KeyHit_(020) And Ctrl : ProcedureReturn #PB_Key_T : EndIf
If KeyHit_(022) And Ctrl : ProcedureReturn #PB_Key_U : EndIf
If KeyHit_(033) And Ctrl : ProcedureReturn #PB_Key_F : EndIf
If KeyHit_(048) And Ctrl : ProcedureReturn #PB_Key_B : EndIf
If KeyHit_(024) And Ctrl : ProcedureReturn #PB_Key_O : EndIf
If KeyHit_(016) And Ctrl : ProcedureReturn #PB_Key_Q : EndIf
If KeyHit_(046) And Ctrl : ProcedureReturn #PB_Key_C : EndIf
For I = 0 To 9 ; Check-up for numerical keymap.
If KeyHit_(I + 2) : ProcedureReturn #PB_Key_1 + I : EndIf
Next I
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

Procedure PickSquare(*PickedEntity)
Define *Ptr, *Square
If *PickedEntity <> #Null
*Ptr = EntityID_(*PickedEntity)
If *Ptr <> #Null : *Square = *Ptr : EndIf
EndIf
ProcedureReturn *Square
EndProcedure

Macro SetPickedSquare() ; Pseudo-procedure
System\GUI\PickedEntity = CameraPick_(System\Camera, System\GUI\MousePos\X, System\GUI\MousePos\Y)
System\GUI\PickedSquare = PickSquare(System\GUI\PickedEntity)
EndMacro

Macro DrawMiniMap() ; Pseudo-Procedure
#TwistSize = 4
#MMCursorCycle = 11
Define X, Y
If System\Options\DisplayMiniMap
; -Draw border-
If System\Level\ServiceTime : Player2Color(System\Level\CurrentPlayer, -1) ; Серая рамка.
Else : Player2Color(System\Level\CurrentPlayer, System\Level\Infestation) : EndIf
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

Macro ButtonsViziblity() ; Pseudo-procedure
System\Buttons[#BtnEndTurn]\Display = System\Options\DisplayETButton
System\Buttons[#BtnSearchActive]\Display = System\Options\DisplaySAButton
EndMacro

Procedure PressedButton()
Define I, *Button.Button
For I = 0 To #LastButton : *Button = System\Buttons[I]
If *Button\Display
If PointInRect(System\GUI\MousePos, *Button\Rect) And System\GUI\Input = #PB_MB_Left
*Button\State = #True
ProcedureReturn I
Else : *Button\State = #False
EndIf
EndIf
Next
ProcedureReturn -1
EndProcedure 

Macro CheckButtons() ; Pseudo-procedure
Select PressedButton()
Case #BtnEndTurn : System\GUI\Input = #PB_Key_Space
Case #BtnSearchActive : System\GUI\Input = #PB_Key_Tab
EndSelect
EndMacro

Macro DynamicNoise(Target)
If TakeX(System\CamPiv) <> TakeX(Target) Or TakeZ(System\CamPiv) <> TakeZ(Target) : System\GUI\Noised + 3 : EndIf
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
System\GUI\PickedSquare = *PSquare
If System\GUI\Input = #PB_MB_Left : DynamicNoise(*PSquare\Entity)
PositionEntity_(System\CamPiv, TakeX(*PSquare\Entity), 0, TakeZ(*PSquare\Entity))
System\GUI\Input = #Null 
EndIf
EndIf
EndWith
EndIf
EndProcedure

Macro DrawAllButtons() ; Pseudo-Procedure
Define I, *Button.Button
For I = 0 To #LastButton : *Button = System\Buttons[I]
If *Button\Display
DrawImage_(*Button\Image, *Button\Rect\Left, *Button\Rect\Top, *Button\State)
EndIf
Next I
EndMacro

Procedure Existing(*Being.Being, Brief = #True)
With *Being
If *Being ; Если Сущность вообще есть.
If Brief And \GonnaRide : ProcedureReturn #False : EndIf 
If (\State = #BInactive Or \State = #BActive) : ProcedureReturn #True : EndIf
EndIf
EndWith
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

Macro WillBeIgnorant(Being, Square) ; Pseudo-procedure.
(Ignoring(Square) And IsEnigmatic(Being))
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro Player2TeamIdx(PlayerIDx) ; Pseudo-procedure.
System\Players(PlayerIDx)\AlliedTeam
EndMacro

Macro PlayerIdx2Team(PlayerIDx) ; Pseudo-procedure.
System\Teams(System\Players(PlayerIDx)\AlliedTeam)
EndMacro

Macro Allied(PlayerIDx, PlayerIDx2)  ; Pseudo-procedure.
(Player2TeamIdx(PlayerIDx) = Player2TeamIdx(PlayerIDx2))
EndMacro

Macro Enemies(PlayerIDx, PlayerIDx2)  ; Pseudo-procedure.
(Player2TeamIdx(PlayerIDx) <> Player2TeamIdx(PlayerIDx2))
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure NotifyNeeded()
With System\GUI
Define *Square.Square : *Square = \PickedSquare
If \SelectedBeing And *Square
If (*Square\State = #SAbsorbtion Or *Square\State = #SAbsAndSpawn) And *Square\Being
Define *Being.Being = *Square\Being
If Existing(*Being)
If (Allied(*Being\Owner, System\Level\CurrentPlayer) XOr Sacrificer(\SelectedBeing)) And \SelectedBeing <> *Being
ProcedureReturn #True : EndIf
EndIf
EndIf
EndIf
EndWith
EndProcedure

Macro DrawMainCursor() ; Partializer.
If System\GUI\CurFrame = (#CurFrames * 2 - 1) : System\GUI\CurFrame = 0 : Else : System\GUI\CurFrame + 1 : EndIf
DrawImage_(System\Cursor, System\GUI\MousePos\X, System\GUI\MousePos\Y, (System\GUI\CurFrame >> 1))
EndMacro

Macro DrawCursor() ; Pseudo-Procedure
If NotifyNeeded() ; Если требуется вывести пердупредительный курсор...
DrawImage_(System\NotifyCursor, System\GUI\MousePos\X, System\GUI\MousePos\Y)
Else : DrawMainCursor() ; Стандартный курсор.
EndIf
EndMacro

Procedure AddTrack(FName.S)
Define *Sound, LastTrack, NewSize : NewSize = System\FoundTracks * #TrackPtrSize
FMOD_System_CreateStream(System\FModSystem, @FName, #FMOD_SOFTWARE, 0, @*Sound)
ReAllocateMemory(System\Tracks, NewSize)
Define *Track.Integer = System\Tracks + NewSize - #TrackPtrSize
*Track\I = *Sound
EndProcedure

Procedure SetTrackVolume(Volume.F)
FMOD_Channel_SetVolume(System\CurrentChannel, Volume)
EndProcedure

Procedure PlayTrack(Idx)
Define Channel.i, *Track.Integer = System\Tracks + (Idx - 1) * #TrackPtrSize
FMOD_System_PlaySound(System\FModSystem, 0, *Track\I, 0, @Channel)
System\CurrentChannel = Channel
EndProcedure

Procedure StopTrack()
FMOD_Channel_Stop(System\CurrentChannel)
EndProcedure

Procedure TrackPlaying()
Define Result.i
FMOD_Channel_IsPlaying(System\CurrentChannel, @Result)
ProcedureReturn Result
EndProcedure

Procedure PauseTrack()
FMOD_Channel_SetPaused(System\CurrentChannel, #True)
EndProcedure 

Procedure ResumeTrack() 
FMOD_Channel_SetPaused(System\CurrentChannel, #False)
EndProcedure

Macro EnforceMusicSettings() ; Pseudo-procedure.
If System\Options\PlayMusic = #False : StopTrack() : EndIf
EndMacro 

Macro ShutMusic() ; Pseudo-procedure.
PauseThread(System\MBThread)
StopTrack()
EndMacro

Procedure CheckElementSelection(*Img, X, Y)
Define HWidth = ImageWidth_(*Img) / 2 : Define HHeight = ImageHeight_(*Img) / 2
Define LBound = X - HWidth + 1 : Define RBound = X + HWidth - 1
Define TBound = Y - HHeight + 1 : Define BBound = Y + HHeight - 1
With System\GUI\MousePos
If \X >= LBound And \X <= RBound And \Y >= TBound And \Y <= BBound
If ReadPixel_(\X - X + HWidth, \Y - Y + HHeight, ImageBuffer_(*Img, 0)) <> $FF000000
ProcedureReturn #True
EndIf
EndIf
EndWith
EndProcedure

Procedure DrawMainMenuElement(*Image, X, Y, ElementIdx, SelectedElement) ; !!!
DrawImage_(*Image, X, Y, Bool(ElementIdx = SelectedElement))
EndProcedure

Procedure CheckBeing(*Being.Being)
If *Being
With *Being
If \State <> #BDying : ProcedureReturn #True : EndIf
EndWith
EndIf
EndProcedure

Macro DrawTactsCounter()
#TactsCounterCycle = #GameFPS
If System\Level\TactsLimit
Define Str.S : Str = "TACTS LEFT"
If System\GUI\TCBlink = #TactsCounterCycle
System\GUI\TCBlink = 0
Else : System\GUI\TCBlink + 1
EndIf
If System\GUI\TCBlink < (#TactsCounterCycle + 1) / 2 : Str + ":" : Else : Str + " " : EndIf
Str + Str(System\Level\TactsLimit - System\Level\CurrentTurn + 1)
Define XPos = 10, *Char.Character = @Str
While *Char\C : DrawImage_(System\TactsCounterFont, XPos, 10, *Char\C - 32)
XPos + 26 : *Char + SizeOf(Character)
Wend
EndIf
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro RenderTip(TipField, Offset = 0) ; Pseudo-procedure.
DrawImage_(System\TipField, System\GUI\DataBoardTip\X, System\GUI\DataBoardTip\Y - Offset)
EndMacro

Macro IsHuman() ; Pseudo-procedure.
System\Players(System\Level\CurrentPlayer)\IType = #IHuman
EndMacro

Macro HumanOwned(TBeing) ; ; Pseudo-procedure.
System\Players(TBeing\Owner)\IType = #IHuman
EndMacro

Macro IsLinked(TBeing) ; Pseudo-procedure.
(TBeing\Owner = System\Level\CurrentPlayer And IsHuman()) Or (HumanOwned(TBeing) And System\Level\HumanPlayers < 2)
EndMacro

Macro IsNeeded(TBeing) ; Pseudo-procedure.
HumanOwned(TBeing) And System\Level\HumanPlayers > 1 And Not IsHuman()
EndMacro

Macro RenderDataBoard(Being) ; Pseudo-procedure.
DrawImage_(Being\DataBoard, #DataBoardXOffset, System\GUI\DataBoardYPos)
If Being = System\GUI\SelectedBeing                            : RenderTip(IChoosen)
ElseIf Being\Owner = 0                                         : RenderTip(IAbsent)
ElseIf MindInfected(Being)                                     : RenderTip(IDepraved)
ElseIf IsLinked(Being)                                         : RenderTip(ILinked)
ElseIf IsNeeded(Being)                                         : RenderTip(INeeded)
Else                                                           : RenderTip(IOther)
EndIf
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro DrawDataBoard() ; Pseudo-procedure
SetFont_(System\DataBoardFont)
Color_(255, 255, 255)
Define WP.Point : WP\X = 10
If System\Level\TactsLimit : WP\Y = 45
Else : WP\Y = 10
EndIf
;CompilerIf #PB_Compiler_Debugger ; С 0.5 будет так.
WriteText(WP, "FPS: " + Str(System\GUI\FPS), 10)
WriteText(WP, "Tri's rendered: " + Str(TrisRendered_()), 10)
;CompilerEndIf ; Продолжаем с таблицей:
Define *Being.Being
If System\GUI\SelectInfo : RenderDataBoard(System\GUI\SelectedBeing) : System\GUI\SelectInfo = #False
ElseIf System\GUI\PickedSquare : *Being = System\GUI\PickedSquare\Being ; Если выделена платформа...
If *Being And *Being\State<>#BDying And *Being\State<>#BRecarn And *Being\State<>#BRecarnPreparing And *Being\GonnaRide=#False
RenderDataBoard(*Being) ; Рисуем таблицу с данными...
EndIf
EndIf
EndMacro

Macro DrawCounters() ; Pseudo-Procedure
Dim Lineup.Point(#MaxPlayers)
Define Ally, FromY, OldToX, Y, ToX = #LAOffset
Define ToFix = ArraySize(System\Players()), *Plr.Player
For I = 1 To ToFix : *Plr = System\Players(I)
If *Plr\CounterState <> #CNone
; -Update counter-
Select *Plr\CounterState
Case #CPreparing, #CGone
If *Plr\CounterPos\X >= #CountersOffset
*Plr\CounterPos\X = #CountersOffset
If *Plr\CounterState = #CPreparing : *Plr\CounterState = #CNormal : EndIf
Else : *Plr\CounterPos\X + #CounterSpeed
EndIf
Case #CNormal
If I = System\Level\CurrentPlayer
If *Plr\CounterPos\X < #ActiveCounterOffset : *Plr\CounterPos\X + #CounterSpeed 
Else : *Plr\CounterPos\X = #ActiveCounterOffset
EndIf
Else
If *Plr\CounterPos\X > #CountersOffset : *Plr\CounterPos\X - #CounterSpeed 
Else : *Plr\CounterPos\X = #CountersOffset
EndIf
EndIf
Case #CDissolving
If *Plr\CounterPos\X <= -System\CountersData\Left
*Plr\CounterPos\X = -System\CountersData\Left
*Plr\CounterState = #CGone
Else : *Plr\CounterPos\X - #CounterSpeed
EndIf
EndSelect
If System\Options\DisplayCounters
If *Plr\CounterState = #CNormal And System\Teams(*Plr\AlliedTeam)\PlayersCount > 1 
TeamIDx2Color(*Plr\AlliedTeam)
Y = *Plr\CounterPos\Y + #VertOffset
If LineUp(*Plr\AlliedTeam)\X = 0
If I => ToFix - 1 : ToX = #LAOffset : EndIf
Line_(#LSOffset, Y - 1, ToX, Y - 1)
Line_(#LSOffset, Y + 1, ToX - #LineFactor, Y + 1)
LineUp(*Plr\AlliedTeam)\Y = ToX ; Запоминаеми
ToX + #CountersOffset          ; Сдвигаем.
Else : OldToX = LineUp(*Plr\AlliedTeam)\Y
FromY = System\Players(LineUp(*Plr\AlliedTeam)\X)\CounterPos\Y + #VertOffset
Line_(OldToX, FromY, OldToX, Y + 1) : Line_(OldToX - #LineFactor, FromY + #LineFactor, OldToX - #LineFactor, Y - 1)
Line_(#LSOffset, Y - 1, OldToX - #LineFactor, Y - 1)
Line_(#LSOffset, Y + 1, OldToX - #LineFactor, Y + 1)
EndIf
LineUp(*Plr\AlliedTeam)\X = I ; В любом случае отмечаем последнее.
EndIf 
; -Draw counter-
If *Plr\CounterState = #CGone
DrawImage_(System\GoneCounters, *Plr\CounterPos\X, *Plr\CounterPos\Y, I - 1)
Else : DrawImage_(*Plr\Counter, *Plr\CounterPos\X, *Plr\CounterPos\Y)
EndIf
EndIf
EndIf
Next I
; -Uplinking teams
For I = 1 To ToFix : *Plr = System\Players(I) : Ally = *Plr\AlliedTeam
If Lineup(Ally)\X = I : Y = *Plr\CounterPos\Y + #VertOffset + #LineFactor / 2
TeamIDx2Color(Ally) : ToX = Lineup(Ally)\Y : Line_(Tox-1, Y, Tox, Y)
EndIf
Next I
; -Update counter's title-
If System\Level\CountersTitleXPos >= #CountersOffset + #CountersTitleOffset
System\Level\CountersTitleXPos = #CountersOffset + #CountersTitleOffset
Else : System\Level\CountersTitleXPos + #CounterSpeed
EndIf
; -Draw counter's title-
If System\Options\DisplayCounters
DrawImage_(System\CountersTitle, System\Level\CountersTitleXPos, System\GUI\CountersTitleYPos)
EndIf
EndMacro

Procedure CopyMemToImage(*Mem, Img.i, Pitch.i)
StartDrawing(ImageOutput(Img))
Define *Dest.Long = DrawingBuffer()
Define X, Y, *Src.Long = *Mem + (#ScreenHeight - 1) * Pitch
For Y = 1 To #ScreenHeight
For X = 1 To #ScreenWidth
*Dest\L = *Src\L ; Копируем пиксель.
*Src + SizeOf(Long) : *Dest + SizeOf(Long) - 1
Next X : *Src - #ScreenWidth * SizeOf(Long) - Pitch
Next Y
StopDrawing()
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure FindGameWindow() 
Define *DW = GetDesktopWindow_(), *PW, *NW, *ThisThread = GetCurrentThreadId_()
Repeat : *NW = FindWindowEx_(*DW, *PW, #Null, #GameTitle)
If GetWindowThreadProcessId_(*NW, #Null) = *ThisThread : ProcedureReturn *NW : Else : *PW = *NW : EndIf
ForEver
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro Quit() ; Partializer.
SetWindowLong_(System\GameWindow, #GWL_WNDPROC, System\OldCallBack)
EndBlitz3d_() : TerminateProcess_(GetCurrentProcess_(), 0) ; Теперь выходим. Ну, в теории...
EndMacro

Declare SaveOptions()
Procedure QuitDialog(ToMenu = #True)
ShowPointer_()
If ToMenu : Define Msg.s = "Are you sure want to return in menu ?"
Else : Msg = "Are you sure want to exit ?"
EndIf
If MessageRequester("[Flow]", Msg, 4) = 6 
SaveOptions()
ShutMusic()
If ToMenu ; Спасибо Фреду за наше счастливое детство.
! JMP MainMenuLbl
Else : Quit() : EndIf 
EndIf
HidePointer_()
EndProcedure

Macro CheckExitFlag() ; Partializer
If System\GUI\Exit : QuitDialog(#False) : System\GUI\Exit = #False : EndIf
EndMacro

; -Pretty printing (для брифингов)-
Structure PrettyPrintData
PrintPos.Rect
Shift.Point
*PPBuffer
*BackGround
CursorFlash.i
*Timer
EndStructure
Global PPData.PrettyPrintData

#PPLeftBorder = 5
#PPTopBorder = 5
#PPRightBorder = 800

Procedure CarriageReturn()
With PPData\PrintPos
\Top + \Bottom : \Left = #PPLeftBorder
If \Top + \Bottom > #ScreenHeight 
If PPData\Shift\X = PPData\Shift\Y
PPData\Shift\X + 1
EndIf
PPData\Shift\Y + 1 
EndIf
EndWith
EndProcedure

Procedure TypeLetter(Letter.c)
UseBuffer(ImageBuffer_(PPData\PPBuffer, 0))
With PPData\PrintPos
Select Letter
Case #LF ; NOP.
Case #CR : CarriageReturn()
Default
Text_(\Left, \Top, Chr(Letter))
\Left + \Right
If \Left + \Right > #PPRightBorder : CarriageReturn() : EndIf
EndSelect
EndWith
EndProcedure

Procedure PPDrawText()
Protected Origin = -(PPData\Shift\X * PPData\PrintPos\Bottom)
AltLockMutex(System\VideoMutex) : UseBuffer()
DrawImage_(PPData\BackGround, 0, 0)
DrawImage_(PPData\PPBuffer, 0, Origin)
If PPData\CursorFlash
With PPData\PrintPos
Rect_(\Left, \Top + Origin, \Right, \Bottom)
EndWith
EndIf
Flip_()
UnlockVideoMutex()
EndProcedure

Procedure PPHandleInput()
Define Input = GetInput(), Amount : Amount = System\GUI\Optional
Select Input
Case #PB_Key_Escape : UseBuffer() : ProcedureReturn #PB_Key_Escape
Case #PB_Key_Space : ProcedureReturn #PB_Key_Space
Case #PB_Key_Up : If Amount > PPData\Shift\X : Amount = PPData\Shift\X : EndIf
PPData\Shift\X - Amount
Case #PB_Key_Down : PPData\Shift\X + Amount
If PPData\Shift\X > PPData\Shift\Y : PPData\Shift\X = PPData\Shift\Y : EndIf
EndSelect
; -Additional controls-
CheckExitFlag()
EndProcedure

Procedure PrettyPrint(Text.S, Quick = #False)
Define TPos, *Char.Character = @Text, Pause = 1, FlashCounter, PauseCount
Define Leave, Result, CursorFlashEdge, *Buffer ; Подготовка заднего фона.
System\MaxFPS = #PrettyFPS ; Ограничение кадров для распечатки брифинга.
If Quick : CursorFlashEdge = 50 ; Установить период мерцания курсора.
Else : CursorFlashEdge = 2
EndIf
ClearStructure(PPData, PrettyPrintData)
PPData\BackGround = CreateImage_(10, 10, 1)
PauseTrack() ; Остановить музыку.
AltLockMutex(System\VideoMutex)
UseBuffer(ImageBuffer_(PPData\BackGround, 0))
Color_(0, 0, 40)
ClsColor_(9, 9, 10) : Cls_()
Line_(0, 0, ImageWidth_(PPData\BackGround) - 1, 0)
Line_(0, 0, 0, ImageHeight_(PPData\BackGround) - 1)
UseBuffer()
TPos = -(ImageWidth_(PPData\BackGround) + 1) / 2
TileImage_(PPData\BackGround, TPos, -(ImageHeight_(PPData\BackGround) + 1) / 2, 0)
FreeImage_(PPData\BackGround)
PPData\BackGround = CreateImage_(#ScreenWidth, #ScreenHeight, 1)
GrabImage_(PPData\BackGround, 0, 0, 0)
UnlockVideoMutex()
SetFont_(System\PPFont) ; Установить шрифт.
PPData\PrintPos\Left = #PPLeftBorder : PPData\PrintPos\Top = #PPTopBorder
PPData\PrintPos\Right = StringWidth_("0") : PPData\PrintPos\Bottom = StringHeight_("0")
FlashCounter = #PPLeftBorder
;;;;;;;;;;;;;;;;;;;;;;;;;
While *Char\C ; Find all CR's.
If *Char\C <> #LF
If *Char\C = #CR : Pause + 1 : FlashCounter = #PPLeftBorder
Else
FlashCounter + PPData\PrintPos\Right
If FlashCounter + PPData\PrintPos\Right > #PPRightBorder 
Pause + 1 : FlashCounter = #PPLeftBorder
EndIf
EndIf
EndIf
*Char + SizeOf(Character)
Wend
;;;;;;;;;;;;;;;;;;;;;;;;;
; Установить размер буффера...
PPData\PPBuffer = CreateImage_(#ScreenWidth, #PPTopBorder + Pause * PPData\PrintPos\Bottom, 1)
Pause = 0 : FlashCounter = 0 ; Сбросить счетчики паузы и мерцания курсора.
If Quick : PauseCount = 1 : Else : PauseCount = 5 : EndIf ; Установить значение паузы.
Color_(0, 215, 0) ; Установить цвет печати букв.
PPData\Timer = CreateTimer_(#PrettyFPS) ; Создать синхронизирующий таймер.
*Char = @Text ; Reset character buffer.
While *Char\C ; Draw text, letter-by-letter.
TypeLetter(*Char\C)
If FlashCounter = CursorFlashEdge : FlashCounter = 0
PPData\CursorFlash = ~PPData\CursorFlash
Else : FlashCounter + 1
EndIf
If Quick = #False Or FlashCounter = 0 : PPDrawText() : EndIf
Select PPHandleInput()
Case #PB_Key_Escape : Leave = #True : Result = #False : Break
Case #PB_Key_Space : Result = #True : Leave = #True : Break
EndSelect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If Quick = #False : WaitTimer_(PPData\Timer) : EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*Char + SizeOf(Character)
Wend
If Leave : Goto FinishPP : EndIf
PPData\CursorFlash = #False
Repeat
Select PPHandleInput()
Case #PB_Key_Escape : Result = #False : Break
Case #PB_Key_Space : Result = #True : Break
EndSelect
PPDrawText()
WaitTimer_(PPData\Timer)
ForEver
FinishPP:
FreeImage_(PPData\PPBuffer)
FreeImage_(PPData\BackGround)
FreeTimer_(PPData\Timer)
ResumeTrack()  ; Восстановить проигрывание музыки.
ProcedureReturn Result
EndProcedure

Procedure.S FormatStory(Story.S, ForQuick = #False)
If ForQuick <> 'Alt' ; Если не трубется альтернативный вывод.
Story = "=(Press space to skip story)=" + #CR$ + Story + #CR$
If ForQuick : Story + "=(Press space to continue mission)="
Else : Story + "=(Press space to start mission)="
EndIf
Else : Story="=(Press space to skip epilogue)="+#CR$+Story+#CR$+"=(Press space to continue)="
EndIf
ProcedureReturn Story
EndProcedure

Macro ShowNothing() ; Partializer.
ClsColor_(0, 0, 0) : Cls_() ; Сразу очищаем экран и показываем:
DrawImage_(System\NothingText, #ScreenWidth / 2, #ScreenHeight / 2 - 200)
DrawImage_(System\VoidEye, #ScreenWidth / 2, #ScreenHeight / 2) 
DrawImage_(System\InsideText, #ScreenWidth / 2, #ScreenHeight / 2  + 200)
Flip_() ; Finally showing nothing.
EndMacro

Macro NoiseGarden() ; Partializer
TileBlock_(System\Noise, Random(#NoiseBlock-1), Random(#NoiseBlock-1), Random(#NoiseFrames-1))
System\GUI\Noised - 1 ; Снижаем счетик, коли уж.
EndMacro

Macro BadMonitor() ; Partializer
If System\Level\WaitforFinish Or System\Options\InstableOut = 0 : System\GUI\Noised = 0 ; Наоборот убираем шум.
ElseIf Random(150) = 0 : System\GUI\Noised + 2 + Random(5) : EndIf ; Иногда - зашумляем.
EndMacro
;}
;{ --Data basing--
Procedure BeingType2Etalone(Type)
Select Type
Case #BTree      : ProcedureReturn System\TreeMesh
Case #BSpectator : ProcedureReturn System\SpectatorMesh
Case #BSentry    : ProcedureReturn System\SentryMesh
Case #BMeanie    : ProcedureReturn System\MeanieMesh
Case #BIdea      : ProcedureReturn System\IdeaMesh
Case #BSociety   : ProcedureReturn System\SocietyMesh
Case #BJustice   : ProcedureReturn System\JusticeMesh
Case #BSentinel  : ProcedureReturn System\SentinelMesh
Case #BHunger    : ProcedureReturn System\HungerMesh
Case #BJinx      : ProcedureReturn System\JinxMesh
Case #BDefiler   : ProcedureReturn System\DefilerMesh
Case #BAgave     : ProcedureReturn System\AgaveMesh
Case #BEnigma    : ProcedureReturn System\EnigmaMesh
Case #BAmgine    : ProcedureReturn System\AmgineMesh
Case #BFrostBite : ProcedureReturn System\FrostBiteMesh
Case #BSeer      : ProcedureReturn System\SeerMesh
Case #BParadigma : ProcedureReturn System\ParadigmaMesh
Case #BDesire    : ProcedureReturn System\DesireMesh
EndSelect
EndProcedure

Procedure BeingType2Crest(Type)
Select Type
Case #BSpectator : ProcedureReturn System\SpectatorCrest
Case #BSentry    : ProcedureReturn System\SentryCrest
Case #BMeanie    : ProcedureReturn System\MeanieCrest
Case #BIdea      : ProcedureReturn System\IdeaCrest
Case #BSociety   : ProcedureReturn System\SocietyCrest
Case #BJustice   : ProcedureReturn System\JusticeCrest
Case #BHunger    : ProcedureReturn System\HungerCrest
Case #BJinx      : ProcedureReturn System\JinxCrest
Case #BDefiler   : ProcedureReturn System\DefilerCrest
Case #BEnigma    : ProcedureReturn System\EnigmaCrest
Case #BAmgine    : ProcedureReturn System\AmgineCrest
Case #BParadigma : ProcedureReturn System\ParadigmaCrest
EndSelect
EndProcedure

Procedure BeingType2Flector(Type)
Select Type
Case -1          : ProcedureReturn System\CompressFlector
Case #BSeer      : ProcedureReturn System\SeerFlector
Case #BParadigma : ProcedureReturn System\ParadigmaFlector
Case #BDesire    : ProcedureReturn System\DesireFlector
EndSelect
EndProcedure

Procedure Being2Shield(*Being.Being)
Select *Being\Type
Case #bEnigma   : If Ignoring(*Being\Square) : ProcedureReturn System\EnigmaShield : EndIf
Case #bAmgine   : If Ignoring(*Being\Square) : ProcedureReturn System\AmgineShield : EndIf
Case #bAgave    : ProcedureReturn System\AgaveShield
Case #bJustice  : ProcedureReturn System\JusticeShield
Case #bJinx     : ProcedureReturn System\JinxShield
Case #bHunger   : ProcedureReturn System\HungerShield
Case #bSentinel : ProcedureReturn System\SentinelShield
Case #bDefiler  : ProcedureReturn System\DefilerShield
EndSelect
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
;}
;{ --Map management--
Procedure MindInfected(*Being.Being)
With *Being
If \Infection >= #EpidemiaStart : ProcedureReturn #True
ElseIf \Infection >= #EpidemiaStart / 2 ; Тут случай сложнее...
If \Owner <> System\Level\CurrentPlayer And \State <> #BActive : ProcedureReturn #True 
EndIf
EndIf
EndWith
EndProcedure

Procedure AddBeing2UpdateList(*Being.Being, InfFlag)
Define MI = MindInfected(*Being)
With *Being
If \NeedsTableUpdate = #False
\NeedsTableUpdate = #True
If InfFlag And MI = #False Or MI And InfFlag = #False : \NeedsTableUpdate = 2 : EndIf
AddElement(System\GUI\BeingsToUpdate())
System\GUI\BeingsToUpdate() = *Being
EndIf
EndWith
EndProcedure

Procedure Add2BeingsCount(PlayerIdx, Value = 1)
Define *Player.Player, *Team.Team, *Being.Being
*Player = System\Players(PlayerIdx)
With *Player
If \BeingsCount = 1 And Value = -1
\BeingsCount = 0 : System\Level\PlayersCount - 1
*Team = System\Teams(\AlliedTeam)
If *Team\PlayersCount = 1 : System\Level\TeamsCount - 1
Else : *Team\PlayersCount - 1 ; Снижаем счетчик.
ForEach System\Beings() : *Being = System\Beings()
If System\Players(*Being\Owner)\AlliedTeam = \AlliedTeam
AddBeing2UpdateList(*Being, #False) : EndIf ; Ставим на обновление.
Next ; Продолжаем со счетчиком.
EndIf : \CounterState = #CDissolving
If \IType = #IHuman : System\Level\HumanPlayers - 1 : EndIf
Else : \BeingsCount + Value
EndIf
EndWith
EndProcedure

Procedure Player2Color(PlayerIdx, OutTable)
If OutTable = #False
Select PlayerIdx
Case 0 : Color_(245, 245, 245)
Case 1 : Color_(120, 255, 120)
Case 2 : Color_(255, 90, 90)
Case 3 : Color_(235, 209, 57)
Case 4 : Color_(36, 238, 219)
EndSelect
ElseIf OutTable = -1 : Color_(145, 145, 145)
Else                 : Color_(220, 90, 220)
EndIf
EndProcedure

Procedure MarkMinimap(*Being.Being) ; Доделать !
Define X, Y
With *Being
X = 1 + \Square\ArrayPos\X * #MMCellSize : Y = 1 + \Square\ArrayPos\Y * #MMCellSize
UseBuffer(ImageBuffer_(System\MiniMap, 0))
Color_(10, 10, 10)
Rect_(X, Y, #MMCellSize, #MMCellSize)
If \State <> #BDying : Player2Color(\Owner, MindInfected(*Being)) : EndIf 
If \State = #BActive Or \State = #BPreparing
Rect_(X + 1, Y + 1, #MMCellSize - 2, #MMCellSize - 2)
Else : Rect_(X, Y, #MMCellSize, #MMCellSize)
EndIf
Color_(10, 10, 10)
Plot_(X, Y)
Plot_(X + #MMCellSize - 1, Y)
Plot_(X, Y + #MMCellSize - 1)
Plot_(X + #MMCellSize - 1, Y + #MMCellSize - 1)
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

Macro ColorText(Text, Fection = Inf, Border = #TextBorder)
Player2Color(Owner, Fection) : WriteText(TextPoint, Text, Border)
EndMacro

Procedure TeamIdx2Color(Idx)
Define *Team.Team = System\Teams(Idx)
Color_(*Team\R, *Team\G, *Team\B)
EndProcedure

Macro TeamText(Text)
TeamIdx2Color(TeamIDx) : WriteText(TextPoint, Text, #TextBorder)
EndMacro

Procedure.S Amount2Str(Amount, *Being.Being, CheckNull = #False)
If *Being\LockDown And CheckNull : ProcedureReturn "Nulled"
ElseIf *Being\Interstate : ProcedureReturn "+/-"
ElseIf Amount <> #All : ProcedureReturn Str(Amount)
Else : ProcedureReturn "All" ; Все-все.
EndIf
EndProcedure

Procedure CanBeInfected(*Being.Being, Channel = #False)
With *Being
If \Type <> #BSociety And \Type <> #BDefiler And (\Ascended = #False Or Channel) : ProcedureReturn #True : EndIf
EndWith
EndProcedure

Procedure ScriptCounter(PlayerIdx) ; Доделать !
If System\Players(PlayerIdx)\CounterState <> #CNone
Define Text.S
With System\Players(PlayerIdx)
UseBuffer(ImageBuffer_(\Counter, 0))
ClsColor_(0, 0, 0) : Cls_()
DrawImage_(System\Counters, 0, 0, PlayerIdx - 1)
SetFont_(System\CountersFont)
Text = Str(\BeingsCount) + ": " + Str(\TotalEnergy) + "E"
Color_(255, 255, 255)
Text_(System\CountersData\Right, System\CountersData\Bottom, Text, #True, #True)
EndWith
EndIf
EndProcedure

Macro UpdateCounters() ; Pseudo-procedure
Define I, ToFix : ToFix = ArraySize(System\Players())
For I = 1 To ToFix
ScriptCounter(I)
Next I
EndMacro

Macro Unfreezable(Being) ; Pseudo-procedure.
(Being\Type = #BMeanie Or Being\Type = #BHunger Or Being\Type = #BFrostbite Or Being\Type = #BDesire)
EndMacro

Procedure.s GetMood(*Being.being)
If *Being\Interstate    : ProcedureReturn "Shifting"
ElseIf *Being\ExtraMode : ProcedureReturn "Extraversal"
Else                    : ProcedureReturn "Intraversal"
EndIf
EndProcedure

Macro DelayTargeting(TBeing) ; Pseudo-procedure.
(TBeing\Type = #BSeer And TBeing\ExtraMode = #True)
EndMacro

Macro ParaTroop(TBeing) ; Pseudo-procedure.
(TBeing\Type = #BParadigma And TBeing\ExtraMode = #True)
EndMacro

Macro ColdFusion(TBeing) ; Pseudo-procedure.
(TBeing\Type = #BDesire And TBeing\ExtraMode = #True)
EndMacro

Procedure ScriptDataBoard(*Being.Being)
#TextBorder = 6
Define TypeName.S, TextPoint.Point, Owner, Inf, TeamIdx, *Team.Team
With *Being
; Подготовка к отображению таблицы.
UseBuffer(ImageBuffer_(\DataBoard, 0))
If \Ascended : DrawImage_(System\AscendantBoard, 0, 0)
Else         : DrawImage_(System\DataBoard, 0, 0) : EndIf
SetFont_(System\DataBoardFont)
Inf = MindInfected(*Being) : Owner = \Owner
TextPoint\X = #TextBorder : TextPoint\Y = #TextBorder
; Определение типа Сущности.
TypeName = BeingType2Name(\Type)
If \Reincarnated : TypeName + " (R)" : ElseIf Ignorant(*Being) : TypeName + " [I]" : EndIf
; Вывод данных.
If \Ascended : WhiteText("Kind: ") 
Else         : WhiteText("Type: ") 
EndIf : ColorText(TypeName)
WhiteText("Owner: ") 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If *Being\Owner ; Если это не нейтрал...
TeamIdx = Player2TeamIdx(\Owner) ; Индекс.
*Team = System\Teams(TeamIdx)    ; Указатель.
If Inf : ColorText("Player " + Str(\Owner))
ElseIf *Team\PlayersCount > 1 : ColorText("Player " + Str(\Owner), Inf, 0)
TeamText(" (Team " + Str(TeamIdx) + ")") : Else : TeamText("Team " + Str(TeamIdx))
EndIf ; Иначе рапортуем нейтралитет:
Else : ColorText("Neutral")
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WhiteText("Energy: ") 
TypeName = Str(\EnergyLevel)
If \ReincarnationCost > 0 And Not Ignoring(\Square) : TypeName + "/" + Str(\ReincarnationCost) : EndIf
ColorText(TypeName)
If Unfreezable(*Being) ; Если Сущность может быть заморожена...
ColorText("Can't be frozen.") 
ElseIf \Frozen ; Если Сущность заморожена...
If \Frozen = 1 : TypeName = "" : Else : TypeName = "s" : EndIf
WhiteText("Frozen") : ColorText(" (" + Str(\Frozen) + " turn" + TypeName + " left)")
Else : WhiteTextCR("Not frozen.") 
EndIf
If \Type = #BSociety Or \Type = #BDefiler ; Если Сущность может открывать каналы...
TypeName = "Input " : Else : TypeName = "Output " : EndIf
TypeName + "channels: " : WhiteText(TypeName)
TypeName = Str(*Being\Channels) + "(x" + Str(#ChannelsFlow) + ")"
If \Type = #BSociety : TypeName + "/" + Str(#MaxChannels)
ElseIf \Type = #BDefiler : TypeName + "/" + Str(#DefMAxChannels)
EndIf
ColorText(TypeName)
If \Ascended = #False ; Если сущность не вознесена...
If CanBeInfected(*Being) ; Если Сущность может быть заражена...
If MindInfected(*Being) ; Если нервная секция Сущности подавлена...
ColorText("Critically infected !")    ; Выводим предупреждение.
Else : WhiteText("Infection level: ") ; Выписываем уровень заражения.
If \Infection > 1 : ColorText(Roman(\Infection), #True)  ; Стандартный цвет.
Else : ColorText(Roman(\Infection)) : EndIf ; Фиолетовый цвет (дабы было яснее).
EndIf
Else : ColorText("Can't be infected.") 
EndIf
Else : WhiteText("Mood: ") : ColorText(GetMood(*Being))
EndIf
WhiteTextCR("")
TextPoint\X = System\GUI\DataBoardXCenter : WriteText(TextPoint, "Stats:", #TextBorder, #True)
If Not ColdFusion(*Being) ; Если не идет холодный синтез.
If DelayTargeting(*Being) ; Если готовится отложенный удар...
WhiteText("Targeting range: ") : TypeName = "Absorbtion"
Else : If Sacrificer(*Being) : TypeName = "Sacrification"
Else : TypeName = "Absorbtion"
EndIf : WhiteText(TypeName + " range: ") 
EndIf : ColorText(Amount2Str(\AbsorbtionRange, *Being, #True))
WhiteText(TypeName + " count: ")
TypeName = Amount2Str(\AbsorbtionCount, *Being, #True)
If \Ascended And Sacrificer(*Being) = #False ; Отдельно - вознесенным.
If \Interstate = #False And \AbsorbtionCount : TypeName + "->" + Str(\AbsorbtionCount * 2) : EndIf
ElseIf \Reincarnated = #False And \Type <> #BEnigma And Sacrificer(*Being) = #False
TypeName + "/"
If \AbsorbtionCount = #All : TypeName + Str(#AllReplacer)
Else : TypeName + Str(\AbsorbtionCount / 2) : EndIf
EndIf
ColorText(TypeName)
If \Ascended ; Если это аскендант...
WhiteText("Personal matter: ") : ColorText(BeingType2Name(\Hatred))
If ParaTroop(*Being) : WhiteText("Vertoposition range: ")
Else : WhiteText("Transposition range: ") : EndIf ; Стандартная надпись.
ColorText(Amount2Str(\SpawningRange, *Being)) ; Пишем дальноссть.
Else ; -Стандартная роспись:
WhiteText("Spawning range: ") : ColorText(Amount2Str(\SpawningRange, *Being))
WhiteText("Spawning cost: ")
TypeName = Amount2Str(\SpawningCost, *Being) 
If DeficitSpawner(*Being) : TypeName = "1.." + TypeName : EndIf
ColorText(TypeName)
EndIf
Else ; -Описываем производство.
WhiteText("In-production: ") : ColorText(BeingType2Name(\Posterity))
TypeName = Amount2Str(\SynthCores, *Being) 
If \Interstate = #False : TypeName + "/" + Str(#MaxCores) : EndIf
WhiteText("Cores available: ") : ColorText(TypeName)
WhiteText("Synthesis range: ") : ColorText(Amount2Str(\SpawningRange, *Being))
WhiteText("Synthesis cost: ")  : ColorText(Amount2Str(\SpawningCost, *Being))
EndIf
EndWith
EndProcedure

Macro PrettyBox(Width, Height, Y = 0) ; Partializer.
#Corner = 4 : #InCorner = #Corner - 1
Rect_(0, Y, Width, Height, #False) : Rect_(0, Y, #Corner, #Corner, #False)
Rect_(Width - #Corner, Y + Height - #Corner, #Corner, #Corner, #False)
EndMacro

Macro EndPrettyBox(Width, Height, Y = 0) ; Partializer.
Color_(0, 0, 0) : Rect_(0, Y, #InCorner, #InCorner, #True) 
Rect_(Width - #InCorner, Y + Height - #InCorner, #InCorner, #InCorner, #True)
EndMacro

Procedure ScriptTable(*Being.Being)
With *Being
Define Text.s
SetFont_(System\TableFont)
Player2Color(\Owner, MindInfected(*Being))
UseBuffer(ImageBuffer_(\Table, 0)) 
ClsColor_(80, 80, 80) : Cls_() : PrettyBox(#TableWidth, #TableHeight) ; Теперь сам текст:
If \EnergyLevel > #TableMax : Text = Str(#TableMax) : Else : Text = Str(\EnergyLevel) : EndIf
Text_(#TableWidth / 2, #TableHeight / 2, Text, 1, 1) : EndPrettyBox(#TableWidth, #TableHeight)
EndWith
ScriptDataBoard(*Being)
EndProcedure

Macro UpdateTables() ; Pseudo-Procedure
Define *UBeing.Being
While ListSize(System\GUI\BeingsToUpdate())
*UBeing = System\GUI\BeingsToUpdate()
ScriptTable(*UBeing)
If *UBeing\NeedsTableUpdate = 2 : MarkMiniMap(*UBeing) : EndIf
*UBeing\NeedsTableUpdate = #False
DeleteElement(System\GUI\BeingsToUpdate())
Wend
EndMacro

Macro DrawAttention() ; Partializer.
Define I, G ; Счетчики.
For G = 0 To 1 ; Подготовка спец. графики
For I = 1 To #MaxPlayers : Player2Color(I, #False)
UseBuffer(ImageBuffer_(System\Attention, I + G * #MAxPlayers))
PrettyBox(#AttentionWidth, #AttentionHeight, #AttentionFix)
EndPrettyBox(#AttentionWidth, #AttentionHeight, #AttentionFix)
If G : Player2Color(I, #False) ; Требуется доп. графика:
Define X = #AttentionWidth / 2 - #RectWidth / 2 - #ConnRect - 2
Line_(X, 0, X, #ConnRect + 2) : Line_(X, 0, X + #ConnRect + 2, 0)
Color_(0, 0, 0) : Plot_(X +1, #ConnRect + 3) : Player2Color(I, #False)
Define X = #AttentionWidth / 2 + #RectWidth/2 + #ConnRect + 2
Line_(X, 0, X, #ConnRect + 2) : Line_(X, 0, X - #ConnRect - 2, 0)
Color_(0, 0, 0) : Plot_(X - 1, #ConnRect + 3) : Player2Color(I, #False)
EndIf
Next I
Next G
MidHandle_(System\Attention)
EndMacro

Macro DrawInfection()
#InfStep = 7 ; Самое важное - шаг.
#InfHorizon = #InfStep - #HalfInf
#LowEdge = #TableHeight + #HalfInf
Define X, Y : Player2Color(0, #True)
For X = 0 To #EpidemiaStart - 1 ; Все точки...
UseBuffer(ImageBuffer_(System\InfCache, X))
For Y = 0 To X ; Рисуем точки.
Rect_(#HTWidth+(Y%3-1)*#InfHorizon-#HalfInf, #LowEdge * (Y/3), #InfPoint, #InfPoint)
Next Y
Next X
MidHandle_(System\InfCache)
EndMacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro DrawStore()
Define X, Player, Cell, Frame = 0
SetFont_(system\TableFont)
For Player = 1 To #MaxPlayers
For Cell = 1 To #StoreCells : Frame + 1
UseBuffer(ImageBuffer_(System\StoreCache, Frame))
Player2Color(Player, 0) ; Cтавим цвет рамке.
Rect_(#ConnRect, 0, #RectWidth, #RectHeight, 0)
Rect_(0, #RectHeight - #ConnRect, #ConnRect + 1, #EveryThing, 0)
Rect_(#RectWidth + #ConnRect -1, #RectHeight - #ConnRect, #ConnRect + 1, #EveryThing, 0)
Color_(0, 0, 0) ; Черный-черный.
Line_(#ConnRect, #TitleHeight - 1, #TitleWidth - #ConnRect, #TitleHeight - 1)
Plot_(#ConnRect, #RectHeight - 1) : Plot_(#ConnRect + #RectWidth - 1, #RectHeight - 1)
Plot_(#ConnRect, 0) : Plot_(#ConnRect + #RectWidth - 1, 0) ; ...И последнее:
Color_(50, 50, 50) : Rect_(#ConnRect + 1, 1, #RectWidth -2 , #RectHeight -2 , 1)
Player2Color(0, 0) : X = #RectWidth / 2+#ConnRect : Text_(X, #RectHeight / 2, Str(Cell % 10), 1, 1)
Next Cell
Next Player
MidHandle_(System\StoreCache)
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Macro StepBlock(Edge, Luft)
X + XSpeed : Y + YSpeed ; Сдвиг по скоростям.
If     X = Luft And Y = Luft : XSpeed = 1  : YSpeed = 0
ElseIf X = Luft And Y = Edge : XSpeed = 0  : YSpeed = -1
ElseIf X = Edge And Y = Luft : XSpeed = 0  : YSpeed = 1
ElseIf X = Edge And Y = Edge : XSpeed = -1 : YSpeed = 0
EndIf
EndMacro

Procedure MomentumFrame(*Buffer, Shift, Border, Limit, Start = 0)
#TrueBlack = $FF000000
Define X = Start, Y = Start, XSpeed, YSpeed
Define I, SColor, TColor ; Аккумуляторы.
UseBuffer(*Buffer) : Plot_(Start, Start) 
SColor = ReadPixel_(Start, Start, *Buffer)
WritePixel_(Start, Start, 0, *Buffer) ; На всякий пожарный.
Define R = Red(SColor)   ; Красный.
Define B = Blue(SColor)  ; Синий.
Define G = Green(SColor) ; Зеленый.
For I = 1 To Shift : StepBlock(Border, Start) : Next I
For I = 3 To Limit ; Рисуем сам блок:
Define TColor = RGBA(R, G, B, 255 * (0.0 + I / Limit))
WritePixel_(X, Y, AlphaBlend(TColor, #TrueBlack), *Buffer)
StepBlock(Border, Start) ; Продолжаем шаг.
Next I
EndProcedure

Macro DrawMomentum() ; Partializer.
Define Frame = 0, Time ; Переменные.
For I = 0 To #MaxPlayers : Player2Color(I, Int(Sign(I)) ! 1)
For Time = 1 To #MaxMomentum ; Рисуем вортекс:
MomentumFrame(ImageBuffer_(System\Momentum,Frame),Time,#MomentumQuant-1,#MaxMomentum-1)
Frame + 1
Next Time
Next I
EndMacro

Procedure HLSquare(*Square.Square, State, Register = #True)
With *Square
If State = #SActiveBeing And *Square\Being And *Square\Being\Gonnaride : ProcedureReturn #False : EndIf
If State = #SSpawning And \State = #SAbsorbtion : Register = #False : State = #SAbsAndSpawn : EndIf
EntityAlpha_(\Entity, #SquareAlpha)
\State = State
Select \State
Case #SNone   : EntityAlpha_(\Entity, 0.0)
Case #SSwitch : ShowEntity_(System\SwitchSymbol)
SetOn(System\SwitchSymbol, \Entity) ; Выставляем.
TranslateEntity_(System\SwitchSymbol, 0, 0.01, 0)
Case #SAbsorbtion : EntityColor_(\Entity, 245, 100, 0)
Case #SSpawning : EntityColor_(\Entity, 0, 0, 180)
Case #SAbsAndSpawn : EntityColor_(\Entity, 142, 26, 113)
EndSelect
EndWith
If Register 
AddElement(System\GUI\HLSquares())
System\GUI\HLSquares() = *Square
EndIf
EndProcedure

Procedure CollapseHL()
Define *Square.Square
HideEntity_(System\SwitchSymbol)
ForEach System\GUI\HLSquares()
*Square = System\GUI\HLSquares()
HLSquare(*Square, #SNone, #False)
With *Square
If \Being
If \Being\State = #BActive And \Being\Owner = System\Level\CurrentPlayer
HLSquare(*Square, #SActiveBeing, #False)
EndIf
EndIf
DeleteElement(System\GUI\HLSquares())
EndWith
Next
EndProcedure

Macro RotatorPart() ; Partializer, damn it.
RotateEntity_(*Being\Entity, 0, Yaw, 0) : *Being\EntityYaw = Yaw
EndMacro 

Procedure TurnBeing(*Being.Being, Yaw)
With *Being
Select \Type
Case #BMeanie, #BSentry, #BSentinel, #BHunger, #BDefiler, #BFrostBite, #BDesire
Case #BParadigma, #BSeer : If \ExtraMode = #False : RotatorPart() : EndIf
Default : RotatorPart() ; Стандартное вращение.
EndSelect
EndWith
EndProcedure

Procedure ApplyChannel(*Source.Being, *Destination.Being, Advanced = #False)
Define *Channel.Channel, *Pos
AddElement(System\Channels()) : *Channel = System\Channels()
With *Channel
\Source = *Source : \Destination = *Destination
\SourcePos\X = *Source\Square\ArrayPos\X
\SourcePos\Y = *Source\Square\ArrayPos\Y
\DestinationPos\X = *Destination\Square\ArrayPos\X
\DestinationPos\Y = *Destination\Square\ArrayPos\Y
\Advanced = Sign(Advanced)
*Source\Channels + 1
*Destination\Channels + 1
If *Source\Ascended = #False
*Source\InfChannels + \Advanced
If Advanced=1 And *Source\Owner<>*Destination\Owner:*Source\Infection=Min(*Source\Infection+1,#EpidemiaStart):EndIf
EndIf
EndWith
ProcedureReturn *Channel
EndProcedure

Procedure CloseChannel(Fast = #False)
Define *Channel.Channel = System\Channels()
With *Channel
If Fast = #False
\Source\Channels - 1 : \Destination\Channels - 1
If \Advanced : \Destination\InfChannels - 1: EndIf
EndIf : DeleteElement(System\Channels())
EndWith
EndProcedure

Macro CellRandom() ; Pseudo-procedure.
(Random(#HalfCell) - #HalfCell / 2)
EndMacro

Procedure RandomizeQuant(*Quant.Quant)
With *Quant
\X = CellRandom() : \Z = CellRandom()
TranslateEntity_(\Entity, \X, #QuantHeight, \Z)
EndWith
EndProcedure

Procedure UpdateVortexes() ; Pseudo-procedure
Define Line, Flag, *Square, Pixel, Angle.f, *Ptr.Square = @Squares(), Oddity = System\Level\Height % 2 
Define Offset = @Squares(1, 0) - @Squares(0, 0) - SizeOf(Square) * System\Level\Height, Light
Define Factor.f=1-System\GUI\SinCache,Factor2.f=1-Abs(Sin(Radian(90-System\GUI\SinFeeder)))
System\GUI\LightCache = #NoColor + #FlashDiff * Factor : System\GUI\LightCache2 = #NoColor + #FlashDiff * Factor2
For Pixel = 1 To System\Level\Width ; Сканируем каждую линию.
For Line = 1 To System\Level\Height ; На каждый пиксель...
Flag = ~Flag : If Flag : Angle = #VortexSpeed : Light = System\GUI\LightCache
Else : Angle = -#VortexSpeed : Light = System\GUI\LightCache2 : EndIf
TurnEntity_(*Ptr\Vortex, 0, Angle, 0) 
TurnEntity_(*Ptr\FVortex, 0, Angle/3, 0) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If *Ptr\CellType = #pIgnorance       ; Освещение:
EntityColor_(GetParent_(*Ptr\Entity), Light, Light, Light)
EndIf : *Ptr + SizeOf(Square)        ; Стандартное смещение.
Next Line : *Ptr + Offset            ; Полное смещение.
If Oddity = 0 : Flag = ~Flag : EndIf ; Поправка.
Next Pixel
EndProcedure

Macro UpdateRotors() ; Pseudo-procedure
Define Speed = 3, Light ; Изначальные параметры...
ForEach System\GUI\Rotors() : Speed = -Speed : TurnEntity_(System\GUI\Rotors(), Speed, 0, 0, 0)
If Speed > 0 : Light = System\GUI\LightCache : Else : Light = System\GUI\LightCache2 : EndIf
EntityColor_(System\GUI\Rotors(), Light, Light, Light) ; Еще и подсвечиваем для красоты.
Next
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure AddLadder(*Square.Square, Dir.i = 1)
Define *Ladder.Ladder, Size.f
AddElement(System\GUI\Ladders())
*Ladder = System\GUI\Ladders()
With *Ladder ; Готовим лестницу.
\Entity = CopyEntity_(System\LadderMesh)
Size = 16 - Rnd(50) / 1000.0
ScaleEntity_(\Entity, Size, #TallInfinity, Size)
TurnEntity_(\Entity, 0,  Random(180), 0)
SetOn(\Entity, *Square\Entity)
\Size = Size ; For saving as well.
\X = *Square\ArrayPos\X ; For save.
\Y = *Square\ArrayPos\Y ; For save.
\Polarity = Dir
EndWith
ProcedureReturn *Ladder
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure SendEnergy(*Source.Square, *Destination.Square, Amount.i, UseLAdders.i = #True)
#QuareterCell = #HalfCell / 2
Define *Quant.Quant, I
For I = 1 To Amount
AddElement(System\GUI\Quants()) : *Quant = System\GUI\Quants()
With *Quant
\Entity = CopyEntity_(System\QuantMesh, *Source\Vortex)
\Source = *Source
\Destination = *Destination
\SourcePos\X = \Source\ArrayPos\X
\SourcePos\Y = \Source\ArrayPos\Y
\DestinationPos\X = \Destination\ArrayPos\X
\DestinationPos\Y = \Destination\ArrayPos\Y
SetOn(\Entity, \Source\Entity)
RandomizeQuant(*Quant)
EndWith
Next I
; Теперь лестницы.
If UseLadders
AddLadder(*Source)
AddLadder(*Destination, -1)
EndIf
EndProcedure

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

Macro ApplyVision(Ring)
EntityTexture_(Ring, System\SanityTex, Random(#Visions-1))
EndMacro

Procedure PrepareVisions(*Being.Being)
With *Being ; Долгая и нудная настройка:
\Vision = CopyEntity_(System\VisionMesh, \EyePoint)
ScaleEntity_(\Vision, #OutRing, #RingHeight, #OutRing) : ApplyVision(\Vision)
TranslateEntity_(\Vision, 0, #VisionLuft, 0) ; Небольшое смещение.
Define *Vision2 = CopyEntity_(\Vision) ; Еще одно кольцо.
EntityParent_(*Vision2, \Vision) : SetOn(*Vision2, \EyePoint)
TranslateEntity_(*Vision2, 0, -#VisionLuft, 0) : ApplyVision(*Vision2)
Define *Vision3 = CopyEntity_(System\VisionMesh, \Vision)
ScaleEntity_(*Vision3, #InRing, #RingHeight, #InRing) : ApplyVision(*Vision3)
Define *Vision4 = CopyEntity_(*Vision3, *Vision2) : ApplyVision(*Vision2)
EntityParent_(*Vision4, \Vision) : EntityParent_(*Vision2, *Vision3)
HideEntity_(\Vision) ; Сразу скрываем.
EndWith
EndProcedure

Macro ColorizeParadigma(PhaseName, TexName, Textured=*Being\Entity, TexOwner=*Being)
EntityTexture_(FindChildSafe(Textured, "L" + PhaseName + "Wing"), TexOwner\TexName)
EntityTexture_(FindChildSafe(Textured, "R" + PhaseName + "Wing"), TexOwner\TexName)
EntityTexture_(FindChildSafe(Textured, PhaseName + "Heart"), TexOwner\TexName)
EntityTexture_(FindChildSafe(Textured, PhaseName + "Torus"), TexOwner\TexName)
EntityTexture_(FindChildSafe(Textured, PhaseName + "Complex"), TexOwner\TexName)
ComplexEntityTexture(FindChildSafe(Textured, PhaseName + "Engine"), TexOwner\TexName)
EndMacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Procedure FindParts(*Being.Being)
Define I
With *Being ; Обработка...
Select \Type ; Не для всех...
Case #BFrostBite : \SpecialPart = FindChildSafe(*Being\Entity, "Cubez")
\SpecialPart2 = CreateMesh_(*Being\Entity) : TranslateEntity_(\SpecialPart2, 0, #EyePointHeight * 0.8, 0)
Case #BSeer      : \SpecialPart = FindChildSafe(*Being\Entity, "Creen")
\SpecialTex = CloneTexture(System\CaosTex)
Case #BParadigma
\SpecialTex = CloneTexture(System\RedTex)
\SpecialTex2 = CloneTexture(System\GreenTex)
\SpecialTex3 = CloneTexture(System\BlueTex)
\SpecialTex4 = CloneTexture(System\WhiteTex)
ColorizeParadigma("Red"  , SpecialTex)
ColorizeParadigma("Green", SpecialTex2, *Being\Entity, *Being)
ColorizeParadigma("Blue" , SpecialTex3, *Being\Entity, *Being)
\SpecialPart = FindChildSafe(\Entity, "Spine")
\SpecialPart2 = CreateMesh_(*Being\Entity)
EntityTexture_(\SpecialPart, \SpecialTex4)
Case #BDesire
\SpecialPart  = FindChildSafe(\Entity, "Holic")
\SpecialPart2 = FindChildSafe(\Entity, "Hatchery")
\SpecialPart3 = CreateMesh_(\SpecialPart2)
\SpecialPart4 = FindChildSafe(\Entity, "Mover1")
\SpecialPart5 = FindChildSafe(\Entity, "Mover2")
SetOn(\SpecialPart3, \SpecialPart2)
; -Optimization-
For I = 1 To #VicHolez
HideEntity_(FindChildSafe(\Entity, "Tubus" + RSet(Str(I), 2, "0")))
Next I
EndSelect
EndWith
EndProcedure

Macro RecarnType(Type)
Bool(Type >= #BJustice And Type < #BEnigma)
EndMacro

Procedure CreateBeing(*Square.Square, Type, Owner, InitState = #BPreparing, EnergyLevel = #All)
Define *Being.Being, *Mesh, I, ToFix
If *Square\Being = #Null
AddElement(System\Beings()) : *Being = System\Beings()
With *Being
; -Primary parameters setup-
\Owner = Owner : \Type = Type  : \State = InitState : \StoreLink = #NoLink
*Square\Being = *Being : \Square = *Square : \Posterity = \Type
\X = *Square\ArrayPos\X : \Y = *Square\ArrayPos\Y
If RecarnType(Type) : \Reincarnated = #True ; Установить флаг реинкарнации.
ElseIf Type >= #BSeer : \Ascended = #True : \SpawningCost = #All : \SwapPost = \Posterity: EndIf ; Установить флаг вознесения.
; -Secondary parameters setup-
Select Type
Case #BTree
\EnergyLevel = 5 : \SpawningCost = #All
Case #BSpectator
\EnergyLevel = 15
\AbsorbtionRange = 8  : \SpawningRange = 2
\AbsorbtionCount = 10 : \SpawningCost = 15
\ReincarnationCost = 80
Case #BSentry
\EnergyLevel = 20
\AbsorbtionRange = 2    : \SpawningRange = 2
\AbsorbtionCount = #All : \SpawningCost = #All
\ReincarnationCost = 160
Case #BMeanie
\EnergyLevel = 10
\AbsorbtionRange = 3 : \SpawningRange = 4
\AbsorbtionCount = 5 : \SpawningCost = 10
\ReincarnationCost = 50
Case #BIdea
\EnergyLevel = 2
\AbsorbtionRange = 2 : \SpawningRange = 7
\AbsorbtionCount = 6 : \SpawningCost = 2
\ReincarnationCost = 30
Case #BSociety
\EnergyLevel = 20
\AbsorbtionRange = 4 : \SpawningRange = 3
\AbsorbtionCount = 7 : \SpawningCost = 20
\ReincarnationCost = 100
Case #BEnigma 
\EnergyLevel = 13
\AbsorbtionRange = 3  : \SpawningRange = 3
\AbsorbtionCount = 13 : \SpawningCost = 13
\ReincarnationCost = #All
Case #BAmgine
\EnergyLevel     = 13 
\AbsorbtionRange = 3  : \SpawningRange = 3
\AbsorbtionCount = 13 : \SpawningCost = 13
\ReincarnationCost = #All
; -Reincarnated Beings-
Case #BJustice
\EnergyLevel = 80 
\AbsorbtionRange = 20 : \SpawningRange = 4
\AbsorbtionCount = 25 : \SpawningCost = #All
Case #BSentinel
\EnergyLevel = 150 
\AbsorbtionRange = 4    : \SpawningRange = 4
\AbsorbtionCount = #All : \SpawningCost = 15
\Posterity = #BSentry
Case #BHunger
\EnergyLevel = 50
\AbsorbtionRange = 5  : \SpawningRange = 6
\AbsorbtionCount = 15 : \SpawningCost = #All
Case #BJinx
\EnergyLevel = 30 
\AbsorbtionRange = 4  : \SpawningRange = 20
\AbsorbtionCount = 20 : \SpawningCost = #All
Case #BDefiler
\EnergyLevel = 100 
\AbsorbtionRange = 6  : \SpawningRange = 5
\AbsorbtionCount = 10 : \SpawningCost = #All
Case #BAgave
\EnergyLevel = 50     : \SpawningCost = #All
; -Tools-
Case #BFrostBite
\EnergyLevel = 1      : \SpawningCost = #All
\Owner = 0 ; For sure.
; -Ascendants-
Case #BSeer           : \Hatred = #BJustice
\AbsorbtionRange = 10 : \SpawningRange = 3
\AbsorbtionCount = 15 : \AnimEdge = 100
\SwapAR = #All        : \SwapSR = 0
\SwapAC = 15          : \SwapSC = #All
\SwapEdge = 59        : \Transition = 20
Case #BParadigma      : \Hatred = #BJinx
\AbsorbtionRange = 3  : \SpawningRange = 9
\AbsorbtionCount = 12 : \AnimEdge = 100
\SwapSR = #All        : \SwapSC = #All
\SwapEdge = 79        : \Transition = 30
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Case #BDesire
\EnergyLevel = 50     : \Hatred = #BHunger
\AbsorbtionRange = 4  : \SpawningRange = 5
\AbsorbtionCount = 10 : \AnimEdge = 100
\SwapSR = 2           : \SwapSC = 1
\Transition = 30      : \SwapEdge = 80
\SwapPost = #BFrostBite ; Cold fusion.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndSelect
If EnergyLevel <> #All : \EnergyLevel = EnergyLevel : EndIf
If \Owner And InitState <> #BDying : Add2BeingsCount(\Owner) ; Increse owner's beings count.
System\Players(\Owner)\TotalEnergy + \EnergyLevel ; Increse owner's energy count.
EndIf 
; -Entity setup-
\Entity = CopyEntity_(BeingType2Etalone(Type)) : SetOn(\Entity, *Square\Entity)
SetAnimTime_(\Entity, 0) : FindParts(*Being) ; Поиск спец. частей на анимацию.
; -Shield setup-
\Shield = Being2Shield(*Being) ; Получаем собственный щит.
If \Shield : \Shield = CopyEntity_(\Shield, \Entity) : EndIf
If \Reincarnated : \Shocker = CopyEntity_(\Shield, \Entity) 
\ShockTex = CloneTexture(System\ShockTex) ; Шокер.
ComplexEntityTexture(\Shocker, \ShockTex) ; Шок.
EndIf
; -Turn around-
TurnBeing(*Being, DeltaYaw_(\Entity, System\Sky) - 180)
; -Cryogene setup-
\CryoTex = CloneTexture(System\CryoTex)
TextureBlend_(\CryoTex, 0) ; Изначальная невидимость.
ComplexEntityTexture(\Entity, \CryoTex, 1)
; -EyePoint setup-
\EyePoint = CreatePivot_(\Entity)
If \Ascended : TranslateEntity_(\EyePoint, 0, #EyePointHeight * 1.5, 0) : EndIf
Select \Type
Case #BSentry, #BJinx : TranslateEntity_(\EyePoint, 0, #EyePointHeight * 2.2, 0)
Case #BSentinel       : TranslateEntity_(\EyePoint, 0, #EyePointHeight * 3, 0)
Case #BFrostBite      : TranslateEntity_(\EyePoint, 0, #EyePointHeight * 0.8, 0)
Default               : TranslateEntity_(\EyePoint, 0, #EyePointHeight, 0)
EndSelect
; -Visionary setup-
PrepareVisions(*Being.Being)
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
EndIf
ProcedureReturn *Being
EndProcedure

Macro MakeAllBeingsPickable() ; Pseudo-procedure
ForEach System\Beings()
MakePickable(System\Beings())
Next
EndMacro

Macro MakeAllBeingsUnPickable() ; Pseudo-procedure
ForEach System\Beings()
MakePickable(System\Beings(), #False)
Next
EndMacro

Procedure DestroyBeing()
Define *Being.Being = System\Beings(), Shift
With *Being
\Square\Being = #Null ; Стираем запись на клетке.
FreeImage_(\Table) : FreeImage_(\DataBoard) : FreeEntity_(\Entity) : FreeTexture_(\CryoTex)
If \SpecialTex : FreeTexture_(\SpecialTex) : EndIf ; Освобождаем специальную текстуру.
If \SpecialTex2 : FreeTexture_(\SpecialTex2) : EndIf ; Освобождаем специальную текстуру 2.
If \SpecialTex3 : FreeTexture_(\SpecialTex3) : EndIf ; Освобождаем специальную текстуру 3.
If \SpecialTex4 : FreeTexture_(\SpecialTex4) : EndIf ; Освобождаем специальную текстуру 4.
If @System\Beings() = System\GUI\ActiveBeingPos And ListSize(System\Beings()) > 1
Define *ListPos = @System\Beings() ; Сохраняем позицию.
If PreviousElement(System\Beings()) = #Null : LastElement(System\Beings()) : EndIf
System\GUI\ActiveBeingPos = @System\Beings() ; Получаем новую активную Сущность.
ChangeCurrentElement(System\Beings(), *ListPos) ; Возвращаем позицию
EndIf : DeleteElement(System\Beings()) ; Удаляем, наконец, Сущность.
EndWith
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
Macro Ascendable(Square) ; PSeudo-procedure.
(Ignoring(Square) Or Square\Gold = #False)
EndMacro

Macro NoGoldForMe(Being, Square) ; Pseudo-procedure
(Being\Ascended And Ascendable(Square))
EndMacro

Macro SimpleLife(Being, Square) ; Pseudo-rpcoedure.
(Being\Ascended = #False And Being\Reincarnated = #False)
EndMacro

Macro NeedsAttention(Being, Square) ; Pseud-procedure
(Being\Reincarnated And (Being\Type = #BSentinel Or Not Ignoring(Square)))
EndMacro

Procedure CanVisit(*Being.Being, *Square.Square) ; Pseudo-procedure.
If ColdFusion(*Being) And Not NoGoldForMe(*Being, *Square) : ProcedureReturn #False : EndIf
If ParaTroop(*Being) ; Если имеем дело с прыжком.
If NoGoldForMe(*Being, *Square) And *Square\Being And *Square\Being\State <> #BDying 
If *Square\Being\Reincarnated = #False Or Not Ignoring(*Being\Square)
ProcedureReturn #True : EndIf : EndIf
Else ; Разбираепмся со случаями по-проще.
If NoGoldForMe(*Being, *Square) Or SimpleLife(*Being, *Square) Or NeedsAttention(*Being, *Square)
ProcedureReturn #True
EndIf
EndIf
EndProcedure

Procedure CanAbsorb(*Being.Being, *Sqr.Square)
If *Being\LockDown = #False Or *Being\Square = *Sqr
If DelayTargeting(*Being) ; Если мы имеем дело с Seer'ом в позе...
If Ascendable(*Sqr) : ProcedureReturn #True : EndIf
Else : ProcedureReturn EntityVisible_(*Being\EyePoint, *Sqr\Entity)
EndIf
EndIf
EndProcedure

Macro ActionAvailable(Being, Square, SpawnFlag) ; Pseudo-procedure.
(SpawnFlag And CanVisit(Being, Square)) Or (SpawnFlag=#False And CanAbsorb(Being, Square))
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure BeingHL(*Being.Being, Spawning = #False)
Define Sure, X, Y, HLRect.Rect, Range, HLState, *Square.Square
With *Being ; Для начала определеяем радиус и тип действия:
If Spawning : Range = \SpawningRange : HLState = #SSpawning
Else : Range = \AbsorbtionRange : HLState = #SAbsorbtion : EndIf
If Range = #All : Sure = #True : Range = #EveryThing : EndIf
HLRect\Left = \Square\ArrayPos\X : HLRect\Top = \Square\ArrayPos\Y
HLRect\Right = Range : FormRect(HLRect) ; ...А теперь сканируем...
For X = HLRect\Left To HLRect\Right
For Y = HLRect\Top To HLRect\Bottom
If Sure Or (Abs(X - \Square\ArrayPos\X) + Abs(Y - \Square\ArrayPos\Y)) <= Range
*Square = Squares(X, Y) ; Подсвечиваем, если действие допустимо:
If ActionAvailable(*Being, *Square, Spawning) : HLSquare(*Square, HLState, #True) : EndIf
EndIf
Next Y
Next X
EndWith
EndProcedure

Procedure IsActiveBeing(*B.Being, PlayerIdx, SM)
With *B
If SM = 2
If (\Owner <> PlayerIdx Or MindInfected(*B)) And \Owner And Existing(*B) And Sacrificer(*B) = #False
ProcedureReturn #True : EndIf
ElseIf \Owner = PlayerIdx And \GonnaRide = #False And \State = #BActive And (SM = 0 Or MindInfected(*B)) 
ProcedureReturn #True
EndIf
EndWith
EndProcedure

Procedure NextActiveBeing(PlayerIdx, SearchMode = 0)
; SM = 0 - Обычный поиск.
; SM = 1 - Поиск инфицированных Сущностей.
; SM = 2 - Поиск Сущностей для таблицы опасностей.
Define *B.Being, *StartPos, Count
Count = ListSize(System\Beings()) - 1
ChangeCurrentElement(System\Beings(), System\GUI\ActiveBeingPos)
*StartPos = @System\Beings()
Repeat 
If ListIndex(System\Beings()) = Count : FirstElement(System\Beings())
Else : NextElement(System\Beings()) : EndIf
*B = System\Beings()
If IsActiveBeing(*B, PlayerIdx, SearchMode)
System\GUI\ActiveBeingPos = @System\Beings()
Break : EndIf
If *StartPos = @System\Beings() : *B = #Null : Break : EndIf
ForEver
ProcedureReturn *B
EndProcedure

Procedure CountFreeChannels(*Being.Being)
With *Being
If \Type = #BSociety : ProcedureReturn #MaxChannels - \Channels
ElseIf \Type = #BDefiler : ProcedureReturn #DefMaxChannels - \Channels
EndIf
EndWith
EndProcedure

Macro SetHatred(Square, Target)
Square\iKills[Target - #BJustice] + Reverse
EndMacro

Procedure CanSpawn(*Being.Being, Factor = 0)
With *Being
Define EL = \EnergyLevel + Factor
If ColdFusion(*Being) And (\SynthCores = 0 Or \Special Or EL <= \SpawningCost) : ProcedureReturn #False : EndIf
If DeficitSpawner(*Being) Or EL > \SpawningCost Or (EL >= \SpawningCost And \Type <> #BSentinel)
ProcedureReturn #True
EndIf
EndWith
EndProcedure

Procedure CanReincarnate(*Being.Being, Factor = 0)
With *Being
If \ReincarnationCost And (IsEnigmatic(*Being) Or Not Ignoring(\Square)) And \EnergyLevel + Factor >= \ReincarnationCost
ProcedureReturn #True
EndIf
EndWith
EndProcedure

Macro FullHL(Being) ; Pseudo-procedure.
If Being\Interstate = #False : BeingHL(Being)
If CanSpawn(Being) : BeingHL(Being, #True) : EndIf
EndIf ; Оставляем только простую подсветку.
If CanReincarnate(Being) : HLSquare(Being\Square, #SRecarn) 
ElseIf Being\Ascended : HLSquare(Being\Square, #SSwitch)
EndIf
EndMacro

Macro SetupGhost(Being) ; Pseudo-rpcoedure.
If System\GUI\Ghost\Entity : HideEntity_(System\GUI\Ghost\Entity) : EndIf ; Сразу убиваем.
System\GUI\Ghost\Type = Being\Posterity ; Призрак.
System\GUI\Ghost\Entity = BeingType2Etalone(Being\Posterity)
EndMacro

Procedure TechSwitch(*Being.Being)
With *Being
\ExtraMode ! 1
Swap \AnimEdge, \SwapEdge
Swap \AbsorbtionRange, \SwapAR
Swap \AbsorbtionCount, \SwapAC
Swap \SpawningRange  , \SwapSR
Swap \SpawningCost   , \SwapSC
Swap \Posterity      , \SwapPost
If \Type = #BDesire  : SetupGhost(*Being) : EndIf
EndWith
EndProcedure

Procedure SwitchMood(*Being.Being)
With *Being ; Обработка Сущности...
\InterState = #True ; Флаг перемен.
ScriptDataBoard(*Being) : CollapseHL() : FullHL(*Being)
EndWith
EndProcedure

Procedure SetDanger(*Being.Being, Reverse = #False)
With *Being
If Reverse : Reverse = -1 : Else : Reverse = 1 : EndIf
If *Being\Frozen <= 1 And *Being\LockDown <=1 
If *Being\DelayedBlow ; Если готовится отложенный удар...
*Being\DelayedBlow\DangerLevel + *Being\AbsorbtionCount * Reverse
*Being\DelayedBlow\DangerLevel4Reincarnates + *Being\AbsorbtionCount * Reverse
SetHatred(*Being\DelayedBlow, *Being\Hatred)
Else ; Иначе таки сканируем.
Define Extra = \ExtraMode, ScanRect.Rect, X, Y, Channels, *Sqr.Square, FC = CountFreeChannels(*Being)
If Extra : TechSwitch(*Being) : EndIf
If \AbsorbtionRange ; Если Сущность вообще может абсорбировать...
; Формируем зону поиска.
ScanRect\Left = \Square\ArrayPos\X
ScanRect\Top = \Square\ArrayPos\Y
If *Being\Type = #BFrostBite : ScanRect\Right = 1
Else : ScanRect\Right = \AbsorbtionRange
EndIf : FormRect(ScanRect)
; И сканируем ее.
For X = ScanRect\Left To ScanRect\Right
For Y = ScanRect\Top To ScanRect\Bottom
; ...Если клетка попадает в область абсорбции...
If (Abs(X - \Square\ArrayPos\X) + Abs(Y - \Square\ArrayPos\Y)) <= \AbsorbtionRange
*Sqr = Squares(X, Y)
If EntityVisible_(\EyePoint, *Sqr\Entity) ; Если она видима...
; Выставляем уровень опасности.
If \AbsorbtionCount = #All
*Sqr\InstantAbsorbers + 1 * Reverse
; ...и для реинкарнатов...
If \Reincarnated : *Sqr\AdvInstantAbsorbers + 1 * Reverse
Else : *Sqr\DangerLevel4Reincarnates + #AllReplacer * Reverse
EndIf
Else : *Sqr\DangerLevel + \AbsorbtionCount * Reverse
; ...и для реинкарнатов...
If \Reincarnated ; Реинкарнат на реинкарната.
*Sqr\DangerLevel4Reincarnates + \AbsorbtionCount * Reverse
ElseIf \Ascended : *Sqr\DangerLevel4Reincarnates + \AbsorbtionCount * 2 * Reverse 
SetHatred(*Sqr, \Hatred) ; Ненависть, ненависть, ненависть !
Else : *Sqr\DangerLevel4Reincarnates + \AbsorbtionCount / 2 * Reverse
EndIf ; Выставляем удвоенный уровень опасности:
EndIf
; Корректировка уровня опасности с учетом каналов...
If FC > 0
*Sqr\DangerLevel + #ChannelsFlow * Reverse
*Sqr\DangerLevel4Reincarnates + #ChannelsFlow * Reverse
; Запись информации о замораживающих Сущностях...
ElseIf \Type = #BMeanie : *Sqr\Frozers + Reverse
ElseIf \Type = #BHunger : *Sqr\AdvFrozers + Reverse
ElseIf \Type = #BFrostBite : *Sqr\Biters + Reverse
EndIf
EndIf
EndIf
Next Y
Next X
If Extra : TechSwitch(*Being) : EndIf
EndIf
EndIf
EndIf
EndWith
EndProcedure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure DeActivateBeing(*Being.Being)
With *Being
\State = #BInActive
HLSquare(\Square, #SNone, #False)
EndWith
MarkMiniMap(*Being)
EndProcedure

Macro HalfFroze(Being) ; Partializer.
TextureBlend_(Being\CryoTex, 5) ; Полуоттаянное состояние.
EndMacro

Procedure ApplyFroze(*Being.Being, Duration)
With *Being
If Duration > \Frozen ; Разумная проверка.
FreezeAnim(*Being) : \Frozen = Duration ; Самое главное.
If \State = #BActive : DeActivateBeing(*Being) : EndIf ; Казалось бы. Но...
If \Type = #BParadigma    : ComplexEntityBlend(\Entity, 1) : EndIf
If Duration > #MeanFreeze : TextureBlend_(\CryoTex, 3)
Else : HalfFroze(*Being) : EndIf
EndIf
EndWith
EndProcedure

Procedure PeekHeight(X, Y)
If X >= 0 And X <= System\Level\Width - 1
If Y >= 0 And Y <= System\Level\Height - 1
ProcedureReturn Squares(X, Y)\Height
EndIf : EndIf
EndProcedure

Macro CellFroze(XShift, YShift) ; Partializer.
If PeekHeight(X + XShift, Y + YShift) = Height ; Начинаем.
Define *VBeing.Being = Squares(X + XShift, Y + YShift)\Being
If *VBeing And Existing(*VBeing, #False) And Not Unfreezable(*VBeing)
ApplyFroze(*VBeing, #MeanFreeze) : AddBeing2UpdateList(*VBeing, 0)
EndIf : EndIf
EndMacro

Macro SpawnShiver(TShiver, FullWork = #True) ; Partializer.
If FullWork : AddElement(System\GUI\Shivers()) : TShiver = System\GUI\Shivers() : EndIf
TShiver\Entity = CopyEntity_(System\ShiverMesh) : If FullWork : SetOn(TShiver\Entity, *Source\Entity) 
TShiver\Angle = Random(360) : RotateSprite_(TShiver\Entity, TShiver\Angle) : TShiver\Invertor = 1 : EndIf
If Advanced Or TShiver\Bright : EntityFX_(TShiver\Entity, 1) : TShiver\Bright = #True : EndIf
EndMacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro PrepareScoring(Being) ; Partializer.
Define Height = Being\Square\Height
Define X = Being\Square\ArrayPos\X
Define Y = Being\Square\ArrayPos\Y
EndMacro 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Macro WideFroze(Center, ItSelf = 0) ; Pseudo-procedure.
PrepareScoring(Center)
CellFroze(-1, 0)  : CellFroze(0, -1)
CellFroze(1, 0)   : CellFroze(0, 1)
If ITself : ApplyFroze(Center, ItSelf) : EndIf
EndMacro 

Procedure FuseGas(*FrostBite.Being)
Define *Shiver.Shiver, I, X, Y, Advanced, *Source.Being = *FrostBite
For I = 1 To #BiteGas - #BiteGas / 3 : SpawnShiver(*Shiver) : SetOn(*Shiver\Entity, *FrostBite\EyePoint)
RotateEntity_(*Shiver\Entity, 90, 0, Random(360)) : *Shiver\Invertor = 0
TranslateEntity_(*Shiver\Entity, CellRandom(), Random(20) - 10, CellRandom())
MoveEntity_(*Shiver\Entity, 0, #Cellsize * 1.5, 0) : TurnEntity_(*Shiver\Entity, 0, 0, 180, 0)
EntityPArent_(*Shiver\Entity, *FrostBite\Square\Fvortex) : *Shiver\Speeder = -0.2 ; A little slower.
*Shiver\Parented = 1 : *Shiver\Parent = *FrostBite\Square\ArrayPos
Next I
For I = 1 To #BiteGas / 3 : SpawnShiver(*Shiver) : : SetOn(*Shiver\Entity, *FrostBite\EyePoint)
TranslateEntity_(*Shiver\Entity, CellRandom() * 2, Random(20) - 10, CellRandom() * 2)
*Shiver\Latency = #CryoTime - 5 + Random(5) : EntityAlpha_(*Shiver\Entity, 0)
RotateEntity_(*Shiver\Entity, (Random(20) - 10), 0, (Random(20) - 10))
Next I : *FrostBite\Transfert = #True
EndProcedure

Procedure PostScriptum(*Being.Being)
Define *Shiver.Shiver, I, X, Y, Advanced
Select *Being\Type ; Не для всех...
Case #BFrostBite ; Криобомба.
; Логическая часть.
WideFroze(*Being)
; Визуальная часть.
Define *Source.Being = *Being
For I = 1 To #BiteGas : SpawnShiver(*Shiver) : SetOn(*Shiver\Entity, *Being\EyePoint)
RotateEntity_(*Shiver\Entity, 90, 0, Random(360))
TranslateEntity_(*Shiver\Entity, CellRandom(), Random(20) - 10, CellRandom())
*Being\StateFrame = 0.025 : *Shiver\Speeder = 0.1
Next I
Case #BSeer : EntityTexture_(*Being\SpecialPArt, System\BlankTex)
EntityColor_(*Being\SpecialPArt, #NoColor, #NoColor, #NoColor)
EndSelect
EndProcedure

Macro ClearBlow(Being) ; Pseudo-procedure.
If Being\DelayedBlow : Being\DelayedBlow\DelayedBlow = #Null
FreeEntity_(Being\DelayedBlow\Projection) 
FreeEntity_(Being\DelayedBlow\TPiv) ; Тоже освобождаем.
Being\DelayedBlow = #Null
EndIf
EndMacro

Macro StoreCell(CellNum) ; Partializer
System\Players(System\Level\CurrentPlayer)\Store[CellNum]
EndMacro 

Procedure DrainEnergy(*Victim.Being, Amount.i, DelayScripting = #False)
Protected CP = System\Level\CurrentPlayer 
With *Victim
If Amount = #All Or Amount > \EnergyLevel : Amount = \EnergyLevel : EndIf
\EnergyLevel - Amount
If \Owner : System\Players(\Owner)\TotalEnergy - Amount : EndIf
If \EnergyLevel = 0 
; -Kill being-
HLSquare(\Square, #SNone, #False)
FreezeAnim(*Victim)
PostScriptum(*Victim)
ClearBlow(*Victim)
\State = #BDying
If \StoreLink <> #NoLink : StoreCell(\StoreLink) = #Null : \StoreLink = #NoLink : EndIf ; Удаляем привязку к клавише.
If System\Players(CP)\IType <> #IHuman And (Enemies(*Victim\Owner, System\Level\CurrentPlayer) Or MindInfected(*Victim))
If Sacrificer(*Victim) : SetDanger(*Victim, #True) : EndIf : EndIf
If DelayScripting = #False : MarkMinimap(*Victim) : EndIf
If \Owner : Add2BeingsCount(\Owner, -1) : EndIf ; Decrese owner's beings count.
Else
If DelayScripting = #False : ScriptTable(*Victim) : EndIf
EndIf
System\Level\ChannelsExamination = #True
EndWith
ProcedureReturn Amount
EndProcedure

Procedure AddEnergy(*Being.Being, Amount)
With *Being
\EnergyLevel + Amount
If \Owner : System\Players(\Owner)\TotalEnergy + Amount : EndIf
EndWith
EndProcedure

Procedure ActivateBeing(*Being.Being)
With *Being
\State = #BActive
If \Square\State = #SNone
HLSquare(\Square, #SActiveBeing, #False)
EndIf
MarkMiniMap(*Being)
EndWith
EndProcedure

Procedure VizualizeReincarnation(*Square.Square, Fake = #False)
Define *RE.ReincEffect
AddElement(System\GUI\ReincEffects()) : *RE = System\GUI\ReincEffects()
With *RE
\Fake = Fake
\TubeEntity = CreateCylinder_(20, #False, #Null) : SetOn(\TubeEntity, *Square\Entity)
If \Fake = #False : EntityFx_(\TubeEntity, 1+16) : Else : EntityFx_(\TubeEntity, 16) : EndIf
If Fake : EntityTexture_(\TubeEntity, System\FakeReincarnationTubeTex)
Else : EntityTexture_(\TubeEntity, System\ReincarnationTubeTex)
EndIf
\TubeFrame = 0.5
\Position\X = *Square\ArrayPos\X
\Position\Y = *Square\ArrayPos\Y
EndWith
ProcedureReturn *RE
EndProcedure

Procedure StartReincarnation(*Being.Being)
With *Being
If \ReincarnationCost = #All
VizualizeReincarnation(\Square, #True)
Else : VizualizeReincarnation(\Square)
EndIf : DeActivateBeing(*Being)
\State = #BRecarn : FreezeAnim(*Being)
ComplexEntityColor(\Entity, 0, 0, 0)
EndWith
System\GUI\SelectedBeing = #Null
EndProcedure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure LinkBeing(*Being.Being, LinkNum)
With *Being ; Всестороняя обработка.
If *Being ; Если мы линкуем не ноль.
Select \StoreLink ; Действуем по ситуации.
Case #NoLink : If StoreCell(LinkNum) : StoreCell(LinkNum)\StoreLink = #NoLink : EndIf
Case LinkNum : ProcedureReturn ; Не требуется, просто из процедуры выходим.
Default ; Нужен обмен групп - самое глючное (обычно)...
Swap StoreCell(LinkNum), StoreCell(\StoreLink) ; Обмен указателей. А теперь и номеров:
If StoreCell(\StoreLink) : StoreCell(\StoreLink)\StoreLink = \StoreLink : EndIf
EndSelect : \StoreLink = LinkNum    ; Релинковка. Ну а если мы линковали 0...
ElseIf StoreCell(LinkNum) : StoreCell(LinkNum)\StoreLink = #NoLink ; Обнуление.
EndIf : StoreCell(LinkNum) = *Being ; На всякий случай.
EndWith
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Procedure ReincarnateBeing(*Being.Being)
Define Type, EnergyLevel, Owner, State
Define *NewCell, *Platform
With *Being
EnergyLevel = \EnergyLevel
Owner = \Owner
State = \State
Select \Type
Case #BSpectator : Type = #BJustice
Case #BSentry    : Type = #BSentinel
Case #BMeanie    : Type = #BHunger
Case #BIdea      : Type = #BJinx
Case #BSociety   : Type = #BDefiler
Case #BEnigma    : Type = #BAmgine
Case #BAmgine    : Type = #BEnigma
EndSelect
If \ReincarnationCost <> #All
*Platform = GetParent_(\Square\Entity)
Select \Square\CellType ; Выбираем тип покраски...
Case #pVanilla  : ExchangeEntity(*Platform, System\PlatformGold)
Case #pElevator : *NewCell = ExchangeEntity(*Platform, System\ElevatorGold)
ComplexEntityTexture(GetChild_(*NewCell, 1), System\CellGoldTex)
EndSelect
\Square\Gold = #True
ClearBlow(*Being)
If System\GUI\SelectedBeing And System\GUI\SelectedBeing\Ascended And System\GUI\SelectedBeing\ExtraMode
If \Square\State <> #SActiveBeing : HLSquare(\Square, #SNone) : EndIf : EndIf
EndIf
If State = #BRecarnPreparing And System\Level\CurrentPlayer = \Owner : State = #BPreparing
Else : State = #BBorning
EndIf
Define Link = \StoreLink
Define *Square = \Square : DestroyBeing()
*Being = CreateBeing(*Square, Type, 0, State, EnergyLevel)
If Link <> #NoLink : LinkBeing(*Being, Link) : EndIf
\Owner = Owner
MarkMiniMap(*Being)
ScriptTable(*Being)
System\Level\ChannelsExamination = #True
EndWith
ProcedureReturn *Being
EndProcedure

Procedure DestroyReincEffect()
Define *RE.ReincEffect = System\GUI\ReincEffects()
With *RE
FreeEntity_(\TubeEntity)
EndWith
DeleteElement(System\GUI\ReincEffects())
EndProcedure

Procedure AnimateReincarnation(*RE.ReincEffect) ; Доделать !
#RTubeStep = 0.5
#RTubeFinalFrame = #CellSize / 1.25
#RTubeCollapse = 10
Define TubeStep.F, FinalFrame, TC
With *RE
TurnEntity_(\TubeEntity, 0, 5, 0)
TranslateEntity_(\TubeEntity, 0, 2, 0)
If \TubeCollapsing : TubeStep = -#RTubeStep : FinalFrame = #RTubeStep
Else : TubeStep = #RTubeStep : FinalFrame = #RTubeFinalFrame : EndIf
TC = \TubeCollapsing
If (\TubeFrame < FinalFrame And TC < #RTubeCollapse) Or (\TubeFrame > FinalFrame And TC = #RTubeCollapse)
ScaleEntity_(\TubeEntity, \TubeFrame, #TenInfinity, \TubeFrame)
EntityAlpha_(\TubeEntity, (\TubeFrame / #RTubeFinalFrame) - 0.05)
\TubeFrame + TubeStep
Else
If \TubeCollapsing = #RTubeCollapse
DestroyReincEffect()
Else : \TubeCollapsing + 1
EndIf
EndIf
EndWith
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure RegisterTable(*Being.Being)
Define *Table.Table
With *Being
If System\Level\WaitForFinish = 0 And System\Options\DisplayTables
If EntityInView_(\EyePoint, System\Camera)
; -Setup table-
AddElement(System\GUI\TablesOnScreen()) : *Table = System\GUI\TablesOnScreen()
CameraProject_(System\Camera, TakeX(\EyePoint), TakeY(\EyePoint), TakeZ(\EyePoint))
*Table\ScreenPos\X = ProjectedX_()
*Table\ScreenPos\Y = ProjectedY_()
*Table\ZOrder = EntityDistance_(System\Camera, \EyePoint)
*Table\Image = \Table : *Table\Momentum = -1
; -Frame around-
If *Being = System\GUI\SelectedBeing : *Table\Attention = \Owner 
ElseIf \State = #BActive ; Ставим вортекс.
If MindInfected(*Being) : *Table\Momentum = \Momentum >> #MomentShift
*Table\Momentum = #Mirror - \Momentum >> #MomentShift ; ...или стандартные цвета:
Else : *Table\Momentum = *Being\Owner * #MaxMomentum + (\Momentum >> #MomentShift) 
*Table\Mirror = (*Being\Owner) * #MaxMomentum - (\Momentum >> #MomentShift) + #Mirror
EndIf
EndIf
If *Table\Attention = 0 : *Table\InfPoints = \Infection : EndIf
If *Being\StoreLink<>#NoLink : *Table\StoreRem = (\Owner - 1) * #StoreCells + \StoreLink + 1
If *Table\Attention : *Table\Attention + #MaxPlayers : EndIf ; Специальная рамка.
EndIf
; -Check for Reincarnation Mark-
If CanReincarnate(*Being) And \ReincarnationCost <> #All 
*Table\RMark = #True : Else : *Table\RMark = #False
EndIf
EndIf
EndIf
EndWith
EndProcedure

Procedure EnablesReincarnation(*Being.Being, Factor) ; For AI
If CanReincarnate(*Being) = #False And CanReincarnate(*Being, Factor) : ProcedureReturn #True : EndIf
EndProcedure

Procedure EnablesSpawning(*Being.Being, Factor) ; For AI
If CanSpawn(*Being) = #False And CanSpawn(*Being, Factor) : ProcedureReturn #True : EndIf
EndProcedure

Macro Unrecarned() ; Partializer.
Mode<>2 And *Being\Reincarnated=#False
EndMacro

Procedure CheckDeadlyDanger(*Being.Being, *Square.Square, Mode = 0, Factor = 0)
; Mode = 0 ; Стандартная проверка.
; Mode = 1 ; Проверка по полной энергии.
; Mode = 2 ; Проверка на будущую реинкарнацию.
With *Square
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If Not Unfreezable(*Being) ; Если Сущность вообще может быть заморожена...
Define FactorEx = *Being\SpawningRange * *Being\SpawningRange
If Random(\Frozers*FactorEX)>\Frozers And UnRecarned() And Not WillBeIgnorant(*Being,*Square)
ProcedureReturn #True : ElseIf \AdvFrozers : ProcedureReturn #True ; Да, заморозка - это плохо.
ElseIf Random(\Biters*FactorEX)>\Biters    : ProcedureReturn #True ; Frostbite'ы - тоже.
EndIf
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If *Being\Reincarnated And \iKills[*Being\Type - #BJustice] : ProcedureReturn #True : EndIf
Define EL = *Being\SpawningCost
If EL = #All Or Mode : EL = *Being\EnergyLevel : EndIf
EL + Factor
If *Being\Reincarnated Or WillBeIgnorant(*Being, *Square) Or Mode = 2
If \DangerLevel4Reincarnates >= EL Or \AdvInstantAbsorbers : ProcedureReturn #True : EndIf 
ElseIf \DangerLevel >= EL Or \InstantAbsorbers             : ProcedureReturn #True
EndIf
EndWith
EndProcedure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro CheckScore(XShift, YShift) ; Partializer.
If PeekHeight(X + XShift, Y + YShift) = Height ; Начинаем.
Define *VBeing.Being = Squares(X + XShift, Y + YShift)\Being
If *VBeing And Existing(*VBeing,#False) And *VBeing\Owner And *VBeing\Frozen<=#MeanFreeze And Not Unfreezable(*VBeing)
If Enemies(*VBeing\Owner, Owner) : Score + 1 : Else : Score - 1 : EndIf
EndIf : EndIf
EndMacro

Procedure BiteScore(*Bite.Being, Owner)
Define Score
PrepareScoring(*Bite)
CheckScore(1, 0)  : CheckScore(0, 1)
CheckScore(-1, 0) : CheckScore(0, -1)
ProcedureReturn Score
EndProcedure

Macro FrostCalc()
Define OldScore, Score = BiteScore(*Victim, *Absorber\Owner)
If Score > 0 And *OldFavorite\Type = #BFrostBite
OldScore = BiteScore(*OldFavorite, *Absorber\Owner)
If Score > OldScore : ProcedureReturn #True : Else : ProcedureReturn #False : EndIf
ElseIf Score > 3 And Random(1) : ProcedureReturn #True
Else : ProcedureReturn #False
EndIf
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Procedure CheckFavorite(*Absorber.Being, *Victim.Being, *OldFavorite.Being, Inf, Sacr) ; For AI
Define AbsorbtionCount
If *Victim\Type = #BFrostBite : FrostCalc() : EndIf
With *Absorber
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If Sacr=#False And \Ascended And *Victim\Reincarnated ; Полетят клочки по закоулочкам...
If \Hatred = *Victim\Type : AbsorbtionCount = #All : Else : AbsorbtionCount = \AbsorbtionCount * 2 : EndIf
Else ; Все как обычно:
If Sacr=#False And (*Victim\Reincarnated Or Ignorant(*Victim)) And (\Reincarnated=#False And \Type<>#BEnigma)
If \AbsorbtionCount = #All ; Если должны взять все....
AbsorbtionCount  = #AllReplacer                   ; ...Берем не все.
Else : AbsorbtionCount = \AbsorbtionCount / 2     ; ...Иначе берем половину.
EndIf
Else : AbsorbtionCount = \AbsorbtionCount         ; Берем как положено.
EndIf
EndIf ; Продолжаем наши расчеты:
If AbsorbtionCount <> #All ; Если не должны взять все...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If (CanBeInfected(*Victim) And MindInfected(*Victim) = #False) Or Inf = #False
If MindInfected(*OldFavorite) = #True And Inf : ProcedureReturn #True
Else ; ...Если инфекция не рассматривается....
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If Sacr = #False : If *OldFavorite\Type = #BFrostBite And (BiteScore(*OldFavorite.Being, \Owner) < 4 Or Random(1))
ProcedureReturn InInterval(*Victim\EnergyLevel, AbsorbtionCount, *OldFavorite\EnergyLevel) : EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ElseIf Sacrificer(*Victim) = #False ; Поиск оптимальной цели для передатчиков энергии:
; ------------------------------------------
Define F = \AbsorbtionCount ; Дабы укоротить формулы.
If EnablesReincarnation(*Victim, F) And CheckDeadlyDanger(*Victim, *Victim\Square, 2, F) = #False
ProcedureReturn #True : EndIf ; Скажем "да", если цель может реинкарнировать.
If CheckDeadlyDanger(*Victim, *Victim\Square, 1, F) = #False And EnablesReincarnation(*OldFavorite, F) = #False
If EnablesSpawning(*Victim, F) : ProcedureReturn #True ; Скажем "да", если поможем размножению.
ElseIf EnablesSpawning(*OldFavorite, F) = #False And *Victim\ReincarnationCost > 0
F = *OldFavorite\ReincarnationCost - *OldFavorite\EnergyLevel ; Пересчет.
If *OldFavorite\ReincarnationCost <= 0 Or *Victim\ReincarnationCost - *Victim\EnergyLevel < F
ProcedureReturn #True ; Скажем "да", если поможем реинкарнации.
EndIf
EndIf
EndIf
; ------------------------------------------
EndIf
EndIf
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ElseIf *Victim\EnergyLevel > *OldFavorite\EnergyLevel : ProcedureReturn #True
EndIf
EndWith
EndProcedure

Procedure SelectBeing(*Being.Being)
System\GUI\SelectedBeing = *Being : FullHL(*Being) : SetupGhost(*Being)
EndProcedure

Procedure CryoGas(*Source.Square, Advanced = #False)
Define *Shiver.Shiver, I, Factor = Advanced + 1
With *Shiver
For I = 1 To 200 : SpawnShiver(*Shiver)
TranslateEntity_(\Entity, CellRandom(), Random(10), CellRandom())
RotateEntity_(\Entity, (Random(30) - 15), 0, (Random(30) - 15))
\Latency = Random(#CryoTime)
If Advanced : \Speeder = 0.5 : EndIf
Next I
If Advanced ; Если еще нужно кольцо...
For I = 1 To 200 : SpawnShiver(*Shiver)
RotateEntity_(\Entity, 0, Random(360), 0)
MoveEntity_(\Entity, 0, Random(20), #CellSize / 2)
\Latency = #CryoTime / 4
Next I
EndIf
EndWith
EndProcedure

Procedure GasCrest(*Source.Square, Target = 0)
Define *Shiver.Shiver, I, Dir, Advanced
For Dir = 0 To 3 ; По сторонам...
For I = 1 To 250 : SpawnShiver(*Shiver)
RotateEntity_(*Shiver\Entity, 90, 0, Dir * 90 + Random(50) - 25)
If I > 75 : EntityParent_(*Shiver\Entity, *Source\FVortex) 
*Shiver\Parented = 1 : *Shiver\Parent = *Source\ArrayPos
TurnEntity_(*Shiver\Entity, 0, 0, 0) : EndIf
TranslateEntity_(*Shiver\Entity, 0, Random(20) + 10, 0)
*Shiver\Latency = Random(I / 250.0 * 5) : *Shiver\Speeder = 0.5
Next I
Next Dir
If Target = #BHunger ; Если имеем дело с любимым...
For Dir = 1 To 4 ; Еще раз по сторонам....
For I = 1 To 100 : SpawnShiver(*Shiver)
RotateEntity_(*Shiver\Entity, 0, Dir * 90 - 45, 0)
EntityAlpha_(*Shiver\Entity, 0) : *Shiver\Latency = Random(I % 10)
MoveEntity_(*Shiver\Entity, 0, 0, I / 100.0 * #HalfCell)
RotateEntity_(*Shiver\Entity, 0, 0, 0)
Next I
Next Dir
Else ; Просто небольшой столбик газа:
For I = 1 To 50 : SpawnShiver(*Shiver)
TranslateEntity_(*Shiver\Entity, CellRandom(), Random(10), CellRandom())
RotateEntity_(*Shiver\Entity, (Random(30) - 15), 0, (Random(30) - 15))
*Shiver\Latency = Random(10)
Next I
EndIf
EndProcedure

Macro EnableLayer(Being, Layer) ; Psuedo-procedure.
Select Being\Layer#Blink
Case 0 : Being\Layer#Blink = 1 ; Если щит не активен - активируем.
Case 1 To #HalfBlink        ; NOP. Иначе сбрасываем обратно:
Case #HalfBlink + 1 To #MaxBlink : Being\Layer#Blink - #HalfBlink
EndSelect
EndMacro

Procedure FancyBlow(*Square.Square) ; Pseudo-procedure.
#TCorner = #HalfCell * 0.72
With *Square ; Обработка.
\Projection = CopyEntity_(System\Projection, \FVortex)
EntityAlpha_(GetChild_(\Projection, CountChildren_(\Projection)), #GlimLight)
SetOn(\Projection, \Entity) ; Раз.
\Projection2 = CopyEntity_(System\Projection, \Projection)
SetOn(\Projection2, \Entity) ; Два.
Define *Tube = GetChild_(\Projection2, CountChildren_(\Projection2))
RotateEntity_(\Projection2, 0, EntityYaw_(\Projection, 1), 0, 1)
\Tube = *Tube : \TPiv = CreatePivot_(\Entity)
*Tube = CopyEntity_(\Tube, \TPiv) : Seton(*Tube, \TPiv) : TranslateEntity_(*Tube, #TCorner , #TallInfinity, #TCorner)
*Tube = CopyEntity_(\Tube, \TPiv) : Seton(*Tube, \TPiv) : TranslateEntity_(*Tube, -#TCorner, #TallInfinity, -#TCorner)
*Tube = CopyEntity_(\Tube, \TPiv) : Seton(*Tube, \TPiv) : TranslateEntity_(*Tube, -#TCorner, #TallInfinity, #TCorner)
*Tube = CopyEntity_(\Tube, \TPiv) : Seton(*Tube, \TPiv) : TranslateEntity_(*Tube, #TCorner , #TallInfinity, -#TCorner)
HideEntity_(\Projection2) : HideEntity_(\TPiv)
EndWith
EndProcedure

Procedure BlowSquare(*Square.Square)
AddElement(System\GUI\BlownSquares())
Define *DBlow.DBlow = @System\GUI\BlownSquares()
*DBlow\Square = *Square : *DBlow\ArrayPos = *Square\ArrayPos
ShowEntity_(*Square\Projection2) : ShowEntity_(*Square\TPiv)
ProcedureReturn *DBlow
EndProcedure

Procedure SpawnShard(Color, MaxFrame = #ShardTime, Fade = #ShardFade)
Define *Shard.Shard ; Аккумулятор.
AddElement(System\GUI\Shards())
*Shard = @System\GUI\Shards()
With *Shard ; Обработка...
\Entity = CopyEntity_(System\ShardMesh) : \Color = Color
\Layer1 = GetChild_(\Entity, 1) : \Layer2 = GetChild_(\Layer1, 1)
\MaxFrame = MaxFrame : \FadeEdge = MAxFrame - Fade
Select Color ; в зависимости от цвета...
Case 1 To #Everything : EntityTexture_(*Shard\Layer2, System\CryoTex)
EntityTexture_(*Shard\Layer1, System\CryoTex)
If Color > #MeanFreeze : ComplexEntityFX(\Entity, 1+16) : EndIf
Default ; Стандартная окраска.
EntityColor_(\Layer1, Red(Color), Green(Color), Blue(Color)) : Color = ~Color
EntityColor_(\Layer2, Red(Color), Green(Color), Blue(Color))
EndSelect ; Ставим вращательные моменты:
If Random(1) : \XFactor = 5 : Else : \XFactor - 5 : EndIf
If Random(1) : \YFactor = 5 : Else : \YFactor - 5 : EndIf
If Random(1) : \ZFactor = 5 : Else : \ZFactor - 5 : EndIf
ProcedureReturn *Shard
EndWith
EndProcedure


Procedure FinishingBlow(*Absorber.Being, *Victim.Being)
If *Absorber\ExtraMode = #False
With *Victim ; Работаем с оппонентом.
Select \Type ; Выбираем по типу.
Case #BJustice : FancyBlow(\Square) : BlowSquare(\Square) : HideEntity_(\Square\Projection) ; Лучи.
Case #BJinx : Define I, ToFix = 300 : For I = 1 To ToFix ; Создаем осколки.
Define *Shard.Shard = SpawnShard(-Random(#White), #ShardTime/2.75, 5) : SetOn(*Shard\Entity, \Square\Entity) 
RotateEntity_(*Shard\Entity, -90, Random(4)-2, Random(4)-2) ; Летят вверх. Фонтаном.
MoveEntity_(*Shard\Entity,CellRandom()*1.5, CellRandom()*1.5,Random(10) - 5)
EntityParent_(*Shard\Entity, \Square\FVortex) : ComplexEntityFx(*Shard\Entity, 1+16)
*Shard\Parented = 2 : *Shard\Parent = \Square\ArrayPos ; Пишем флаги.
*Shard\Speeder = 2.75 : *Shard\Latency = Rnd(#ShardTime / 2) : HideEntity_(*Shard\Entity)
Next I
EndSelect
EndWith
EndIf
EndProcedure

Procedure AbsorbBeing(*Absorber.Being, *V.Being)
Define Absorbed, DrainAmount, *Channel.Channel, I, Factor
With *Absorber
RotateEntity_(\Entity, 0, 0, 0)
TurnBeing(*Absorber, DeltaYaw_(\Entity, *V\Square\Entity) - 180)
\Flash = #MaxFlash ; Эффект вспышки от абсорбции.
If \Type = #BMeanie And *V\Reincarnated = #False And Not (Ignorant(*V) Or Unfreezable(*V)) ; Check for Meanie frozing.
ApplyFroze(*V, #MeanFreeze)
ElseIf \Type = #BHunger And Not Unfreezable(*V) : ; Check for Hunger's deep frozing.
ApplyFroze(*V, 13)
ElseIf \Type = #BDesire ; Check for Desire's wide frozing.
WideFroze(*V, #MeanFreeze)
ElseIf \Type = #BSociety And \Channels < #MaxChannels And CanBeInfected(*V, #True) ; Check for Society's channel injection.
ApplyChannel(*V, *Absorber)
ElseIf \Type = #BDefiler And \Channels < #DefMaxChannels And CanBeInfected(*V, #True) ; Check for Defiler's channel injection.
ApplyChannel(*V, *Absorber, #True)
EndIf
If \Type = #BMEanie      : CryoGas(*V\Square) 
ElseIf \Type = #BHunger  : CryoGas(*V\Square, #True) 
ElseIf \Type = #BDesire And *V\Type <> #BFrostBite : GasCrest(*V\Square, *V\Type)
EndIf
; --Инфекционная зона--
If CanBeInfected(*V)
If \InfChannels => #EpidemiaStart : Factor = #EpidemiaStart / 2
ElseIf \Infchannels > 1 : Factor = 1
Else : Factor = 0
EndIf
; ^Если есть инфекционные каналы и жертва может быть инфицировна, принадлежа при этом другому игроку...^
ForEach System\Channels()
If Factor = 0 : Break : EndIf
*Channel = System\Channels()
If *Channel\Advanced And *Channel\Source = *Absorber And *Channel\Destination\Owner <> *V\Owner
; ^Если инфекционный канал найден и пригоден...^
; Переносим канал.
CloseChannel() : Define *Dest = *Channel\Destination
ApplyChannel(*V, *Dest, #True) : Factor - 1
EndIf
Next
EndIf
; Собственно, перекачка.
DeActivateBeing(*Absorber)
If Sacrificer(*Absorber) = #False
If *V\Reincarnated And *Absorber\Ascended ; Если у нас конфлект принципов...
If *V\Type = *Absorber\Hatred : DrainAmount = #All : FinishingBlow(*Absorber, *V) 
Else : DrainAmount = \AbsorbtionCount * 2 : EndIf ; Просто лупим в 2 раза сильнее.
EnableLayer(*V, Shocker) : *V\LockDown = 2        ; ...И ломаем оптику.
Else ; Иначе продолжаем как обычно:
If (*V\Reincarnated Or Ignorant(*V)) And (\Reincarnated = #False And \Type <> #BEnigma)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If *V\Shield ; Кидаем на щит, если есть.
EnableLayer(*V, Shield) : EndIf ; Продолжаем транзакцию:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If \AbsorbtionCount = #All
DrainAmount = #AllReplacer
Else : DrainAmount = \AbsorbtionCount / 2
EndIf
Else : DrainAmount = \AbsorbtionCount
EndIf
EndIf
Absorbed = DrainEnergy(*V, DrainAmount)
AddEnergy(*Absorber, Absorbed)
SendEnergy(*V\Square, \Square, Absorbed)
ScriptTable(*Absorber)
Else
Absorbed = DrainEnergy(*Absorber, \AbsorbtionCount)
AddEnergy(*V, Absorbed)
SendEnergy(\Square, *V\Square, Absorbed)
ScriptTable(*V)
EndIf
ScriptCounter(\Owner)
If *V\Owner And *V\Owner <> \Owner : ScriptCounter(*V\Owner) : EndIf
EndWith
System\GUI\SelectedBeing = #Null
EndProcedure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure DelayBlow(*Seer.Being, *Square.Square, Lazy = #False)
With *Seer ; Обработка Seer'а.
\BlowPos = *Square\ArrayPos
\DelayedBlow = *Square      ; X-link.
*Square\DelayedBlow = *Seer ; X-Link.
FancyBlow(*Square) ; Графика.
EndWith
If Lazy = #False ; Если не восстанавливаемся из Save'а.
DeActivateBeing(*Seer) ; Сразу снимаем действие.
System\GUI\SelectedBeing = #Null
EndIf
EndProcedure

Procedure TriggerBlow(*Seer.Being, *Target.Square)
Define *Victim.Being, TmpR
BlowSquare(*Target) ; Сразу ставим анимацию.
If *Target\Being : *Victim = *Target\Being
If *Victim\State <> #BDying ; Если там еще что-то есть...
If (*Victim\State = #BRecarn Or *Victim\State = #BRecarnPreparing) And Not isEnigmatic(*Victim)
*Victim\Reincarnated = #True : TmpR = #True : EndIf
AbsorbBeing(*Seer, *Victim) ; Абсорбция (наконец).
If TmpR : *Victim\Reincarnated = #False : EndIf
EndIf 
EndIf
*Seer\Flash = #MaxFlash ; Эффект вспышки.
*Seer\DelayedBlow = #Null : *Target\DelayedBlow = -1
EndProcedure

Procedure InvokeCrest(*Square.Square, Type, Angle = 0)
Define *Crest.Crest, Origin    ; Будущий символ.
AddElement(System\GUI\Crests()) : *Crest = System\GUI\Crests()
With *Crest ; Обработка.
\Entity = CopyEntity_(System\CrestMesh, GetParent_(*Square\Entity))
EntityTexture_(\Entity, BeingType2Crest(Type))
SetOn(\Entity, *Square\Entity)
TranslateEntity_(\Entity, 0, 0.1, 0)
RotateEntity_(\Entity, 90, Angle, 0)
entitycolor_(\Entity, #BrightColor, #BrightColor, #BrightColor)
\Type = Type   ; Записываем на будущее.
\X = *Square\ArrayPos\X
\Y = *Square\ArrayPos\Y
\Angle = Angle ; Кэш угла.
EndWith
ProcedureReturn *Crest
EndProcedure

Procedure SpawnFlector(*Square.Square, Type)
Define *Flector.Flector
AddElement(System\GUI\Flectors()) : *Flector = @System\GUI\Flectors()
*Flector\Entity = CopyEntity_(System\FlectorMesh, *Square\FVortex)
*Flector\ArrayPos = *Square\ArrayPos
*Flector\Type = Type
EntityTexture_(*Flector\Entity, BeingType2Flector(Type))
ProcedureReturn *Flector
EndProcedure


Procedure Flectorize(*Square.Square, Type)
#FlectorsRound = 8
#RoundPart = 360 / #FlectorsRound
Define X, Y, Factor, *Flector.Flector
Define Layer.f = 1 / Rnd(1000)
With *Flector ; Дальнейшая обработка.
For Y = 1 To 12
Factor = (#RoundPart / 2) * Y % 2
For X = 1 To #FlectorsRound
*Flector = SpawnFlector(*Square, Type)
TranslateEntity_(\Entity, 0, Y * #FlectorSize * 2.1, 0)
RotateEntity_(\Entity, 0, #RoundPart * X + Factor, 0) 
MoveEntity_(\Entity, 0, 0, #HalfCell * 1.30 + Layer)
Next X : Next Y
EndWith
EndProcedure

Procedure ColorizeExpress(*Ride.Expresso, *Entity, Mode = 0)
With *Ride
Define *Child1 = GetChild_(*Entity, 1)
Define *Child2 = GetChild_(*Entity, 2)
Define *Child3 = GetChild_(*Entity, 3)
Select Mode ; Разные варианты.
Case 0 : EntityTexture_(*Child1, \BlueTex) : EntityTexture_(*Child2, \GreenTex) : EntityTexture_(*Child3, \RedTex)
Case 1 : EntityTexture_(*Child1, \BlueTex) : EntityTexture_(*Child2, \RedTex) : EntityTexture_(*Child3, \GreenTex)
Case 2 : EntityTexture_(*Child1, \GreenTex) : EntityTexture_(*Child2, \RedTex) : EntityTexture_(*Child3, \BlueTex)
Case 3 : EntityTexture_(*Child1, \GreenTex) : EntityTexture_(*Child2, \BlueTex) : EntityTexture_(*Child3, \RedTex)
Case 4 : EntityTexture_(*Child1, \RedTex) : EntityTexture_(*Child2, \BlueTex) : EntityTexture_(*Child3, \GreenTex)
Case 5 : EntityTexture_(*Child1, \RedTex) : EntityTexture_(*Child2, \GreenTex) : EntityTexture_(*Child3, \BlueTex)
EndSelect
EndWith
EndProcedure

Procedure SpawnExpress(*Target.Being, *Destination.Being, Mode)
Define *Ride.Expresso : AddElement(System\Rides())
*Ride = System\Rides() ; Ситаем новосозданное....
With *Ride ; Обработка экспресса.
\ColorMode = Mode ; Режим раскраски.
\TBeing = *Target : \DBeing = *Destination
\RedTex   = CloneTexture(System\RedTex)
\BlueTex  = CloneTexture(System\BlueTex)
\GreenTex = CloneTexture(System\GreenTex)
ScaleTexture_(\RedTex,   0.25, 1 / #ExpressSize)
ScaleTexture_(\BlueTex,  0.25, 1 / #ExpressSize)
ScaleTexture_(\GreenTex, 0.25, 1 / #ExpressSize)
*Target\GonnaRide = #True : *Destination\GonnaRide = #True
\SourcePos = *Target\Square\ArrayPos
\DestPos   = *Destination\Square\ArrayPos
\In  = CopyEntity_(System\ExpressMesh) : SetOn(\In,  *Target\Square\Entity)
\Out = CopyEntity_(System\ExpressMesh) : SetOn(\Out, *Destination\Square\Entity)
ColorizeExpress(*Ride.Expresso, \In, Mode) : ColorizeExpress(*Ride.Expresso, \Out, Mode)
TranslateEntity_(\In, 0, -500, 0) : RotateEntity_(\Out, 180, 0, 0)
TranslateEntity_(\Out, 0, 600, 0)
EndWith
ProcedureReturn *Ride
EndProcedure

Procedure Vertoposition(*Being1.Being, *Being2.being)
With *Being1 ; Просто для удобства.
Swap \X, *Being2\X ; X-позиция.
Swap \Y, *Being2\Y ; Y-позиция.
SetOn(\Entity, *Being2\Square\Entity)
SetOn(*Being2\Entity, \Square\Entity)
Swap \Square\Being, *Being2\Square\Being
Swap \Square, *Being2\Square
EndWith
EndProcedure

Macro SureTroop(TBeing) ; Pseudo-procedure.
(ParaTroop(TBeing) And TBeing\Interstate = #False)
EndMacro

Procedure RidingFlex(*Target.Being, Flag = #False)
If Flag Or Not SureTroop(*Target)
If *Target\Ascended : Flectorize(*Target\Square, *Target\Type)
Else : Flectorize(*Target\Square, -1)
EndIf
EndIf
EndProcedure

Procedure GoNNaRide(*Target.Being, *Destination.Being)
HLSquare(*Destination\Square, #SNone, #False)
HLSquare(*Target\Square     , #SNone, #False)
InvokeCrest(*Target\Square, #BParadigma)
InvokeCrest(*Destination\Square, #BParadigma)
RidingFlex(*Destination) ; Компрессор (стандарт или нет).
If *Destination\Type<>#BParadigma Or Enemies(*Target\Owner,*Destination\Owner):DeActivateBeing(*Target):EndIf 
Define *Ride.Expresso = SpawnExpress(*Target, *Destination, Random(5))
If Not SureTroop(*Destination) : *Ride\Compressed = #True : EndIf
System\GUI\SelectedBeing = #Null
EndProcedure

Macro DestroyExpress() ; Pseudo-procedure.
FreeEntity_(System\Rides()\In)
FreeEntity_(System\Rides()\Out)
FreeTexture_(System\Rides()\RedTex)
FreeTexture_(System\Rides()\GreenTex)
FreeTexture_(System\Rides()\BlueTex)
DeleteElement(System\Rides())
EndMacro

Procedure Activing(*Being.being)
If *Being\State = #BActive And *Being\Square\State = #SNone:HLSquare(*Being\Square, #SActiveBeing, #False)
ElseIf *Being\State = #BINActive And *Being\Square\State = #SActiveBeing:HLSquare(*Being\Square, #SNone, #False)
EndIf : MarkMiniMap(*Being)
EndProcedure
; ===================================================
Macro BeingAlpha(Being, AL) ; Pseudo-procedure.
ComplexEntityAlpha(Being\Entity, AL) : Being\Alpha = AL
EndMacro
; ===================================================
Procedure AnimateRide(*Ride.Expresso)
#ExpressSpeed = 12 : #ExpressTime = 110 : #RideEdge = 30
#PostRide = #ExpressTime - #RideEdge : #Pulse = 20
Define TFactor, TimeFactor.f = Abs(*Ride\Frame / #Expresstime * 2 - 1)
With *Ride ; Начинаем обрабоатку поездки. Весь комфорт:
If \Frame < #Expresstime : \Frame + 1 ; Счетчик.
BeingAlpha(\TBeing, \TBeing\StateFrame * TimeFactor)
Define Accum = \Frame % #Pulse, Pulse.f = Abs(1 - Accum / (#Pulse - 1) * 2)
Define Color1 = 72 + 128 * Pulse, Color2 = 180 - 128 * Pulse
If \Frame <= #RideEdge : Define SFactor.f = 1 - \Frame / #RideEdge
Color1 * (1 - SFactor) : Color2 * (1 - SFactor) ; Альфа.
ElseIf \Frame => #PostRide : SFactor = (\Frame - #PostRide) / #RideEdge
If \Frame >= #PostRide : \DBeing\GonnaRide = 2 : EndIf
Color1 * (1 - SFactor) : Color2 * (1 - SFactor) ; Альфа.
If \Frame = #PostRide : RidingFlex(\DBeing, \Compressed) : EndIf
Else : SFactor = 0
EndIf
If \Compressed ; И никаких компромиссов.
ScaleEntity_(\DBeing\Entity, SFactor, 1, SFactor)
ScaleEntity_(\DBeing\Vision, SFactor, 1, SFactor)
Else : BeingAlpha(\DBeing, \DBeing\StateFrame * TimeFactor)
EndIf : TimeFactor = 1 - TimeFactor
; Цвета, текстуры, музыка... А, музыка не здесь.
ComplexEntityColor(\In, Color1, Color1, Color1)
ComplexEntityColor(\Out, Color2, Color2, Color2)
PositionTexture_(\RedTex,   \Frame / 100.0, \Frame / 100.0)
PositionTexture_(\GreenTex, -\Frame / 100.0, \Frame / 100.0)
PositionTexture_(\BlueTex,  -\Frame / 100.0, -\Frame / 100.0)
MoveEntity_(*Ride\In, 0, #ExpressSpeed, 0)
MoveEntity_(*Ride\Out, 0, #ExpressSpeed, 0)
If \Frame = #ExpressTime / 2 : Vertoposition(\TBeing , \DBeing) : EndIf
Else : ; Финализация сделанного.
\TBeing\GonnaRide = #False : \DBeing\GonnaRide = #False
Activing(\TBeing) : Activing(\DBeing)
DestroyExpress()
EndIf
EndWith
EndProcedure

Macro ParaShifting(Tex, Tex2, Tex3, Tex4, Amount = *Being\Special)
PositionTexture_(Tex, Amount, Amount)
PositionTexture_(Tex2, -Amount, Amount)
PositionTexture_(Tex3, Amount, -Amount)
PositionTexture_(Tex4, -Amount, -Amount)
EndMacro

Macro FuseBite(Desire, FBite) ; Pseudo-procedure.
GoON = #True : ScriptDataBoard(Desire) : FuseGas(FBite) : Desire\Special = 1
CollapseHL() : FullHL(Desire) ; Область выделения.
SendEnergy(Desire\Square, FBite\Square, 1) ; Временное решение.
EndMacro

Procedure SpawnBeing(*Parent.Being, *TargetSquare.Square)
Define GoOn, Link, Size.f, *Child.Being, SentEnergy, *Channel.Channel
With *Parent
RotateEntity_(\Entity, 0, 0, 0)
TurnBeing(*Parent, DeltaYaw_(\Entity, *TargetSquare\Entity) - 180)
*Child = CreateBeing(*TargetSquare, \Posterity, \Owner, #BBorning)
Link = \StoreLink ; Запоминаем.
SentEnergy = DrainEnergy(*Parent, \SpawningCost)
If *Parent\State = #BDying And *Child\Type = *Parent\Type And Link <> #NoLink : LinkBeing(*Child, Link) : EndIf
If \Ascended = #False ; Если разговор не идет об Аскендантах...
SendEnergy(\Square, *Child\Square, SentEnergy)
InvokeCrest(*TargetSquare, \Posterity, (*Child\EntityYaw - 45) / 90 * 90)
ElseIf *Child\Type = *Parent\Type : Size = Min(AnimLength_(\Entity) - 1, \AnimEdge) ; Корректируем.
*Child\OnceAnim = ExtractAnimSeq_(*Child\Entity, AnimTime_(\Entity), Size, AnimSeq_(\Entity))
*Child\Temporary = AnimTime(*Parent)           ; Точка начала временной анимации.
SetAnimTime_(*Child\Entity, AnimTime(*Parent)) ; Тоже ставим.
\Transfert = #True : *Child\Transfert = #True   ; Спец. флаги.
Flectorize(*Parent\Square, *Parent\Type) : Flectorize(*Child\Square, *Child\Type)
*Child\Special = *Parent\Special : *Child\SynthCores = *Parent\SynthCores ; На всякий случай. 
ElseIf *Child\Type = #BFrostBite : FuseBite(*Parent, *Child)
EndIf ; ...Теперь стандартное развитие событий:
If GoOn = #False : System\GUI\SelectedBeing = #Null ; Снимаем выделение.
If *Parent\State <> #BDying : DeActivateBeing(*Parent) : EndIf : EndIf
AddEnergy(*Child, SentEnergy - *Child\EnergyLevel)
ScriptCounter(\Owner)
TurnBeing(*Child, \EntityYaw)
; Apply parent's channels to child.
Define SocietyFactor.F, SpawnFactor.F
If \State <> #BDying
SocietyFactor = \Channels / 2 : Round(SocietyFactor, 1)
SpawnFactor = \Channels / 2 : SocietyFactor = Int(SocietyFactor)
Else : SocietyFactor = \Channels
SpawnFactor = \Channels
EndIf
ForEach System\Channels() : *Channel = System\Channels()
If *Channel\Source = *Parent And SpawnFactor
CloseChannel()
ApplyChannel(*Child, *Channel\Destination, *Channel\Advanced)
SpawnFactor - 1
ElseIf *Channel\Destination = *Parent And SocietyFactor
CloseChannel()
ApplyChannel(*Channel\Source, *Child, *Channel\Advanced)
SocietyFactor - 1
EndIf
Next
EndWith
ScriptTable(*Child)
MarkMiniMap(*Child)
ProcedureReturn *Child
EndProcedure

Procedure CheckEscape(*Being.Being, RushMode)
Define ScanRect.Rect, X, Y, *Square.Square
With *Being
If CheckDeadlyDanger(*Being, \Square, 1) ; Если находиться на клетке опасно.
If IsEnigmatic(*Being) Or CanReincarnate(*Being) = #False Or CheckDeadlyDanger(*Being, \Square, 2)
If \SuicidalStop = #False And RushMode = #False And Rnd(3) <> 1 : ProcedureReturn #True : EndIf
EndIf
Else : \SuicidalStop = #False
EndIf
EndWith
EndProcedure

Procedure CheckOwner(*Checker.Being, *Target.Being, Inf) ; For AI
If Sacrificer(*Checker) = #False
If Enemies(*Checker\Owner, *Target\Owner) Or (MindInfected(*Target) And Inf = #False) : ProcedureReturn #True : EndIf
ElseIf Allied(*Checker\Owner, *Target\Owner) And (MindInfected(*Target) = #False Or Inf) : ProcedureReturn #True
EndIf
EndProcedure

Macro Boring(Being) ; Pseudo-procedure.
(Being\Owner = 0 And (Being\Type <> #BFrostBite Or Inf))
EndMacro

Procedure FindVictim4Absobtion(*Absorber.Being, Inf = #False) ; For AI
Define Sure, Score, ScanRect.Rect, X, Y, *FB.Being, *Favorite.Being, St, Sacr = Sacrificer(*Absorber)
; Пытаемся найти пригодного для абсорбции врага...
; Формируем зону поиска.
ScanRect\Left = *Absorber\Square\ArrayPos\X
ScanRect\Top = *Absorber\Square\ArrayPos\Y
ScanRect\Right = *Absorber\AbsorbtionRange
If ScanRect\Right = #All : ScanRect\Right = #Everything : Sure = #True : EndIf
FormRect(ScanRect)
; ...и ищем.
For Y = ScanRect\Top To ScanRect\Bottom
For X = ScanRect\Left To ScanRect\Right
; ...Если клетка попадает в область абсорбции...
If Sure Or (Abs(X - *Absorber\Square\ArrayPos\X) + Abs(Y - *Absorber\Square\ArrayPos\Y)) <= *Absorber\AbsorbtionRange
If CanAbsorb(*Absorber, Squares(X, Y)) : *FB.Being = Squares(X, Y)\Being
If *FB ; Если на ней кто-то есть...
If CheckOwner(*Absorber, *FB, Inf) And Existing(*FB) And *FB <> *Absorber
; ^Если этот кто-то - чужой или заражен...^
If *Favorite ; Если уже есть хоть одна намечаемая цель...
If Not Boring(*FB) ; Если найден НЕ нейтрал...
If Boring(*Favorite) Or CheckFavorite(*Absorber, *FB, *Favorite, Inf, Sacr)
; ^Если найденная сущность подходит для абсорбции лучше...^
*Favorite = *FB ; Изменяем намеченную цель.
EndIf
EndIf
Else : *Favorite = *FB ; Выставляем первую цель.
EndIf
EndIf
EndIf
EndIf
EndIf
Next X
Next Y ; Возвращаем результат:
If *Favorite ; Если хоть что-то нашли...
If Inf = #False :  If *Favorite\Type = #BFrostBite : Score = BiteScore(*Favorite, *Absorber\Owner)
If Score < 0  : ProcedureReturn #Null : EndIf : EndIf ; Лучше так, чем никак.
If *Favorite\Owner = 0 And *Favorite\EnergyLevel < 5 And Score = 0 And Random(1) : ProcedureReturn #False : EndIf ; На случай.
EndIf
If Sacr = #False Or Sacrificer(*Favorite) = #False : ProcedureReturn *Favorite : EndIf
EndIf
EndProcedure

Procedure FindNearestEnemy(*Seeker.Being) ; For AI
Define ScanRect.Rect, X, Y, *FB.Being, *Favorite.Being, Range, FavRange
Define *ListPos = @System\Beings()
; Перебираем весь список Сущностей...
ForEach System\Beings()
*FB.Being = System\Beings()
If *FB ; Если на ней кто-то есть...
If *FB\Owner And (Enemies(*Seeker\Owner, *FB\Owner) Or MindInfected(*FB)) ; Если эта цель подходит...
Range = Abs(*FB\Square\ArrayPos\X - *Seeker\Square\ArrayPos\X)
Range + Abs(*FB\Square\ArrayPos\Y - *Seeker\Square\ArrayPos\Y) 
; ^Определяем расстояние до найденной сущности^.
If *Favorite  ; Если уже есть хоть одна намечаемая цель...
If Range < FavRange Or Random(20) = 0 ; Если найденная цель ближе намечаемой или случайный порыв...
FavRange = Range : *Favorite = *FB ; Изменяем намеченную цель.
EndIf ; Если цели нет:
Else : FavRange = Range : *Favorite = *FB ; Выставляем первую цель.
EndIf
EndIf
EndIf
Next
ChangeCurrentElement(System\Beings(), *ListPos)
ProcedureReturn *Favorite
EndProcedure

Procedure FindNearestSquare4Spawning(*Parent.Being, *Victim.Being, RushMode) ; For AI
Define X, Y, ScanRect.Rect, *FSquare.Square
Define *Favorite.Square, Range, FavRange, *EyePoint = CreatePivot_()
Define EyePointHeight = EntityDistance_(*Parent\EyePoint, *Parent\Square\Entity)
; Формируем зону поиска...
With *Parent
ScanRect\Left = \Square\ArrayPos\X
ScanRect\Top = \Square\ArrayPos\Y
ScanRect\Right = \SpawningRange
FormRect(ScanRect)
; И ищем оптимальную позицию для переноса.
For X = ScanRect\Left To ScanRect\Right
For Y = ScanRect\Top To ScanRect\Bottom
If (Abs(X - \Square\ArrayPos\X) + Abs(Y - \Square\ArrayPos\Y)) <= \SpawningRange
*FSquare = Squares(X, Y)
If *FSquare\Being = #Null And CanVisit(*Parent, *FSquare) And (CheckDeadlyDanger(*Parent, *FSquare) = #False Or RushMode)
Range = Abs(X - *Victim\Square\ArrayPos\X) + Abs(Y - *Victim\Square\ArrayPos\Y)
If Range <= \AbsorbtionRange ; Если цель можно сразу абсорбировать с этой позиции...
; Выставляем позицию EyePoint'а.
SetOn(*EyePoint, *FSquare\Entity)
TranslateEntity_(*EyePoint, 0, EyePointHeight, 0)
If EntityVisible_(*EyePoint, *FSquare\Entity) ; Если жертва видима с этой позиции...
; Изменяем намеченую позицию и выходим из цикла поиска.
*Favorite = *FSquare
Break 2
EndIf
EndIf
If CheckDeadlyDanger(*Parent, *FSquare) = #False ; Если это не бессмысленный риск...
If *Favorite ; Если уже есть намеченная позиция...
If Range < FavRange ; Если ближе...
*Favorite = *FSquare : FavRange = Range ; Изменяем намеченную позицию.
EndIf
Else ; Если позиции нет:
*Favorite = *FSquare : FavRange = Range ; Выставляем первую позицию.
EndIf
EndIf
EndIf
EndIf
Next Y
Next X
EndWith
FreeEntity_(*EyePoint)
ProcedureReturn *Favorite
EndProcedure

Procedure NeedsReincarnation(*Being.Being, Stage = 0)
With *Being
Select Stage
Case 0 ; Перед какими-либо действиями.
Select \Type 
Case #BEnigma ; NOP
Case #BAmgine
If \EnergyLevel <= \SpawningCost Or System\Players(System\Level\CurrentPlayer)\IType <> #INormalAI
ProcedureReturn #True
EndIf
Default : ProcedureReturn CanReincarnate(*Being)
EndSelect
Case 1
; -[Reserved for future]-
EndSelect
EndWith
EndProcedure

Procedure AlphaVision(*Being.Being)
Define Factor.f = *Being\Sanity / #MaxSanity
Define HiColor = #HighVision * Factor
Define LoColor = #LowVision * Factor
EntityColor_(*Being\Vision, HiColor, LoColor, LoColor)
EntityColor_(GetChild_(*Being\Vision, 1), LoColor, LoColor, HiColor)
EntityColor_(GetChild_(*Being\Vision, 2), HiColor, LoColor, LoColor)
EntityColor_(GetChild_(GetChild_(*Being\Vision, 1), 1), LoColor, LoColor, HiColor)
EndProcedure

Macro TurnVision(Vis)
TurnEntity_(Vis, 0, 1, 0) : TurnEntity_(GetChild_(Vis, 1), 0, -2, 0)
EndMacro

Procedure ResumeAnimation(*Being.Being)
With *Being
If \OnceAnim : Animate_(\Entity, 3, 1, \OnceAnim)
Else ; Иначе стандартная анимация...
Select \Type
Case #BFrostBite : Define Mode = 2
Default          : Mode = 1
EndSelect : Animate_(\Entity, Mode, 1, \ExtraMode) : EndIf
EndWith
EndProcedure

Procedure BreakFree(*Being.Being, Amount = 50, Speeder = 0, *Parent.Being = #Null)
Define I, *Source.Square = *Being\Square, *Shiver.Shiver
Define Advanced = #False ; Dummy.
For I = 1 To Amount : SpawnShiver(*Shiver)
SetOn(*Shiver\Entity, *Being\EyePoint)
RotateEntity_(*Shiver\Entity, Random(360), Random(360), Random(360))
If *Parent : EntityParent_(*Shiver\Entity, *Parent\SpecialPart2) 
*Shiver\Parented = 3 : *Shiver\Parent = *Parent\Square\ArrayPos
EndIf : *Shiver\Speeder = Speeder
Next I
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro ParaRain(SColor, Limit = 6) ; Partializer.
Define I, ToFix = Random(Limit)
For I = 1 To ToFix ; Создаем осколки.
Define *Shard.Shard = SpawnShard(SColor)
If *Being\ExtraMode ; Искры с земли.
SetOn(*Shard\Entity, *Being\Square\Entity) 
RotateEntity_(*Shard\Entity, -90, Random(360), 0)
MoveEntity_(*Shard\Entity, 0, Random(#HalfCell / 2), Random(5))
*Shard\Speeder = 0.05
Else ; Стандартный дождь.
SetOn(*Being\SpecialPart2, *Being\SpecialPart)
SetOn(*Shard\Entity, *Being\SpecialPart) 
RotateEntity_(*Shard\Entity, 90, *Being\EntityYaw, 0)
MoveEntity_(*Shard\Entity,Random(#ShardWiden)-#HalfWiden-Random(4)*0.25, CellRandom()-3-Random(4)*0.25,-Random(5))
EndIf
If *Being\GonnaRide = #True : EntityParent_(*Shard\Entity, *Being\SpecialPart2)
*Shard\Parent = *Being\Square\ArrayPos : *Shard\Parented = 1 : EndIf
Next I
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro Colorize(Entity, Color)
EntityColor_(Entity, Red(Color), Green(Color), Blue(Color))
EndMacro

Macro UpdateDesireDesc(Desire)
If Desire\ExtraMode = #True : AddBeing2UpdateList(Desire, 0) : EndIf
If System\GUI\SelectedBeing = Desire : CollapseHL() : FullHL(Desire) : EndIf
EndMacro

Procedure UpholdCores(*Desire.Being, Factor = 1)
#SynthStep = 0.05 : #SynthFactor = 0.06 : #CoreAscend =  3
With *Desire ; Обрабатываем...
Define Alpha.f, I, ToFix = CountChildren_(\SpecialPart2) - Factor, *ThatCore
; Обработка каждого ядра. Потом некоторые претерпят изменения, но то потом.
Define  Limit = \SynthCores                 ; Для небольшого упрощения.
If \Special < 0 : Limit + 1 : EndIf         ; Корректировка. Пока так.
For I = ToFix - #MaxCores + 1 To ToFix
Define *Child = GetChild_(\SpecialPart2, I) ; Получаем указатель на ядро.
If Limit : Alpha = \StateFrame : Limit - 1  ; Делаем ядро видимым.
If Limit = 0 : *ThatCore = *Child : EndIf   ; Запоминаем последнее ядро.
Else : Alpha = 0 : EndIf                    ; Делаем ядро невидимым.
EntityAlpha_(*Child, Alpha) : EntityAlpha_(Getchild_(*Child, 1), Alpha)
ScaleEntity_(*Child, #SynthFactor, #SynthFactor, #SynthFactor)
PositionEntity_(*Child, EntityX_(*Child, 0), System\HardCore, EntityZ_(*Child, 0), 0)
Next I
; Обработка ограничителя кадров...
If \Special < 0 ; Если идет задержка с генерации нового ядра...
If \Special < -1 : \Special + 1 : Else : \Special = 0 : \SynthCores + 1 ; Обнуление таймера.
UpdateDesireDesc(*Desire) : EndIf
ElseIf \Special > 0 ; Если идет задержка с синтеза...
Define ScaleFactor.f = \Special * #SynthFactor
Define BackFactor.f  = (1 - \Special) * #SynthFactor
Define MoveFactor.f  = (1 - \Special) * #CoreAscend
ScaleEntity_(*ThatCore, ScaleFactor, #SynthFactor+BackFactor*2, ScaleFactor)
EntityAlpha_(*ThatCore, \Special) : EntityAlpha_(GetChild_(*ThatCore, 1), \Special)
MoveEntity_(*ThatCore, 0, MoveFactor, 0)         ; I like to move it !
If \Special > #SynthStep : \Special - #SynthStep ; Снижение шага.
Else : \Special = 0 : \SynthCores - 1            ; Обнуление шага.
UpholdCores(*Desire, Factor)                     ; Самовызываемся, дабы все скрыть.                            
UpdateDesireDesc(*Desire)                        ; Уточняем, да.
EndIf : EndIf
EndWith
EndProcedure

Procedure FreezeCore(*Desire.Being)
#CoreShivers = 25.0 : #CoreLat = 10 : #CoreFrame = 5
With *Desire ; Обрабатываем целевую Сущность...
\Special = -(#CryoTime - #CoreFrame + #CoreLat)
If \SynthCores > -1 ; Если там что-то есть...
Define I, *Shiver.Shiver, Advanced
Define *Source.Square = \Square, *NeededCore = GetChild_(\SpecialPart2, CountChildren_(\SpecialPart2) - #MaxCores + \SynthCores)
EndWith : With *Shiver
For I = 1 To #CoreShivers : SpawnShiver(*Shiver)
SetOn(\Entity, *NeededCore)
RotateEntity_(\Entity, (Random(20) - 10), 0, (Random(20) - 10))
\Latency = I / #CoreShivers * #CoreLat : EntityParent_(\Entity, *Desire\SpecialPart3)
\Parented = 4 : \Parent = *Desire\Square\ArrayPos : \Speeder = -1.0 : \Frame = #CoreFrame
Next I
EndIf
EndWith
EndProcedure

Procedure UpholdScrews(*Desire.Being, Forced = #False)
With *Desire ; Обрабатываем...
Define I, AFactor.f = -1, HFactor, AnimTime = AnimTimeEX(*Desire)
If \Interstate ; Если вообще требуется обработка...
If \ExtraMode = #False ; Если винты исчезают...
AFactor = \StateFrame * (1 - ((AnimTime - \AnimEdge) / 10))
If AnimTime = \AnimEdge + 15 : HFactor = 1 : EndIf ; Показать трубы.
Else ; Если винты таки появляются...
AFactor = \StateFrame * ((AnimTime - \AnimEdge - 20) / 10)
If AnimTime = \AnimEdge + 15 : HFactor = 2 : EndIf ; Скрыть трубы.
EndIf : Else ; Теперь проверяем специальные случаи...
If \ExtraMode And (Forced Or Not Existing(*Desire)) : AFactor = 0 : EndIf
If \ExtraMode And Forced : HFactor = 1 : EndIf 
EndIf ; Теперь вершим предначертанное по альфе:
If AFactor >= 0 And AFactor <= \StateFrame ; Логическая проверка.
ComplexEntityAlpha(\SpecialPart4, AFactor) : ComplexEntityAlpha(\SpecialPart5, AFactor)
EntityAlpha_(\SpecialPart2,\StateFrame) : ComplexEntityAlpha(\SpecialPart2,\StateFrame) ; Так надо.
EntityAlpha_(FindChildSafe(\Entity, "Hatchery_Blend"), \StateFrame) ; Тоже надо.
EndIf
; ...И по трубам:
If HFactor = 1     ; Если надо показать трубы...
For I = 1 To #VicHolez : ShowEntity_(FindChildSafe(\Entity, "Tubus" + RSet(Str(I), 2, "0"))) : Next I
ElseIf HFactor = 2 ; Если надо скрыть трубы...
For I = 1 To #VicHolez : HideEntity_(FindChildSafe(\Entity, "Tubus" + RSet(Str(I), 2, "0"))) : Next I
EndIf
EndWith
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure SpecialAnimation(*Being.Being)
Define LoopFlag ; Для упрощения алгоритма.
With *Being ; Обрабатываем...
If \Alpha <> System\Options\OmniAlpha  : BeingAlpha(*Being, System\Options\OmniAlpha) : EndIf
If Animating_(*Being\Entity) ; Только если анимируемся....
; Что для всех:
If \Interstate ; Специальная проверка.
If AnimTimeEX(*Being) => \AnimEdge + \Transition : TechSwitch(*Being)
Animate_(\Entity, 1, 1, \ExtraMode) : \Interstate = #False : ScriptDataBoard(*Being)
If System\GUI\SelectedBeing = *Being : CollapseHL() : FullHL(*Being) : EndIf
EndIf ; Обычная проверка.
ElseIf LoopFlag Or (\AnimEdge And AnimTimeEX(*Being) => \AnimEdge)
Animate_(\Entity, 1, 1, \ExtraMode)
EndIf
; Что не для всех:
Select \Type ; Выбор по типу.
Case #BFrostBite ; Для ледяных бомб...
Define *Parent = 0, Factor.f = Abs(AnimTime_(\Entity) - 100) / 100.0 * 0.3
ComplexEntityAlpha(\SpecialPart, 0.7 + Factor)
If \GonnaRide : *Parent = *Being : EndIf : BreakFree(*Being, 4, -0.5, *Parent)
Case #BSeer : Factor = #NoColor + #FlashDiff * Sign(Random(15))
EntityColor_(\SpecialPArt, Factor, Factor, Factor) ; Мерцаем.
PositionTexture_(\SpecialTex, Random(200) / 100.0, Random(200) / 100.0)
Case #BParadigma ; Бабочки, бабочки...
If \Special < 1 : \Special + 0.01 : Else : \Special - 1 : EndIf
ParaShifting(\SpecialTex, \SpecialTex2, \SpecialTex3, \SpecialTex4)
If \Interstate = #False Or AnimTimeEX(*Being) < \AnimEdge
Define Color, ColorPie = \AnimEdge / 4
Define AnimTime = AnimTimeEX(*Being)
Define Intense = (AnimTime % ColorPie) * 1.0 / ColorPie * #NoColor
Select AnimTime / ColorPie ; Окраска позвоночника.
Case 0 : Color = AlphaBlend(RGBA(255, 0, 255, Intense)  , #WhiteFF)
Case 1 : Color = AlphaBlend(RGBA(0, 255, 255, Intense)  , #PurpleFF)
Case 2 : Color = AlphaBlend(RGBA(255, 255, 0, Intense)  , #CyanFF)
Case 3 : Color = AlphaBlend(RGBA(255, 255, 255, Intense), #YellowFF)
EndSelect 
If \ExtraMode = #False : Colorize(\SpecialPart, Color)
If System\GUI\SelectedBeing = *Being : EntityColor_(System\ParaSpine, Red(Color), Green(Color), Blue(Color))
ParaShifting(System\RedTex, System\GreenTex, System\BlueTex, System\WhiteTex)
EndIf : EndIf : ParaRain(Color) : EndIf ; Немного дождя на грешную землю.
Case #BDesire : #TubeShivers = 25.0 : #TubeAngle = 45.0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Define ToFix, I, Advanced, *Source.Square = \Square, *Shiver.Shiver
Define AnimTime = AnimTimeEX(*Being)
If \ExtraMode = #False And AnimTime <= \AnimEdge ; Стандартный выброс криогена.
If (AnimTime % 25) = 0 : ToFix = 75 : Else : ToFix = 3 : EndIf
For I = 1 To ToFix
SpawnShiver(*Shiver) : SetOn(*Shiver\Entity, \SpecialPart)
RotateEntity_(*Shiver\Entity, Random(360), Random(360), Random(360))
MoveEntity_(*Shiver\Entity, 0, 4, 0)
*Shiver\Speeder = -1.5 : EntityParent_(*Shiver\Entity, \SpecialPart)
*Shiver\Parented = 2 : *Shiver\Parent = \Square\ArrayPos
Next I 
ElseIf \ExtraMode = #True And AnimTime <= \AnimEdge ; Выбросы из труб...
Define X, Y, Angle, Yaw = Animtime / \AnimEdge * 360
While X = \Power\X And Y = \Power\Y ; Дабы не повторяться....
Y = Random(7) * #TubeAngle + Yaw : X = (Random(2) - 1) * #TubeAngle : Wend
If X = 0 : Angle = -20 : Else : Angle = 10 : EndIf
For I = 1 To #TubeShivers ; Создаем выхлоп..
SpawnShiver(*Shiver) : SetOn(*Shiver\Entity, \SpecialPart)
RotateEntity_(*Shiver\Entity, X, Y, 0)
MoveEntity_(*Shiver\Entity, 0, 0, 9) : *Shiver\Speeder = -1.0
If X => 0 : PointEntity_(*Shiver\Entity, \SpecialPart) ; Выброс "по диагонали".
TurnEntity_(*Shiver\Entity, Angle + Random(20) - 10, 0, Random(20) - 10, 0)
Else : RotateEntity_(*Shiver\Entity, Random(20) - 10, 0, Random(20) - 10) : EndIf
*Shiver\Frame = 5 : *Shiver\Latency = I / #TubeShivers * 10
MoveEntity_(*Shiver\Entity, 0, -#ShiverMove, 0) : EntityAlpha_(*Shiver\Entity, 0)
EntityParent_(*Shiver\Entity, \SpecialPart)
*Shiver\Parented = 2 : *Shiver\Parent = \Square\ArrayPos
Next I
EndIf
; Дабы Ядра отображались на силуете...
If System\GUI\SelectedBeing = *Being : Swap \SpecialPart2, System\SharedHatch
UpholdCores(*Being, 0) : Swap \SpecialPart2, System\SharedHatch : EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndSelect
ElseIf *Being\OnceAnim : *Being\OnceAnim = #Null : ResumeAnimation(*Being)
ElseIf \Frozen And \Type=#BParadigma And \Extramode=#False And (\Interstate=#False Or AnimTimeEX(*Being)<\AnimEdge)
ParaRain(\Frozen, 4) ; Ледяной дождь.
EndIf
EndWith
EndProcedure

Procedure SpecialActivation(*Being.Being)
With *Being ; Обрабатываем...
Select \Type ; Не для всех.
Case #BSeer : EntityTexture_(\SpecialPart, \SpecialTex)
EndSelect
EndWith
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro LayerUpdate(Being, Layer, Additional = #False)
If Being\Layer#Blink And Being\Layer#Blink < #MaxBlink 
ShowEntity_(Being\Layer) : SetAnimTime_(Being\Layer, AnimTime_(Being\Entity))
Define Blink = #NoColor * 1.5 * (1 - Abs(Being\Layer#Blink / #MaxBlink - 0.5) * 2)
ComplexEntityColor(Being\Layer, Blink, Blink, Blink)
If Additional : PositionTexture_(Being\ShockTex, Random(200) / 100.0, Random(200) / 100.0) : EndIf
Being\Layer#Blink + 1 ; Поднимаем значение счетчика.
ElseIf Being\Layer : Being\Layer#Blink = 0 : HideEntity_(Being\Layer)
EndIf
EndMacro

Macro UpdateTransfert(Being) ; Pseudo-rocedure.
If Being\Transfert And Being\Type <> #BFrostBite
Define Factor.f = 1 * Being\StateFrame / #MaxFrame
ScaleEntity_(Being\Entity, Factor, 1, Factor)
EndIf
EndMacro

Procedure AnimateBeing(*Being.Being)
With *Being
; -State checking-
Select \State
Case #BBorning, #BPreparing
If \StateFrame >= #MaxFrame : SpecialActivation(*Being)
\Transfert = #False ; Снимаем флаг на всякий случай.
If \State = #BBorning Or System\Level\WaitForFinish
\State = #BInactive : Else : ActivateBeing(*Being)
EndIf : ResumeAnimation(*Being)
Else : \StateFrame + #FrameStep
EndIf : UpdateTransfert(*Being)
BeingAlpha(*Being, \StateFrame)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If \Transfert And \Type = #BFrostBite And \StateFrame => 0.55 : \StateFrame = #MaxFrame : EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Case #BDying
If \StateFrame <= 0.025
If \GonnaRide = #False : DestroyBeing() : EndIf : ProcedureReturn
Else : \StateFrame - #FrameStep
BeingAlpha(*Being, \StateFrame)
UpdateTransfert(*Being)
EndIf
Case #BRecarn, #BRecarnPreparing
If \StateFrame <= 0.025
*Being = ReincarnateBeing(*Being)
Else : \StateFrame - #FrameStep
BeingAlpha(*Being, \StateFrame)
EndIf
Case #BActive, #BInactive : SpecialAnimation(*Being)
EndSelect
If \Type = #BDesire : UpholdScrews(*Being) : UpholdCores(*Being) : EndIf
#BRP = #BRecarnPreparing ; Shortcut.
If \State = #BPreparing Or \State = #BBorning Or \State = #BDying Or \State = #BRecarn Or \State = #BRP
System\Level\ActivationFlag = #True ; Флаг задержки AI.
ElseIf \State = #BActive Or \State = #BInActive
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If (\Interstate And Animating_(\Entity)) Or \GonnaRide : System\Level\ActivationFlag = #True : EndIf
Define ASF : ASF = System\GUI\ASFlashing ; Небольшое сокращение.
If System\GUI\ASFlashing >= #ASMaxBrightness : ASF = #ASMaxBrightness * 2 - ASF : EndIf
If \Square\State = #SActiveBeing : EntityColor_(\Square\Entity, ASF, ASF, ASF)
ElseIf \Square\State = #SRecarn : EntityColor_(\Square\Entity, 0, ASF, ASF)
ElseIf \Square\State = #SSwitch : EntityColor_(\Square\Entity, ASF, ASF, 0)
If \Interstate = #False ; Если с настроением определились - вращаем значок.
If \ExtraMode : System\GUI\SwitchAngle + 3 : Else : System\GUI\SwitchAngle - 3 : EndIf
If System\GUI\SwitchAngle < 0 : System\GUI\SwitchAngle = 360 + System\GUI\SwitchAngle
ElseIf System\GUI\SwitchAngle > 360 : System\GUI\SwitchAngle - 360 : EndIf
RotateSprite_(System\SwitchSymbol, System\GUI\SwitchAngle) ; Разворот спрайта.
EndIf 
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If \GonnaRide = #False : RegisterTable(*Being) : EndIf
EndIf
; -Momentum update-
If \Momentum = #MaxMomentum << #MomentShift - 1 : \Momentum = 0 : Else : \Momentum + 1 : EndIf
; -Vision update-
If MindInfected(*Being) And \State <> #BDying ; Если есть заражение...
If \StoreLink <> #NoLink : LinkBeing(#Null, \StoreLink) : EndIf
If \Sanity < #MaxSanity : \Sanity + 1 : AlphaVision(*Being.Being) : EndIf 
ShowEntity_(\Vision) : TurnVision(\Vision) ; Отображение и прокрутка.
ElseIf \Sanity : \Sanity - 1 : AlphaVision(*Being.Being) : TurnVision(\Vision) 
If \Sanity = 0 : HideEntity_(\Vision) : EndIf : EndIf
; -Flash update-
If \State <> #BActive And \State <> #BInActive And \Flash : \Flash = 1 : EndIf
If \Flash = 1 : \Flash = 0 : ComplexEntityColor(\Entity, #NoColor, #NoColor, #NoColor)
ElseIf \Flash : \Flash - 1 : Define Factor.f = Abs(\Flash - #HalfFlash) / #HalfFlash
If Sacrificer(*Being) : Define LightLevel = #NoColor * Factor    ; Затемнение.
Else : LightLevel = #NoColor + #FlashDiff * (1 - Factor) : EndIf ; Засветление.
ComplexEntityColor(\Entity, LightLevel, LightLevel, LightLevel)  ; Ставим освещение.
EndIf
; -Shield update-
LayerUpdate(*Being, shield)
LayerUpdate(*Being, Shocker, #True)
EndWith
EndProcedure

Macro DestroyQuant() ; Pseudo-procedure.
FreeEntity_(System\GUI\Quants()\Entity)
DeleteElement(System\GUI\Quants())
EndMacro

Macro DestroyShiver() ; Pseudo-procedure.
FreeEntity_(System\GUI\Shivers()\Entity)
DeleteElement(System\GUI\Shivers())
EndMacro

Macro DestroyLadder() ; Pseudo-procedure.
FreeEntity_(System\GUI\Ladders()\Entity)
DeleteElement(System\GUI\Ladders())
EndMacro

Macro DestroyFlector() ; Pseudo-procedure.
FreeEntity_(System\GUI\Flectors()\Entity)
DeleteElement(System\GUI\Flectors())
EndMacro

Macro DestroySpark() ; Pseudo-procedure.
FreeEntity_(System\GUI\Sparks()\Entity)
DeleteElement(System\GUI\Sparks())
EndMacro

Macro DestroyCrest() ; Pseudo-procedure.
FreeEntity_(System\GUI\Crests()\Entity)
DeleteElement(System\GUI\Crests())
EndMacro

Macro DestroyShard() ; Pseudo-procedure.
FreeEntity_(System\GUI\Shards()\Entity)
DeleteElement(System\GUI\Shards())
EndMacro

Macro DestroyProjection() ; Pseudo-procedure.
FreeEntity_(System\GUI\BlownSquares()\Square\Projection)
FreeEntity_(System\GUI\BlownSquares()\Square\TPiv)
DeleteElement(System\GUI\BlownSquares())
EndMacro

Macro WipeSparksOut() ; Pseudo-procedure
ForEach System\GUI\Sparks() : DestroySpark() : Next
EndMacro

Procedure AnimateQuant(*Quant.Quant)
Define Translation = #QuantStep, Alpha.F
With *Quant
If \ToDestination : Translation * - 1 : EndIf
If \Frame >= #QuantFinalHeight
If \ToDestination : DestroyQuant()
Else
\ToDestination = #True
EntityParent_(\Entity, \Destination\Vortex)
SetOn(\Entity, \Destination\Entity)
RandomizeQuant(*Quant)
TranslateEntity_(\Entity, 0, #QuantFinalHeight, 0)
\Frame = 0
EndIf
Else : \Frame + #QuantStep
TranslateEntity_(\Entity, 0, Translation, 0)
\Height + Translation
Alpha = \Frame / #QuantFinalHeight
If \ToDestination = #False : Alpha = 1 - Alpha : EndIf
EntityAlpha_(\Entity, Alpha)
EndIf
EndWith
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro AnimateShiver(TShiver) ; Partializer.
#CFadeTime = #CryoTime / 3.0 : #CFadeEdge = #CryoTime - #CFadeTime
; --------------
Define *Shiver.Shiver = TShiver ; Аккумулятор.
If *Shiver\Latency : *Shiver\Latency - 1 : Else ; Ведем анимацию.
If *Shiver\Invertor = 0 And *Shiver\Frame >= #CFadeEdge
EntityAlpha_(*Shiver\Entity, (1 - (*Shiver\Frame - #CFadeEdge) / #CFadeTime) / 2)
Else : EntityAlpha_(*Shiver\Entity, Abs(*Shiver\Invertor - *Shiver\Frame / #CryoTime) / 2)
EndIf : *Shiver\Angle + 1 : RotateSprite_(*Shiver\Entity, *Shiver\Angle)
If *Shiver\Frame < #CryoTime : MoveEntity_(*Shiver\Entity, 0, #ShiverMove + *Shiver\Speeder, 0)
*Shiver\Frame + 1 : Else : DestroyShiver() : EndIf
EndIf
; --------------
EndMacro

Procedure AnimateLadder(*Ladder.Ladder)
With *Ladder ; Обработка.
If \Frame < #LadderTime ; Анимация же.
EntityAlpha_(\Entity, 0.15 * (1 - Abs(\Frame / #LadderTime - 0.5) * 2))
TurnEntity_(\Entity, 0, \Polarity * 5, 0) : \Frame + 1
Else : DestroyLadder() : EndIf
EndWith
EndProcedure

Procedure AnimateBlow(*DBlow.DBlow)
With *DBlow ; Обработка.
If \Frame < #BlowTime ; Анимация же.
Define Factor.f = (1 - Abs(\Frame / #BlowTime - 0.5) * 2)
If \Frame > #BlowTime / 2
ComplexEntityAlpha(\Square\Projection, #GlimLight * Factor)
EndIf : ComplexEntityAlpha(\Square\Projection2, 1 * Factor)
ComplexEntityAlpha(\Square\TPiv, 0.5 * Factor)
TranslateEntity_(\Square\Tube, 0, -1, 0)
TranslateEntity_(\Square\TPiv, 0, -1, 0)
Factor * 2.5 ; Для будущего масштабирования.
ScaleEntity_(\Square\Tube, 1 + Factor,#TallInfinity, 1 + Factor)
\Frame + 1 : Else : \Square\DelayedBlow = #Null : DestroyProjection()
EndIf
EndWith
EndProcedure

Procedure AnimateFlector(*Flector.Flector)
With *Flector ; Обработка.
If \Frame < #FlectorDance ; Анимация же.
EntityAlpha_(\Entity, 0.75 * (1 - Abs(\Frame / #FlectorDance - 0.5) * 2))
\Frame + 1 ; Инкремент.
Else : DestroyFlector() : EndIf
EndWith
EndProcedure

Procedure AnimateCrest(*Crest.Crest)
With *Crest
If \Frame < #CrestShine ; Анимация же.
Define Factor.f = 1 * (1 - Abs(\Frame / #CrestShine - 0.5) * 2)
EntityAlpha_(\Entity, Factor) : \Frame + 1
Else : DestroyCrest()
EndIf
EndWith
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro ShardAlpha() ; Partializer.
EntityAlpha_(*Shard\Layer1, Alpha) : EntityAlpha_(*Shard\Layer2, Alpha)
EndMacro

Procedure AnimateShard(*Shard.Shard)
With *Shard ; Обработка.
If \Frame < \MaxFrame ; Если еще нужна анимация...
If \Latency = 0 : \Frame + 1
MoveEntity_(\Entity, 0, 0, 0.75 + \Speeder)
TurnEntity_(\Layer1, \XFactor, \YFactor, \ZFactor)
If \Frame >= \FadeEdge ; Немного альфы.
Define Alpha.f = 1.0 - (\Frame - \FadeEdge) / \FadeEdge   : ShardAlpha()
ElseIf \Frame <= #ShardIntro : Alpha = \Frame / #ShardIntro : ShardAlpha()
EndIf ; Или просто убиваем:
Else : \Latency - 1 ; Снижаем задержку.
If \Latency = 0 : ShowEntity_(\Entity) : EndIf
EndIf
Else : DestroyShard()
EndIf
EndWith
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure SpawnSpark(Alternative)
Define *Spark.Spark, I
AddElement(System\GUI\Sparks()) : *Spark = System\GUI\Sparks()
With *Spark
\Alt = Alternative
If Alternative : \Entity = CopyEntity_(System\AltSparkMesh)
Else : \Entity = CopyEntity_(System\SparkMesh)
EndIf
\X = Random(System\GUI\MapWidth)
\Y = #SparkFlightStart - Random(-#SparkSpeed - 1)
\Z = -Random(System\GUI\MapHeight)
PositionEntity_(\Entity, \X, \Y, \Z)
EndWith
EndProcedure

Macro AnimateSpark() ; Pseudo-procedure
Define *Spark.Spark : *Spark = System\GUI\Sparks()
#SparksFlightDist = #SparksFadingEdge - #SparkFlightEnd ; ShortCut.
*Spark\Y + #SparkSpeed
If *Spark\Y <= #SparkFlightEnd : DestroySpark()
Else : PositionEntity_(*Spark\Entity, *Spark\X, *Spark\Y, *Spark\Z, 1)
If *Spark\Y < #SparksFadingEdge
EntityAlpha_(*Spark\Entity, (1 - (#SparksFadingEdge - *Spark\Y) / #SparksFlightDist) * #SparksAlpha)
EndIf
EndIf
EndMacro

Procedure SpreadInfection(*Being.Being)
Define Owner, *Channel.Channel, *Victim.Being
With *Being
If *Being\Owner
DeActivateBeing(*Being)
; Ищем первый канал Defiler'а...
ForEach System\Channels()
*Channel = System\Channels()
If *Channel\Advanced : Break : EndIf ; Если инфекционный канал найден - выходим из цикла.
Next
If *Channel ; Если есть, для кого стараться....
Owner = \Owner ; Запоминаем старого хозяина...
\Owner = *Channel\Destination\Owner ; Выставляем новым хозяином наложившего инфекционный канал.
*Victim = FindVictim4Absobtion(*Being.Being, #True)
\Owner = Owner ; Выставляем старого хозяина.
If *Victim : AbsorbBeing(*Being, *Victim) : EndIf ; Если жертва найдена - атакуем...
EndIf
EndIf
EndWith
EndProcedure

Procedure InfectionControl()
Protected *Being.Being, *Player.Player = System\Players(System\Level\CurrentPlayer)
If *Player\MovedBeings = 0 And System\Level\ActivationFlag = #False 
*Player\MovedBeings = 1 : EndIf
If *Player\MovedBeings
If System\Level\AIFrame >= System\Options\AIDelay ; Если сработал счетчик кадров...
System\Level\AIFrame = 0 ; Обнуляем его.
*Being = NextActiveBeing(System\Level\CurrentPlayer, #True)
If *Being
SpreadInfection(*Being)
*Player\MovedBeings + 1 
Else : *Player\MovedBeings = 0
System\Level\Infestation = #False
EndIf
Else : System\Level\AIFrame + 1 ; Инкрементируем значение счетчика кадров.
EndIf
EndIf
EndProcedure

Macro MessageBox(Title, Text, Flags = 0) ; Pseudo-procedure.
ShowPointer_() : MessageRequester(Title, Text, Flags)
EndMacro

Macro ErrorBox(Text, Title = "Erroneous activity:") ; Pseudo-procedure.
MessageBox(Title, "FAIL: " + Text, #MB_ICONSTOP)
EndMacro

Macro SetHint(NewHint) ; Pseudo-procedure.
System\Hinter = "HINT[ " + NewHint + " ]HINT"
EndMacro

Procedure SaveMap(FName.S = #AutoSave) ; Доделать !
Define AutoSave, Proj, *Square.Square, *Ptr, *Being. Being, X, Y, Header.S = #MapHeader
Define *Ride.Expresso, *Shard.Shard, *Shiver.Shiver, *Flector.Flector, *Ladder.Ladder, *ListPos
If FName = #AutoSave : AutoSave = #True
CreateDirectory(#SavesDir)
EndIf
; -Первичная подготовка к сохранению-
If CreateFile(0, FName)
WriteData(0, @Header, Len(Header))
WriteLong(0, #False) ; Game save flag.
WriteData(0, @System\Level, SizeOf(LevelData))
WriteLong(0, Len(System\Story)) ; Записать брифинг.
WriteData(0, @System\Story, Len(System\Story))
WriteLong(0, Len(System\AfterStory)) ; Запись эпилога карты.
WriteData(0, @System\AfterStory, Len(System\AfterStory))
; -Записать данных клеток-
For Y = 1 To System\Level\Height
For X = 1 To System\Level\Width
*Square = Squares(X - 1, Y - 1)
Proj = *Square\Projection
*Square\Projection = #Null
WriteData(0, @Squares(X - 1, Y - 1), SizeOf(Square))
*Square\Projection = Proj
Next X
Next Y
; Записать данных игроков.
Y = ArraySize(System\Players())
WriteLong(0, Y)
For X = 1 To Y
WriteData(0, System\Players(X), SizeOf(Player))
Next X
; Записываем данные комманд.
Y = ArraySize(System\Teams()) : WriteLong(0, Y)
For X = 1 To Y ; Пишем все.
WriteData(0, System\Teams(X), SizeOf(Team))
Next X
; Записать данные Сущностей.
WriteLong(0, ListSize(System\Beings()))
ForEach System\Beings() : *Being = @System\Beings()
*Being\SeqFrame = AnimTime(*Being)
WriteData(0, *Being, SizeOf(Being))
Next
; Записать данные квантов.
WriteLong(0, ListSize(System\GUI\Quants()))
ForEach System\GUI\Quants()
WriteData(0, System\GUI\Quants(), SizeOf(Quant))
Next
; Записать позицию камеры.
WriteLong(0, EntityZ_(System\CamPiv))
WriteLong(0, EntityX_(System\CamPiv))
WriteLong(0, EntityYaw_(System\CamPiv))
WriteLong(0, EntityDistance_(System\Camera, System\CamPiv))
; Записать позицию для выделения.
If System\GUI\PickedSquare <> #Null
WriteLong(0, EntityZ_(System\GUI\PickedSquare\Entity))
WriteLong(0, EntityY_(System\GUI\PickedSquare\Entity))
WriteLong(0, EntityX_(System\GUI\PickedSquare\Entity))
Else
WriteLong(0, EntityZ_(System\Selection))
WriteLong(0, EntityY_(System\Selection))
WriteLong(0, EntityX_(System\Selection))
EndIf
; Записать данные матрицы.
ForEach System\GUI\Matrix() : *Ptr = System\GUI\Matrix()
WriteLong(0, EntityZ_(*Ptr)) : WriteLong(0, EntityX_(*Ptr))
WriteLong(0, EntityPitch_(*Ptr)) ; Другие углы не нужны.
Next
; Записать данные каналов.
WriteLong(0, ListSize(System\Channels()))
ForEach System\Channels()
WriteData(0, System\Channels(), SizeOf(Channel))
Next
; Записать данные эффектов Перерождения.
WriteLong(0, ListSize(System\GUI\ReincEffects()))
ForEach System\GUI\ReincEffects()
WriteData(0, System\GUI\ReincEffects(), SizeOf(ReincEffect))
Next
; Записать данные дождевых искр.
WriteLong(0, System\GUI\SparksRainTimer)
WriteLong(0, ListSize(System\GUI\Sparks()))
ForEach System\GUI\Sparks()
WriteData(0, System\GUI\Sparks(), SizeOf(Spark))
Next
; Записать данные газа.
WriteLong(0, ListSize(System\GUI\Shivers()))
ForEach System\GUI\Shivers() : *Shiver = System\GUI\Shivers()
*Shiver\X = TakeX(*Shiver\Entity)
*Shiver\Y = TakeY(*Shiver\Entity)
*Shiver\Z = TakeZ(*Shiver\Entity)
*Shiver\XAngle = EntityPitch_(*Shiver\Entity, 1)
*Shiver\YAngle = EntityYaw_(*Shiver\Entity, 1)
*Shiver\ZAngle = EntityRoll_(*Shiver\Entity, 1)
WriteData(0, *Shiver, SizeOf(Shiver))
Next
; Записать данные осклоков.
WriteLong(0, ListSize(System\GUI\Shards()))
ForEach System\GUI\Shards() : *Shard = System\GUI\Shards()
*Shard\X = TakeX(*Shard\Entity)
*Shard\Y = TakeY(*Shard\Entity)
*Shard\Z = TakeZ(*Shard\Entity)
*Shard\XAngle = EntityPitch_(*Shard\Layer1, 1)
*Shard\YAngle = EntityYaw_(*Shard\Layer1, 1)
*Shard\ZAngle = EntityRoll_(*Shard\Layer1, 1)
*Shard\XDir = EntityPitch_(*Shard\Entity, 1)
*Shard\YDir = EntityYaw_(*Shard\Entity, 1)
*Shard\ZDir = EntityRoll_(*Shard\Entity, 1)
WriteData(0, *Shard, SizeOf(Shard))
Next
; Записать данные поездок.
WriteLong(0, ListSize(System\Rides()))
ForEach System\Rides() : *Ride = System\Rides()
*Ride\X = TakeX(*Ride\In)
*Ride\Y = TakeY(*Ride\In)
*Ride\Z = TakeZ(*Ride\In)
*Ride\X2 = TakeX(*Ride\Out)
*Ride\Y2 = TakeY(*Ride\Out)
*Ride\Z2 = TakeZ(*Ride\Out)
WriteData(0, *Ride, SizeOf(Expresso))
Next
; Записать данные рефлекторов.
WriteLong(0, ListSize(System\GUI\Flectors()))
ForEach System\GUI\Flectors() : *Flector = System\GUI\Flectors()
*Flector\X = TakeX(*Flector\Entity)
*Flector\Y = TakeY(*Flector\Entity)
*Flector\Z = TakeZ(*Flector\Entity)
*Flector\XAngle = EntityPitch_(*Flector\Entity, 1)
*Flector\YAngle = EntityYaw_(*Flector\Entity, 1)
*Flector\ZAngle = EntityRoll_(*Flector\Entity, 1)
WriteData(0, *Flector, SizeOf(Flector))
Next
; Записать данные лестниц.
WriteLong(0, ListSize(System\GUI\Ladders()))
ForEach System\GUI\Ladders() : *Ladder = System\GUI\Ladders()
*Ladder\Angle = EntityYaw_(*Ladder\Entity, 1)
WriteData(0, *Ladder, SizeOf(Ladder))
Next
; Записать данные символик.
WriteLong(0, ListSize(System\GUI\Crests()))
ForEach System\GUI\Crests() 
WriteData(0, System\GUI\Crests(), SizeOf(Crest))
Next
; Записать данные ударов.
WriteLong(0, ListSize(System\GUI\BlownSquares()))
ForEach System\GUI\BlownSquares()
WriteData(0, System\GUI\BlownSquares(), SizeOf(DBlow))
Next
; Закрыть файл.
CloseFile(0)
Else 
If AutoSave = #False 
ErrorBox("can't write to '" + FName + "' !", "Map saving error:")
EndIf
ProcedureReturn #False
EndIf
ProcedureReturn #True
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure CheckFrozing(*Being.Being)
Define Advanced
With *Being
If \Frozen : \Frozen - 1
AddBeing2UpdateList(*Being, MindInfected(*Being))
If \Frozen = #MeanFreeze : HalfFroze(*Being) 
ElseIf \Frozen = 0 : BreakFree(*Being)
EndIf
EndIf
If \Frozen = 0 ; Нет больше заморозки.
If \Owner : ActivateBeing(*Being) : EndIf
If Not Animating_(\Entity) : ResumeAnimation(*Being) : EndIf
If \Type = #BParadigma : ComplexEntityBlend(\Entity, 3) : EndIf
TextureBlend_(\CryoTex, 0) ; Убираем изморозь.
EndIf
; Тут же проверяем Lock-down.
If \LockDown : \LockDown - 1 ; Снижаем флаг.
AddBeing2UpdateList(*Being, MindInfected(*Being))
EndIf
EndWith
EndProcedure


Procedure CheckTimeOut()
If System\Level\TactsLimit And System\Level\CurrentTurn > System\Level\TactsLimit
ProcedureReturn #True
EndIf
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro DirectElevators() ; Partializer.
Define *Elevator.Square ; Получаем данные блока.
ForEach System\Elevators() : *Elevator = System\Elevators() ; Получаем направление:
If     *Elevator\Height = 1 : *Elevator\OwnData = #False ; Иначе вниз...
ElseIf *Elevator\Height = #MaxPlatformsScale : *Elevator\OwnData = #True
EndIf ; Теперь обрабатываем само смещение.
If *Elevator\OwnData : *Elevator\Height - 1 : Else : *Elevator\Height + 1 : EndIf
Next
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure NextTurn(SkipToActivation = #False)
If SkipToActivation = #False ; Если переход не идет от самой зоны...
Define *Being.Being, ActivateNeutrals = #False, *Channel.Channel
Define Drained, DestChans, *Link.Point
; -Select next player-
NextPlayer:
If System\Level\CurrentPlayer = ArraySize(System\Players())
If System\Level\TactsLimit : System\Level\CurrentTurn + 1 : EndIf
If CheckTimeOut() ; Если задача миссии не была достигнута вовремя...
System\Level\WaitForFinish = 1 
ProcedureReturn #True
EndIf
System\Level\CurrentPlayer = 1
ActivateNeutrals = #True
Else : System\Level\CurrentPlayer + 1
EndIf
If System\Players(System\Level\CurrentPlayer)\BeingsCount = 0 : Goto NextPlayer : EndIf
; -Channels drain & progressing-
ForEach System\Channels() : *Channel = System\Channels()
With *Channel
If (\Source\Owner = System\Level\CurrentPlayer Or (\Source\Owner = 0 And ActivateNeutrals)) And \Source\State <> #BDying
Drained = DrainEnergy(\Source, #ChannelsFlow, #True)
AddEnergy(\Destination, Drained) : DestChans = \Destination\Channels
SendEnergy(\Source\Square, \Destination\Square, Drained, #False)
AddMapElement(System\GUI\JacobsMatrix(), Str(\Source) + ":" + Str(\Destination))
*Link = System\GUI\JacobsMatrix() : *Link\X = \Source\Square : *Link\Y = \Destination\Square
If DestChans < #MaxChannels Or (DestChans < #DefMaxChannels And \Advanced) : ApplyChannel(\Source,\Destination,\Advanced*2) 
EndIf
EndIf
AddBeing2UpdateList(\Destination, #False)
AddBeing2UpdateList(\Source, #False)
If \Source\State = #BDying : \Source\NeedsTableUpdate = 2 : EndIf
EndWith
Next
; -Missing links-
ForEach System\GUI\JacobsMatrix()
*Link = System\GUI\JacobsMatrix()
AddLAdder(*Link\X) : AddLadder(*Link\Y, -1)
Next : ClearMap(System\GUI\JacobsMatrix())
; -Something about service-
If ActivateNeutrals And ListSize(System\Elevators()):System\Level\ServiceTime=#ServiceFrames:DirectElevators():EndIf
EndIf
; -Activate player's beings-
If System\Level\ServiceTime = #False ; Если есть время на глупости...
ForEach System\Beings()
*Being = System\Beings()
With *Being
If \Owner = System\Level\CurrentPlayer ; Если этот тот, кто нам нужен:
If \Type=#BDesire And \SynthCores<#MaxCores And \State<>#BDying And \Special < = 0 : FreezeCore(*Being) : EndIf
If \DelayedBlow And \Frozen <= 1 : TriggerBlow(*Being, \DelayedBlow) : EndIf ; Удар с задержкой.
If \Infection : \Infection = Min(\Infection * 2, #EpidemiaStart) : AddBeing2UpdateList(*Being, MindInfected(*Being)) : EndIf
If \State = #BInactive : CheckFrozing(*Being) 
If \State = #BActive And MindInfected(*Being) : System\Level\Infestation = #True : EndIf
EndIf
If \State = #BBorning : \State = #BPreparing : MarkMiniMap(*Being) : EndIf
Else
If \State = #BActive : DeActivateBeing(*Being) : EndIf
If \State = #BPreparing : \State = #BBorning : MarkMiniMap(*Being) : EndIf
If \State = #BRecarn : \State = #BRecarnPreparing : MarkMiniMap(*Being) : EndIf
If \Owner = 0 And ActivateNeutrals And \State = #BInactive : CheckFrozing(*Being) : EndIf
EndIf
EndWith
Next
UpdateTables()
UpdateCounters()
With System ; Последние действия по системе:
If \Options\AutoSave And \Players(\Level\CurrentPlayer)\IType = #IHuman : SaveMap() ; Auto-Saving.
Else ; Обнуляем данные ИИ:
\Players(\Level\CurrentPlayer)\MovedBeings = 0    ; Nullify counter of moved beings.
\Players(\Level\CurrentPlayer)\FirstBeing = #Null ; Reset pointer to first Being.
EndIf
EndWith 
EndIf
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Macro Enlight(Entity) ; Partializer.
SetOn(System\LightPiv, Entity)
EndMacro

Procedure DoService()
Define *Block, *Elevator.Square, Move.d, *Cube, *Node
Static *Lock ; Accumulator.
If System\GUI\PickedSquare  : *Lock = System\GUI\PickedSquare : EndIf
Define LightLevel = #NoColor + #FlashDiff * (1 - Abs(System\Level\ServiceTime - #HalfService) / #HalfService)
; -Elevators update-
ForEach System\Elevators() : *Elevator = System\Elevators() ; Анимируем элеваторы.
If *Elevator\OwnData : Move = -#ElevationStep : Else : Move = #ElevationStep : EndIf
*Cube = GetParent_(*Elevator\Entity) ; Меш самого блока.
*Node = GetChild_(*Cube, 1)          ; Меш узлов.
TranslateEntity_(*Cube, 0, Move, 0)  ; Сдвигаем блок.
If *Elevator\Being : SetOn(*Elevator\Being\Entity, *Elevator\Entity) : EndIf
If *Lock = *Elevator : SetOn(System\Selection, *Elevator\Entity) 
Enlight(*Elevator\Entity) : EndIf ; Освещение для полноты картины
TranslateEntity_(*Elevator\TubesPiv, 0, -Move, 0) ; Ставим трубы вниз.
TranslateEntity_(*Node, 0, -Move, 0)              ; Ставим узлы вниз.
EntityColor_(*Cube, LightLevel, LightLevel, LightLevel) ; Немного освещения.
ComplexEntityColor(*Node, LightLevel, LightLevel, LightLevel) ; Еще чуток.
Next : System\Level\ServiceTime - 1
If System\Level\ServiceTime = 0 : NextTurn(#True) : EndIf
EndProcedure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure ConnectionTubes(X, Y, Vert = #False)
With System
Define *Square.Square, *Tube, I, Factor, Count
Define Height = Squares(X, Y)\Height, *Etalone
If Vert : Factor = Y : Else : Factor = X : EndIf
If Factor ; Если мы не в углу....
; -Create connection tube-
If Vert : *Square = Squares(X, Y - 1) : Else : *Square = Squares(X - 1, Y) : EndIf
If *Square\CellType <> Squares(X, Y)\CellType : Count = 0 : Else : Count = Min(Height, *Square\Height) : EndIf
If *Square\CellType = #pVanilla : *Etalone = \ConnectionTube : Else : *Etalone = \Void : EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
For I = 1 To Count
*Tube = CopyEntity_(*Etalone, Squares(X, Y)\TubesPiv)
If Vert : TurnEntity_(*Tube, 0, 90, 0) 
TranslateEntity_(*Tube, 0, 0, #FullGap / 2)
Else : TranslateEntity_(*Tube, -#FullGap / 2, 0, 0)
EndIf
; -Height translation-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If *Square\CellType = #pVanilla ; стандартная корректировка
TranslateEntity_(*Tube, 0, #InfiniteCell - #HalfCell - (#CellSize * Height) + (#CellSize * I), 0)
SetupBox(*Tube, *Tube) ; Для коллизий.
Else : TranslateEntity_(*Tube, 0, -(#CellSize * Height) + (#CellSize * I), 0) 
Define *Rotor = CopyEntity_(\Rotor, *Tube) : SetupBox(*Tube, *Rotor)
AddElement(\GUI\Rotors()) : \GUI\Rotors() = *Rotor
EndIf ; Ставим pick mode:
If I > 1 : EntityPickMode_(*Tube, 3, #False) : EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Next I
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndIf
EndWith
EndProcedure

Procedure MatrixTubes(X, Y, Angle = 0)
Define I, *Tube
For I = 1 To #MatrixDepth ; Like that...
*Tube = CopyEntity_(System\MatrixTube, Squares(X, Y)\TubesPiv)
AddElement(System\GUI\Matrix()) : System\GUI\Matrix() = *Tube    ; Вносим на баланс.
TurnEntity_(*Tube, Random(180) + 0.1, Angle, 0)    ; Разворот для матрицы.
MoveEntity_(*Tube, 0, Random(#TubeQuant), 0) ; Небольшой сдвиг.
If Squares(X, Y)\CellType = #pVanilla ; Небольшие поправки...
TranslateEntity_(*Tube, 0, #InfiniteCell + #HalfCell - #CellSize * (I + Squares(X, Y)\Height), 0)   ; С поправками
Else : TranslateEntity_(*Tube, 0, -Squares(X, Y)\Height * #CellSize + #CellSize - #CellSize * I, 0) ; Без поправок.
EndIf
Next I
EndProcedure

Procedure CleanUp()
With System
Define X, Y, XEnd, YEnd, I, ToFix
If \GUI\LevelResourcesAllocated = #True
; Удаляем всю графику.
ForEach \GUI\Shards() : DestroyShard()              : Next
ForEach \GUI\Shivers() : DestroyShiver()            : Next
ForEach \Beings()      : DestroyBeing()             : Next
ForEach \GUI\Quants()  : DestroyQuant()             : Next
ForEach \GUI\Ladders() : DestroyLadder()            : Next
ForEach \GUI\Crests()  : DestroyCrest()             : Next
ForEach \Channels()    : CloseChannel(#True)        : Next
ForEach \GUI\ReincEffects() : DestroyReincEffect()  : Next
ForEach \Rides()      : DestroyExpress()            : Next
WipeSparksOut() : CollapseHL() : ToFix = ArraySize(\Players())
For I = 1 To ToFix : FreeImage_(\Players(I)\Counter)
ClearStructure(@\Players(I), Player) : Next I
; Очищаем игровое поле.
XEnd = \Level\Width - 1 : YEnd = \Level\Height - 1 ; Считаем границы.
For X = 0 To XEnd : For Y = 0 To YEnd : FreeEntity_(GetParent_(Squares(X, Y)\Entity))
ClearStructure(Squares(X, Y), Square) : Next Y : Next X : ClearList(\Elevators())
; Убиваем игроков.
For I = 1 To ArraySize(System\Players()) : ClearStructure(@System\Players(I), Player) : Next I
; Последние приготовления.
If \GUI\Ghost\Entity : HideEntity_(\GUI\Ghost\Entity) : RotateEntity_(\GUI\Ghost\Entity, 0, 0, 0) : EndIf
ClearStructure(@\GUI, GUIData) : ClearStructure(@\Level, LevelData) : InitializeStructure(@\GUI, GUIData)
HideEntity_(\Target) : \GUI\LevelResourcesAllocated = #False
EndIf
EndWith
EndProcedure

Macro BeginDialog() ; Partializer.
EnableWindow_(System\GameWindow, #False)
ShowPointer_()
EndMacro

Macro FinishDialog() ; Partializer.
HidePointer_()
EnableWindow_(System\GameWindow, #True)
SetActiveWindow_(System\GameWindow)
EndMacro

Macro LoadingErr(Text) ; Pseudo-procedure.
ErrorBox(Text, "Map loading error:")
EndMacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure.s InvalidatePass(Pass.s)
Define *Char.Character = @Pass
While *Char\C : *Char\C ! 255 : *Char + SizeOf(Character) : Wend
ProcedureReturn Pass
EndProcedure

Macro CodeRequester(Code, Trivia) ; Pseudo-procedure.
ReplaceString(Trim(InputRequester(#Security, Trivia, Code)), " ", " ")
EndMacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Procedure FindColor(*Team.Team, TeamIdx)
Define I, Pixel.l, NewPixel.l, *Buffer, Factor
*Buffer = ImageBuffer_(System\Mixer, 0)
UseBuffer(*Buffer) ; Установка буффера.
With *Team ; Обработка комманды
For I = 1 To System\Level\PlayersCount
If System\Players(I)\AlliedTeam = TeamIdx 
Player2Color(I, 0) : Plot_(0, 0) : NewPixel = ReadPixel_(0, 0, *Buffer)
If Pixel : Factor + 2 : Pixel = AlphaBlend(RGBA(Red(NewPixel), Green(NewPixel), Blue(NewPixel), 255 / Factor), Pixel)
Else : Pixel = NewPixel : EndIf
EndIf
Next I
\B = Red(Pixel)
\G = Green(Pixel)
\R = Blue(Pixel)
EndWith
EndProcedure

Procedure LoadMap(FName.S = ":Random:", Unlock = #False) ; Доделать !
With System
Define X, Y, Code.s, XEnd, YEnd, *Platform, Type, Scale, *Square, *Player.Player, Random
Define Type, Header.S = Space(Len(#MapHeader)), EHeader.S = #MapHeader, I, ToFix
Define Params.RandomMapParams
If FName = ":Random:" ; Определение типа загрузки.
BeginDialog() ; Включить диалоговый режим.
If MGRequester(Params) ; Получение данных от пользователя.
FinishDialog() ; Закрываем диалог.
Random = #True ; Случайная генерация.
Else : FinishDialog() ; Закрываем диалог.
ProcedureReturn #False
EndIf
Else ; Загрузка из файла.
If OpenFile(0, FName.S)
ReadData(0, @Header, Len(#MapHeader))
If CompareMemory(@Header, @EHeader, Len(Header)) = #False
CloseFile(0)
LoadingErr("invalid header !")
ProcedureReturn #False
EndIf
Else ; Show error !
LoadingErr("can't open '" + FName + "' !")
ProcedureReturn #False
EndIf
If ReadLong(0) ; Если карта у нас из редактора...
; Теперь проверяем защитный код:
FileSeek(0, ReadLong(0) + Loc(0)) ; Edition pass.
I = ReadLong(0) : If I : Code = Space(I) : ReadData(0, @Code, I) ; Читаем защитный код...
If Unlock = #False ; Если не стоит универсальная отмычка...
Code = InvalidatePass(Code) ; Сразу же, на всякий пожарный.
Select CodeRequester("", #UnlockMsg)
Case "" : CloseFile(0) : ProcedureReturn #False ; Мирно выходим.
Case Code ; Nop. продолжаем загрузку.
Default   ; Неправильный пароль...
LoadingErr("incorrect code - loading aborted !")
CloseFile(0) : ProcedureReturn #False
EndSelect
EndIf
EndIf
EndIf
EndIf
; "Loading" screen.
HidePointer_()
AltLockMutex(\VideoMutex)
ClsColor_(0, 0, 0) : Cls_()
DrawImage_(\LoadingText, #ScreenWidth / 2, #ScreenHeight / 2) 
Flip_()
UnlockVideoMutex()
CleanUp()
\GUI\LevelResourcesAllocated = #True
If Random
; Выставить пользовательский размер поля.
\Level\Width = Params\MapWidth : \Level\Height = Params\MapHeight
\Level\TactsLimit = Params\TactsLimit : \Story = "" : \AfterStory = ""
Else : ReadData(0, @\Level, SizeOf(LevelData)) ; Загрузить размер поля из файла.
; Загрузить брифинг
I = ReadLong(0) : \Story = Space(I) : ReadData(0, @\Story, I)
I = ReadLong(0) : \AfterStory = Space(I) : ReadData(0, @\AfterStory, I)
EndIf
; Настроить мини-карту.
ReSizeImage_(\MiniMap, #MMCellSize * \Level\Width + 2, #MMCellSize * \Level\Height + 2)
UseBuffer(ImageBuffer_(\MiniMap, 0))
ClsColor_(10, 10, 10) : Cls_()
\GUI\MiniMapXPos = #ScreenWidth - ImageWidth_(\MiniMap) - #MMOffset
\GUI\MiniMapWidth = ImageWidth_(\MiniMap)
\GUI\MiniMapHeight = ImageHeight_(\MiniMap)
\GUI\MiniMapCursorPos\X = 1 + \GUI\MiniMapXPos
\GUI\MiniMapCursorPos\Y = 1 + #MMOffset
; -Заново выставить параметры кнопки "конец хода"-
Protected *Button.Button = \Buttons[#BtnEndTurn]
*Button\Rect\Right = #ScreenWidth - #ETButtonOffset
*Button\Rect\Bottom = #ScreenHeight - #ETButtonOffset
*Button\Rect\Left = *Button\Rect\Right - ImageWidth_(*Button\Image)
*Button\Rect\Top = *Button\Rect\Bottom - ImageHeight_(*Button\Image)
; -Заново выставить параметры кнопки перебора Сущностей-
*Button = \Buttons[#BtnSearchActive]
*Button\Rect\Right = #ScreenWidth - #ETButtonOffset
*Button\Rect\Bottom = \Buttons[#BtnEndTurn]\Rect\Top - 5
*Button\Rect\Left = *Button\Rect\Right - ImageWidth_(*Button\Image)
*Button\Rect\Top = *Button\Rect\Bottom - ImageHeight_(*Button\Image)
; -Настроить таблицу данных-
\GUI\DataBoardYPos = #ScreenHeight - \DataBoardSize\Y - #DataBoardYOffset
\GUI\DataBoardXCenter = #DataBoardXOffset + \DataBoardSize\X / 2
\GUI\DataBoardTip\X  = \GUI\DataBoardXCenter ; Но мало ли потом !
\GUI\DataBoardTip\Y  = #ScreenHeight - \DataBoardSize\Y - #DataBoardYOffset - #DataBoardTipOffset
; --Floor creation--
XEnd = \Level\Width - 1 : YEnd = \Level\Height - 1
Select Params\LandScape
Case 0 : I = 20
Case 1 : I = 50
Case 2 : I = 70
Case 3 : I = 100
EndSelect
For Y = 0 To YEnd
For X = 0 To XEnd
Define *Cell.Square = Squares(X, Y)
; -Platform creation-
If Random ; Если идет случайная генерация....
; Случайно выбрать высоту клетки.
If Rnd(100) <= I : Scale = Rnd(#MaxPlatformsScale) : Else : Scale = 1 : EndIf
; --------
; Небольшая рандомизация типа клеток:
Define CT, ElevatorEdge = Params\ElevatorsPercentage
Select Random(100, 1)  ; 100% шансов.
Case 1 To ElevatorEdge : CT = #pElevator       ; Элеватор
Case ElevatorEdge + 1 To ElevatorEdge + Params\IgnorancePercentage
*Cell\Gold = Random(3) : CT = #pIgnorance      ; Обелиск
Default : CT = #pVanilla                       ; Платформа.
EndSelect : *Cell\CellType = CT ; Ставим, наконец, клетке этот самый тип.
; --------
Else ; Считать высоту из файла
ReadData(0, *Cell, SizeOf(Square))
Scale = *Cell\Height
*Cell\State = #SNone
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Select *Cell\CellType
Case #pVanilla ; Стандартная платформа.
If *Cell\Gold : *Platform = \PlatformGold ; С позолотой же !
ElseIf Type : *Platform = \PlatformRed : Else : *Platform = \PlatformGreen : EndIf
*Platform = CopyEntity_(*Platform) ; Таки создаем.
PositionEntity_(*Platform, X * #FullGap + #HalfCell, -#InfiniteCell + #CellSize * Scale, -Y * #FullGap - #HalfCell)
; ~Рутина.
*Square = CopyEntity_(\SquareMesh, *Platform)
PositionEntity_(*Square, 0, #InfiniteCell + #SquareLuft, 0, 0)
; -----
Case #pElevator ; Элеватор.
If *Cell\Gold : *Platform = \ElevatorGold ; С позолотой же !
ElseIf Type : *Platform = \ElevatorRed : Else : *Platform = \ElevatorGreen : EndIf
*Platform = CopyEntity_(*Platform) ; Таки создаем.
If *Cell\Gold : Define *Nodes = CopyEntity_(\NodeCubesGold, *Platform)
Else : *Nodes = CopyEntity_(\NodeCubes, *Platform) : EndIf ; Elevating:
PositionEntity_(*Platform, X * #FullGap + #HalfCell, Scale * #CellSize - #HalfCell, -Y * #FullGap - #HalfCell)
PositionEntity_(*Nodes, 0, (Scale - 1) * -#CellSize, 0, 0)
; .......
AddElement(\Elevators()) : \Elevators() = Squares(X, Y)
; ~Рутина.
*Square = CopyEntity_(\SquareMesh, *Platform)
TranslateEntity_(*Square, 0, #HalfCell + #SquareLuft, 0)
; -----
Case #pIgnorance ; Обелиск.
*Platform = CopyEntity_(\Ignorance)
RotateEntity_(*Platform, 0, *Cell\Gold * 90, 0)
PositionEntity_(*Platform, X * #FullGap + #HalfCell, Scale * #CellSize - #HalfCell, -Y * #FullGap - #HalfCell)
; ~Рутина.
*Square = CopyEntity_(\SquareMesh, *Platform)
TranslateEntity_(*Square, 0, #HalfCell + #SquareLuft - #Ignoring, 0)
EndSelect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -Squares creation-
SetEntityID_(*Square, *Cell)
*Cell\Entity = *Square
*Cell\Being = #Null
If Random
*Cell\Height = Scale
*Cell\ArrayPos\X = X
*Cell\ArrayPos\Y = Y
EndIf
; -Leak point-
*Cell\FVortex = CreatePivot_(*Square) ; For flectors dance.
*Cell\Vortex  = CreatePivot_(*Square) ; For quantum mechanic.
; Соеденительные трубы.
*Cell\TubesPiv = CreatePivot_(*Platform)
If *Cell\CellType = #pIgnorance ; Если требуется корректировка.
RotateEntity_(*Cell\TubesPiv, 0, 0, 0) : EndIf
If *Cell\CellType <> #pElevator ; Трубы и роторы.
ConnectionTubes(X, Y) : ConnectionTubes(X, Y, #True) : EndIf
If Y = 0 : MatrixTubes(X, Y, -90) : EndIf
If X = 0 : MatrixTubes(X, Y, 0)   : EndIf
Type = ~Type
Next X
If \Level\Width % 2 = 0 : Type = ~Type : EndIf
Next Y
; --Players setup--
If Random
; Создать заданных пользователем игроков.
ReDim \Players.Player(Params\PlayersCount)
If Params\ExpertMode : System\Level\TeamsCount = 2    ; Всего 2 команды.
Else : System\Level\TeamsCount = Params\PlayersCount  ; !!!!Временно!!!!
EndIf : ReDim System\Teams.Team(Params\PlayersCount) 
FillMemory(@System\Teams(1), Params\PlayersCount * SizeOf(Team))
For I = 1 To Params\PlayersCount : *Player = \Players(I)
If I > 1 ; Задать тип управления игроком.
*Player\IType = Params\ITypes[I - 2]          ; !!!!Временно!!!!
Else : *Player\IType = #IHuman
EndIf
If *Player\IType = #IHuman : \Level\HumanPlayers + 1 : EndIf
If Params\ExpertMode And I > 1 : *Player\AlliedTeam = 2
Else : *Player\AlliedTeam = I : EndIf
System\Teams(*Player\AlliedTeam)\PlayersCount + 1
Next I
; Покраска...
\Level\PlayersCount = Params\PlayersCount
For I = 1 To System\Level\TeamsCount
FindColor(System\Teams(I), I) ; На случай войны.
Next I ; Продолжаем разговор...
If \Level\HumanPlayers > 1 : \Level\MultiPlayer = #True
Else : \Level\MultiPlayer = #False : EndIf
Else ; Загрузить данные о игроках из файла:
ToFix = ReadLong(0)
ReDim \Players.Player(ToFix)
For I = 1 To ToFix
ReadData(0, \Players(I), SizeOf(Player))
Next I
; Загрузить данные комманд из файла...
ToFix = ReadLong(0) ; Количество комманд.
ReDim \Teams.Team(ToFix) ; Массив.
For I = 1 To ToFix ; Обрабатываем каждую.
ReadData(0, \Teams(I), SizeOf(Team))
Next I ; Под конец сохраняем:
EndIf
; --Настроить счетчики Сущностей--
#CountersInter = 4
ToFix = ArraySize(\Players())
Define Factor
If \Level\CurrentTurn = 0
Factor = \Level\PlayersCount
Else : Factor = ToFix
EndIf
X = ImageHeight_(\CountersTitle) + 7
Y = (#ScreenHeight - ((\CountersData\Top + #CountersInter) * Factor - #CountersInter + X)) / 2
\GUI\CountersTitleYPos = Y : Y + X
If Random : \Level\CountersTitleXPos = -\CountersData\Left + #CountersTitleOffset : EndIf
For I = 1 To ToFix
If \Players(I)\BeingsCount > 0 Or Random
\Players(I)\Counter = CreateImage_(ImageWidth_(\Counters), ImageHeight_(\Counters), 1)
\Players(I)\CounterPos\Y = Y
If Random
\Players(I)\CounterPos\X = -\CountersData\Left
\Players(I)\CounterState = #CPreparing
EndIf
Y + \CountersData\Top + #CountersInter
Else : \Players(I)\CounterState = #CNone
EndIf
\Players(I)\BeingsCount = 0
\Players(I)\TotalEnergy = 0
Next I
; --Positioning--
; -"Sky"-
\GUI\MapWidth = \Level\Width * #FullGap - #CellGap   ; Real map width.
\GUI\MapHeight = \Level\Height * #FullGap - #CellGap ; Real map height.
\GUI\SparksRainFactor = Round(\Level\Width * \Level\Width / 9, 1)
PositionEntity_(\Sky, \GUI\MapWidth / 2, 0, -\GUI\MapHeight / 2)
PositionEntity_(\Space, \GUI\MapWidth / 2, 0, -\GUI\MapHeight / 2)
; -Beings-
If Random ; Случайная генерация и расстановка сущностей.
Define XStart, YStart, XStep, YStep, I
; Определение допущенных на карту Сущностей.
NewList AllowedSquad.i()  ; Сущности, доступные для формирования взвода.
NewList AllowedNeuter.i() ; Сущyости, которыми добивается карта.
ForEach Params\AllowedBeings()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Define BeingType = Val("$" + MapKey(Params\AllowedBeings())), BeingRarity = Params\AllowedBeings() ; Получаем необходимые параметры.
For I = 1 To BeingRarity ; По нескослько вхождений, для чистоты эксперимента.
If BeingType = #BTree Or BeingType = #BAgave : AddElement(AllowedNeuter()) : AllowedNeuter() = BeingType 
Else                                         : AddElement(AllowedSquad())  : AllowedSquad()  = BeingType  : EndIf
Next I
Next
; Установка начального набора Сущностей для игроков.
Protected NewList Squad.i()
For I = 1 To Params\StartingBeings
AddElement(Squad()) : Squad() = RandomIElement(AllowedSquad())
Next I
; Определение волны.
Structure Wave
X.i : Y.i
XStart.i : YStart.i
XStep.i : YStep.i
XEnd.i
EndStructure
Protected NewList Waves.Wave()
ClearList(Waves())
Define *Wave.Wave
; Выставление площади для расстановки.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
For I = 1 To Params\PlayersCount
Define SquadVal.F = Sqr(Params\StartingBeings), BiggerHalf.F = Round(SquadVal, 1)
Define Factor = Int(SquadVal) + BiggerHalf, Result
If Factor > \Level\Height
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Factor = \Level\Height / 2
BiggerHalf = Round(ListSize(Squad()) / Factor, 1)
SquadVal = Round(\Level\Width / 2, 1)
If BiggerHalf > SquadVal : BiggerHalf = SquadVal : EndIf
SquadVal = BiggerHalf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ElseIf Factor > \Level\Width
SquadVal = Round(\Level\Width / 2, 1)
BiggerHalf = SquadVal
EndIf
Select I
Case 1 : XStart = 0 : YStart = 0 : XEnd = BiggerHalf - 1 : XStep = 1 : YStep = 1
Case 2 : XEnd = \Level\Width - BiggerHalf : XStep = -1 : YStep = -1
XStart = XEnd + BiggerHalf - 1 : YStart = \Level\Height - 1
Case 3 : XEnd = \Level\Width - SquadVal : YStart = 0 : XStart = XEnd + SquadVal - 1
XStep = -1 : YStep = 1
Case 4 : XEnd = SquadVal - 1 : YStart = \Level\Height - 1 : XStart = 0
XStep = 1 : YStep = -1
EndSelect
AddElement(Waves()) : *Wave = Waves()
*Wave\XStart = XStart : *Wave\YStart = YStart : *Wave\XEnd = XEnd
*Wave\XStep = XStep : *Wave\YStep = YStep : *Wave\X = XStart : *Wave\Y = YStart
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Next I
; Расстановка Сущностей.
ForEach Squad() : I = 0
ForEach Waves() : *Wave = Waves() : I + 1
SetAgain: : Define Gen ; Пробуем, пробуем.
If RecarnType(SQuad()) And Squares(*Wave\X, *Wave\Y)\CellType = #pIgnorance : Gen = GetDegradatedType(Squad(), #True)
Else : Gen = Squad() : EndIf : Result = CreateBeing(Squares(*Wave\X, *Wave\Y), Gen, I)
If *Wave\X = *Wave\XEnd
*Wave\X = *Wave\XStart : *Wave\Y + *Wave\YStep
Else : *Wave\X + *Wave\XStep
EndIf
If Result = #False : Goto SetAgain : EndIf
Next
Next
; Расстановка нейтральных Сущностей.
For I = 1 To Params\NeutralBeings
X = Random(\Level\Width - 1) : Y = Random(\Level\Height - 1)
If Squares(X, Y)\Being = #Null
CreateBeing(Squares(X, Y), RandomIElement(AllowedNeuter()), 0)
Else : I - 1
EndIf
Next I
Else ; Загрузка данных о Сущностях из файла
Define Being.Being, *CreatedBeing.Being
ToFix = ReadLong(0)
For I = 1 To ToFix
ReadData(0, @Being, SizeOf(Being))
;;;;;;;;;;;;
If Being\Sanity = #MaxSanity : Being\Sanity - 1 : EndIf ; Маленькая хитрость...
*CreatedBeing = CreateBeing(Squares(Being\X, Being\Y), Being\Type, Being\Owner, Being\State, Being\EnergyLevel)
If Being\StoreLink <> #NoLink : LinkBeing(*CreatedBeing, Being\StoreLink) : EndIf
If Being\StoreLink <> #NoLink : LinkBeing(*CreatedBeing, Being\StoreLink) : EndIf
If Being\ExtraMode XOr (Being\Interstate And Being\Frozen=0):TechSwitch(*CreatedBeing):Being\Interstate=#False
Else : *CreatedBeing\InterState = Being\Interstate ; Иначе ставим флажок.
EndIf
If Being\Frozen : ApplyFroze(*CreatedBeing, Being\Frozen) : EndIf
If Being\LockDown : *CreatedBeing\LockDown = Being\LockDown : EndIf
SetAnimTime_(*CreatedBeing\Entity, Being\SeqFrame) ; Иногда выручает.
*CreatedBeing\GonnaRide = Being\GonnaRide ; Очень важный флаг.
If *CreatedBeing\State = #BActive Or *CreatedBeing\State = #BInActive
BeingAlpha(*CreatedBeing, Being\StateFrame)
If *CreatedBeing\State = #BActive : ActivateBeing(*CreatedBeing) : EndIf
If *CreatedBeing\State = #BActive Or *CreatedBeing\State = #BInactive : SpecialActivation(*CreatedBeing) : EndIf
If *CreatedBeing\Frozen = 0 : ResumeAnimation(*CreatedBeing) : EndIf
If Being\DelayedBlow : DelayBlow(*CreatedBeing, Squares(Being\BlowPos\X, Being\BlowPos\Y), #False) : EndIf
EndIf ; Вертаем назад:
*CreatedBeing\Sanity = Being\Sanity : *CreatedBeing\Momentum = Being\Momentum 
*CreatedBeing\Flash = Being\Flash   : *CreatedBeing\ShieldBlink = Being\ShieldBlink
*CreatedBeing\Transfert = Being\Transfert : *CreatedBeing\ShockerBlink = Being\ShockerBlink
*CreatedBeing\SynthCores = Being\SynthCores : ScriptTable(*CreatedBeing) : MarkMiniMap(*CreatedBeing)
*CreatedBeing\StateFrame = Being\StateFrame
RotateEntity_(*CreatedBeing\Entity, 0, 0, 0) ; ...Ну и последнее:
If *CreatedBeing\Type = #BDesire : UpholdScrews(*CreatedBeing, #True) : EndIf
TurnBeing(*CreatedBeing, Being\EntityYaw)
Next I
If \Level\CurrentTurn <> 0 : UpdateCounters() : EndIf ; Обновить значения счетчиков Сущностей.
; Загрузка данных о квантах из файла.
Define *Ptr, Quant.Quant, *SentQuant.Quant
ToFix = ReadLong(0)
For I = 1 To ToFix
ReadData(0, @Quant, SizeOf(Quant))
X = Quant\DestinationPos\X : Y = Quant\DestinationPos\Y
SendEnergy(Squares(Quant\SourcePos\X, Quant\SourcePos\Y), Squares(X, Y), 1, #False)
*SentQuant = System\GUI\Quants()
*SentQuant\Height = Quant\Height
*SentQuant\X = Quant\X
*SentQuant\Z = Quant\Z
*SentQuant\Frame = Quant\Frame
If Quant\ToDestination
*SentQuant\ToDestination = #True
EntityParent_(*SentQuant\Entity, *SentQuant\Destination\Vortex)
SetOn(*SentQuant\Entity, *SentQuant\Destination\Entity)
TranslateEntity_(*SentQuant\Entity, Quant\X, 0, Quant\Z)
TranslateEntity_(*SentQuant\Entity, 0, #QuantHeight + Quant\Height, 0)
Else : TranslateEntity_(*SentQuant\Entity, Quant\X, Quant\Height, Quant\Z)
EndIf
Next I
EndIf
If Random
PositionEntity_(\CamPiv, #MapBoundsGap, 0, -#MapBoundsGap)
SetOn(\Selection, Squares(0, 0)\Entity)
; -Fine-tuning camera-
RotateEntity_(System\CamPiv, 0, 45, 0)  ; Iso-view.
SetOn(System\Camera, System\CamPiv)     ; Ставим в начало.
MoveEntity_(System\Camera, 0, 0, -25 - #MinCameraDistance) ; Better view.
Else ; Позиционирование выделения и камеры.
PositionEntity_(\CamPiv, ReadLong(0), 0, ReadLong(0))
RotateEntity_(\CamPiv, 0, ReadLong(0), 0)
MoveEntity_(\Camera, 0, 0, EntityDistance_(\Camera, \CamPiv) - ReadLong(0))
PositionEntity_(\Selection, ReadLong(0), ReadLong(0), ReadLong(0))
; Загрузить данные матрицы из файла.
ForEach \GUI\Matrix() : *Ptr = \GUI\Matrix() ; Корректируем смещения.
PositionEntity_(*Ptr, ReadLong(0), EntityY_(*Ptr), ReadLong(0))       ; Пространство.
RotateEntity_(*Ptr, ReadLong(0), EntityYaw_(*Ptr), EntityRoll_(*Ptr)) ; Углы.
Next
; -Загрузка информации о каналах-
Define Chnl.Channel, *Chnl.Channel
ToFix = ReadLong(0)
For I = 1 To ToFix
ReadData(0, @Chnl, SizeOf(Channel))
Define *Source.Being = Squares(Chnl\SourcePos\X, Chnl\SourcePos\Y)\Being
Define *Destination.Being = Squares(Chnl\DestinationPos\X, Chnl\DestinationPos\Y)\Being
Define MI = MindInfected(*Source)
*Chnl = ApplyChannel(*Source, *Destination, Chnl\Advanced)
AddBeing2UpdateList(*Source, MI)
AddBeing2UpdateList(*Destination, MindInfected(*Destination))
Next I
UpdateTables()
; -Загрузка информации о эффектах Перерождения-
Define ReincEffect.ReincEffect, *RE.ReincEffect
ToFix = ReadLong(0)
For I = 1 To ToFix
ReadData(0, @ReincEffect, SizeOf(ReincEffect))
*RE = VizualizeReincarnation(Squares(ReincEffect\Position\X, ReincEffect\Position\Y), ReincEffect\Fake)
*RE\TubeFrame = ReincEffect\TubeFrame
Next I
; -Загрузка информации о искрах-
\GUI\SparksRainTimer = ReadLong(0)
Define Spark.Spark, *NewSpark.Spark
ToFix = ReadLong(0)
For I = 1 To ToFix
ReadData(0, @Spark, SizeOf(Spark))
If \Options\SparksRain ; Если оно нас интересует....
SpawnSpark(Spark\Alt)
*NewSpark = \GUI\Sparks()
*NewSpark\X = Spark\X : *NewSpark\Y = Spark\Y : *NewSpark\Z = Spark\Z
PositionEntity_(*NewSpark\Entity, Spark\X, Spark\Y, Spark\Z, 1)
EndIf
Next I
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -Загрузка инфорции о криогене-
Define *PArent.Square, Advanced, ToFix = ReadLong(0), *Shiver.Shiver
For I = 1 To ToFix ; Cчитываем.
AddElement(System\GUI\Shivers()) : *Shiver = System\GUI\Shivers()
ReadData(0, *Shiver, SizeOf(Shiver)) : SpawnShiver(*Shiver, #False)
PositionEntity_(*Shiver\Entity, *Shiver\X, *Shiver\Y, *Shiver\Z, 1)
RotateEntity_(*Shiver\Entity, *Shiver\XAngle, *Shiver\YAngle, *Shiver\ZAngle, 1)
ScaleSprite_(*Shiver\Entity, #ShiverSize + *Shiver\ScaleMod, #ShiverSize + *Shiver\ScaleMod)
*Parent = Squares(*Shiver\Parent\X, *Shiver\Parent\Y)
Select *Shiver\Parented ; Выбираем по типу....
Case 1 : EntityParent_(*Shiver\Entity, *Parent\FVortex)
Case 2 : EntityParent_(*Shiver\Entity, *Parent\Being\SpecialPart)
Case 3 : EntityParent_(*Shiver\Entity, *Parent\Being\SpecialPart2)
Case 4 : EntityParent_(*Shiver\Entity, *Parent\Being\SpecialPart3)
EndSelect
Next I
; Загрузка информации об осколках.
Define ToFix = ReadLong(0), *Shard.Shard, Shard.Shard
For I = 1 To ToFix ; Cчитываем.
ReadData(0, @Shard, SizeOf(Shard)) ; Сами данные.
*Shard=SpawnShard(Shard\Color,Shard\MaxFrame):*Shard\FadeEdge=Shard\FadeEdge
PositionEntity_(*Shard\Entity, Shard\X, Shard\Y, Shard\Z, 1)
RotateEntity_(*Shard\Entity, Shard\XDir, Shard\YDir, Shard\ZDir, 1)
RotateEntity_(*Shard\Layer1, Shard\XAngle, Shard\YAngle, Shard\ZAngle, 1)
*Shard\Frame = Shard\Frame : *Shard\Xfactor = Shard\XFactor
*Shard\Yfactor = Shard\YFactor : *Shard\Zfactor = Shard\ZFactor
*Shard\Speeder = Shard\Speeder : *Shard\LAtency = Shard\Latency
*Shard\Parented = Shard\Parented : *Shard\Parent = Shard\Parent
If *Shard\Parented : *Parent = Squares(*Shard\Parent\X, *Shard\Parent\Y)
Select *Shard\Parented ; Выбираем по типу....
Case 1 : EntityParent_(*Shard\Entity, *Parent\Being\SpecialPart2)
Case 2 : EntityParent_(*Shard\Entity, *Parent\FVortex)
EndSelect
EndIf
Next I
; -Загрузка информации о поездках-
Define ToFix = ReadLong(0), *Ride.Expresso, Ride.Expresso
For I = 1 To ToFix ; Cчитываем.
ReadData(0, @Ride, SizeOf(Expresso)) ; Сами данные.
Define *Dest = Squares(Ride\DestPos\X, Ride\DestPos\Y)\Being
*Ride = SpawnExpress(Squares(Ride\SourcePos\X, Ride\SourcePos\Y)\Being, *Dest, Ride\ColorMode)
*Ride\Frame = Ride\Frame : PositionEntity_(*Ride\IN, Ride\X, Ride\Y, Ride\Z, 1)
PositionEntity_(*Ride\Out, Ride\X2, Ride\Y2, Ride\Z2, 1) 
*Ride\Compressed = Ride\Compressed
Next I
; -Загрузка инфорции о дефлекторах-
Define ToFix = ReadLong(0), *Flector.Flector, Flector.Flector
For I = 1 To ToFix : ReadData(0, Flector, SizeOf(Flector)) 
*Flector = SpawnFlector(Squares(Flector\ArrayPos\X, Flector\ArrayPos\Y), Flector\Type)
PositionEntity_(*Flector\Entity, Flector\X, Flector\Y, Flector\Z, 1)
RotateEntity_(*Flector\Entity, Flector\XAngle, Flector\YAngle, Flector\ZAngle, 1)
*Flector\Frame = Flector\Frame
Next I
; -Загузка информации о лестницах-
Define Ladder.Ladder, *Ladder.LAdder, ToFix = ReadLong(0)
For I = 1 To ToFix ; Cчитываем.
ReadData(0, @Ladder, SizeOf(Ladder))
*Ladder = AddLadder(Squares(Ladder\X, Ladder\Y), Ladder\Polarity)
*Ladder\Frame = Ladder\Frame : TurnEntity_(*Ladder\Entity, 0, Ladder\Angle, 0)
ScaleEntity_(*Ladder\Entity, Ladder\Size, #TallInfinity, Ladder\Size)
Next I
; Загрузка информации о символике.
Define Crest.Crest, ToFix = ReadLong(0)
For I = 1 To ToFix ; Cчитываем.
ReadData(0, @Crest, SizeOf(Crest))
InvokeCrest(Squares(Crest\X, Crest\Y), Crest\Type, Crest\Angle)
System\GUI\Crests()\Frame = Crest\Frame
Next I
; Данные ударов.
Define *BSquare.Square, *DBlow.DBlow, DBlow.DBlow, ToFix = ReadLong(0)
For I = 1 To ToFix ; Cчитываем.
ReadData(0, @DBlow, SizeOf(DBlow)) : *BSquare = Squares(DBlow\ArrayPos\X, DBlow\ArrayPos\Y)
If *BSquare\Projection = #Null : FancyBlow(*BSquare) : EndIf
*DBlow = BlowSquare(*BSquare) : *DBlow\Frame = DBlow\Frame
Next I ; Зaкрытие файла.
CloseFile(0)
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Настройка света.
SetOn(\LightPiv, \Selection)
AmbientLight_(#AmbientLight, #AmbientLight, #AmbientLight)
LightColor_(\Light, #CursorLight, #CursorLight, #CursorLight)
; Выставить позиции для поиска активных Сущностей.
LastElement(\Beings())
\GUI\ActiveBeingPos = @\Beings()
; -Установка стартового меша для силуэта (Tree)-
\GUI\Ghost\Entity = \TreeMesh
; -Game Start-
If \Level\CurrentTurn = 0
; Показать брифинг.
If Trim(\Story) <> ""
If PrettyPrint(FormatStory(\Story)) = #False
ProcedureReturn #False
EndIf
EndIf
\Level\CurrentTurn = 1
NextTurn()
; -Создать изначальную массу искр-
WipeSparksOut()
If \Options\SparksRain
For X = 1 To 5
For Y = 1 To \GUI\SparksRainFactor
SpawnSpark(Random(1))
\GUI\Sparks()\Y + X * #SparkSpeed * #SparksSpawningDelay
Next Y
Next X
EndIf
EndIf
\GUI\ASFlashing = #ASMinBrightness
; -Настроить размытие-
EntityAlpha_(\Blurer, 0.35) : EntityTexture_(\Blurer, \BlurTex)
EntityFX_(\Blurer, 1) : If \Options\BlurFilter : ShowEntity_(\Blurer) : EndIf
USeBuffer(TextureBuffer_(\BlurTex)) : ClsColor_(0, 0, 0) : Cls_() : UseBuffer()
; -Настроить выцветание-
ShowEntity_(\Fader) : EntityAlpha_(\Fader, 0.0)
; -Включить музыку-
\GUI\Noised = #GameFPS / 2
ResumeThread(\MBThread)
ProcedureReturn #True
EndWith
EndProcedure

Macro ClearDSTable() ; Pseudo-procedure
Define I, X, Y, XEnd, YEnd 
XEnd = System\Level\Width - 1
YEnd = System\Level\Height - 1
For Y = 0 To YEnd : For X = 0 To XEnd
Define *Cell.Square = Squares(X, Y)
*Cell\DangerLevel = 0
*Cell\DangerLevel4Reincarnates = 0
*Cell\InstantAbsorbers = 0
*Cell\AdvInstantAbsorbers = 0
*Cell\Frozers = 0
*Cell\AdvFrozers = 0
*Cell\Biters = 0
For I = 0 To #ReincFamily - 1
*Cell\iKills[I] = 0
Next I 
Next X : Next Y
EndMacro

Macro CopyScreen(Src, Target) ; Pseudo-procedure.
CopyRect__(0, 0, #ScreenWidth, #ScreenHeight, 0, 0, Src, Target)
EndMacro

Macro UpdateBlur() ; Pseudo-procedure.
CopyScreen(BackBuffer_(), TextureBuffer_(System\BlurTex))
EndMacro

Macro NoiseRegFilter(Reg) ; ASM-partializer.
MOVZX EAX, Reg : ADD EAX, ECX : CDQ
XOr EAX, EDX : SUB EAX, EDX :  MOV Reg, AL
EndMacro

Macro MakeNoise(Amount) ; Pseudo-procedure.
If System\Options\NoiseFilter Or System\Options\InstableOut ; Пока так.
#MixerRange = 12
Define *Buffer = TextureBuffer_(System\NoiseBuffer)
CopyScreen(BackBuffer_(), *Buffer)
LockBuffer_(*Buffer)
Define *GfxData.Integer = *Buffer + 60
Define Pitch.i = *GfxData\I : *GfxData + 16
*GfxData = *GfxData\I ; Считываем адрес буффера.
If System\Options\NoiseFilter ; Проверям здесь. Пока здесь.
For I = 1 To Amount
Define XStart = Random(#ScreenWidth-#NoiseSize-1) 
Define YStart = Random(#ScreenHeight-#NoiseSize-1)
Define Mixer  = Random(#MixerRange * 2) - #MixerRange
Define Y, *YLine = *GfxData + YStart * Pitch, YEnd = YStart + #NoiseSize
For Y = YStart To YEnd
Define *Pixel.Long = *YLine + XStart << 2
Define *RowEnd = *Pixel + #NoiseSize << 2
For *Pixel = *Pixel To *RowEnd Step SizeOf(Long)
EnableASM
MOV EBX, *Pixel\L
MOV ECX, Mixer
NoiseRegFilter(BL) ; B
NoiseRegFilter(BH) ; G
BSWAP EBX
NoiseRegFilter(BH) ; R
BSWAP EBX
MOV *Pixel\L, EBX
DisableASM
Next *Pixel : *YLine + Pitch
Next Y
Next I
EndIf
; -Зашумление v2.0-
If System\GUI\Noised
If Random(2)
For I = 1 To #ScreenHeight - 1
*Pixel = (*GfxData + I * Pitch)
MoveMemory(*Pixel, *Pixel + Random(System\GUI\Noised) * #ScreenDepth, #ScreenWidth * #ScreenDepth)
Next I : Else : RandomData(*GfxData, #ScreenHeight * Pitch) : EndIf
System\GUI\Noised - 1 : EndIf : UnLockBuffer_(*Buffer)
CopyScreen(*Buffer, BackBuffer_())
EndIf
EndMacro

Procedure DrawAllTables()
SortStructuredList(System\GUI\TablesOnScreen(), 1, OffsetOf(Table\ZOrder), #PB_Float)
Player2Color(0, 1) ; Для фиолетовых точек.
ForEach System\GUI\TablesOnScreen()
Define *Table.Table = System\GUI\TablesOnScreen()
With *Table
DrawImage_(\Image, \ScreenPos\X, \ScreenPos\Y)
Define TitleY = \ScreenPos\Y - #HTHeight - #TitleHeight / 2 - 1
If \RMark : DrawImage_(System\RMark, \ScreenPos\X, \ScreenPos\Y + 19) : EndIf
If \Attention : DrawImage_(System\Attention, \ScreenPos\X, \ScreenPos\Y-#AttentionFix/2, \Attention) : TitleY - 2
ElseIf \Momentum <> -1 ; Если нужно рисовать вортекс:
DrawImage_(System\Momentum, \ScreenPos\X - #HTWidth - 2, \ScreenPos\Y - #HTHeight - 2, \Momentum)
DrawImage_(System\Momentum, \ScreenPos\X + #HTWidth - 2, \ScreenPos\Y + #HTHeight - 2, \Mirror)
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If \StoreRem : DrawImage_(System\StoreCache, \ScreenPos\X, TitleY, \StoreRem)
Player2Color(\StoreRem / #StoreCells + 1, 0)
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -Визуализация инфекции-
If \InfPoints : \InfPoints - 1 : DrawImage_(System\InfCache, \ScreenPos\X, \ScreenPos\Y, \InfPoints) : EndIf
EndWith
Next
ClearList(System\GUI\TablesOnScreen())
EndProcedure

Macro InfoHL() ; Pseudo-procedure.
If System\GUI\SelectedBeing = #Null
CollapseHL()
If System\GUI\Input = #PB_Key_I And System\GUI\PickedSquare
If System\GUI\PickedSquare\Being
If Existing(System\GUI\PickedSquare\Being)
FullHL(System\GUI\PickedSquare\Being)
EndIf
EndIf
EndIf
ElseIf System\GUI\Input = #PB_Key_I : System\GUI\SelectInfo = #True
EndIf
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

Procedure SaveOptions()
Define Header.S = #CfgFileHeader
CreateFile(0, #CfgSaveFile)
WriteData(0, @Header, Len(Header))
WriteData(0, @System\Options, SizeOf(OptionsData))
CloseFile(0)
EndProcedure

Procedure ShowOptionsPanel()
BeginDialog()
If OptionsRequester(System\Options) 
SaveOptions() : ButtonsViziblity()
If System\Options\SparksRain = #False : WipeSparksOut() : EndIf
EndIf 
FinishDialog()
EndProcedure
;}
;{ --Paralleling--
Procedure ScreenShooter(A) ; Thread.
Define *Buffer, PrtScn
Define *GfxData.Long, *Pitch.Long
#ScreensDir = "..\ScreenShots\"
#SSDataMask = "%dd.%mm.%yy [%hh'%ii'%ss]"
Repeat : Delay(1000 / System\MaxFPS)
If GetKeyState_(#VK_SNAPSHOT) => 0 
If PrtScn : PrtScn = #False
CreateDirectory(#ScreensDir)
System\GUI\WaitVideo = #True ; Оптимизация.
AltLockMutex(System\VideoMutex)
System\GUI\WaitVideo = #False ; Ставим обратно.
*Buffer = FrontBuffer_()
LockBuffer_(*Buffer)
CreateImage(0, #ScreenWidth, #ScreenHeight, Min(#ScreenDepth, 24))
*GfxData = *Buffer + 76 : *Pitch = *Buffer + 60
CopyMemToImage(*GfxData\L, 0, *Pitch\L) 
UnLockBuffer_(*Buffer)
UnlockVideoMutex()
SaveImage(0, #ScreensDir + FormatDate(#SSDataMask, Date()) + ".PNG", #PB_ImagePlugin_PNG)
EndIf
Else : PrtScn = #True
EndIf
ForEver
EndProcedure
 
Procedure MusicBox(A) ; Thread.
While System\CurrentTrack = 0
Delay(1000 / System\MaxFPS)
Wend
Repeat : Delay(1000 / System\MaxFPS)
If System\Options\PlayMusic
If TrackPlaying() = #False Or System\GUI\Input = #PB_Key_T
StopTrack()
System\CurrentTrack = Rnd(System\FoundTracks)
PlayTrack(System\CurrentTrack)
SetTrackVolume(System\Options\MusicVolume)
EndIf
EndIf
ForEver
EndProcedure

Procedure GameCB(*Window, Event.i, lParam.i, wParam.i) ; Callback
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
EndSelect : ErrorBox(Diagnose + " It's irreparable."+#CR$+System\Hinter+#CR$+"Application would now be terminated.")
EndProcedure
;}
;} EndProcedures

;{ MainMacros
Macro Initialization()
Define I, *Texture, *Being.Being
; -System init-
SetHint("try with Win98 compatibility mode") ; Инструкция к действиям.
While CreateMutex_(0, 0, "=[Flow.Gaem]=") = #Null : Delay(100) : Wend ; Идентификатор.
If GetLastError_() : ErrorBox("Flow is already running !" + #CR$ + "Press 'OK' to exit.") : End : EndIf
Define FixDir.s = GetPathPart(ProgramFilename()) ; На случай cmd и тому подобного.
If FixDir <> GetTemporaryDirectory() : SetCurrentDirectory(FixDir) : EndIf
CompilerIf Not #PB_Compiler_Debugger : OnErrorCall(@ErrorHandler())
CompilerEndIf
; -Blitz init-
BeginBlitz3D_() : SetBlitz3DDebugMode_(0)
Graphics3D_(#ScreenWidth, #ScreenHeight, #ScreenDepth, 2)
SetBlitz3DTitle_(#GameTitle, "") : HidePointer_()
SetCurrentDirectory("Media\") : UsePNGImageEncoder()
System\GameWindow = FindGameWindow()
System\OldCallBack = GetWindowLong_(System\GameWindow, #GWL_WNDPROC)
SetWindowLong_(System\GameWindow, #GWL_WNDPROC, @GameCB())
; --Screen filler--
System\VoidEye = LoadImage__("VoidEye.png") 
System\NothingText = LoadImage__("Nothing.png") 
System\InsideText  = LoadImage__("Inside.png") 
MidHandle_(System\InsideText) : MidHandle_(System\NothingText)
MidHandle_(System\VoidEye)    : ShowNothing()
; -Missing API extraction-
System\FontLoader = GetProcAddress_(GetModuleHandle_("GDI32.DLL"), "AddFontResourceExA")
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
System\Rotor = LoadMesh_("Rotor.b3d"):HideEntity_(System\Rotor):System\Void = CreatePivot_()
; -Square-
System\SquareMesh = CreateQuad()
ScaleMesh_(System\SquareMesh, #HalfCell, 0, #HalfCell)
EntityPickMode_(System\SquareMesh, 2, #False)
EntityAlpha_(System\SquareMesh, 0.0)
EntityFX_(System\SquareMesh, 1)
EntityBlend_(System\SquareMesh, 1)
HideEntity_(System\SquareMesh)
; -Matrix tubes-
System\MatrixTex = LoadTexture_("MatrixTex.JPG")
ScaleTexture_(System\MatrixTex, 1, 1 / #TenInfinity)
System\MatrixTube = CopyEntity_(System\ConnectionTube)
ScaleEntity_(System\MatrixTube, 1, #TenInfinity , 1)
EntityTexture_(System\MatrixTube, System\MatrixTex)
HideEntity_(System\MatrixTube)
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
; -Quant-
System\QuantMesh = LoadSprite_("Quant.PNG")
EntityFX_(System\QuantMesh, 1)
HideEntity_(System\QuantMesh)
; -Sviver
System\ShiverMesh = LoadSprite_("Shiver.PNG")
ScaleSprite_(System\ShiverMesh, #ShiverSize, #Shiversize)
HideEntity_(System\ShiverMesh)
; -Sanity-
System\SanityTex = LoadAnimTexture_("Sanity.png", 2+4, #SanitySize, #SanitySize / #Visions, 0, #Visions)
System\VisionMesh = CreateCylinder_(32, 0) : EntityBlend_(System\VisionMesh, 3)
EntityFX_(System\VisionMesh, 1+16) : HideEntity_(System\VisionMesh)
ScaleTexture_(System\SanityTex, 1 / 5, 1)
; -Ladders-
*Texture = LoadTexture_("Jacob.png", 2)
System\LadderMesh = CreateCylinder_(32)
ScaleTexture_(*Texture, 0.1, 1 / #TallInfinity * 4)
EntityTexture_(System\LadderMesh, *Texture)
EntityFX_(System\LadderMesh, 1 + 16)
HideEntity_(System\LadderMesh)
FreeTexture_(*Texture)
; -Projection-
System\Projection = LoadAnimEtalone("Projection.b3d", 'Hull')
System\PlasmaTex = LoadTexture_("Plasma.jpg")
ScaleTexture_(System\PlasmaTex, 1, 1/#TallInfinity * 6)
*Texture = CreateCylinder_(16, 0, System\Projection)
ScaleEntity_(*Texture, 1.5, #TallInfinity, 1.5)
TranslateEntity_(*Texture, 0, #TallInfinity, 0)
EntityBlend_(*Texture, 3)
EntityFX_(*Texture, 17)   : EntityAlpha_(*Texture, 0.1)
EntityTexture_(*Texture, System\PlasmaTex)
; -Shards-
System\ShardMesh = CreateMesh_()
*Texture = CreateCone_(3, #True, System\ShardMesh)
EntityBlend_(*Texture, 3)
ScaleEntity_(*Texture, 0.15, 0.15, 0.15)
*Texture = CreateCone_(3, #True, *Texture)
ScaleEntity_(*Texture, 0.25, 0.25, 0.25, #True)
EntityBlend_(*Texture, 3)
ComplexEntityFX(System\ShardMesh, 1)
HideEntity_(System\ShardMesh)
; -Expresso-
System\ExpressMesh = CreatePivot_()
*Texture = LoadMesh_("Express.b3d", System\ExpressMesh)
*Texture = CopyEntity_(*Texture, System\ExpressMesh)
ScaleEntity_(*Texture, 1.1, 1, 1.1)
Define MH = MEshHeight_(*Texture)
Translateentity_(*Texture, 0, -MH / 3, 0)
*Texture = CopyEntity_(*Texture, System\ExpressMesh)
ScaleEntity_(*Texture, 1.2, 1, 1.2)
Translateentity_(*Texture, 0, -MH / 3, 0)
ScaleEntity_(System\ExpressMEsh, 1, #ExpressSize, 1)
ComplexEntityFX(System\ExpressMEsh, 1+16)
ComplexEntityBlend(System\ExpressMEsh, 3)
HideEntity_(System\ExpressMEsh)
; -Spark-
System\SparkMesh = LoadSprite_("Spark.PNG")
EntityAlpha_(System\SparkMesh, #SparksAlpha)
HideEntity_(System\SparkMesh)
EntityFX_(System\SparkMesh, 1)
System\AltSparkMesh = LoadSprite_("AltSpark.PNG")
EntityAlpha_(System\AltSparkMesh, #SparksAlpha)
HideEntity_(System\AltSparkMesh)
EntityFX_(System\AltSparkMesh, 1)
; -Beings-
System\CryoTex       = LoadTexture_("Cryo.jpg")
System\CaosTex       = LoadTexture_("Caos.jpg")
System\RedTex        = LoadTexture_("Red.jpg")
System\GreenTex      = LoadTexture_("Green.jpg")
System\BlueTex       = LoadTexture_("Blue.jpg")
System\WhiteTex      = LoadTexture_("White.jpg")
System\ShockTex      = LoadTexture_("Shock.jpg")
System\BlankTex      = LoadTexture_("BlankEye.png")
System\TreeMesh      = LoadAnimEtalone("Tree.B3D")
System\SpectatorMesh = LoadAnimEtalone("Spectator.B3D")
System\MeanieMesh    = LoadAnimEtalone("Meanie.B3D")
System\IdeaMesh      = LoadAnimEtalone("Idea.B3D")
System\SentryMesh    = LoadAnimEtalone("Sentry.B3D")
System\SocietyMesh   = LoadAnimEtalone("Society.B3D")
System\EnigmaMesh    = LoadAnimEtalone("Enigma.B3D")
System\AmgineMesh    = LoadAnimEtalone("Amgine.B3D")
; -Reinacarnated beings-
System\ReincarnationTubeTex = LoadTexture_("Gold_Flame.JPG")
System\FakeReincarnationTubeTex = LoadTexture_("Unether.JPG")
ScaleTexture_(System\ReincarnationTubeTex, 0.5, 1 / #TallInfinity)
ScaleTexture_(System\FakeReincarnationTubeTex, 0.5, 1 / #TallInfinity)
System\JusticeMesh   = LoadAnimEtalone("Justice.B3D")
System\SentinelMesh  = LoadAnimEtalone("Sentinel.B3D")
System\HungerMesh    = LoadAnimEtalone("Hunger.B3D")
System\JinxMesh      = LoadAnimEtalone("Jinx.B3D")
System\DefilerMesh   = LoadAnimEtalone("Defiler.B3D")
System\AgaveMesh     = LoadAnimEtalone("Agave.B3D")
; -Tools-
System\FrostBiteMesh = LoadAnimEtalone("FrostBite.B3D")
; -Ascendants-
; .Seer.
System\SeerMesh      = LoadAnimEtalone("Seer.B3D")
EntityBlend_(FindChildSafe(System\SeerMesh, "SubBody"), 3)
EntityBlend_(FindChildSafe(System\SeerMesh, "Plasmoid"), 3)
EntityBlend_(FindChildSafe(System\SeerMesh, "PlasmoidOut"), 3)
EntityFX_(FindChildSafe(System\SeerMesh, "Plasmoid"), 16)
For I = 1 To 4 ; Еще немного альфы.
EntityBlend_(FindChildSafe(System\SeerMesh, "Window" + Str(I)), 3)
Next I
ExtractAnimSeq_(System\SeerMesh, 120, #Everything, 0)
; .Paradigma.
System\ParadigmaMesh  = LoadAnimEtalone("Paradigma.B3D")
ComplexEntityFX(System\ParadigmaMesh, 16)
ComplexEntityBlend(System\ParadigmaMesh, 3)
System\ParaSpine = FindChildSafe(System\ParadigmaMesh, "Spine")
EntityFX_(System\ParaSpine,1):EntityTexture_(System\ParaSpine,System\WhiteTex)
ColorizeParadigma("Red", RedTex,System\ParadigmaMesh,System)
ColorizeParadigma("Green", GreenTex, System\ParadigmaMesh,System)
ColorizeParadigma("Blue", BlueTex, System\ParadigmaMesh,System)
ExtractAnimSeq_(System\ParadigmaMesh, 130, #Everything, 0)
; .Desire.
System\DesireMesh  = LoadAnimEtalone("Desire.b3d")
System\SharedHatch = FindChildSafe(System\DesireMesh, "Hatchery")
EntityBlend_(FindChildSafe(System\DesireMesh, "LScrewer_Blend"), 3)
EntityBlend_(FindChildSafe(System\DesireMesh, "UScrewer_Blend"), 3)
EntityBlend_(FindChildSafe(System\DesireMesh, "Hatchery_Blend"), 3)
EntityBlend_(FindChildSafe(System\DesireMesh, "WatchGlass"), 3)
For I = 1 To #VicHolez
EntityBlend_(FindChildSafe(System\DesireMesh, "PressRing" + RSet(Str(I), 2, "0")), 3)
EntityBlend_(FindChildSafe(System\DesireMesh, "Tubus" + RSet(Str(I), 2, "0")), 3)
EntityFX_(FindChildSafe(System\DesireMesh   , "Tubus" + RSet(Str(I), 2, "0")), 16)
HideEntity_(FindChildSafe(System\DesireMesh , "Tubus" + RSet(Str(I), 2, "0")))
Next I
For I = 1 To 12
EntityBlend_(FindChildSafe(System\DesireMesh, "CoreGlass" + RSet(Str(I), 2, "0")), 3)
EntityAlpha_(FindChildSafe(System\DesireMesh, "CoreGlass" + RSet(Str(I), 2, "0")), 0)
EntityAlpha_(FindChildSafe(System\DesireMesh, "ProtoCore" + RSet(Str(I), 2, "0")), 0)
Next I
ExtractAnimSeq_(System\DesireMesh, 130, #Everything, 0)
System\HardCore = EntityY_(FindChildSafe(System\DesireMesh, "ProtoCore01"), 0)
; -Shields-
System\EnigmaShield   = LoadAnimEtalone("Shields\Enigma (shield).b3d"  , 'Hull')
System\AmgineShield   = LoadAnimEtalone("Shields\Amgine (shield).b3d"  , 'Hull')
System\AgaveShield    = LoadAnimEtalone("Shields\Agave (shield).b3d"   , 'Hull')
System\JusticeShield  = LoadAnimEtalone("Shields\Justice (shield).b3d" , 'Hull')
System\HungerShield   = LoadAnimEtalone("Shields\Hunger (shield).b3d"  , 'Hull')
System\JinxShield     = LoadAnimEtalone("Shields\Jinx (shield).b3d"    , 'Hull')
System\SentinelShield = LoadAnimEtalone("Shields\Sentinel (shield).b3d", 'Hull')
System\DefilerShield  = LoadAnimEtalone("Shields\Defiler (shield).b3d" , 'Hull')
; -Generic crest-
System\CrestMesh       = CreateSprite_()
EntityFx_(System\CrestMesh, 1)
EntityBlend_(System\CrestMesh, 3)
SpriteViewMode_(System\CrestMesh, 2)
ScaleSprite_(System\CrestMesh, #HalfCell, #HalfCell)
HideEntity_(System\CrestMesh)
; -Generic flector-
System\FlectorMesh       = CreateSprite_()
EntityFX_(System\FlectorMesh, 1+16)
SpriteViewMode_(System\FlectorMesh, 2)
ScaleSprite_(System\FlectorMesh, #FlectorSize, #FlectorSize)
EntityBlend_(System\FlectorMesh, 3)
HideEntity_(System\FlectorMesh)
; -Switcher-
System\SwitchSymbol   = LoadSprite_("Switch.png")
EntityFX_(System\SwitchSymbol, 1)
SpriteViewMode_(System\SwitchSymbol, 2)
RotateEntity_(System\SwitchSymbol, 90, 0, 0)
ScaleSprite_(System\SwitchSymbol, #HalfCell, #HalfCell)
HideEntity_(System\SwitchSymbol)
; -Personal crests-
System\SpectatorCrest = LoadTexture_("Crests\Spectator.jpg")
System\MeanieCrest    = LoadTexture_("Crests\Meanie.jpg")
System\IdeaCrest      = LoadTexture_("Crests\Idea.jpg")
System\SentryCrest    = LoadTexture_("Crests\Sentry.jpg")
System\SocietyCrest   = LoadTexture_("Crests\Society.jpg")
System\EnigmaCrest    = LoadTexture_("Crests\Enigma.jpg")
System\JusticeCrest   = LoadTexture_("Crests\Justice.jpg")
System\HungerCrest    = LoadTexture_("Crests\Hunger.jpg")
System\JinxCrest      = LoadTexture_("Crests\Jinx.jpg")
System\DefilerCrest   = LoadTexture_("Crests\Defiler.jpg")
System\AmgineCrest    = LoadTexture_("Crests\Amgine.jpg")
System\ParadigmaCrest = LoadTexture_("Crests\PAradigma.jpg")
; -Flectors-
System\CompressFlector  = LoadTexture_("Flectors\Compressor.jpg")
System\SeerFlector      = LoadTexture_("Flectors\Seer.jpg")
System\ParadigmaFlector = LoadTexture_("Flectors\Paradigma.jpg")
System\DesireFlector    = LoadTexture_("Flectors\Desire.jpg")
; -Express crest-
Define Square.Square : Square\Entity = CreatePivot_()
InvokeCrest(Square, #BParadigma) ; Тихо вызываем...
System\ExpressCrest = CopyEntity_(System\GUI\Crests()\Entity)
FreeEntity_(System\GUI\Crests()\Entity) ; ...Убираем...
FreeEntity_(Square\Entity) : ClearList(System\GUI\Crests())
HideEntity_(System\ExpressCrest) ; ...И скрываем.
; --Setup camera--
System\CamPiv = CreatePivot_()
System\Camera = CreateCamera_(System\CamPiv)
TurnEntity_(System\Camera, 50, 0, 0)
CameraRange_(System\Camera, 1, 1500)
; --Prepare fonts--
System\TableFont = LoadFont_("Courier")
System\DataBoardFont = LoadFont_("Lucida Console", 10)
System\PPFont = LoadFont_("FixedSys", 10)
System\TactsCounterFont = LoadAnimImage_("knight6.PNG", 24, 25, 0, 60)
System\CountersFont = LoadFont_("Tahoma", 13)
System\WinFont = LoadFontFile("WinFont.ttf", "Haiku", 70)
; --Preparing GUI--
System\Cursor = LoadAnimImage_("Cursor.PNG", 32, 32, 0, #CurFrames)
MaskImage_(System\Cursor, 5, 7, 6)
System\NotifyCursor = LoadImage__("Notify_Cursor.PNG")
MidHandle_(System\NotifyCursor)
System\MiniMap = CreateImage_(1, 1, 1)
System\LoadingText = LoadImage__("LoadingText.PNG")
MidHandle_(System\LoadingText)
System\WinText = LoadImage__("WinText.PNG")
MidHandle_(System\WinText)
System\LoseText = LoadImage__("LoseText.PNG")
MidHandle_(System\LoseText)
System\PressSpace = LoadImage__("PressSpace.PNG")
MidHandle_(System\PressSpace)
System\TimeOutText = LoadImage__("TimeOut.PNG")
MidHandle_(System\TimeOutText)
System\AIWinText = LoadImage__("AIWin.PNG")
MidHandle_(System\AIWinText)
System\RMark = LoadImage__("RMark.PNG")
MidHandle_(System\RMark)
System\DataBoard = LoadImage__("DataBoard.PNG")
System\AscendantBoard = LoadImage__("AscendantBoard.PNG")
System\DataBoardSize\X = ImageWidth_(System\DataBoard)
System\DataBoardSize\Y = ImageHeight_(System\DataBoard)
System\CountersTitle = LoadImage__("CountersTitle.PNG")
System\Mixer = CreateImage_(1, 1, 1)
System\Attention = CreateImage_(#AttentionWidth, #AttentionHeight+#AttentionFix, #MaxPlayers*2+1) : DrawAttention()
System\InfCache = CreateImage_(#TableWidth, #InfCacheHeight, #EpidemiaStart) : DrawInfection()
System\StoreCache = CreateImage_(#TitleWidth, #TitleHeight, #MaxPlayers * #StoreCells + 1) : DrawStore()
System\Momentum = CreateImage_(#MomentumQuant, #MomentumQuant, (#MaxPlayers+1)*#MaxMomentum) : DrawMomentum()
System\GoneCounters = LoadAnimImage_("GoneCounters.PNG", #CounterWidth, #CounterHeight, 0, #MaxPlayers)
System\Counters = LoadAnimImage_("Counters.PNG", #CounterWidth, #CounterHeight, 0, #MaxPlayers)
System\CountersData\Left = #CounterWidth : System\CountersData\Top = #CounterHeight
System\CountersData\Right = (System\CountersData\Left - 26 - 5) / 2 + 5
System\CountersData\Bottom = (System\CountersData\Top - 4) / 2
; -DataBoard tips:
System\IChoosen  = LoadImage__("IChoosen.png")  : MidHandle_(System\IChoosen)
System\IAbsent   = LoadImage__("IAbsent.png")   : MidHandle_(System\IAbsent)
System\ILinked   = LoadImage__("ILinked.png")   : MidHandle_(System\ILinked)
System\IDepraved = LoadImage__("IDepraved.png") : MidHandle_(System\IDepraved)
System\IOther    = LoadImage__("IOther.png")    : MidHandle_(System\IOther)
System\INeeded   = LoadImage__("INeeded.png")   : MidHandle_(System\INeeded)
; -Buttons-
System\Buttons[#BtnEndTurn]\Image = LoadAnimImage_("EndButton.PNG", 98, 28, 0, 2)
System\Buttons[#BtnSearchActive]\Image = LoadAnimImage_("IterateButton.PNG", 98, 28, 0, 2)
; -Main Menu-
System\MTextLogo   = LoadImage__("Logo.PNG")                          : MidHandle_(System\MTextLogo)
System\MSubLogo    = LoadImage__("SubLogo.PNG")                       : MidHandle_(System\MSubLogo)
System\MPanoptikum = LoadAnimImage_("Panoptikum.png", 262, 75, 0, 2) : MidHandle_(System\MPanoptikum)
System\MRandomMap  = LoadAnimImage_("Random Map.PNG", 286, 75, 0, 2) : MidHandle_(System\MRandomMap)
System\MLoadMap    = LoadAnimImage_("Load game.PNG", 358, 75, 0, 2)  : MidHandle_(System\MLoadMap)
System\MOptions    = LoadAnimImage_("Options.PNG", 177, 75, 0, 2)    : MidHandle_(System\MOptions)
System\MExit       = LoadAnimImage_("Exit.PNG", 102, 75, 0, 2)       : MidHandle_(System\MExit)
System\MSignature  = LoadImage__("Signature.PNG")                     : MidHandle_(System\MSignature)
System\MBackGroundTex = LoadTexture_("MenuBG.JPEG")
; -Selection-
System\Selection = LoadAnimMesh_("Selection.B3D")
Animate_(System\Selection, 1)
; --Eye candy--
System\Noise = LoadAnimImage_("noise.jpg", #NoiseBlock, #NoiseBlock, 0, #NoiseFrames)
System\BlurTex = ScreenTexture(256) : System\Blurer = ScreenSprite(1, -10000) ; Blur.
System\NoiseBuffer = ScreenTexture() ; Noise
; --Fading setup--
System\Fader = ScreenSprite(1, -10001) : EntityColor_(System\Fader, 0, 0, 0)
; -Targeting setup-
*Texture = LoadTexture_("Target.png", 4)
System\Target = CreateSprite_()
EntityTexture_(System\Target, *Texture)
ScaleSprite_(System\Target, 15, 15) 
EntityOrder_(System\Target, -1)
System\SubTarget = CopyEntity_(System\Target, System\Target)
ScaleSprite_(System\SubTarget, 18, 18) 
HideEntity_(System\Target)
FreeTexture_(*Texture)
; -Frost marks-
*Texture = LoadTexture_("Frost.png", 4)
System\FrostCross = CreateSprite_(System\Target)
EntityTexture_(System\FrostCross , *Texture)
EntityOrder_(System\FrostCross, -2) : RotateSprite_(System\FrostCross, 45)
For I = 0 To #DesireWide-1:System\SubCrosses[I]=CopyEntity_(System\FrostCross, System\Target):Next I 
System\GrandCross = CopyEntity_(System\FrostCross, System\FrostCross)
RotateSprite_(System\GrandCross, 90)
; --Synchronizer--
System\GameTimer = CreateTimer_(#GameFPS)
System\MenuTimer = CreateTimer_(#MenuFPS)
; --Prepare music list--
FMOD_System_Create(@System\FModSystem)
FMOD_System_Init(System\FModSystem, 32, 0, 0) 
System\Tracks = AllocateMemory(1)
SetCurrentDirectory("Music\")
ExamineDirectory(0, "", "*.MUS")
While NextDirectoryEntry(0)
If DirectoryEntryType(0) : System\FoundTracks + 1 : AddTrack(DirectoryEntryName(0)) : EndIf
Wend : If System\FoundTracks : System\CurrentTrack = 1 : EndIf
; -Data container-
DataSection
denominations: Data.s "M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"
denomValues:   Data.i  1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1
EndDataSection
; -Roman cache setup-
Restore denominations : For I = 0 To #RomanCount : Read.s System\refRoman(i)\Symbol : Next I 
Restore denomValues   : For I = 0 To #RomanCount : Read.I System\refRoman(i)\Value : Next I 
; --Select "Maps" directory--
SetCurrentDirectory("..\..\Maps")
; --Options--
If OpenOptionsFile() = #False ; Если не удалось загрузить настройки...
System\Options\PlayMusic          = #True
System\Options\AutoSave           = #True
System\Options\DisplayMiniMap     = #True
System\Options\DisplayETButton    = #True
System\Options\DisplaySAButton    = #True
System\Options\DisplayTables      = #True
System\Options\DisplayCounters    = #True
;System\Options\SelectBeingByModel = #True ; Unfortunately.
System\Options\OmniAlpha          = #LegacyAlpha
System\Options\SparksRain         = #True
System\Options\NoiseFilter        = #True
System\Options\BlurFilter         = #True
System\Options\InstableOut        = #True
System\Options\MusicVolume        = 1.0
SaveOptions()
ButtonsViziblity()
Else ; Загружаем настройки.
ReadData(0, @System\Options, SizeOf(OptionsData))
ButtonsViziblity()
CloseFile(0)
EndIf
; -Start additional threads-
System\VideoMutex = CreateMutex()
System\MAxFPS   = #MenuFPS ; Заглушка.
System\SSThread = CreateThread(@ScreenShooter(), 0)
System\MBThread = CreateThread(@MusicBox(), 0)
While IsThread(System\MBThread) = #False : Delay(5) : Wend
PauseThread(System\MBThread)
System\CurrentTrack = 1
; -Recording stack base-
SetHint("send AutoSave.MAP to author")
EnableASM : MOV System\StackAnchor, ESP : DisableASM
EndMacro

Macro RegisterInput()
System\GUI\Input = GetInput()
System\GUI\MousePos\X = MouseX_()
System\GUI\MousePos\Y = MouseY_()
System\GUI\FPS = CountFPS()
EndMacro

Macro MainMenu() ; Доделать
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EnableASM : MOV ESP, System\StackAnchor : DisableASM
System\MaxFPS = #MenuFPS
Define SelectedElement, FName.S, Fade.F = 250
#HalfScreenWidth = #ScreenWidth / 2
#MRequesterTitle = "Choose file to load game/map:"
#ElementsGap     = 70
#MPanoptikumPos  = 235 - #ElementsGap / 3 ;Temporary
#MRandomMapYPos  = #MPanoptikumPos + #ElementsGap 
#MLoadMapYPos    = #MRandomMapYPos + #ElementsGap
#MOptionsYPos    = #MLoadMapYPos   + #ElementsGap
#MExitYPos       = #MOptionsYPos   + #ElementsGap
#MinFadeLevel    = 100
HidePointer_() : ClsColor_(0, 0, 0) : UseBuffer()
CleanUp() : System\GUI\Noised = 5 : HideEntity_(System\Fader)
EntityAlpha_(System\Blurer, 1) : EntityFX_(System\Blurer, 0)
ShowEntity_(System\Blurer) : EntityTexture_(System\Blurer, System\MBackGroundTex)
Repeat : RegisterInput()
AltLockMutex(System\VideoMutex)
If System\GUI\Noised = 0 ; Если нет зашумления...
RenderWorld_()
If Fade <= #MinFadeLevel
; -Check high-lighting-
If CheckElementSelection(System\MPanoptikum, #HalfScreenWidth, #MPanoptikumPos)    : SelectedElement = 1
ElseIf CheckElementSelection(System\MRandomMap, #HalfScreenWidth, #MRandomMapYPos) : SelectedElement = 2
ElseIf CheckElementSelection(System\MLoadMap, #HalfScreenWidth, #MLoadMapYPos)     : SelectedElement = 3
ElseIf CheckElementSelection(System\MOptions, #HalfScreenWidth, #MOptionsYPos)     : SelectedElement = 4
ElseIf CheckElementSelection(System\MExit, #HalfScreenWidth, #MExitYPos)           : SelectedElement = 5
Else : SelectedElement = 0 : EndIf
; -Redraw main menu-
DrawImage_(System\MTextLogo, #HalfScreenWidth, 70) : DrawImage_(System\MSubLogo, #HalfScreenWidth, 160)
;DrawMainMenuElement(System\MPanoptikum, #HalfScreenWidth, #MPanoptikumPos, 1, SelectedElement)
DrawMainMenuElement(System\MRandomMap, #HalfScreenWidth, #MRandomMapYPos, 2, SelectedElement)
DrawMainMenuElement(System\MLoadMap  , #HalfScreenWidth, #MLoadMapYPos  , 3, SelectedElement)
DrawMainMenuElement(System\MOptions  , #HalfScreenWidth, #MOptionsYPos  , 4, SelectedElement)
DrawMainMenuElement(System\MExit     , #HalfScreenWidth, #MExitYPos     , 5, SelectedElement) 
DrawImage_(System\MSignature, #HalfScreenWidth, #ScreenHeight - 20) 
DrawMainCursor() ; Отрисовка курсора.
Else : AmbientLight_(Fade, Fade, Fade) : Fade - 6
EndIf
Else : NoiseGarden() : EndIf
Flip_() ; Показываем меню.
UnlockVideoMutex()
; -Check input
Select System\GUI\Input
Case #PB_MB_Left ; Щелчек левой.
If Fade <= #MinFadeLevel And System\GUI\Noised = 0
Select SelectedElement
Case 2 : If LoadMap() = #True : Break : EndIf
Case 3 : ShowPointer_()
FName = OpenFileRequester(#MRequesterTitle, GetCurrentDirectory(), "Flow saves/maps (*.MAP)|*.MAP", 1)
If FName <> "" : If LoadMap(FName) = #True : Break : EndIf : EndIf : HidePointer_() 
Case 4 : ShowOptionsPanel()
Case 5 : Quit()
EndSelect
EndIf
Case #PB_Key_Escape : Quit()
EndSelect

; -Additional controls-
If System\GUI\Exit : Quit() : EndIf
WaitTimer_(System\MenuTimer)
ForEver
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndMacro

Procedure LookAt(*Target.Square, SendPointer = #False)
Define *Square = *Target\Entity ; Получаем область.
DynamicNoise(*Square) : PositionEntity_(System\CamPiv, TakeX(*Square), 0, TakeZ(*Square))
SetOn(System\Selection, *Square) ; Поставить выделение.
If SendPointer Or System\Buttons[#BtnSearchActive]\State <> #True
CameraProject_(System\Camera,TakeX(*Square),TakeY(*Square),TakeZ(*Square))
System\GUI\MousePos\X = ProjectedX_() : System\GUI\MousePos\Y = ProjectedY_()
MoveMouse_(System\GUI\MousePos\X, System\GUI\MousePos\Y)
SetPickedSquare()
EndIf
EndProcedure

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
SetPickedSquare()
; -Mini Map controls-
CheckMiniMap()
EndMacro

Macro Linkable(Being) ; Pseudo-procedure.
Being And Being\Owner = System\Level\CurrentPlayer
EndMacro

Macro Selectable(SBeing) ; Pseudo-procedure.
SBeing\State=#BActive And SBeing\Owner=System\Level\CurrentPlayer And SBeing\GonnaRide=#False And MindInfected(SBeing)=#False
EndMacro

Macro PlayerControl()
#SavePattern = "Flow saves (*.MAP)|*.MAP"
CheckButtons()
Define FName.S, *PSquare.Square, *Being.Being : *PSquare = System\GUI\PickedSquare
Select System\GUI\Input
Case #PB_MB_Left
If *PSquare ; Если выделена клетка.
Define *PBeing.Being, *SelBeing.Being : *PBeing = *PSquare\Being : *SelBeing = System\GUI\SelectedBeing
If *SelBeing ; Perform actions (Aborbtion/Spawning)
If DelayTargeting(*SelBeing) And *PSquare\State = #SAbsorbtion
If *PSquare\DelayedBlow = #Null : DelayBlow(*SelBeing, *PSquare) : EndIf
ElseIf ParaTroop(*SelBeing) And *PSquare\State = #SSpawning ; Мгновенный прыжок
If Existing(*Being) : GoNNaRide(*SelBeing, *PBeing) :  EndIf
ElseIf *PBeing ; Если там что-то есть...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If *PSquare\State = #SAbsorbtion Or *PSquare\State = #SAbsAndSpawn ; Check square state
If *PBeing <> *SelBeing And Existing(*PBeing)
; ^Prevent self-absorbtion And absrobtion of non-existent beings.^
AbsorbBeing(*SelBeing, *PSquare\Being)
EndIf
ElseIf *PSquare\State = #SRecarn : StartReincarnation(*SelBeing) ; - Реинкарнируем
ElseIf *PSquare\State = #SSwitch And *Being\Interstate = #False : SwitchMood(*SelBeing) ; Инвертируем режим.
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ElseIf *PSquare\State = #SSpawning Or *PSquare\State = #SAbsAndSpawn ; Check square state.
SpawnBeing(*SelBeing, *PSquare)
EndIf
ElseIf *PBeing And Selectable(*PBeing) : SelectBeing(*PBeing) ; Select being.
EndIf
EndIf
Case #PB_MB_Right
System\GUI\SelectedBeing = #Null
Case #PB_Key_Space
System\GUI\SelectedBeing = #Null
NextTurn()
Case #PB_Key_L
ShowPointer_() : CreateDirectory(#SavesDir)
FName = Trim(OpenFileRequester("Choose file to load game:", #SavesDir, #SavePattern, 1))
If FName <> "" : LoadMap(FName) : EndIf
HidePointer_()
Case #PB_Key_S
ShowPointer_() : CreateDirectory(#SavesDir)
FName = Trim(SaveFileRequester("Choose file to save game:", #SavesDir, #SavePattern, 1))
If FName <> "" 
If GetExtensionPart(FName) = "" : FName + ".MAP" : EndIf
SaveMap(FName)
EndIf
HidePointer_()
Case #PB_Key_U;ndo (load last save).
If System\Options\AutoSave : LoadMap(#AutoSave) : EndIf
Case #PB_Key_Tab ; Goto bext Being.
*Being = NextActiveBeing(System\Level\CurrentPlayer) ; Ищем по списку.
If *Being And *Being = System\GUI\SelectedBeing      ; Если уже выделена...
*Being = NextActiveBeing(System\Level\CurrentPlayer) ; ...Ищем опять.
EndIf : If *Being ; Если в списке что-нибудь осталось...
LookAt(*Being\Square) : CollapseHL() : SelectBeing(*Being)
EndIf
Case #PB_Key_Return ; Look at selected Being.
If System\GUI\SelectedBeing : LookAt(System\GUI\SelectedBeing\Square, #True) : EndIf
Case #PB_Key_O ; Открыть панель опций.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ShowOptionsPanel()
If System\Options\SelectBeingByModel : MakeAllBeingsPickable()
Else : MakeAllBeingsUnPickable()
EndIf
If System\Options\BlurFilter : ShowEntity_(System\Blurer)
Else : HideEntity_(System\Blurer) : EndIf
EnforceMusicSettings()
SetTrackVolume(System\Options\MusicVolume)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Case #PB_Key_Q ; Снова показать брифинг.
If Trim(System\Story) <> "" 
PauseThread(System\MBThread)
PrettyPrint(FormatStory(System\Story, #True), #True)
ResumeThread(System\MBThread)
EndIf
Case #PB_Key_1 To #PB_Key_0 ; Bind-клавиши.
Define SCell = System\GUI\Input - #PB_Key_1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If System\GUI\Control And Linkable(System\GUI\SelectedBeing)
LinkBeing(System\GUI\SelectedBeing, SCell)               ; Формируем связь.
ElseIf System\GUI\Control : LinkBeing(#Null, SCell)      ; Отвязываем.
ElseIf StoreCell(SCell) And Selectable(StoreCell(SCell)) ; Если на клавише кто-то висит...
SetOn(System\Selection, StoreCell(SCell)\Square\Entity)  ; Ставим выделение.
CollapseHL() : SelectBeing(StoreCell(SCell))             ; Выделяем соответствующую Сущность.
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndSelect
InfoHL()
EndMacro

Macro AIControl()
;;;;;;;; Base AI ;;;;;;;;;;;
Define *AIBeing.Being, *Victim.Being, *NearestEnemy.Being, *NearestSquare.Square
Define Run, *Player.Player : *Player = System\Players(System\Level\CurrentPlayer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If System\Level\ActivationFlag = #False And *Player\MovedBeings = 0 ; Если никого не ждем и еще нет таблицы...
If *Player\FirstBeing = #Null ; Если мы начали строить таблицу....
ClearDSTable() ; Очистить таблицу опасностей.
EndIf
*AIBeing = NextActiveBeing(System\Level\CurrentPlayer, 2)
If *AIBeing <> *Player\FirstBeing
If *Player\FirstBeing = #Null : *Player\FirstBeing = *AIBeing : EndIf
If Sacrificer(*AIBeing) = #False And (Enemies(*AIBeing\Owner, System\Level\CurrentPlayer) Or MindInfected(*AIBeing))
SetDanger(*AIBeing) : EndIf ; Выставить уровни опасности.
Else : *Player\MovedBeings = 1
System\Level\AIFrame = System\Options\AIDelay
*Player\Rush = Rnd(7)
If *Player\Rush = 1 Or *Player\IType = #IKamikazeAI : *Player\Rush = #True
Else : *Player\Rush = #False : EndIf
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndIf
If *Player\MovedBeings > 0
If System\Level\AIFrame >= System\Options\AIDelay ; Если сработал счетчик кадров...
System\Level\AIFrame = 0 ; Обнуляем его.
*AIBeing = NextActiveBeing(System\Level\CurrentPlayer) ; Ищем следующую активную Сущность...
If *AIBeing : DeActivateBeing(*AIBeing)   ; Снимаем флаг активации.
Run = CheckEscape(*AIBeing, *Player\Rush) ; Если с клетки нужно срочно уходить...
RestartAI:
If NeedsReincarnation(*AIBeing) = #False Or Run ; Если Сущность пока не может реинкарнировать...
If Run : *Victim = #Null ; Если с клетки нужно убегать - целей нет.
Else : *Victim = FindVictim4Absobtion(*AIBeing) ; Ищем ближайшего врага, чтобы абсорбировать...
EndIf ; Подводим итоги прцеливания:
If *Victim ; Если есть результаты...
AbsorbBeing(*AIBeing, *Victim) ; Абсорбировать найденного врага.
Else ; Если нет результатов...
If Run = #False And NeedsReincarnation(*AIBeing, 1) ; Если теперь есть смысл реинкарнировать...
StartReincarnation(*AIBeing) ; Ренкарнируем.
ElseIf Run = #False And *AIBeing\Type = #BAmgine : StartReincarnation(*AIBeing) ; Переходим в боевую форму.
ElseIf CanSpawn(*AIBeing) And System\Players(System\Level\CurrentPlayer)\IType <> #IGuardianAI
*NearestEnemy = FindNearestEnemy(*AIBeing.Being) ; Ищем ближайшего врага, что бы переместиться к нему...
*NearestSquare = FindNearestSquare4Spawning(*AIBeing, *NearestEnemy, *Player\Rush)
; ^Ищем оптимальную позицию для переноса^...
If *NearestSquare ; Если свободная панель найдена...
If Run : *AIBeing\SuicidalStop = #True : EndIf
Run = #False ; Снимаем флаг рестарта AI
*NearestEnemy = SpawnBeing(*AIBeing, *NearestSquare) ; - размножаемся :)
; Выставляем флаг остановки в случае Rush'а.
If CheckDeadlyDanger(*NearestEnemy, *NearestEnemy\Square, 2) : *NearestEnemy\SuicidalStop = #True : EndIf
EndIf
EndIf
If Run = #True : Run = #False : Goto RestartAI : EndIf
EndIf
Else : StartReincarnation(*AIBeing) ; Ренкарнируем.
EndIf
*Player\MovedBeings + 1
Else
NextTurn() ; Завершаем ход.
EndIf
Else : System\Level\AIFrame + 1 ; Инкрементируем счетчик кадров.
EndIf
EndIf
;;;;;;;; Base AI ;;;;;;;;;;;
EndMacro

Macro FadeScreen() ; Доделать !
EntityAlpha_(System\Fader, System\Level\WaitForFinish / #WaitFinish)
Define LightLevel = #CursorLight - System\Level\WaitForFinish * (#CursorLight / #WaitFinish)
LightColor_(System\Light, LightLevel, LightLevel, LightLevel)
EndMacro

Macro HorizLines(Y) ; Pseudo-procedure
Define YPos = Y
Line_(0, Y - 1, #ScreenWidth, Y - 1)
Line_(0, Y + 1, #ScreenWidth, Y + 1)
EndMacro

Macro VertLines(X) ; Pseudo-procedure
Define XPos = X
Line_(X - 1, 0, X - 1, #ScreenHeight)
Line_(X + 1, 0, x + 1, #ScreenHeight)
EndMacro

Macro H2Lines(Height)
HorizLines((#ScreenHeight - Height) / 2) : HorizLines((#ScreenHeight + Height) / 2)
EndMacro

Procedure FindVictor(Start)
Define I, ToFix = ArraySize(System\Players())
For I = Start To ToFix
If System\Players(I)\BeingsCount And Enemies(1, I)
TeamIdx2Color(System\Players(I)\AlliedTeam) : ProcedureReturn 0
EndIf
Next I
EndProcedure

Macro CheckResults()
Define *Image, Text.s, HumanWin = #False, I, *Team.Team, ToFix
If System\Level\WaitForFinish = 0
If System\Level\HumanPlayers = 0 Or System\Level\TeamsCount = 1 : System\Level\WaitForFinish = 1 
CollapseHL() ; Убрать подсветку (на всякий случай).
ForEach System\Beings() ; Снять флаг готовности со всех сущностей.
If System\Beings()\State = #BActive : DeActivateBeing(System\Beings()) : EndIf
Next ; ...Иначе продолжаем...
ElseIf System\Players(System\Level\CurrentPlayer)\BeingsCount = 0
NextTurn()
EndIf
Else : System\Level\WaitForFinish + 1
If System\Level\WaitForfinish = #WaitFinish
ShutMusic()
If CheckTimeOut() = #False
If System\Level\Multiplayer = #False
If System\Players(1)\BeingsCount > 0
TeamIdx2Color(System\Players(1)\AlliedTeam)
*Image = System\WinText : HumanWin = #True 
Else : *Image = System\LoseText : FindVictor(2)
EndIf
Else
ToFix = ArraySize(System\Players())
For I = 1 To ToFix
If System\Players(I)\BeingsCount > 0
If System\Players(I)\IType = #IHuman
HumanWin = #True : *Image = #Null
Text = "Team " + Str(System\Players(I)\AlliedTeam) + " win."
TeamIdx2Color(System\Players(I)\AlliedTeam) ; Цвет.
Else : *Image = System\AIWinText   : Player2Color(0, 1)
EndIf
EndIf
Next
EndIf
Else : *Image = System\TimeOutText : Player2Color(0, -1)
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
If Trim(System\AfterStory) And HumanWin ; Если есть эпилог...
Define Standart = #False
PrettyPrint(FormatStory(System\AfterStory, 'Alt'))
Else : Standart = #True ; Выдаем стандартный экран.
UseBuffer() : ClsColor_(0, 0, 0) : Cls_()
AltLockMutex(System\VideoMutex)
If *Image ; Если готов изображение...
Define Width = ImageWidth_(*Image), Height = ImageHeight_(*Image)
H2Lines(Height) : DrawImage_(*Image, #ScreenWidth / 2, #ScreenHeight / 2, 0)
Else : SetFont_(System\WinFont) ; Ставим соотв/ ситуации шрифт.
Width = StringWidth_(Text) + #WinOut * 2 : Height = StringHeight_(Text) + #WinOut * 2
H2Lines(Height) : VertLines((#ScreenWidth - Width) / 2) : VertLines((#ScreenWidth + Width) / 2) 
Text_(#ScreenWidth / 2, #ScreenHeight / 2, Text, 1, 1) : Color_(0, 0, 0)
Line_((#ScreenWidth - Width) / 2, 0, (#ScreenWidth - Width) / 2, #ScreenHeight)
Line_((#ScreenWidth + Width) / 2, 0, (#ScreenWidth + Width) / 2, #ScreenHeight)
Line_(0, (#ScreenHeight - Height) / 2, #ScreenWidth, (#ScreenHeight - Height) / 2)
Line_(0, (#ScreenHeight + Height) / 2, #ScreenWidth, (#ScreenHeight + Height) / 2)
EndIf : Flip_() : UnlockVideoMutex()
Delay(1000) ; Пауза...
EndIf
If System\Level\NextMapFName <> "" And HumanWin ; Если найдена ссылка на следующую карту...
ShowPointer_()
If MessageRequester("[Flow]", "Do you want to go at ze next map ?", 4) = 6
If LoadMap(System\Level\NextMapFName, #True) : Goto EndChecking : EndIf
EndIf
HidePointer_()
SaveOptions()
! JMP MainMenuLbl
ElseIf Standart ; Если нужен стандартный экран....
AltLockMutex(System\VideoMutex)
DrawImage_(System\PressSpace, #ScreenWidth / 2, 50, 0)
DrawImage_(System\PressSpace, #ScreenWidth / 2, #ScreenHeight - 50, 0)
Flip_()
UnlockVideoMutex()
FlushKeys_() ; Ожидание нажатия пробела.
While GetInput() <> #PB_Key_Space : Delay(50) : Wend
FlushKeys_()
EndIf
SaveOptions()
! JMP MainMenuLbl
EndIf
EndIf
EndChecking:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndMacro

Macro IsTargeted(TBeing, Square) ; Pseudo-procedure
(TBeing\ExtraMode = #False And Square\Being And Square\Being <> TBeing And Existing(Square\Being))
EndMacro

Macro SetCrest(XShift, YShift) ; Partializer.
If PeekHeight(X + XShift, Y + YShift) = Height ; Начинаем.
Define *VBeing.Being = Squares(X + XShift, Y + YShift)\Being
If *VBeing And Existing(*VBeing) And *VBeing\Frozen <= #MeanFreeze And Not Unfreezable(*VBeing)
SetOn(System\SubCrosses[NextCross], *VBeing\EyePoint)
ShowEntity_(System\SubCrosses[NextCross]) : NextCross + 1
EndIf : EndIf
EndMacro

Macro CrossWarn() ; Partializer.
PrepareScoring(*PSquare\Being) : SetCrest(0, 1) : SetCrest(0, -1) : SetCrest(1, 0) : SetCrest(-1, 0)
EndMacro

Macro AnimateWorld()
Define ATime.f, NextCross = 0
; -Update feeder-
If System\GUI\SinFeeder = #MaxFeeder : System\GUI\SinFeeder = 0
Else : System\GUI\SinFeeder + 1 : EndIf  ; Теперь кэш:
System\GUI\SinCache = Sin(Radian(System\GUI\SinFeeder))
System\GUI\DoubleCache = Abs(Sin(Radian(System\GUI\SinFeeder * 2)))
; -Update animation-
UpdateWorld_()
; -Update "Sky"-
TurnEntity_(System\Sky, 0, 0.1, 0)
TurnEntity_(System\Space, 0, -0.3, 0)
EntityAlpha_(System\Space, 0.15 + 0.15 * System\GUI\SinCache)
; -Hide crosshair-
HideEntity_(System\Target)
; -Hide "ghost"-
HideEntity_(System\GUI\Ghost\Entity)
; -Hide Projection-
HideEntity_(System\Projection)
; -Hide ExpressCrest-
HideEntity_(System\ExpressCrest)
; -Update targeting-
If System\GUI\Targeting >= 360 - #TSpeed : System\GUI\Targeting = 0 : Else : System\GUI\Targeting + #TSpeed : EndIf
RotateSprite_(System\Target, System\GUI\Targeting) : RotateSprite_(System\SubTarget, -System\GUI\Targeting)
EntityAlpha_(System\Target, 0.5 + 0.5 * System\GUI\SinCache)
EntityAlpha_(System\SubTarget, 0.5 + 0.5 * (1 - System\GUI\SinCache))
; -Update crossing-
EntityAlpha_(System\FrostCross, 0.6 + 0.3 * System\GUI\SinCache)
Define AltAlpha.f = 0.6 + 0.3 * (1 - System\GUI\SinCache)
EntityAlpha_(System\GrandCross, AltAlpha.f)
Define Scale.f = 6 + System\GUI\DoubleCache       * 2
ScaleSprite_(System\FrostCross, Scale, Scale) 
Define Scale.f = 6 + (1 - System\GUI\DoubleCache) * 2
ScaleSprite_(System\GrandCross, Scale, Scale) : Scale / 1.5 
For I = 0 To #DesireWide-1 
EntityAlpha_(System\SubCrosses[I], AltAlpha.f)
ScaleSprite_(System\SubCrosses[I], Scale, Scale)
HideEntity_(System\SubCrosses[I]) ; Скрываем на всякий пожарный.
Next I
; -Update express cross-
EntityAlpha_(System\ExpressCrest, 0.4 + 0.9 * Abs(System\GUI\ASFlashing / 255 * 2 - 1))
; -Update selection-
Define *PSquare.Square = System\GUI\PickedSquare
If *PSquare <> #Null 
If System\GUI\SelectedBeing = #Null
SetOn(System\Selection, *PSquare\Entity)
; -Targeting system-
ElseIf (*PSquare\State=#SAbsorbtion Or *PSquare\State=#SAbsAndSpawn) And IsTargeted(System\GUI\SelectedBeing,*PSquare)
Define *PBeing.Being = *PSquare\Being ; To short things a little.
;;;;;Здесь что-то идет не так...
SetOn(System\Target, *PBeing\EyePoint) : ShowEntity_(System\Target) : HideEntity_(System\FrostCross)
;;;;;...Но вот что ?
If System\GUI\SelectedBeing\Type = #BDesire Or Not Unfreezable(*PBeing) ; Если оно все замораживается...
Select System\GUI\SelectedBeing\Type ; По типу...
Case #bHunger : ShowEntity_(System\FrostCross) : ShowEntity_(System\GrandCross) ; Полный крест.
Case #bMeanie : If *PSquare\Being\Reincarnated = #False And Not Ignorant(*PBeing) And *PBeing\Frozen <= #MeanFreeze
ShowEntity_(System\FrostCross) : HideEntity_(System\GrandCross) : EndIf         ; Простой крест.
Case #bDesire : If Not Unfreezable(*PBeing) : ShowEntity_(System\FrostCross) : HideEntity_(System\GrandCross) : EndIf
CrossWarn() ; Всегда ставим соседние кресты !
EndSelect ; Отдельно для бомбочек:
ElseIf *PBeing\Type = #BFrostBite And System\GUI\SelectedBeing\Type <> #BDesire : CrossWarn()
EndIf
ElseIf DelayTargeting(System\GUI\SelectedBeing) And *PSquare\State=#SAbsorbtion And *PSquare\DelayedBlow = #Null
ShowEntity_(System\Projection) : SetON(System\Projection, *PSquare\Entity)
RotateEntity_(System\Projection, 0, EntityYaw_(*PSquare\FVortex, 1), 0)
Else ; Если надо показать силуэт - так и делаем...
; -Update "ghost"-
If (*PSquare\State = #SSpawning Or *PSquare\State = #SAbsAndSpawn) And *PSquare\Being = #Null
ShowEntity_(System\GUI\Ghost\Entity) : RotateEntity_(System\GUI\Ghost\Entity, 0, 0, 0)
SetOn(System\GUI\Ghost\Entity, System\GUI\SelectedBeing\Entity)
TurnBeing(System\GUI\Ghost, DeltaYaw_(System\GUI\Ghost\Entity, *PSquare\Entity) - 180)
SetOn(System\GUI\Ghost\Entity, *PSquare\Entity) ; ...А теперь - анимация:
If System\GUI\SelectedBeing\Ascended And System\GUI\SelectedBeing\Posterity = System\GUI\SelectedBeing\Type
SetAnimTime_(System\GUI\Ghost\Entity, AnimTime(System\GUI\SelectedBeing)) : EndIf
ElseIf ParaTroop(System\GUI\SelectedBeing) And *PSquare\State = #SSpawning And Existing(*PBeing)
ShowEntity_(System\ExpressCrest) : SetOn(System\ExpressCrest, *PSquare\Entity)
TranslateEntity_(System\ExpressCrest, 0, 0.1, 0) ; Для зазору.
EndIf
EndIf
; -Update light-
Enlight(*PSquare\Entity) ; Поставить свет.
EndIf
; -Active Beings's squares HL cycle-
If System\GUI\ASFlashing > (#ASMaxBrightness - #ASMinBrightness) * 2
System\GUI\ASFlashing = #ASMinBrightness
Else : System\GUI\ASFlashing + 10
EndIf
; -Update cryogene-
ForEach System\GUI\Shivers()
AnimateShiver(System\GUI\Shivers())
Next
; -Update shards-
ForEach System\GUI\Shards()
AnimateShard(System\GUI\Shards())
Next
; -Update Beings-
System\Level\ActivationFlag = #False ; Сброс флага ожидания активации (для AI).
ForEach System\Beings()
AnimateBeing(System\Beings())
Next
; -Update quants-
ForEach System\GUI\Quants()
AnimateQuant(System\GUI\Quants())
Next
; -Update Ladders-
ForEach System\GUI\Ladders()
AnimateLadder(System\GUI\Ladders())
Next
; -Update crests-
ForEach System\GUI\Crests()
AnimateCrest(System\GUI\Crests())
Next
; -Update flectors-
ForEach System\GUI\Flectors()
AnimateFlector(System\GUI\Flectors())
Next
; -Update blowjob-
ForEach System\GUI\BlownSquares()
AnimateBlow(System\GUI\BlownSquares())
Next
; -Update expresses-
ForEach System\Rides()
AnimateRide(System\Rides())
Next
; -Update sparks-
If System\Options\SparksRain
If System\GUI\SparksRainTimer = #SparksSpawningDelay : System\GUI\SparksRainTimer = 0
For I = 1 To System\GUI\SparksRainFactor : SpawnSpark(Random(1)) : Next I
Else : System\GUI\SparksRainTimer + 1
EndIf
ForEach System\GUI\Sparks()
AnimateSpark()
Next
EndIf
; -Update channels-
If System\Level\ChannelsExamination = #True
System\Level\ChannelsExamination = #False
ForEach System\Channels()
Define *Channel.Channel = System\Channels(), *Source.Being = *Channel\Source, DS = *Channel\Destination\State
Define MI = MindInfected(*Source), SS = *Channel\Source\State
#BRP = #BRecarnPreparing ; Shortcut.
If SS = #BDying Or DS = #BDying Or SS = #BRecarn Or DS = #BRecarn Or SS = #BRP Or DS = #BRP
Define *Destionation = *Channel\Destination : CloseChannel()
AddBeing2UpdateList(*Source, MI) ; Обновляем источник.
AddBeing2UpdateList(*Destionation, MindInfected(*Destionation))
EndIf
Next
EndIf
; -Update vortex points-
UpdateVortexes()
; -Update rotors-
UpdateRotors()
; -Update Being's tables-
UpdateTables()
; -Update Reincarnation effects-
ForEach System\GUI\ReincEffects()
AnimateReincarnation(System\GUI\ReincEffects())
Next
EndMacro

Macro Vizualization()
AltLockMutex(System\VideoMutex)
UseBuffer()
BadMonitor() ; Генератор шума.
RenderWorld_()
MakeNoise(1000)
If System\Level\WaitForFinish = 0
DrawAllTables()
DrawTactsCounter()
DrawDataBoard()
DrawMiniMap()
DrawAllButtons()
DrawCounters()
DrawCursor()
EndIf
UpdateBlur()
Flip_()
UnlockVideoMutex()
EndMacro

Macro SystemControls()
Select System\GUI\Input
Case #PB_Key_Escape : QuitDialog()
Case #PB_Key_M : System\Options\PlayMusic = LogNot(System\Options\PlayMusic) : EnforceMusicSettings()
Case #PB_Key_A : System\Options\AutoSave = LogNot(System\Options\AutoSave)
Case #PB_Key_R : System\Options\DisplayMiniMap = LogNot(System\Options\DisplayMiniMap)
Case #PB_Key_E 
System\Buttons[#BtnEndTurn]\Display = LogNot(System\Buttons[#BtnEndTurn]\Display)
System\Options\DisplayETButton = LogNot(System\Options\DisplayETButton)
Case #PB_Key_F
System\Buttons[#BtnSearchActive]\Display = LogNot(System\Buttons[#BtnSearchActive]\Display)
System\Options\DisplaySAButton = LogNot(System\Options\DisplaySAButton)
Case #PB_Key_B : System\Options\DisplayTables = LogNot(System\Options\DisplayTables)
Case #PB_Key_C : System\Options\DisplayCounters = LogNot(System\Options\DisplayCounters)
EndSelect
; -Additional controls-
CheckExitFlag()
EndMacro

Macro ControlBlock() ; Partializer.
If System\Level\WaitForFinish = 0 ; Если игра еще продолжается...
CameraControl()
If System\Level\ServiceTime = #False ; Если не идет обслуживание...
If System\Level\Infestation = #False ; Если нет зараженных Сущностей...
If System\Players(System\Level\CurrentPlayer)\IType = #IHuman 
PlayerControl()
Else : AIControl()
EndIf
Else : InfectionControl() ; Передать управление зараженным.
EndIf
Else : DoService() ; Произвести изменения на уровне.
EndIf
Else : FadeScreen()
EndIf
EndMacro
;} EndMainMacros
; ==Main Code==
Initialization()
! MainMenuLbl: ; Спасибо Фреду за наше счастливое детство.
MainMenu()
System\MaxFPS = #GameFPS ; Выставляется игровое ограничение.
Repeat
RegisterInput()
ControlBlock()
CheckResults()
AnimateWorld()
Vizualization()
SystemControls()
WaitTimer_(System\GameTimer)
ForEver 
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 2
; Folding = C0----8----88-------------------48
; Markers = 1095,5350,5595
; EnableThread
; UseIcon = ..\Media\Eye.ico
; Executable = ..\Flow.exe
; CurrentDirectory = ..\
; Warnings = Display