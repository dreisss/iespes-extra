function print( [string] $text ) {
  Write-Host -ForegroundColor "DarkCyan" "   $text"
}

# ==================================================================> Functions
function setGroupPolicies {
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoDispAppearancePage" -Value 1 -PropertyType "DWord" | Out-Null
  print("Disabled appearence page")
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoThemesTab" -Value 1 -PropertyType "DWord" | Out-Null
  print("Disabled themes page")
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "TaskbarLockAll" -Value 1 -PropertyType "DWord" | Out-Null
  print("Locked Taskbar configurations")
}

setGroupPolicies
