@echo off
set path=C:\Users\Kacper\Desktop\save wip\Conan Exiles\ConanSandbox

:main
echo 1 Name your current save
echo 2 Select a save to load
echo 0 Exit

set /p choice=""
if %choice%==1 set /p name="Enter save name:" && goto nameSave
if %choice%==2 goto listSaves
if %choice%==0 exit

exit

:nameSave
ren "%path%\Saved" "Saved_%name%"
goto main

:listSaves
cd %path%
setlocal enabledelayedexpansion
set c = -1
for /d %%d in (*) do (
    set dir=%%~nxd
    set fin=!dir:~6!
    if "!dir:~0,6!" == "Saved_" (
        set /A c+=1
        set "arr[!c!]=!fin!"
    )
)
echo Select a save to load
for /L %%f in (1,1,!c!) do (echo %%f - !arr[%%f]!)

:selection
set /p sel=""

if defined arr[%sel%] (
    set load=Saved_!arr[%sel%]!
    echo !load!
) else (echo Invalid selection && goto selection)

endlocal