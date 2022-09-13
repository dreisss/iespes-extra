param ( [string] $labinNumber, [string] $computerNumber )

function formatNumber( [string] $number ) {
  return $(if ($number.Length -lt 2) { "0$number" } else { $number })
}

# ===================================================================> Functions
function renameComputer {
  Write-Host " > Renaming Computer... " -BackgroundColor "Blue" -ForegroundColor "Black"

  $newName = "LABIN$(formatNumber($labinNumber))-PC$(formatNumber($computerNumber))"
  Rename-Computer -NewName $newName | Out-Null

  Write-Host ""
}

function createDefaultUser {
  Write-Host " > Creating Default User... " -BackgroundColor "Blue" -ForegroundColor "Black"

  New-LocalUser -Name "Aluno" -NoPassword | Out-Null
  Set-LocalUser -Name "Aluno" -UserMayChangePassword $false  -PasswordNeverExpires $true -AccountNeverExpires | Out-Null
  Add-LocalGroupMember -SID "S-1-5-32-545" -Member "Aluno" | Out-Null

  Write-Host ""
}

function activateWindows {
  Write-Host " > Activating Windows... " -BackgroundColor "Blue" -ForegroundColor "Black"

  cmd.exe /c slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
  cmd.exe /c slmgr /skms kms8.msguides.com
  cmd.exe /c slmgr /ato

  Write-Host ""
}

# =====================================================================> Running
renameComputer
createDefaultUser
activateWindows
