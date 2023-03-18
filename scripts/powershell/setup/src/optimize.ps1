Import-Module "$env:TEMP/utils";

$console = create_console;

$console.puts("Executando arquivo `"optimize.ps1`":");

$console.puts("  Configurando efeitos visuais para o usuário administrador...");
Set-ItemProperty -Force -Type "DWord" -Value 2 -Name "VisualFXSetting" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/VisualEffects"
$console.success("  Efeitos visuais configurados com sucesso!");

$console.puts("  Desativando transparência para o usuário administrador...");
Set-ItemProperty -Force -Type "DWord" -Value 0 -Name "EnableTransparency" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize"
$console.success("  Transparência desativada com sucesso!");

$console.puts("  Desativando telemetria...");
Set-ItemProperty -Force -Type "DWord" -Value 0 -Name "AllowTelemetry" "HKLM:/SOFTWARE/Policies/Microsoft/Windows/DataCollection"
$console.success("  Telemetria desativada com sucesso!");

$console.puts("  Desativando aplicativos em segundo plano...");
New-Item -Path "HKLM:/SOFTWARE/Policies/Microsoft/Windows/AppPrivacy" | Out-Null
Set-ItemProperty -Force -Type "DWord" -Value 2 -Name "LetAppsRunInBackground" "HKLM:/SOFTWARE/Policies/Microsoft/Windows/AppPrivacy"
$console.success("  Aplicativos em segundo plano desativados com sucesso!");

$console.puts("Execução do arquivo `"optimize.ps1`" finalizado!");
