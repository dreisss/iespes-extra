function createConsole {
  class Console {
    [string] gets([string] $text) { return Read-Host " $text" } 
    [void] puts([string] $text) { Write-Host " $text " -ForegroundColor "Blue" }
    [void] alert([string] $text) { Write-Host "@: $text " -ForegroundColor "Blue" -BackgroundColor "Black" }
    [void] error([string] $text) { Write-Host " $text "  -ForegroundColor "Red" }
    [void] success([string] $text) { Write-Host " $text " -ForegroundColor "Green" }
    [void] alert_error([string] $text) { Write-Host "@: $text "  -ForegroundColor "Red" -BackgroundColor "Black" }
  }

  return New-Object Console;
}
