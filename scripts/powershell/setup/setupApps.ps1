param (
  [Parameter()]
  [string] $labinNumber
)

$WINDOWS_DEFAULT_APPS_TO_UNINSTALL = @("Microsoft.549981C3F5F10", "Microsoft.3DBuilder", "Microsoft.Appconnector", "Microsoft.BingFinance", "Microsoft.BingNews", "Microsoft.BingSports", "Microsoft.BingTranslator", "Microsoft.BingWeather", "Microsoft.FreshPaint", "Microsoft.GamingServices", "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftPowerBIForWindows", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.MicrosoftStickyNotes", "Microsoft.MinecraftUWP", "Microsoft.NetworkSpeedTest", "Microsoft.Office.OneNote", "Microsoft.People", "Microsoft.Print3D", "Microsoft.SkypeApp", "Microsoft.Wallet", "Microsoft.WindowsAlarms", "Microsoft.WindowsCamera", "microsoft.windowscommunicationsapps", "Microsoft.WindowsMaps", "Microsoft.WindowsPhone", "Microsoft.WindowsSoundRecorder", "Microsoft.Xbox.TCUI", "Microsoft.XboxApp", "Microsoft.XboxGameOverlay", "Microsoft.XboxSpeechToTextOverlay", "Microsoft.YourPhone", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "Microsoft.CommsPhone", "Microsoft.ConnectivityStore", "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.Messaging", "Microsoft.Office.Sway", "Microsoft.OneConnect", "Microsoft.WindowsFeedbackHub", "Microsoft.Microsoft3DViewer", "Microsoft.BingFoodAndDrink", "Microsoft.BingHealthAndFitness", "Microsoft.BingTravel", "Microsoft.WindowsReadingList", "Microsoft.MixedReality.Portal", "Microsoft.ScreenSketch", "Microsoft.XboxGamingOverlay", "2FE3CB00.PicsArt-PhotoStudio", "46928bounde.EclipseManager", "4DF9E0F8.Netflix", "613EBCEA.PolarrPhotoEditorAcademicEdition", "6Wunderkinder.Wunderlist", "7EE7776C.LinkedInforWindows", "89006A2E.AutodeskSketchBook", "9E2F88E3.Twitter", "A278AB0D.DisneyMagicKingdoms", "A278AB0D.MarchofEmpires", "ActiproSoftwareLLC.562882FEEB491", "CAF9E577.Plex", "ClearChannelRadioDigital.iHeartRadio", "D52A8D61.FarmVille2CountryEscape", "D5EA27B7.Duolingo-LearnLanguagesforFree", "DB6EA5DB.CyberLinkMediaSuiteEssentials", "DolbyLaboratories.DolbyAccess", "DolbyLaboratories.DolbyAccess", "Drawboard.DrawboardPDF", "Facebook.Facebook", "Fitbit.FitbitCoach", "Flipboard.Flipboard", "GAMELOFTSA.Asphalt8Airborne", "KeeperSecurityInc.Keeper", "NORDCURRENT.COOKINGFEVER", "PandoraMediaInc.29680B314EFC2", "Playtika.CaesarsSlotsFreeCasino", "ShazamEntertainmentLtd.Shazam", "SlingTVLLC.SlingTV", "SpotifyAB.SpotifyMusic", "TheNewYorkTimes.NYTCrossword", "ThumbmunkeysLtd.PhototasticCollage", "TuneIn.TuneInRadio", "WinZipComputing.WinZipUniversal", "XINGAG.XING", "flaregamesGmbH.RoyalRevolt2", "king.com.*", "king.com.BubbleWitch3Saga", "king.com.CandyCrushSaga", "king.com.CandyCrushSodaSaga", "Microsoft.Advertising.Xaml")

function installChocolatey {
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://community.chocolatey.org/install.ps1"))
}

function installAppsFromChocolatey {
  foreach ($app in @("winrar", "adobereader", "avastfreeantivirus")) {
    choco.exe install -y $app | Out-Null
  }
}

function installAppsLabin4 {
  foreach ($app in @("git", "python", "sqlite", "vscode", "pycharm-community")) {
    choco.exe install $app -y -f | Out-Null
  }
}

function installApps {
  printImportant("Installing apps")
  installChocolatey
  installAppsFromChocolatey
  if ($labinNumber -eq 4) {
    installAppsLabin4
  }
  printSpace
}

# ==========================================================> Apps: Uninstalling
function uninstallWindowsDefaultApps {
  foreach ($app in $WINDOWS_DEFAULT_APPS_TO_UNINSTALL) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers
    (Get-AppxProvisionedPackage -Online).Where( { $_.DisplayName -EQ $app }) | Remove-AppxProvisionedPackage -Online
  }
}

function uninstallOneDrive {
  foreach ($userSID in getUsersSIDList) {
    $uninstallerPath = Get-ItemPropertyValue "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe" -Name "UninstallString"
    cmd.exe /c $uninstallerPath
  }
}

function uninstallApps {
  printImportant("Uninstalling apps")
  uninstallOneDrive
  uninstallWindowsDefaultApps
  printSpace
}
