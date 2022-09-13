function lockComputerAppearence {
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoDispAppearancePage" -Value 1 -PropertyType "DWord" | Out-Null
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoThemesTab" -Value 1 -PropertyType "DWord" | Out-Null
}

function lockTaskBarSettings {
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "TaskbarLockAll" -Value 1 -PropertyType "DWord" | Out-Null
}

function setGroupPolicies {
  lockComputerAppearence
  lockTaskBarSettings
}

setGroupPolicies
