; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
; -Common reference table of essential constants.
; -Accentuated in 2014 by Guevara-chan.
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Enumeration ; Being types
#BTree      ; Препятствие и источник энергии.
#BSpectator ; Высокий радиус для абсорбции, низкий для размножения.
#BSentry    ; Абсорбируют сразу, не размножаются.
#BMeanie    ; Замораживают атакованные Сущности.
#BIdea      ; Низкая атака, но низкая цена размножения, и высокий радиус.
#BSociety   ; Изменяет атакованные Сущности, заставляя их каждый ход передавать ему энергию.
; -Реинкарнаты-
#BJustice  ; Перерожденный Spectator.
#BSentinel ; Перерожденный Sentry.
#BHunger   ; Пееррожденный Meanie.
#BJinx     ; Перерожденная Idea.
#BDefiler  ; Перожденное Society.
#BAgave    ; Перерожденная версия Tree.
; -Энигматики-
#BEnigma   ; Игнорирует штрафы за атаку по Перерожденным. Может превращаться в Amgine.
#BAmgine   ; Вместо абсорбции передает свою энергию. Может превращаться в Enigma.
; -Инструменты-
#BFrostbite ; Занимает место, замораживает при разрушении всех вокруг.
; -Аскенданты-
#BSeer      ; Вознесенный Spectator. В бытность экстравертом бьет по любой клетке с задержкой в ход.
#BParadigma ; Вознесенная Idea. В бытность экстравертом меняется местами с выбранной Сущностью.
#BDesire    ; Вознесенный Meanie. В бытность экстравертом плодит ForstBite'е из накопленных Ядер.
EndEnumeration

Procedure GetReincarnatedType(Type)
Select Type
Case #BSpectator, #BSeer : ProcedureReturn #BJustice
Case #BSentry            : ProcedureReturn #BSentinel
Case #BMeanie, #BDesire  : ProcedureReturn #BHunger
Case #BIdea, #BParadigma : ProcedureReturn #BJinx
Case #BSociety           : ProcedureReturn #BDefiler
Case #BEnigma            : ProcedureReturn #BAmgine
Case #BAmgine            : ProcedureReturn #BEnigma
Default : ProcedureReturn Type
EndSelect
EndProcedure

Procedure GetDegradatedType(Type, Extra = #False)
Select Type
Case #BJustice  : ProcedureReturn #BSpectator
Case #BSentinel : ProcedureReturn #BSentry
Case #BHunger   : ProcedureReturn #BMeanie
Case #BJinx     : ProcedureReturn #BIdea
Case #BDefiler  : ProcedureReturn #BSociety
Case #BAgave    : If Extra : ProcedureReturn #BTree : EndIf
Default : ProcedureReturn Type
EndSelect
EndProcedure

Procedure GetAscendedType(Type)
Select Type
Case #BSpectator, #BJustice : ProcedureReturn #BSeer
Case #BIdea, #BJinx         : ProcedureReturn #BParadigma
Case #BMeanie, #BHunger     : ProcedureReturn #BDesire
Default : ProcedureReturn Type
EndSelect
EndProcedure

Procedure GetDescendedType(Type)
Select Type
Case #BSeer      : ProcedureReturn #BSpectator
Case #BParadigma : ProcedureReturn #BIdea
Case #BDesire    : ProcedureReturn #BMeanie
Default : ProcedureReturn Type
EndSelect
EndProcedure
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; Folding = -
; EnableUnicode
; EnableXP