$isNotebook = $args[0]
$labinNumber = $args[1]
$computerNumber = $args[2]

function print( [string] $text, [string] $color = "Blue") {
  Write-Host -ForegroundColor $color "   $text"
}

function important( [string] $text, [string] $color = "Blue") {
  Write-Host ""
  Write-Host -BackgroundColor "Black"  -ForegroundColor $color " | $text | "
  Write-Host ""
}

function isRunningAsAdmin {
  $currentProcess = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentProcess.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not(isRunningAsAdmin)) {
  Start-Process powershell -Verb RunAs -ArgumentList ('-Noprofile -ExecutionPolicy Bypass -File "{0}" -Elevated' -f ($myinvocation.MyCommand.Definition))
  exit
}

function downloadScripts {
  print("Downloading utilities module file...")
  (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/src/utilities.psm1", "$env:TEMP\utilities.psm1")

  foreach ($file in @("general", "apps", "optimize", "style", "permissions", "other")) {
    print("Downloading $file.ps1 file...")
    (New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/src/$file.ps1", "$env:TEMP\$file.ps1")
  }
}

function runScripts {
  foreach ($file in @("general", "apps", "optimize", "style", "permissions", "other")) {
    important("Running $file.ps1 file...") -color "DarkCyan"
    powershell.exe -file "$env:TEMP\$file.ps1" $isNotebook $labinNumber $computerNumber
  }
}

function removeScripts {
  print("Removing utilities.psm1 file...")
  Remove-Item "$env:TEMP\utilities.psm1"

  foreach ($file in @("general", "apps", "optimize", "style", "permissions", "other")) {
    print("Removing $file.ps1 file...")
    Remove-Item "$env:TEMP\$file.ps1"
  }
}

important("Downloading other configuration scripts")
downloadScripts

important("Running other configuration scripts")
runScripts

important("Removing other configuration scripts")
removeScripts

important("Setting execution policy to restricted")
Set-ExecutionPolicy "Restricted" -Scope "LocalMachine" -Force

important("Finished script execution")
