@echo off
setlocal enabledelayedexpansion

set REPOURL=https://github.com/Berkkenz/BMP
set MCPATH=%APPDATA%\.minecraft
set GITPATH="%programfiles%\git\bin\git.exe"
set JAVA17PATH="%programfiles%\Java\jdk-17\bin\java.exe"
set JAVA8PATH="%programfiles%\Java\jre-1.8\bin\java.exe"

:: THIS IS THE INSTALLER UPDATE SECTION
echo Checking for Updates...
if not exist %GITPATH% (
	echo Git is not installed. Install Git and restart this application.
	pause
	exit /b 1
)

cd %~dp0
git fetch origin
git diff --quiet origin/main || (
	echo Updates found! Updating...
	git reset --hard origin/main
	echo Update completed... Please restart!
	pause
	exit /b 0
)