$WINDOWS_DEFAULT_APPS_TO_UNINSTALL = @("Microsoft.549981C3F5F10", "Microsoft.3DBuilder", "Microsoft.Appconnector", "Microsoft.BingFinance", "Microsoft.BingNews", "Microsoft.BingSports", "Microsoft.BingTranslator", "Microsoft.BingWeather", "Microsoft.FreshPaint", "Microsoft.GamingServices", "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftPowerBIForWindows", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.MicrosoftStickyNotes", "Microsoft.MinecraftUWP", "Microsoft.NetworkSpeedTest", "Microsoft.Office.OneNote", "Microsoft.People", "Microsoft.Print3D", "Microsoft.SkypeApp", "Microsoft.Wallet", "Microsoft.WindowsAlarms", "Microsoft.WindowsCamera", "microsoft.windowscommunicationsapps", "Microsoft.WindowsMaps", "Microsoft.WindowsPhone", "Microsoft.WindowsSoundRecorder", "Microsoft.Xbox.TCUI", "Microsoft.XboxApp", "Microsoft.XboxGameOverlay", "Microsoft.XboxSpeechToTextOverlay", "Microsoft.YourPhone", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "Microsoft.CommsPhone", "Microsoft.ConnectivityStore", "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.Messaging", "Microsoft.Office.Sway", "Microsoft.OneConnect", "Microsoft.WindowsFeedbackHub", "Microsoft.Microsoft3DViewer", "Microsoft.BingFoodAndDrink", "Microsoft.BingHealthAndFitness", "Microsoft.BingTravel", "Microsoft.WindowsReadingList", "Microsoft.MixedReality.Portal", "Microsoft.ScreenSketch", "Microsoft.XboxGamingOverlay", "2FE3CB00.PicsArt-PhotoStudio", "46928bounde.EclipseManager", "4DF9E0F8.Netflix", "613EBCEA.PolarrPhotoEditorAcademicEdition", "6Wunderkinder.Wunderlist", "7EE7776C.LinkedInforWindows", "89006A2E.AutodeskSketchBook", "9E2F88E3.Twitter", "A278AB0D.DisneyMagicKingdoms", "A278AB0D.MarchofEmpires", "ActiproSoftwareLLC.562882FEEB491", "CAF9E577.Plex", "ClearChannelRadioDigital.iHeartRadio", "D52A8D61.FarmVille2CountryEscape", "D5EA27B7.Duolingo-LearnLanguagesforFree", "DB6EA5DB.CyberLinkMediaSuiteEssentials", "DolbyLaboratories.DolbyAccess", "DolbyLaboratories.DolbyAccess", "Drawboard.DrawboardPDF", "Facebook.Facebook", "Fitbit.FitbitCoach", "Flipboard.Flipboard", "GAMELOFTSA.Asphalt8Airborne", "KeeperSecurityInc.Keeper", "NORDCURRENT.COOKINGFEVER", "PandoraMediaInc.29680B314EFC2", "Playtika.CaesarsSlotsFreeCasino", "ShazamEntertainmentLtd.Shazam", "SlingTVLLC.SlingTV", "SpotifyAB.SpotifyMusic", "TheNewYorkTimes.NYTCrossword", "ThumbmunkeysLtd.PhototasticCollage", "TuneIn.TuneInRadio", "WinZipComputing.WinZipUniversal", "XINGAG.XING", "flaregamesGmbH.RoyalRevolt2", "king.com.*", "king.com.BubbleWitch3Saga", "king.com.CandyCrushSaga", "king.com.CandyCrushSodaSaga", "Microsoft.Advertising.Xaml")

# ===================================================> Utilities: write and read
function printImportant( [string] $text ) {
  Write-Host " > $text " -BackgroundColor "Blue" -ForegroundColor "Black"
}

function printSecondary( [string] $text ) {
  Write-Host "   $text " -ForegroundColor "Gray"
}

function printSpace() {
  Write-Host ""
}

function waitKey( [string] $text ) {
  printSecondary("$text...")
  [Console]::ReadKey($true) | Out-Null
}

function read( [string] $text ) {
  return $(Read-Host "   $text")
}

function readConditional( [string] $text ) {
  $value = Read-Host "   $text ? (y, N)"
  return $value -eq "y"
}

# ============================================================> Utilities: other
function formatNumber( [string] $number ) {
  return $(if ($number.Length -lt 2) { "0$number" } else { $number })
}

function getComputerName {
  return "LABIN$(formatNumber($labinNumber))-PC$(formatNumber($computerNumber))"
}

function getNetworkConfig {
  return @{
    ipAddress      = "192.168.$($labinNumber).$($computerNumber + 1)"
    defaultGateway = "192.168.$($labinNumber).1"
    dns            = ("8.8.8.8", "8.8.4.4")
  }
}

function getUsersSIDList {
  $usersList = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | Where-Object { $_.PSChildName -match "S-1-5-21-\d+-\d+\-\d+\-\d+$" }
  return $usersList.PSChildName
}

function isRunningAsAdmin {
  $currentProcess = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentProcess.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ====================================================> Config Computer: General
function renameComputer {
  $newName = getComputerName

  printImportant("Renaming computer");
  printSecondary("New name: $newName")
  Rename-Computer -NewName $newName | Out-Null
  printSpace
}

function createDefaultUser {
  printImportant("Creating default user");
  printSecondary("Default user name: Aluno");
  printSecondary("Default user password: ")
  New-LocalUser -Name "Aluno" -NoPassword | Out-Null
  Set-LocalUser -Name "Aluno" -UserMayChangePassword $false  -PasswordNeverExpires $true -AccountNeverExpires | Out-Null
  Add-LocalGroupMember -SID "S-1-5-32-545" -Member "Aluno" | Out-Null
  printSpace
}

# ====================================================> Config Computer: Network
function setNetworkConfigNotebook {
  printSecondary("Waiting for Wifi connection")
  waitKey("Press when network is available")
}

function setNetworkConfigDesktop {
  $config = getNetworkConfig

  printSecondary("IPV4 address: $($config.ipAddress)")
  printSecondary("Default gateway: $($config.defaultGateway)")
  printSecondary("Primary and Secondary DNS: $($config.dns[0]), $($config.dns[1])")
  New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily "ipv4" -IPAddress $config.ipAddress -PrefixLength 24 -DefaultGateway $config.defaultGateway | Out-Null
  Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $config.dns | Out-Null
  printSecondary("Waiting 30 seconds...")
  Start-Sleep -Seconds 30
}

function setNetworkConfig {
  printImportant("Configuring network")
  if ($isNotebook) { setNetworkConfigNotebook } else { setNetworkConfigDesktop }
  printSpace
}

# ===========================================> Config Computer: Activate Windows
function activateWindows {
  printImportant("Activating Windows")
  cmd.exe /c slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
  cmd.exe /c slmgr /skms kms8.msguides.com
  cmd.exe /c slmgr /ato
}

# ===================================> Config Computer: Styling and Optimization
function optimizeComputer {
  printImportant("Optimizing computer")
  printSecondary("Defined performance as priority on configs")
  printSecondary("Disabled background application")
  printSecondary("Disabled visual transparency")
  foreach ($userSID in getUsersSIDList) {
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0
  }
  printSpace
}

function getWallpapers {
  $outPath = "$env:USERPROFILE\Documents\Wallpapers"

  printSecondary("Getting wallpapers...")
  New-Item $outPath -ItemType "directory" | Out-Null
  Invoke-WebRequest -Uri "https://github.com/dreisss/iespes-extra/raw/main/design/wallpapers/desktop.png" -Outfile "$outPath\desktop.png"
  Invoke-WebRequest -Uri "https://github.com/dreisss/iespes-extra/raw/main/design/wallpapers/lock.png" -Outfile "$outPath\lock.png"
}

function styleComputer {
  printImportant("Styling computer")
  printSecondary("Defined system and applications theme to black")
  printSecondary("Applied font smoothing")
  foreach ($userSID in getUsersSIDList) {
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
    Set-ItemProperty "Registry::HKEY_USERS\$userSID\Control Panel\Desktop" -Name "FontSmoothing" -Value 2
  }
  printSpace
}

# ============================================================> Apps: Installing
function installChocolatey {
  printSecondary("chocolatey...")
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function installAppsFromChocolatey {
  foreach ($app in @("winrar", "adobereader", "avastfreeantivirus")) {
    printSecondary("$app...")
    choco install -y $app | Out-Null
  }
}

function installAppsLabin4 {
  foreach ($app in @("vscode", "git", "python", "mysql")) {
    printSecondary("$app...")
    choco install -y $app | Out-Null
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
    printSecondary("$app...")
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers
    (Get-AppxProvisionedPackage -Online).Where( { $_.DisplayName -EQ $app }) | Remove-AppxProvisionedPackage -Online
  }
}

function uninstallOneDrive {
  printSecondary("Microsoft.OneDrive")
  foreach ($userSID in getUsersSIDList) {
    $uninstallerPath = Get-ItemPropertyValue "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe" -Name UninstallString
    cmd.exe /c $uninstallerPath
  }
}

function uninstallApps {
  printImportant("Uninstalling apps")
  uninstallOneDrive
  uninstallWindowsDefaultApps
  printSpace
}

# =====================================================================> Running
function runFunctions {
  renameComputer
  createDefaultUser
  setNetworkConfig
  activateWindows
  optimizeComputer
  styleComputer
  installApps
  uninstallApps
}

if (-not(isRunningAsAdmin)) {
  Start-Process powershell -Verb RunAs -ArgumentList ('-Noprofile -ExecutionPolicy Bypass -File "{0}" -Elevated' -f ($myinvocation.MyCommand.Definition))
  exit
}

printSpace
printImportant("Starting script")

[int] $labinNumber = read("Labin number")
[int] $computerNumber = read("Computer number")
[bool] $isNotebook = readConditional("Is Notebook")
printSpace

runFunctions
printImportant("Finished script")
printSpace
