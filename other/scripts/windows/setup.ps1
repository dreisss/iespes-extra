#Requires -RunAsAdministrator

function formatNumber( [string]$number ) {
  if ($number.Length -lt 2) { return "0$number" }
  return $number
}

function setNetworkConfigs() {
  $addressIPV4 = "192.168.$($primitives.labinNumber).$([int]$primitives.computerNumber + 1)"
  $defaultGateway = "192.168.$($primitives.labinNumber).1"
  $primaryDNS = "8.8.8.8"
  $secondaryDNS = "8.8.4.4"

  Write-Host "Changing network configs..." -ForegroundColor Blue
  New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $addressIPV4 -PrefixLength 24 -DefaultGateway $defaultGateway | Out-Null
  Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ($primaryDNS, $secondaryDNS) | Out-Null
}

function setComputerName() {
  $computerName = "LABIN$(formatNumber($primitives.labinNumber))-PC$(formatNumber($primitives.computerNumber))"

  Write-Host "Renaming computer..." -ForegroundColor Blue
  Rename-Computer -NewName $computerName | Out-Null
}

function createDefaultUser() {
  Write-Host "Creating default user..." -ForegroundColor Blue
  New-LocalUser -Name "Aluno" -NoPassword | Out-Null
  Set-LocalUser -Name "Aluno" -UserMayChangePassword $false  -PasswordNeverExpires $true -AccountNeverExpires | Out-Null
  Add-LocalGroupMember -SID "S-1-5-32-545" -Member "Aluno" | Out-Null
}

function installApps() {
  Write-Host "Installing apps..." -ForegroundColor Blue
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  foreach ($app in @("winrar", "adobereader", "googlechrome", "firefox")) {
    Write-Host "Installing $app" -ForegroundColor Blue
    choco install -y $app
  }
}

function runFunctions() {
  setNetworkConfigs
  setComputerName
  createDefaultUser
  installApps
}

$primitives = @{
  labinNumber    = Read-Host "Labin number"
  computerNumber = Read-Host "Computer number"
}

Write-Host "Press any key to continue." -ForegroundColor Blue
[Console]::ReadKey($true) | Out-Null

runFunctions
