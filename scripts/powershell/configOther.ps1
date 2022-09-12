function configComputerOther {
  printImportant("Other computer configurations")
  printSecondary("Disabled Bing search on Windows menu")
  printSecondary("Setting up explorer home page to 'This PC' folder")
  printSecondary("Disabled showing recent files/folders on 'quick access' in explorer")
  printSecondary("Disabled showing frequent files/folders on 'quick access' in explorer")
  printSecondary("Disabled monitor and standby timeout")
  foreach ($userSID in getUsersSIDList) {
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type "DWord" -Value 0
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type "DWord" -Value 1
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type "DWord" -Value 0
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type "DWord" -Value 0
  }
  powercfg.exe -change -monitor-timeout-ac 0
  powercfg.exe -change -standby-timeout-ac 0
}

configComputerOther
