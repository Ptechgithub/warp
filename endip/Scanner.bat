@echo off & setlocal enabledelayedexpansion
cd "%~dp0"

if not exist "warp.exe" echo Missing warp.exe program&pause&exit

echo.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.::                                                                 ::
echo.::                Welcome to the Windows Platform WARP Startup     ::
echo.::                This program is provided for scan Warp IP        ::
echo.::                github.com/Ptechgithub                           ::
echo.::                github.com/yonggekkk                             ::
echo.::                                                                 ::
echo.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.
echo.
goto main

:main
title CF Preferred WARP IP
set /a menu=1
echo 1. Preferred IPV4 &echo 2. Preferred IPV6&echo 0. Exit&echo.
set /p menu=Please select an option (default %menu%):
if %menu%==0 exit
if %menu%==1 title CF Preferred WARP IP&set ipv4=162.159.192.0/24 162.159.193.0/24 162.159.195.0/24 188.114.96.0/24 188.114.97.0/24 188.114.98.0/24 188.114.99.0/24&goto getv4
if %menu%==2 title CF Preferred WARP IP&set ipv6=2606:4700:d0::/48 2606:4700:d1::/48&goto getv6
cls
goto main

:getv4
for %%i in (%ipv4%) do (
set !random!_%%i=randomsort
)
for /f "tokens=2,3,4 delims=_.=" %%i in ('set ^| findstr =randomsort ^| sort /m 10240') do (
call :randomcidrv4
if not defined %%i.%%j.%%k.!cidr! set %%i.%%j.%%k.!cidr!=anycastip&set /a n+=1
if !n! EQU 100 goto getip
)
goto getv4

:randomcidrv4
set /a cidr=%random%%%256
goto :eof

:getv6
for %%i in (%ipv6%) do (
set !random!_%%i=randomsort
)
for /f "tokens=2,3,4 delims=_:=" %%i in ('set ^| findstr =randomsort ^| sort /m 10240') do (
call :randomcidrv6
if not defined [%%i:%%j:%%k::!cidr!] set [%%i:%%j:%%k::!cidr!]=anycastip&set /a n+=1
if !n! EQU 100 goto getip
)
goto getv6

:randomcidrv6
set str=0123456789abcdef
set /a r=%random%%%16
set cidr=!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!:!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!:!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
set /a r=%random%%%16
set cidr=!cidr!!str:~%r%,1!
goto :eof

:getip
del ip.txt > nul 2>&1
for /f "tokens=1 delims==" %%i in ('set ^| findstr =randomsort') do (
set %%i=
)
for /f "tokens=1 delims==" %%i in ('set ^| findstr =anycastip') do (
echo %%i>>ip.txt
)
for /f "tokens=1 delims==" %%i in ('set ^| findstr =anycastip') do (
set %%i=
)
warp
for /f "skip=1 tokens=1,2,3 delims=," %%i in (result.csv) do (
set endpoint=%%i
set loss=%%j
set delay=%%k
goto show
)

:show
del ip.txt result.csv> nul 2>&1
echo.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.::                                                                 ::
echo.                      Best IP:Port %endpoint%
echo.		    Packet loss %loss% Average delay %delay%                
echo.::                                                                 ::
echo.:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.
pause
exit