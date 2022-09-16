Import-Module utilities

# ==================================================================> Wallpapers
function getWallpaper {
  $outPath = "$env:WINDIR\Personalization"
  New-Item $outPath -ItemType "Directory" | Out-Null
  (New-Object System.Net.WebClient).DownloadFile("https://github.com/dreisss/iespes-extra/raw/main/design/wallpapers/wallpaper.png", "$outPath\wallpaper.png")
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
function setAccentColor {
  [byte[]] $binaryPaletteCode = "94,e0,b1,00,75,c7,95,00,3d,ad,68,00,10,89,3e,00,0b,5c,2a,00,08,42,1e,00,05,2b,14,00,00,b7,c3,00".Split(',') | ForEach-Object { "0x$_" }

  foreach ($user in @("HKCU:", "Registry::HKEY_USERS\.DEFAULT")) {
    Set-ItemProperty -Type "String" -Value "0xff3e8910" -Name "AccentColorMenu" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent"
    Set-ItemProperty -Type "Binary" -Value $binaryPaletteCode -Name "AccentPalette" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent"
    Set-ItemProperty -Type "String" -Value "0xff2a5c0b" -Name "StartColorMenu" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent"
  }
}

function setSystemColor {
  foreach ($user in @("HKCU:", "Registry::HKEY_USERS\.DEFAULT")) {
    Set-ItemProperty -Type "DWord" -Value 0 -Name "SystemUsesLightTheme" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
  }
}

function setAppsColor {
  foreach ($user in @("HKCU:", "Registry::HKEY_USERS\.DEFAULT")) {
    Set-ItemProperty -Type "DWord" -Value 0 -Name "AppsUseLightTheme" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
  }
}

function setFontSmoothing {
  foreach ($user in @("HKCU:", "Registry::HKEY_USERS\.DEFAULT")) {
    Set-ItemProperty -Type "DWord" -Value 2 -Name "FontSmoothing" "$user\Control Panel\Desktop"
  }
}

function setColorConfigs {
  print("Setting accent color...")
  setAccentColor

  print("Setting system color to black...")
  setSystemColor

  print("Setting apps color to black...")
  setAppsColor

  print("Enabling font smoothing again...")
  setFontSmoothing
}

# =====================================================================> Running

setWallpapers
setColorConfigs
