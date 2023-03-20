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
    [object] $data; [string] $path; [bool] $exist;

    CacheManager([string] $path) {
      $this.path = $path;
    }
    
    [void] read() {
      if ($this.data = Get-Content "$($this.path)/setup_cache" -ErrorAction "SilentlyContinue" | ConvertFrom-Json) {
        $this.exist = $true;
        return;
      }
      $this.data = [object]@{};
    }

    [object] get_data() { return $this.data; }
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
      foreach ($script in $scripts) {
        Start-Process powershell -Verb RunAs -ArgumentList ("-Noexit -Noprofile -ExecutionPolicy Bypass -File $($this.path)/$script.ps1 -Elevated");
      }
    }

    delete([string[]] $scripts) {
      foreach ($script in $scripts) { Remove-Item $($this.path)/$script.ps1; }
    }
  }

  return New-Object ScriptManager($data[0], $data[1]);
}

function apps_to_uninstall {
  return @("Microsoft.549981C3F5F10", "Microsoft.3DBuilder", "Microsoft.Appconnector", "Microsoft.BingFinance", "Microsoft.BingNews", "Microsoft.BingSports", "Microsoft.BingTranslator", "Microsoft.BingWeather", "Microsoft.FreshPaint", "Microsoft.GamingServices", "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftPowerBIForWindows", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.MicrosoftStickyNotes", "Microsoft.MinecraftUWP", "Microsoft.NetworkSpeedTest", "Microsoft.Office.OneNote", "Microsoft.People", "Microsoft.Print3D", "Microsoft.SkypeApp", "Microsoft.Wallet", "Microsoft.WindowsAlarms", "Microsoft.WindowsCamera", "microsoft.windowscommunicationsapps", "Microsoft.WindowsMaps", "Microsoft.WindowsPhone", "Microsoft.WindowsSoundRecorder", "Microsoft.Xbox.TCUI", "Microsoft.XboxApp", "Microsoft.XboxGameOverlay", "Microsoft.XboxSpeechToTextOverlay", "Microsoft.YourPhone", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "Microsoft.CommsPhone", "Microsoft.ConnectivityStore", "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.Messaging", "Microsoft.Office.Sway", "Microsoft.OneConnect", "Microsoft.WindowsFeedbackHub", "Microsoft.Microsoft3DViewer", "Microsoft.BingFoodAndDrink", "Microsoft.BingHealthAndFitness", "Microsoft.BingTravel", "Microsoft.WindowsReadingList", "Microsoft.MixedReality.Portal", "Microsoft.ScreenSketch", "Microsoft.XboxGamingOverlay", "2FE3CB00.PicsArt-PhotoStudio", "46928bounde.EclipseManager", "4DF9E0F8.Netflix", "613EBCEA.PolarrPhotoEditorAcademicEdition", "6Wunderkinder.Wunderlist", "7EE7776C.LinkedInforWindows", "89006A2E.AutodeskSketchBook", "9E2F88E3.Twitter", "A278AB0D.DisneyMagicKingdoms", "A278AB0D.MarchofEmpires", "ActiproSoftwareLLC.562882FEEB491", "CAF9E577.Plex", "ClearChannelRadioDigital.iHeartRadio", "D52A8D61.FarmVille2CountryEscape", "D5EA27B7.Duolingo-LearnLanguagesforFree", "DB6EA5DB.CyberLinkMediaSuiteEssentials", "DolbyLaboratories.DolbyAccess", "DolbyLaboratories.DolbyAccess", "Drawboard.DrawboardPDF", "Facebook.Facebook", "Fitbit.FitbitCoach", "Flipboard.Flipboard", "GAMELOFTSA.Asphalt8Airborne", "KeeperSecurityInc.Keeper", "NORDCURRENT.COOKINGFEVER", "PandoraMediaInc.29680B314EFC2", "Playtika.CaesarsSlotsFreeCasino", "ShazamEntertainmentLtd.Shazam", "SlingTVLLC.SlingTV", "SpotifyAB.SpotifyMusic", "TheNewYorkTimes.NYTCrossword", "ThumbmunkeysLtd.PhototasticCollage", "TuneIn.TuneInRadio", "WinZipComputing.WinZipUniversal", "XINGAG.XING", "flaregamesGmbH.RoyalRevolt2", "king.com.*", "king.com.BubbleWitch3Saga", "king.com.CandyCrushSaga", "king.com.CandyCrushSodaSaga", "Microsoft.Advertising.Xaml", "Microsoft.OneDrive")
}
