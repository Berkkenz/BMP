@echo off
setlocal enabledelayedexpansion

set REPOURL=https://github.com/Berkkenz/BMP
set MCPATH=%APPDATA%\.minecraft
set GITPATH="%programfiles%\git\bin\git.exe"
set JAVA17PATH="%programfiles%\Java\jdk-17\bin\java.exe"
set JAVA8PATH="%programfiles%\Java\jre-1.8\bin\java.exe"

:: THIS IS THE GIT CHECK SECTION
echo Checking for Updates...
if not exist %GITPATH% (
	echo Git not installed. Attempting installation...
	curl -o "%temp%\gitinstaller.exe" "https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe"
	start /wait "%temp%\gitinstaller.exe" /s
	del %temp%\gitinstaller.exe /Q /F
	if not exist %GITPATH% (
		cls
		echo Installation failed, exiting...
		pause
		exit /b 1
	)
	echo Git has been installed
	timeout 2
)

:: THIS IS THE INSTALLER UPDATE SECTION
cd %~dp0
git fetch origin
git diff --quiet origin/main || (
	echo Updates found! Updating...
	git reset --hard origin/main
	echo Update completed... Please restart!
	pause
	exit /b 0
)
cls
echo Up to Date! Continuing...
timeout 2

:: THIS IS THE DEPENDANCIES CHECK SECTION
:: JAVA 17
if not exist %JAVA17PATH% (
	echo Java 17 not installed, Attempting installation...
	curl -o "%temp%\java17installer.exe" "https://download.oracle.com/java/17/archive/jdk-17.0.10_windows-x64_bin.exe"
	start /wait "%temp%\java17installer.exe" /s
	del %temp%\java17installer.exe" /Q /F
	if not exist %JAVA17PATH% (
		cls
		echo Install failed. Exiting...
		pause
		exit /b 1
	)
	echo Java 17 installed...
	timeout 2
)

:: JAVA 8
if not exist %JAVA8PATH% (
	echo Java 8 not installed, Attempting installation...
	curl -o "%appdata%\java8installer.exe" "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=249833_43d62d619be4e416215729597d70b8ac"
	start %temp%\java8installer.exe
	del "%temp%\java8installer.exe" /Q /F
	if not exist %JAVA8PATH% (
		cls
		echo Install failed. Exiting...
		pause
		exit /b 1
	)
	cls
	echo Java 8 installed...
	timeout 2
)

:: THIS IS THE MINECRAFT DIRECTORY CHECK
cls
if not exist %MCPATH% (
	echo .minecraft folder is missing. Please ensure minecraft is installed.
	pause
	exit /b 1
)

:: THIS IS THE DELETE AND COPY CODELINE.
del "%MCPATH%\mods" /Q /F
del "%MCPATH%\resourcepacks" /Q /F
del "%MCPATH%\shaderpacks" /Q /F
del "%MCPATH%\config" /Q /F

xcopy "%~dp0\game\.minecraft\mods" "%MCPATH%\mods" /s /e /h /i /y
xcopy "%~dp0\game\.minecraft\shaderpacks" "%MCPATH%\shaderpacks" /s /e /h /i /y
xcopy "%~dp0\game\.minecraft\resourcepacks" "%MCPATH%\resourcepacks" /s /e /h /i /y
xcopy "%~dp0\game\.minecraft\config" "%MCPATH%\config" /s /e /h /i /y

echo Update Completed! Enjoy your Mods!
pause
exit /b 0