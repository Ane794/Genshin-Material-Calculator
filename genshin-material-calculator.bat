@echo off
setLocal enableDelayedExpansion

set /p rarities="Enter the number of rarity types (3): " || set rarities=3
set /p target="Enter the amount of the target rarity (0): " || set target=0

:: Initializes amount array.
for /L %%i in (1, 1, %rarities%) do (
    set amounts[%%i]=0
)

:while
if %target% neq 0 if %amounts[1]% geq %target% (
    goto :whileEnd
)

:: Adds inputs to the array.
set /p inputs="Enter the amount for each rarity types: "
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
    set /a c=!amounts[%%i]!/3
    set /a amounts[%%i]%%=3
)
set /a amounts[1]+=%c%
set c=

:: Output.
set output={%amounts[1]%%
for /L %%i in (2, 1, %rarities%) do (
    set output=!output!, !amounts[%%i]!
)
set output=%output%}
echo %output%
set output=

goto :while
:whileEnd

echo Reached the target amount.
pause
