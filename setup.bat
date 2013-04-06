@echo off
setlocal 
rem ===================================================================
rem                    dotfiles setup script
rem ===================================================================

rem ============
rem Init
rem ============
if "%1" == "-?" goto HELP
if "%1" == "help" goto HELP
if "%1" == "-u" (
    set CLEAR=1
    shift
)
if "%1" == "-f" (
    set FORCE=1
    shift
)

rem Base Directories
set SRC=%~dp0
if %SRC:~-1%==\ set SRC=%SRC:~0,-1%
set DST=%USERPROFILE%
if %DST:~-1%==\ set DST=%DST:~0,-1%
set PAIRS=

rem ============
rem .console
rem ============
set PAIRS=%PAIRS%;%SRC%\.console\console.xml
set PAIRS=%PAIRS%,%DST%\AppData\Roaming\Console\console.xml

rem ============
rem .ps1
rem ============
set PAIRS=%PAIRS%;%SRC%\.ps1
set PAIRS=%PAIRS%,%DST%\Documents\WindowsPowerShell

rem ============
rem .gitconfig
rem ============
set PAIRS=%PAIRS%;%SRC%\.gitconfig\.gitconfig
set PAIRS=%PAIRS%,%DST%\.gitconfig

rem ============
rem .vim
rem ============
set PAIRS=%PAIRS%;%SRC%\.vim\.vimrc
set PAIRS=%PAIRS%,%DST%\.vimrc

set PAIRS=%PAIRS%;%SRC%\.vim\.gvimrc
set PAIRS=%PAIRS%,%DST%\.gvimrc

set PAIRS=%PAIRS%;%SRC%\.vim
set PAIRS=%PAIRS%,%DST%\.vimfile

rem ============
rem main install loop
rem ============
call :process "%PAIRS%"
:process
for /f "tokens=1* delims=;" %%i in ("%~1") do (
    call :install %%i
    call :process "%%j"
)
goto EXIT

rem ============
rem main install function
rem ============
:install
setlocal
rem Test if we're dealing with directory
if exist %1\NUL set DIRECTORY=1
if exist %2\NUL set DIRECTORY=1

if defined CLEAR set DELETE=1
if defined FORCE set DELETE=1

rem Remove Existing Links
if exist %2 if defined DELETE (
    if defined DIRECTORY (
        rd %2
    ) else (
        del %2
    )
)
rem Link
if not defined CLEAR (
    if defined DIRECTORY (
        mklink /j %2 %1
    ) else (
        mklink %2 %1
    )
)

endlocal
goto EXIT

rem ============
rem Help Command Display
rem ============
:HELP
echo Installs the configuration files in dotfiles directory
echo.
echo setup [-f|-u]
echo    -f       overwrites an existing files
echo    -u       uninstalls an existing files
echo    -?       displays this message
echo.
echo e.g.
echo     setup.cmd

rem 
rem ============
rem Exit
rem ============
:EXIT
endlocal
