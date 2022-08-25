# ==============================================================> Write and Read
function printInfo( [string] $text ) {
  Write-Host ">> $text..." -ForegroundColor "Blue"
}

function printInfoWaiting( [string] $text ) {
  Write-Host "> $text..." -ForegroundColor "Yellow"
}

function printInfoSuccess( [string] $text ) {
  Write-Host ">> $text!!" -ForegroundColor "Green"
}

function waitKey( [string] $text ) {
  printInfoWaiting($text)
  [Console]::ReadKey($true) | Out-Null
}

function readInfo( [string] $text ) {
  return $(Read-Host "   $text")
}

function readConditional( [string] $text ) {
  $value = Read-Host "   $text ? (y, N)"
  return $value -eq "y"
}

# =================================================================> Format Data
function formatNumber( [string] $number ) {
  return $(if ($number.Length -lt 2) { "0$number" } else { $number })
}

# ===============================================================> Request Admin
function isAdminShell {
  $currentProcess = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentProcess.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ====================================================> Config Computer: General
function configureComputerName {
  $formattedLabinNumber = formatNumber([int]$labinNumber)
  $formattedComputerNumber = formatNumber([int]$computerNumber)
  $computerName = "LABIN$formattedLabinNumber-PC$formattedComputerNumber"

  printInfo("Renaming computer")
  Rename-Computer -NewName $computerName | Out-Null
}

function createUserAluno {
  printInfo("Creating default user")
  New-LocalUser -Name "Aluno" -NoPassword | Out-Null
  Set-LocalUser -Name "Aluno" -UserMayChangePassword $false  -PasswordNeverExpires $true -AccountNeverExpires | Out-Null
  Add-LocalGroupMember -SID "S-1-5-32-545" -Member "Aluno" | Out-Null
}

function configureComputer {
  configureComputerName
  createUserAluno
}

# ====================================================> Config Computer: Network
function configureNetworkNotebook {
  printInfoWaiting("Waiting for Wifi connection")
  waitKey("Press when network is available")
}

function configureNetworkDesktop {
  $addressIPV4 = "192.168.$([int]$labinNumber).$([int]$computerNumber + 1)"
  $defaultGateway = "192.168.$([int]$labinNumber).1"
  $primaryDNS = "8.8.8.8"
  $secondaryDNS = "8.8.4.4"

  New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $addressIPV4 -PrefixLength 24 -DefaultGateway $defaultGateway | Out-Null
  Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ($primaryDNS, $secondaryDNS) | Out-Null
  Start-Sleep -Seconds 30
}

function configureNetwork {
  printInfo("Configuring network")
  if ($isNotebook) {
    configureNetworkNotebook
    return
  }
  configureNetworkDesktop
}

# ===========================================> Config Computer: Activate Windows
function activateWindows {
  printInfo("Activating Windows")
  cmd.exe /c slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
  cmd.exe /c slmgr /skms kms8.msguides.com
  cmd.exe /c slmgr /ato
}

# ===================================> Config Computer: Styling and Optimization
function getUsersSID {
  $usersList = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | Where-Object {$_.PSChildName -match "S-1-5-21-\d+-\d+\-\d+\-\d+$"}
  return $usersList.PSChildName
}

function optimizeComputer {
  printInfo("Optimizing computer")
  foreach ($userSID in getUsersSID) {
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\Control Panel\Desktop" -Name "FontSmoothing" -Value 2
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1
  }
}

function styleComputer {
  printInfo("Styling computer")
  foreach ($userSID in getUsersSID) {
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0
  }
}

# ============================================================> Apps: Installing
function installAppsFromChoco {
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  foreach ($app in @("winrar", "adobereader", "googlechrome", "firefox", "avastfreeantivirus")) {
    printInfoWaiting("$app")
    choco install -y $app | Out-Null
  }
}

function installApps {
  printInfo("Installing apps")
  installAppsFromChoco
}

# =====================================================================> Running
function runFunctions {
  configureComputer
  configureNetwork
  activateWindows
  optimizeComputer
  styleComputer
  installApps
}

if (-not(isAdminShell)) {
  Start-Process powershell -Verb RunAs -ArgumentList ('-Noprofile -ExecutionPolicy Bypass -File "{0}" -Elevated' -f ($myinvocation.MyCommand.Definition))
  exit
}

printInfo("Running setup script")

$labinNumber = readInfo("Labin number")
$computerNumber = readInfo("Computer number")
$isNotebook = readConditional("Is Notebook")

waitKey("Press to start")
runFunctions
printInfoSuccess("Finished script")
