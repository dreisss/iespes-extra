Import-Module "./utils";

$console = createConsole;

# ===================================================================> Utilities
function isNetworkAvailable {
  return Test-Connection -Quiet "google.com.br"
}

# =====================================================================> Network
function setNetworkConfigNotebook {
  $console.puts("Wi-fi not connected. Press any key when connected:")
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
    $console.error("Test failed! Trying setup network...")
    setNetworkConfig
    $console.puts("Configured network configuration. Testing connection again...")

    if (-not(isNetworkAvailable)) {
      $console.alert_error("Test failed! Breaking script...")
      exit
    }
  }

  $console.success("Test successful! Continuing running scripts...")
  Start-Sleep -Seconds 5
}

# =====================================================================> Running
$console.alert("Starting running script")
[bool] $isNotebook = $console.gets("  Is a notebook? (y, N)").Equals("y")
[int] $labinNumber = $console.gets("  Laboratory number")
[int] $computerNumber = $console.gets("  Computer number")

$console.alert("Verifying network connection")
verifyNetworkConnection

(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/src/main.ps1", "$env:TEMP\main.ps1")
powershell.exe -file "$env:TEMP\main.ps1" $isNotebook $labinNumber $computerNumber
