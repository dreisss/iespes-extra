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

function create_cache_manager([string] $path) {
  class CacheManager {
    [hashtable] $data; [string] $path; [bool] $exist;

    CacheManager([string] $path) {
      $this.path = $path;
    }
    
    [void] read() {
      if ($this.data = Get-Content "$($this.path)/setup_cache" -ErrorAction "SilentlyContinue" | ConvertFrom-Json -AsHashtable) {
        $this.exist = $true;
        return;
      }
      $this.data = @{};
    }

    [hashtable] get_data() { return $this.data; }
  }

  return New-Object CacheManager($path);
}

function create_script_manager([string[]] $data) {
  class ScriptManager {
    [string] $path; [string] $url;

    ScriptManager([string] $path, [string] $url) {
      $this.path = $path;
      $this.url = $url;
    }

    download([string[]] $scripts) {
      [System.Net.WebClient] $web_client = New-Object System.Net.WebClient;
      foreach ($script in $scripts) {
        $web_client.DownloadFile("$($this.url)/$script.ps1", "$($this.path)/$script.ps1");
      }
    }
    
    run([string[]] $scripts) {
      foreach ($script in $scripts) { powershell.exe -file "$($this.path)/$script.ps1"; }
    }

    delete([string[]] $scripts) {
      foreach ($script in $scripts) { Remove-Item $script; }
    }
  }

  return New-Object ScriptManager($data[0], $data[1]);
}
