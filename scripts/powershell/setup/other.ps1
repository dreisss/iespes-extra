Import-Module "$env:USERPROFILE\Downloads\utilities"

# ===================================================================> Functions
function disableBingSearch {
  foreach ($user in @("HKCU:", "Registry::HKEY_USERS\.DEFAULT")) {
    Set-ItemProperty -Type "DWord" -Value 0 -Name "BingSearchEnabled" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
  }
}

function setExplorerLaunchPage {
  foreach ($user in @("HKCU:", "Registry::HKEY_USERS\.DEFAULT")) {
    Set-ItemProperty -Type "DWord" -Value 1 -Name "LaunchTo" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
  }
}

function setQuickAccessPage {
  foreach ($user in @("HKCU:", "Registry::HKEY_USERS\.DEFAULT")) {
    Set-ItemProperty -Type "DWord" -Value 0 -Name "ShowRecent" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    Set-ItemProperty -Type "DWord" -Value 0 -Name "ShowFrequent" "$user\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
  }
}

function createDefaultUser {
  New-LocalUser -Name "Aluno" -NoPassword | Out-Null
  Set-LocalUser -Name "Aluno" -UserMayChangePassword $false  -PasswordNeverExpires $true -AccountNeverExpires | Out-Null
  Add-LocalGroupMember -SID "S-1-5-32-545" -Member "Aluno" | Out-Null
}

# =====================================================================> Running
function configComputerOther {
  disableBingSearch
  print("Disabled bing search on menu")

  setExplorerLaunchPage
  print("Configured explorer launch page to 'This Computer' page")

  setQuickAccessPage
  print("Configured 'Quick Access' explorer page")

  powercfg.exe -change -monitor-timeout-ac 0
  print("Disabled monitor sleeping timeout")

  powercfg.exe -change -standby-timeout-ac 0
  print("Disabled computer sleeping timeout")

  createDefaultUser
  print("Created default user")
}

configComputerOther
