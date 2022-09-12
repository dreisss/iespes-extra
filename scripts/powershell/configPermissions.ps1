function lockComputerAppearence {
  printSecondary("Locked system colors")
  printSecondary("Locked system theme")
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoDispAppearancePage" -Value 1 -PropertyType "DWord" | Out-Null
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoThemesTab" -Value 1 -PropertyType "DWord" | Out-Null
}

function lockTaskBarSettings {
  printSecondary("Locked task bar settings")
  printSecondary("unabled user to pin apps in the taskbar")
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "TaskbarLockAll" -Value 1 -PropertyType "DWord" | Out-Null
}

function setGroupPolicies {
  printImportant("Setting group policies...")
  lockComputerAppearence
  lockTaskBarSettings
}

setGroupPolicies
