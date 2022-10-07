Import-Module "$env:USERPROFILE\Downloads\utilities"
[string] $labinNumber = $args[1]

# ==================================================================> Installing
function installChocolatey {
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://community.chocolatey.org/install.ps1"))
}

function installDefaultApps {
  foreach ($app in @("winrar", "adobereader", "chrome", "avastfreeantivirus", "cpu-z")) {
    print("    $app...")
    choco.exe install $app -y -f | Out-Null
  }
}

function installDeveloperApps {
  foreach ($app in @("git", "python", "sqlite", "vscode")) {
    print("    $app...")
    choco.exe install $app -y -f | Out-Null
  }
}

function installApps {
  print("  Chocolatey...")
  installChocolatey

  print("  Default apps:")
  installDefaultApps

  if (isDeveloperLabin($labinNumber)) {
    print
    print("  Developer apps:")
    installDeveloperApps
  }
}

# ================================================================> Uninstalling
function uninstallWindowsDefaultApps {
  foreach ($app in getWindowsDefaultApps) {
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
