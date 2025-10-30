@echo off
REM Script to create a portable package of the Pokemon Card Viewer app
REM This bundles the EXE and all required DLLs into a single folder

echo Creating portable package...

set SOURCE_DIR=build\windows\x64\runner\Release
set PACKAGE_DIR=PokemonCardViewer_Portable

REM Create package directory
if exist "%PACKAGE_DIR%" rmdir /s /q "%PACKAGE_DIR%"
mkdir "%PACKAGE_DIR%"

REM Copy executable
copy "%SOURCE_DIR%\pokemon_card_viewer.exe" "%PACKAGE_DIR%\" >nul

REM Copy all DLLs
copy "%SOURCE_DIR%\*.dll" "%PACKAGE_DIR%\" >nul

REM Copy data folder if it exists
if exist "%SOURCE_DIR%\data" (
    xcopy "%SOURCE_DIR%\data" "%PACKAGE_DIR%\data\" /E /I /Y >nul
)

echo.
echo Portable package created in: %PACKAGE_DIR%
echo.
echo You can zip this folder and distribute it.
echo The app will create a 'downloads' folder for card images.
echo.
pause

