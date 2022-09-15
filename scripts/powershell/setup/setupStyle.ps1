function print ( [string] $text ) {
  Write-Host -ForegroundColor "Blue" "  $text"
}

# ==================================================================> Wallpapers
function getWallpaper {
  $outPath = "$env:WINDIR\Personalization"
  New-Item $outPath -ItemType "Directory" | Out-Null
  Invoke-WebRequest -Uri "https://github.com/dreisss/iespes-extra/raw/main/design/wallpapers/wallpaper.png" -Outfile "$outPath\wallpaper.png"
}

function setDesktopWallpaper {
  New-ItemProperty -PropertyType "DWord" -Value 1 -Name "DesktopImageStatus" "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" | Out-Null
  New-ItemProperty -PropertyType "String" -Value "$env:WINDIR\Personalization\wallpaper.png" -Name "DesktopImagePath" "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" | Out-Null
}

function setLockScreenWallpaper {
  New-ItemProperty -PropertyType "DWord" -Value 1 -Name "LockScreenImageStatus" "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" | Out-Null
  New-ItemProperty -PropertyType "String" -Value "$env:WINDIR\Personalization\wallpaper.png" -Name "LockScreenImagePath" "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" | Out-Null
}

function setWallpapers {
  print("Downloading wallpapers...")
  getWallpaper
  print("Setting desktop wallpaper...")
  setDesktopWallpaper
  print("Setting lock screen wallpaper...")
  setLockScreenWallpaper
}

# ======================================================================> Colors
function setColorConfigs {
  print("Setting accent color...")
  # FIXME: set accent color to all users function

  print("Setting system color to black...")
  # FIXME: set system color to all users function

  print("Setting apps color to black...")
  # FIXME: set apps color to all users function

  print("Enabling font smoothing again...")
  # FIXME: enable font smoothing to all users function
}

# =====================================================================> Running

setWallpapers
setColorConfigs
