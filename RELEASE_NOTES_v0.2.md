# Pokemon Card Viewer v0.2 Release Notes

## Features
- Browse Pokemon card sets with 7-column grid layout
- Search sets and cards using Pokemon TCG API
- View individual card details with high-resolution images
- Download high-resolution card images
- Images organized by set in downloads/{setName}/ folders
- Cache-first loading for faster performance
- Automatic retry on 504 errors
- Pokemon Solid font throughout the app
- Custom app icon

## Requirements
- Windows 10 or later
- No installation required - portable executable

## Installation
1. Download PokemonCardViewer_v0.2_Windows.zip
2. Extract to any folder
3. Run pokemon_card_viewer.exe
4. Downloads folder will be created automatically in the same directory as the EXE

## Usage
- Browse sets on the home screen
- Click a set to view its cards
- Use search bars to find specific sets or cards
- Click a card to view details and download high-res images
- Images are saved in downloads/{setName}/ folders

## Technical Details
- Built with Flutter for Windows
- Uses Pokemon TCG API (pokemontcg.io)
- Cached network images for faster loading
- Local data caching (24-hour expiry)
- Automatic background refresh

