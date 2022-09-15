function print ( [string] $text ) {
  Write-Host -ForegroundColor "Blue" "  $text"
}

# ===================================================================> Functions
function configComputerOther {
  # FIXME: disable bing search to all users function
  print("Disabled bing search on menu")

  # FIXME: Configure explorer launch page function
  print("Configured explorer launch page to 'This Computer' page")

  # FIXME: Configure 'Fast Access' explorer label - hidden recent function
  print("Configured 'Fast Access' explorer label to hidden recents")

  # FIXME: Configure 'Fast Access' explorer label - hidden frequent function
  print("Configured 'Fast Access' explorer label to hidden recents")

  powercfg.exe -change -monitor-timeout-ac 0
  print("Disabled monitor sleeping timeout")

  powercfg.exe -change -standby-timeout-ac 0
  print("Disabled computer sleeping timeout")
}

configComputerOther
