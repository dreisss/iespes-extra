Import-Module "$env:USERPROFILE\Downloads\utilities"

# ===================================================================> Functions
function setMinimalVisualEffects {
  New-Item -Path "Registry::HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"

  foreach ($user in @("HKCU:", "Registry::HKEY_USERS\.DEFAULT")) {
    Set-ItemProperty -Force -Type "DWord" -Value 2 -Name "VisualFXSetting" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
  }
}

function disableTransparency {
  New-Item -Path "Registry::HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"

  foreach ($user in @("HKCU:", "Registry::HKEY_USERS\.DEFAULT")) {
    Set-ItemProperty -Force -Type "DWord" -Value 0 -Name "EnableTransparency" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
  }
}

# =====================================================================> Running
function optimizeComputer {
  setMinimalVisualEffects
  print("Configured visual effects to minimal")

  disableTransparency
  print("Disabled transparency effects")

  Set-ItemProperty -Force -Type "DWord" -Value 0 -Name "AllowTelemetry" "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
  print("Disabled Telemetry")

  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" | Out-Null
  Set-ItemProperty -Force -Type "DWord" -Value 2 -Name "LetAppsRunInBackground" "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
  print("Disabled background applications")
}

optimizeComputer
