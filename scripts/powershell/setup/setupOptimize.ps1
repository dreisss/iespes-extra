function print ( [string] $text ) {
  Write-Host -ForegroundColor "Blue" "  $text"
}

# ===================================================================> Functions
function optimizeComputer {
  Set-ItemProperty -Type "DWord" -Value 0 -Name "AllowTelemetry" "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
  print("Disabled Telemetry")

  Set-ItemProperty -Type "DWord" -Value 2 -Name "VisualFXSetting" "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
  print("Configured visual effects to minimal")

  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" | Out-Null
  Set-ItemProperty -Type "DWord" -Value 2 -Name "LetAppsRunInBackground" "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
  print("Disabled background applications")

  # FIXME: Disable transparency effects to all users function
  print("Disabled transparency effects")
}

# =====================================================================> Running
optimizeComputer
