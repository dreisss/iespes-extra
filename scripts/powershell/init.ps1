# ===> Setup network configurations
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

  New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway $defaultGateway | Out-Null
  Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $DNSs | Out-Null
}

function setNetworkConfig {
  if ($isNotebook) { setNetworkConfigNotebook } else { setNetworkConfigDesktop }
  while (-not(networkIsAvailable)) { continue }
}

# ===> Download Files
function downloadFiles {
  foreach ($file in @("Apps", "General", "Optimize", "Style", "Permissions", "Other")) {
    Invoke-WebRequest -Uri "https://github.com/dreisss/iespes-extra/blob/main/scripts/powershell/setup$file.ps1" -OutFile "$env:USERPROFILE\Downloads\config$file.ps1"
  }
}

function runFiles {
  foreach ($file in @("Apps", "General", "Optimize", "Style", "Permissions", "Other")) {
    "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
}

# ===> Running
function run {
  if (-not $isConfigured) {
    setNetworkConfig
  }

  downloadFiles
}

[bool] $isConfigured = (Read-Host "is a configured? (y, N)").Equals("y")
[bool] $isNotebook = (Read-Host "is a notebook? (y, N)").Equals("y")
[int] $labinNumber = Read-Host "Laboratory number"
[int] $computerNumber = Read-Host "Computer number"

run
