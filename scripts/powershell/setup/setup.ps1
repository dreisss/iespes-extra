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

function isNetworkAvailable {
  return Test-Connection -Quiet "google.com.br"
}

# ================================================> Setup network configurations
function setNetworkConfigNotebook {
  print("Wi-fi not connected. Press any key when connected:")
  [System.Console]::ReadKey($true) | Out-Null
}

function setNetworkConfigDesktop {
  $ipAddress = "192.168.$($labinNumber).$($computerNumber + 1)"
  $defaultGateway = "192.168.$($labinNumber).1"
  $ServerAddresses = @("8.8.8.8", "8.8.4.4")

  New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway $defaultGateway | Out-Null
  Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $ServerAddresses | Out-Null
}

function setNetworkConfig {
  if ($isNotebook) { setNetworkConfigNotebook } else { setNetworkConfigDesktop }
}

function verifyNetworkConnection {
  if (-not(isNetworkAvailable)) {
    print("Test failed! Trying setup network...") -color "Red"
    setNetworkConfig
    print("Configured network configuration. Testing connection again...")

    if (-not(isNetworkAvailable)) {
      important("Test failed! Breaking script...") -color "Red"
      exit
    }
  }

  print("Test successful! Continuing running scripts...") -color "Green"
}

# ==========================================================> Manage other files
function downloadScripts {
  foreach ($file in @("General", "Apps", "Optimize", "Style", "Permissions", "Other")) {
    print("Downloading setup$file.ps1 file...")
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/setup$file.ps1" -OutFile "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
}

function runScripts {
  foreach ($file in @("General", "Apps", "Optimize", "Style", "Permissions", "Other")) {
    important("Running setup$file.ps1 file...") -color "DarkCyan"
    powershell.exe "$env:USERPROFILE\Downloads\setup$file.ps1" $isNotebook $labinNumber $computerNumber
  }
}

function removeScripts {
  foreach ($file in @("General", "Apps", "Optimize", "Style", "Permissions", "Other")) {
    print("Removing setup$file.ps1 file...")
    Remove-Item "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
}

# =============================================================> Running scripts
if (-not(isRunningAsAdmin)) {
  Start-Process powershell -Verb RunAs -ArgumentList ('-Noprofile -ExecutionPolicy Bypass -File "{0}" -Elevated' -f ($myinvocation.MyCommand.Definition))
  exit
}

important("Starting running script")
[bool] $isNotebook = (Read-Host "   Is a notebook? (y, N)").Equals("y")
[int] $labinNumber = Read-Host "   Laboratory number"
[int] $computerNumber = Read-Host "   Computer number"

important("Verifying network connection")
verifyNetworkConnection

important("Downloading other configuration scripts")
downloadScripts

important("Running other configuration scripts")
runScripts

important("Removing other configuration scripts")
removeScripts

important("Finished script execution")
