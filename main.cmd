::::::::::::::::::::::::::::::::::::::::::::::::::
::                                              ::
::    Powershell CMD Wrapper                    ::
::        *.cmd elevates and runs *.ps1         ::
::                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( GOTO START )

ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

set psExe="powershell.exe"
%psExe% -NoLogo -NoProfile -Command "& { $p = Start-Process -Verb RunAs -PassThru -Wait -File %COMSPEC% -ArgumentList '/c %~s0 %*'; Write-Output $p.ExitCode; exit $p.ExitCode }"

set BANGERROR=!ERRORLEVEL!
ECHO ****ERRORLEVEL is !BANGERROR!
popd
exit /b !BANGERROR!

::::::
:START
ECHO Invoking %~dpn0.ps1 %*
ECHO ***************
setlocal
pushd "%~dp0"

set psExe="powershell.exe"
%psExe% -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "& { %~dpn0.ps1 %* ; exit $LASTEXITCODE }"

set BANGERROR=!ERRORLEVEL!
popd
exit /b !BANGERROR!
