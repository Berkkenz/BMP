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
	curl -L -o %temp%\gitinstaller.exe https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe
	start /wait %temp%\gitinstaller.exe /VERYSILENT
	del %temp%\gitinstaller.exe /Q /F
	if not exist %GITPATH% (
		cls
		echo Installation failed, exiting...
		pause
		exit /b 1
	)
	cls
	echo Git has been installed, please restart the application!
	echo Update completed... Please restart!
	start /min wmplayer "%SystemRoot%\Media\Windows Notify.wav"
	echo MsgBox "Git Install Successful. Please Restart the Application.", vbOKOnly, "UPDATE SUCCESSFUL!." > "%temp%\gittemp.vbs"
	cscript //nologo "%temp%\gittemp.vbs"
	del "%temp%\gittemp.vbs" /Q /F
	exit /b 0
)
cd %~dp0
if not exist ".git" (
	echo No GitHub repoistory detected, Starting initiation...
	git init
	git remote add origin https://github.com/Berkkenz/BMP
	git pull master
	if not exist ".git" (
		echo GitHub repository setup failed, Exiting...
		pause
		exit /b 1
	)
)

:: THIS IS THE INSTALLER UPDATE SECTION
git fetch origin
git diff --quiet origin/main || (
	echo Updates found! Updating...
	git reset --hard origin/main
	echo Update completed... Please restart!
	start /min wmplayer "%SystemRoot%\Media\Windows Notify.wav"
	echo MsgBox "Update Successful. Please Restart the Application.", vbOKOnly, "UPDATE SUCCESSFUL!." > "%temp%\hubtemp.vbs"
	cscript //nologo "%temp%\hubtemp.vbs"
	del "%temp%\hubtemp.vbs" /Q /F
	exit /b 0
)
cls
echo Up to Date! Continuing...
timeout 2

:: THIS IS THE DEPENDANCIES CHECK SECTION
:: JAVA 17
if not exist %JAVA17PATH% (
	echo Java 17 not installed, Attempting installation...
	curl -L -o %temp%\java17installer.exe "https://download.oracle.com/java/17/archive/jdk-17.0.10_windows-x64_bin.exe"
	start /wait %temp%\java17installer.exe /s
	del %temp%\java17installer.exe /Q /F
	if not exist %JAVA17PATH% (
		cls
		echo Install failed. Exiting...
		pause
		exit /b 1
	)
	cls
	echo Java 17 installed...
	timeout 2
)

:: JAVA 8
if not exist %JAVA8PATH% (
	echo Java 8 not installed, Attempting installation...
	curl -L -o %temp%\java8installer.exe "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=249851_43d62d619be4e416215729597d70b8ac"
	start /wait %temp%\java8installer.exe /s
	del %temp%\java8installer.exe /Q /F
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

if not exist "%AppData%\.minecraft\versions\1.16.5-forge-36.2.42\1.16.5-forge-36.2.42.json" (
	curl -L -o %temp%\forgeinstaller.jar "https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.5-36.2.42/forge-1.16.5-36.2.42-installer.jar"
	pushd %MCPATH%
	%JAVA8PATH% -jar %temp%\forgeinstaller.jar --installClient
	popd
	del %temp%\forgeinstaller.jar /Q /F
	if not exist "%appdata%\.minecraft\versions\1.16.5-forge-36.2.42\1.16.5-forge-36.2.42.json" (
		echo Forge install has failed, Exiting...
		pause
		exit /b 1
	)
	echo Forge installed!
	timeout 2
)

:: THIS IS THE DELETE AND COPY CODELINE.
del "%MCPATH%\mods" /Q /F
del "%MCPATH%\resourcepacks" /Q /F
del "%MCPATH%\shaderpacks" /Q /F
del "%MCPATH%\config" /Q /F
del "%MCPATH%\emotes" /Q /F

xcopy "%~dp0\game\.minecraft\mods" "%MCPATH%\mods" /e /h /i /y
xcopy "%~dp0\game\.minecraft\shaderpacks" "%MCPATH%\shaderpacks" /e /h /i /y
xcopy "%~dp0\game\.minecraft\resourcepacks" "%MCPATH%\resourcepacks" /e /h /i /y
xcopy "%~dp0\game\.minecraft\config" "%MCPATH%\config" /e /h /i /y
xcopy "%~dp0\game\.minecraft\emotes" "%MCPATH%\emotes" /e /h /i /y

setlocal
set VBSCRIPT=%temp%\prompt.vbs
start /min wmplayer "%SystemRoot%\Media\Windows Notify.wav"
echo Set WshShell = WScript.CreateObject("WScript.Shell") > %VBSCRIPT%
echo response = WshShell.Popup("Would you like to apply the recommended settings?            This will OVERWRITE your current settings.", 0, "Confirmation", 4 + 32) >> %VBSCRIPT%
echo WScript.Quit response >> %VBSCRIPT%

cscript /nologo %VBSCRIPT%
set response=%errorlevel%
del %VBSCRIPT%

if %response% == 6 (
    echo Applying recommended settings...
    del "%MCPATH%\options.txt" /Q /F
	xcopy "%~dp0\game\.minecraft\options.txt" "%MCPATH%" /e /h /i /y
)

cls
echo Update Completed! Enjoy your Mods!
start /min wmplayer "%SystemRoot%\Media\Windows Notify.wav"
echo MsgBox "Installation Finised. Enjoy your Mods!", vbOKOnly, "UPDATE SUCCESSFUL!." > "%temp%\fintemp.vbs"
cscript //nologo "%temp%\fintemp.vbs"
del "%temp%\fintemp.vbs" /Q /F
pause
exit /b 0