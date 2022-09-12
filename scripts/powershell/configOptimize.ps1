function disableTelemetry {
  printSecondary("Disabled windows telemetry")
  Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type "DWord" -Value 0
}

function optimizeComputer {
  printImportant("Optimizing computer")
  printSecondary("Defined performance as priority on configs")
  printSecondary("Disabled background application")
  printSecondary("Disabled visual transparency")
  foreach ($userSID in getUsersSIDList) {
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0
  }
  disableTelemetry
  printSpace
}

optimizeComputer
