function isRunningAsAdmin {
  $currentProcess = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentProcess.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function isNetworkAvailable {
  return (Test-NetConnection "google.com.br").PingSucceeded
}

# ================================================> Setup network configurations
function setNetworkConfigNotebook {
  Write-Host "   Wi-fi not connected. Click any key when connected:" -ForegroundColor "Blue"
  [System.Console]::ReadKey($true) | Out-Null
}

function setNetworkConfigDesktop {
  Write-Host "   Setting up IPV4 Address, default Gateway and DNS addresses..." -ForegroundColor "Blue"

  $ipAddress = "192.168.$($labinNumber).$($computerNumber + 1)"
  $defaultGateway = "192.168.$($labinNumber).1"
  $ServerAddresses = @("8.8.8.8", "8.8.4.4")

  New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway $defaultGateway | Out-Null
  Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $ServerAddresses | Out-Null
}

function setNetworkConfig {
  Write-Host " > Configuring network connection... " -BackgroundColor "Blue"  -ForegroundColor "Black"

  if (-not(isNetworkAvailable)) {
    if ($isNotebook) { setNetworkConfigNotebook } else { setNetworkConfigDesktop }

    [int] $count = 0
    while (-not(isNetworkAvailable)) {
      Write-Host "   Trying internet connection..." -ForegroundColor "Blue"

      if ($count -eq 5) {
        Write-Host " > Internet connection failed. Stopping script... " -BackgroundColor "Red" -ForegroundColor "Black"
        Write-Host ""
        exit
      }

      $count += 1
      Start-Sleep 5
    }
  }

  Write-Host " > Connection verified. Continuing script..." -BackgroundColor "Blue" -ForegroundColor "Black"
  Write-Host ""
}

# ==========================================================> Manage other files
function downloadScripts {
  Write-Host " > Downloading configuration files... " -BackgroundColor "Blue" -ForegroundColor "Black"
  foreach ($file in @("General", "Apps", "Optimize", "Style", "Permissions", "Other")) {
    Write-Host "   Downloading setup$file.ps1 file..." -ForegroundColor "Blue"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/setup$file.ps1" -OutFile "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
  Write-Host ""
}

function runScripts {
  Write-Host " > Running configuration files... " -BackgroundColor "Blue" -ForegroundColor "Black"
  foreach ($file in @("General", "Apps", "Optimize", "Style", "Permissions", "Other")) {
    Write-Host "   Running setup$file.ps1 file..." -ForegroundColor "Blue"
    powershell.exe "$env:USERPROFILE\Downloads\setup$file.ps1" $labinNumber $computerNumber
  }
  Write-Host ""
}

function removeScripts {
  Write-Host " > Deleting configuration files... " -BackgroundColor "Blue" -ForegroundColor "Black"
  foreach ($file in @("Apps", "General", "Optimize", "Style", "Permissions", "Other")) {
    Write-Host "   Deleting setup$file.ps1 file..." -ForegroundColor "Blue"
    Remove-Item "$env:USERPROFILE\Downloads\setup$file.ps1"
  }
  Write-Host ""
}

# =============================================================> Running scripts
if (-not(isRunningAsAdmin)) {
  Start-Process powershell -Verb RunAs -ArgumentList ('-Noprofile -ExecutionPolicy Bypass -File "{0}" -Elevated' -f ($myinvocation.MyCommand.Definition))
  exit
}

function run {
  setNetworkConfig
  downloadScripts
  runScripts
  removeScripts
}

[bool] $isNotebook = (Read-Host "is a notebook? (y, N)").Equals("y")
[int] $labinNumber = Read-Host "Laboratory number"
[int] $computerNumber = Read-Host "Computer number"

run
