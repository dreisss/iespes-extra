[string] $labinNumber = $args[1]
[int] $DEVELOPER_LABIN = 4
[string[]] $WINDOWS_DEFAULT_APPS_TO_UNINSTALL = @("Microsoft.549981C3F5F10", "Microsoft.3DBuilder", "Microsoft.Appconnector", "Microsoft.BingFinance", "Microsoft.BingNews", "Microsoft.BingSports", "Microsoft.BingTranslator", "Microsoft.BingWeather", "Microsoft.FreshPaint", "Microsoft.GamingServices", "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftPowerBIForWindows", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.MicrosoftStickyNotes", "Microsoft.MinecraftUWP", "Microsoft.NetworkSpeedTest", "Microsoft.Office.OneNote", "Microsoft.People", "Microsoft.Print3D", "Microsoft.SkypeApp", "Microsoft.Wallet", "Microsoft.WindowsAlarms", "Microsoft.WindowsCamera", "microsoft.windowscommunicationsapps", "Microsoft.WindowsMaps", "Microsoft.WindowsPhone", "Microsoft.WindowsSoundRecorder", "Microsoft.Xbox.TCUI", "Microsoft.XboxApp", "Microsoft.XboxGameOverlay", "Microsoft.XboxSpeechToTextOverlay", "Microsoft.YourPhone", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "Microsoft.CommsPhone", "Microsoft.ConnectivityStore", "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.Messaging", "Microsoft.Office.Sway", "Microsoft.OneConnect", "Microsoft.WindowsFeedbackHub", "Microsoft.Microsoft3DViewer", "Microsoft.BingFoodAndDrink", "Microsoft.BingHealthAndFitness", "Microsoft.BingTravel", "Microsoft.WindowsReadingList", "Microsoft.MixedReality.Portal", "Microsoft.ScreenSketch", "Microsoft.XboxGamingOverlay", "2FE3CB00.PicsArt-PhotoStudio", "46928bounde.EclipseManager", "4DF9E0F8.Netflix", "613EBCEA.PolarrPhotoEditorAcademicEdition", "6Wunderkinder.Wunderlist", "7EE7776C.LinkedInforWindows", "89006A2E.AutodeskSketchBook", "9E2F88E3.Twitter", "A278AB0D.DisneyMagicKingdoms", "A278AB0D.MarchofEmpires", "ActiproSoftwareLLC.562882FEEB491", "CAF9E577.Plex", "ClearChannelRadioDigital.iHeartRadio", "D52A8D61.FarmVille2CountryEscape", "D5EA27B7.Duolingo-LearnLanguagesforFree", "DB6EA5DB.CyberLinkMediaSuiteEssentials", "DolbyLaboratories.DolbyAccess", "DolbyLaboratories.DolbyAccess", "Drawboard.DrawboardPDF", "Facebook.Facebook", "Fitbit.FitbitCoach", "Flipboard.Flipboard", "GAMELOFTSA.Asphalt8Airborne", "KeeperSecurityInc.Keeper", "NORDCURRENT.COOKINGFEVER", "PandoraMediaInc.29680B314EFC2", "Playtika.CaesarsSlotsFreeCasino", "ShazamEntertainmentLtd.Shazam", "SlingTVLLC.SlingTV", "SpotifyAB.SpotifyMusic", "TheNewYorkTimes.NYTCrossword", "ThumbmunkeysLtd.PhototasticCollage", "TuneIn.TuneInRadio", "WinZipComputing.WinZipUniversal", "XINGAG.XING", "flaregamesGmbH.RoyalRevolt2", "king.com.*", "king.com.BubbleWitch3Saga", "king.com.CandyCrushSaga", "king.com.CandyCrushSodaSaga", "Microsoft.Advertising.Xaml")

function print( [string] $text) {
  Write-Host -ForegroundColor "Blue" "   $text"
}

# ==================================================================> Installing
function installChocolatey {
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://community.chocolatey.org/install.ps1"))
}

function installDefaultApps {
  foreach ($app in @("winrar", "adobereader", "cpu-z")) {
    print("    $app...")
    choco.exe install $app -y -f | Out-Null
  }
}

function installDeveloperApps {
  foreach ($app in @("git", "python", "sqlite", "vscode", "pycharm-community")) {
    print("    $app...")
    choco.exe install $app -y -f | Out-Null
  }
}

function installApps {
  print("  Chocolatey...")
  installChocolatey

  print("  Default apps:")
  installDefaultApps

  if ($labinNumber -eq $DEVELOPER_LABIN) {
    print
    print("  Developer apps:")
    installDeveloperApps
  }
}

# ================================================================> Uninstalling
function uninstallWindowsDefaultApps {
  foreach ($app in $WINDOWS_DEFAULT_APPS_TO_UNINSTALL) {
    print("    $app...")
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers
    (Get-AppxProvisionedPackage -Online).Where( { $_.DisplayName -eq $app }) | Remove-AppxProvisionedPackage -Online
  }
}

function uninstallOneDrive {
  taskkill.exe /f /im "OneDrive.exe" | Out-Null
  cmd.exe /c "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall | Out-Null
}

function uninstallApps {
  print("  OneDrive...")
  uninstallOneDrive

  print("  Windows default apps:")
  uninstallWindowsDefaultApps
}

# =====================================================================> Running

print("> Installing Apps")
installApps

print
print("> Uninstalling Apps")
uninstallApps