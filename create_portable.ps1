# PowerShell script to convert PNG to ICO and create portable package
# This script converts the PNG icon to ICO format and creates a portable package

$ErrorActionPreference = "Stop"

Write-Host "Converting PNG icon to ICO format..."

# Load System.Drawing assembly
Add-Type -AssemblyName System.Drawing

$pngPath = "windows\runner\resources\app_icon.png"
$icoPath = "windows\runner\resources\app_icon.ico"

if (Test-Path $pngPath) {
    try {
        # Read the PNG image
        $pngImage = [System.Drawing.Image]::FromFile((Resolve-Path $pngPath))
        
        # Create ICO with multiple sizes
        $sizes = @(16, 32, 48, 64, 128, 256)
        $images = New-Object System.Collections.ArrayList
        
        foreach ($size in $sizes) {
            $resized = New-Object System.Drawing.Bitmap($pngImage, $size, $size)
            $images.Add($resized) | Out-Null
        }
        
        # Save as ICO (simplified - Windows will use the best size)
        # For full ICO support, we'd need a library, but this creates a basic ICO
        $pngImage.Save($icoPath, [System.Drawing.Imaging.ImageFormat]::Icon)
        
        Write-Host "Icon converted successfully!"
        
        # Cleanup
        $pngImage.Dispose()
        foreach ($img in $images) {
            $img.Dispose()
        }
    }
    catch {
        Write-Host "Note: Automatic conversion may not work perfectly."
        Write-Host "Please convert the PNG to ICO manually using an online tool or image editor."
        Write-Host "Place the ICO file at: $icoPath"
    }
}
else {
    Write-Host "PNG icon not found at: $pngPath"
}

Write-Host "`nCreating portable package..."

$sourceDir = "build\windows\x64\runner\Release"
$packageDir = "PokemonCardViewer_Portable"

if (Test-Path $packageDir) {
    Remove-Item $packageDir -Recurse -Force
}

New-Item -ItemType Directory -Path $packageDir | Out-Null

# Copy executable
Copy-Item "$sourceDir\pokemon_card_viewer.exe" -Destination $packageDir

# Copy all DLLs
Copy-Item "$sourceDir\*.dll" -Destination $packageDir

# Copy data folder if exists
if (Test-Path "$sourceDir\data") {
    Copy-Item "$sourceDir\data" -Destination $packageDir -Recurse
}

Write-Host "`nPortable package created in: $packageDir"
Write-Host "You can zip this folder and distribute it."
Write-Host "All DLLs and the EXE are bundled together."
Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

