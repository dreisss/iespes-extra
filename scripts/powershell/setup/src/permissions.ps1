Import-Module "$env:TEMP/utils";

$console = create_console;

$console.puts("Executando arquivo `"permissions.ps1`":");

$console.puts("  Desabilitando acesso à página de aparencia...");
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoDispAppearancePage" -Value 1 -PropertyType "DWord" | Out-Null;
$console.success("  Acesso à página de aparencia desabilitado com sucesso!");

$console.puts("  Desabilitando acesso à página de temas...");
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoThemesTab" -Value 1 -PropertyType "DWord" | Out-Null
$console.success("  Acesso à página de temas desabilitado com sucesso!");

$console.puts("  Bloqueando mudanças na barra de tarefas...");
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "TaskbarLockAll" -Value 1 -PropertyType "DWord" | Out-Null
$console.success("  Mudanças na barra de tarefas bloqueadas com sucesso!");

$console.puts("Execução do arquivo `"permissions.ps1`" finalizado!");
