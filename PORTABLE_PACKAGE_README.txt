# Instructions for creating a portable package
# 
# IMPORTANT: Flutter Windows apps cannot pack DLLs into a single EXE file
# because Flutter uses dynamic linking. However, you can create a portable package.
#
# To create a portable package:
# 1. Run: powershell -ExecutionPolicy Bypass -File create_portable.ps1
#
# This will create a PokemonCardViewer_Portable folder with:
# - pokemon_card_viewer.exe
# - All required DLLs (flutter_windows.dll, etc.)
# - Data folder (if present)
#
# You can then zip this folder and distribute it.
# Users just need to extract and run the EXE.
#
# For the icon:
# 1. Convert your PNG to ICO format (use an online converter or image editor)
# 2. Place it at: windows\runner\resources\app_icon.ico
# 3. Rebuild the app
#
# Alternative: Use Inno Setup to create a proper installer that bundles everything

