function isRunningAsAdmin {
  $currentProcess = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentProcess.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ================================================> Setup network configurations
function networkIsAvailable {
  return (Test-NetConnection -ComputerName "google.com.br").PingSucceeded
}

function setNetworkConfigNotebook {}

function setNetworkConfigDesktop {
  $ipAddress = "192.168.$($labinNumber).$($computerNumber + 1)"
  $defaultGateway = "192.168.$($labinNumber).1"
  $DNSs = @("8.8.8.8", "8.8.4.4")

  New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway $defaultGateway | Out-Null
  Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $DNSs | Out-Null
}

function setNetworkConfig {
  if ($isNotebook) { setNetworkConfigNotebook } else { setNetworkConfigDesktop }
  while (-not(networkIsAvailable)) { Start-Sleep -Seconds 10 }
}

# ==========================================================> Manage other files
function downloadFiles {
  foreach ($file in @("Apps", "General", "Optimize", "Style", "Permissions", "Other")) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/setup$file.ps1" -OutFile "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
}

function runFiles {
  powershell.exe "$env:USERPROFILE\Downloads\setupGeneral.ps1" $labinNumber $computerNumber
  powershell.exe "$env:USERPROFILE\Downloads\setupApps.ps1" $labinNumber

  foreach ($file in @("Optimize", "Style", "Permissions", "Other")) {
    powershell.exe "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
}

function deleteFiles {
  foreach ($file in @("Apps", "General", "Optimize", "Style", "Permissions", "Other")) {
    Remove-Item "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
}

# =============================================================> Running scripts
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
