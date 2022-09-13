function isRunningAsAdmin {
  $currentProcess = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentProcess.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ================================================> Setup network configurations
function networkIsAvailable {
  return (Test-NetConnection -ComputerName "google.com.br").PingSucceeded
}

function setNetworkConfigNotebook {
  Write-Host "Waiting Wi-Fi connection..."
}

function setNetworkConfigDesktop {
  $ipAddress = "192.168.$($labinNumber).$($computerNumber + 1)"
  $defaultGateway = "192.168.$($labinNumber).1"
  $DNSs = @("8.8.8.8", "8.8.4.4")

  Write-Host "Changing IPV4 address, default gateway and DNS addresses..."
  New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway $defaultGateway | Out-Null
  Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $DNSs | Out-Null
}

function setNetworkConfig {
  if ($isNotebook) { setNetworkConfigNotebook } else { setNetworkConfigDesktop }
  while (-not(networkIsAvailable)) { Write-Host "Trying internet connection..." }
}

# ==============================================================> Download Files
function downloadFiles {
  Write-Host "Downloading configuration files..."
  foreach ($file in @("Apps", "General", "Optimize", "Style", "Permissions", "Other")) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/setup$file.ps1" -OutFile "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
}

function runFiles {
  Write-Host "Running configuration files..."
  foreach ($file in @("Apps", "General", "Optimize", "Style", "Permissions", "Other")) {
    powershell.exe "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
}

function deleteFiles {
  Write-Host "Deleting configuration files..."
  foreach ($file in @("Apps", "General", "Optimize", "Style", "Permissions", "Other")) {
    Remove-Item "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
}

# =====================================================================> Running
if (-not(isRunningAsAdmin)) {
  Start-Process powershell -Verb RunAs -ArgumentList ('-Noprofile -ExecutionPolicy Bypass -File "{0}" -Elevated' -f ($myinvocation.MyCommand.Definition))
  exit
}

function run {
  if (-not $isConfigured) {
    setNetworkConfig
  }

  downloadFiles
  runFiles
  deleteFiles
}

[bool] $isNotebook = (Read-Host "is a notebook? (y, N)").Equals("y")
[int] $labinNumber = Read-Host "Laboratory number"
[int] $computerNumber = Read-Host "Computer number"

run
