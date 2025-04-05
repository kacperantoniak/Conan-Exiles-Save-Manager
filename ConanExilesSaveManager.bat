@echo off
setlocal enabledelayedexpansion

REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Valve\Steam /v InstallPath>saveMgrDetectTempFile.txt
set "steamPath="

for /f "usebackq tokens=1,2,3*" %%A in (saveMgrDetectTempFile.txt) do (
    if "%%A"=="InstallPath" (
        set "steamPath=%%C %%D"
    )
)

del saveMgrDetectTempFile.txt
echo Steam path is: !steamPath!

set path="!steamPath!\steamapps\common\Conan Exiles\ConanSandbox"
echo saves path is !path! 

if not exist %path% (
    echo %path% does not exist.
    pause
    exit
)
echo %path%> savemgr_tempfile.txt
for %%? in (savemgr_tempfile.txt) do ( set /A len=%%~z? - 2 )
set /A len = %len% - 2
del savemgr_tempfile.txt


:main

if not exist "!path:~1,%len%!\Saved" (
    goto listSaves
)

echo Name your current save.
set /p name=""

if exist "!path:~1,%len%!\Saved_"%name% (
    echo Save with the name %name% already exists, please use a different name.
    goto main
)

ren "!path:~1,%len%!\Saved" "Saved_%name%"


:listSaves
cd %path%
set c = -1
for /d %%d in (*) do (
    set dir=%%~nxd
    set fin=!dir:~6!
    if "!dir:~0,6!" == "Saved_" (
        set /A c+=1
        set "arr[!c!]=!fin!"
    )
)
echo Select a save to load or enter 0 to exit (making you able to start a new save).
for /L %%f in (1,1,!c!) do (echo %%f - !arr[%%f]!)


:selection
set /p sel=""

if %sel%==0 exit

if defined arr[%sel%] (
    set load=Saved_!arr[%sel%]!
    ren "!path:~1,%len%!\Saved_!arr[%sel%]!" "Saved"
) else (echo Invalid selection. && goto selection)

echo Successfully loaded !arr[%sel%]!!
pause
