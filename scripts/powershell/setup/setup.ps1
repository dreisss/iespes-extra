function print( [string] $text, [string] $color = "Blue") {
  Write-Host -ForegroundColor $color "   $text"
}

function important( [string] $text, [string] $color = "Blue") {
  Write-Host ""
  Write-Host -BackgroundColor "Black"  -ForegroundColor $color " | $text | "
  Write-Host ""
}

# ===================================================================> Utilities
function isNetworkAvailable {
  return Test-Connection -Quiet "google.com.br"
}

# =====================================================================> Network
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
  Start-Sleep -Seconds 5
}

# =====================================================================> Running
important("Starting running script")
[bool] $isNotebook = (Read-Host "   Is a notebook? (y, N)").Equals("y")
[int] $labinNumber = Read-Host "   Laboratory number"
[int] $computerNumber = Read-Host "   Computer number"

important("Verifying network connection")
verifyNetworkConnection

(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/src/main.ps1", "$env:TEMP\main.ps1")
powershell.exe -file "$env:TEMP\main.ps1" $isNotebook $labinNumber $computerNumber
