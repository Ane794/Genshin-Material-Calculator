@echo off
setLocal enableDelayedExpansion

set /p rarities="Enter the number of rarity types (3): " || set rarities=3

:: Initializes target array.
for /L %%i in (1, 1, %rarities%) do (
    set targets[%%i]=0
)

:: Sets targets.
set /p inputs="Enter the target amount of each rarity type (0): "
set i=1
for %%a in (%inputs%) do (
    if !i! gtr %rarities% (
        goto :setTargetsEnd
    )
    set /a targets[!i!]+=%%a
    set /a i+=1
)
set i=
set inputs=
:setTargetsEnd

:: Verifies targets.
set hasTargets=0
for /L %%i in (1, 1, %rarities%) do (
    if !targets[%%i]! neq 0 (
        set hasTargets=1
        goto :verifyTargetsEnd
    )
)
:verifyTargetsEnd

:: Initializes amount array.
for /L %%i in (1, 1, %rarities%) do (
    set amounts[%%i]=0
)

set reached=0
:while
if %hasTargets% neq 0 if %reached% neq 0 (
    goto :whileEnd
)

:: Adds inputs to the array.
set /p inputs="Enter the amount of each rarity type: "
set i=1
for %%a in (%inputs%) do (
    if !i! gtr %rarities% (
        goto :addInputEnd
    )
    set /a amounts[!i!]+=%%a
    set /a i+=1
)
set i=
set inputs=
:addInputEnd

:: Reduces.
set c=0
for /L %%i in (%rarities%, -1, 2) do (
    set /a amounts[%%i]+=!c!
    if !amounts[%%i]! gtr !targets[%%i]! (
        set /a c="(!amounts[%%i]!-!targets[%%i]!)/3"
        set /a amounts[%%i]="!targets[%%i]!+(!amounts[%%i]!-!targets[%%i]!)%%3"
    ) else (
        set c=0
    )
)
set /a amounts[1]+=%c%
set c=

:: Outputs.
set output={%amounts[1]%%
for /L %%i in (2, 1, %rarities%) do (
    set output=!output!, !amounts[%%i]!
)
set output=%output%}
echo %output%
set output=

:: Verifies.
set reached=1
for /L %%i in (1, 1, %rarities%) do (
    if !amounts[%%i]! lss !targets[%%i]! (
        set reached=0
        goto :verifyReachedEnd
    )
)
:verifyReachedEnd

goto :while
:whileEnd
set reached=

echo Reached the targets.
pause
