Import-Module "$env:TEMP/utils";

$console = create_console;

$console.puts("Executando arquivo `"other.ps1`":");

$console.puts("  Desabilitando pesquisa no bing...");
Set-ItemProperty -Force -Type "DWord" -Value 0 -Name "BingSearchEnabled" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Search";
$console.success("  Pesquisa no bing desabilitada com sucesso!");

$console.puts("  Configurando página de início do explorer...");
Set-ItemProperty -Force -Type "DWord" -Value 1 -Name "LaunchTo" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/Advanced"
$console.success("  Página de início do explorer configurada com sucesso!");

$console.puts("  Configurando página de acesso rápido do explorer...");
Set-ItemProperty -Force -Type "DWord" -Value 0 -Name "ShowRecent" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer"
Set-ItemProperty -Force -Type "DWord" -Value 0 -Name "ShowFrequent" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer"
$console.success("  Página de acesso rápido do explorer configurada com sucesso!");

$console.puts("  Desabilitando suspensão do computador...");
powercfg.exe -change -monitor-timeout-ac 0
powercfg.exe -change -standby-timeout-ac 0
$console.success("  Suspensão do computador desabilitado com sucesso!");

$console.puts("  Criando usuário `"Aluno`"...");
New-LocalUser -Name "Aluno" -NoPassword | Out-Null
Set-LocalUser -Name "Aluno" -UserMayChangePassword $false  -PasswordNeverExpires $true -AccountNeverExpires | Out-Null
Add-LocalGroupMember -SID "S-1-5-32-545" -Member "Aluno" | Out-Null
$console.success("  Usuário `"Aluno`" criado com sucesso!");

$console.puts("Execução do arquivo `"other.ps1`" finalizado!");
