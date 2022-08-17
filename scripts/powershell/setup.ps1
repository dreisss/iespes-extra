# ---> Utilities
function isAdminShell {
  $currentProcess = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentProcess.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function formatNumber( [string] $number ) {
  return $(if ($number.Length -lt 2) { "0$number" } else { $number })
}

function printInfoBlue( [string] $text ) {
  Write-Host ">> $text..." -ForegroundColor Blue
}

# ---> Configuring
function setNetworkConfigs {
  $addressIPV4 = "192.168.$([int]$labinNumber).$([int]$computerNumber + 1)"
  $defaultGateway = "192.168.$([int]$labinNumber).1"
  $primaryDNS = "8.8.8.8"
  $secondaryDNS = "8.8.4.4"

  printInfoBlue("Changing network configs")
  New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $addressIPV4 -PrefixLength 24 -DefaultGateway $defaultGateway | Out-Null
  Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ($primaryDNS, $secondaryDNS) | Out-Null
}

function setComputerName {
  $formattedLabinNumber = formatNumber([int]$labinNumber)
  $formattedComputerNumber = formatNumber([int]$computerNumber)
  $computerName = "LABIN$formattedLabinNumber-PC$formattedComputerNumber"

  printInfoBlue("Renaming computer")
  Rename-Computer -NewName $computerName | Out-Null
}

function createDefaultUser {
  printInfoBlue("Creating default user")
  New-LocalUser -Name "Aluno" -NoPassword | Out-Null
  Set-LocalUser -Name "Aluno" -UserMayChangePassword $false  -PasswordNeverExpires $true -AccountNeverExpires | Out-Null
  Add-LocalGroupMember -SID "S-1-5-32-545" -Member "Aluno" | Out-Null
}

function activateWindows {
  printInfoBlue("Activating Windows")
  cmd.exe /c slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
  cmd.exe /c slmgr /skms kms8.msguides.com
  cmd.exe /c slmgr /ato
}

function installApps {
  printInfoBlue("Installing apps")
  Start-Sleep -Seconds 30
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  foreach ($app in @("winrar", "adobereader", "googlechrome", "firefox")) {
    Write-Host "Installing $app..." -ForegroundColor Blue
    choco install -y $app | Out-Null
  }
}

function runFunctions {
  setNetworkConfigs
  setComputerName
  createDefaultUser
  activateWindows
  installApps
}

# ---> Running
if (-not(isAdminShell)) {
  Start-Process powershell -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
  exit
}

printInfoBlue("Running setup script")

$labinNumber = Read-Host "Labin number"
$computerNumber = Read-Host "Computer number"

printInfoBlue("Press any key to start running")
[Console]::ReadKey($true) | Out-Null

runFunctions

printInfoBlue("Finished running setup script")
