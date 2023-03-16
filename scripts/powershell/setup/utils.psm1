function running_as_admin {
  $currentProcess = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent());
  return $currentProcess.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator);
}

function create_console {
  class Console {
    [string] gets([string] $text) { return Read-Host " $text "; } 
    [void] puts([string] $text) { Write-Host " $text " -ForegroundColor "Blue"; }
    [void] alert([string] $text) { Write-Host " @: $text " -ForegroundColor "Blue" -BackgroundColor "Black"; }
    [void] error([string] $text) { Write-Host " $text "  -ForegroundColor "Red"; }
    [void] success([string] $text) { Write-Host " $text " -ForegroundColor "Green"; }
    [void] alert_error([string] $text) { Write-Host " @: $text "  -ForegroundColor "Red" -BackgroundColor "Black"; }
  }

  return New-Object Console;
}

function create_network_manager([hashtable] $data) {
  class NetworkManager {
    [string] $ip; [string] $gateway; [bool] $has_connection;

    NetworkManager([hashtable] $data) {
      if (-not($data["is_notebook"])) {
        $this.ip = "192.168.$($data["laboratory_number"]).$($data["computer_number"] + 1)";
        $this.gateway = "192.168.$($data["laboratory_number"]).1";
      }
    }

    [void] try_connection() { $this.has_connection = Test-Connection -Quiet "google.com.br"; }
    [void] configure() {
      if ($this.ip -and $this.gateway) {
        New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $this.ip -PrefixLength 24 -DefaultGateway $this.gateway | Out-Null;
        Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses @("8.8.8.8", "8.8.4.4") | Out-Null;
      }
      else {
        netsh.exe wlan connect "IESPES-HP2G";
        [System.Console]::ReadKey($true) | Out-Null; 
      }
      Start-Sleep -Seconds 5
    }
  }

  return New-Object NetworkManager($data);
}
