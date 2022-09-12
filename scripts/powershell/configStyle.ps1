function getWallpaper {
  $outPath = "$env:WINDIR\Personalization"
  New-Item $outPath -ItemType "Directory" | Out-Null
  Invoke-WebRequest -Uri "https://github.com/dreisss/iespes-extra/raw/main/design/wallpapers/wallpaper.png" -Outfile "$outPath\wallpaper.png"
}

function setDesktopWallpaper {
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "DesktopImageStatus" -Value 1 -PropertyType "DWord" | Out-Null
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "DesktopImagePath" -Value "$env:WINDIR\Personalization\wallpaper.png" -PropertyType "String" | Out-Null
}

function setLockScreenWallpaper {
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "LockScreenImageStatus" -Value 1 -PropertyType "DWord" | Out-Null
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name "LockScreenImagePath" -Value "$env:WINDIR\Personalization\wallpaper.png" -PropertyType "String" | Out-Null
}

function setWallpaper {
  getWallpaper
  setDesktopWallpaper
  setLockScreenWallpaper
}

function setAccentColor {
  [byte[]] $binaryPaletteCode = "94,e0,b1,00,75,c7,95,00,3d,ad,68,00,10,89,3e,00,0b,5c,2a,00,08,42,1e,00,05,2b,14,00,00,b7,c3,00".Split(',') | ForEach-Object { "0x$_" }

  foreach ($userSID in getUsersSIDList) {
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "AccentColorMenu" -Value "0xff3e8910"
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "AccentPalette" -Value $binaryPaletteCode
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "StartColorMenu" -Value "0xff2a5c0b"
  }
}

function styleComputer {
  foreach ($userSID in getUsersSIDList) {
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\Control Panel\Desktop" -Name "FontSmoothing" -Value 2
  }
  setAccentColor
  setWallpaper
  printSpace
}

styleComputer
