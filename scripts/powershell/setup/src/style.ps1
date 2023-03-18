Import-Module "$env:TEMP/utils";

$console = create_console;

$console.puts("Executando arquivo `"style.ps1`":");

$console.puts("  Baixando papel de parede...");
New-Item "$env:WINDIR/Personalization" -ItemType "Directory" | Out-Null;
(New-Object System.Net.WebClient).DownloadFile("https://github.com/dreisss/iespes-extra/raw/main/design/wallpapers/wallpaper.png", "$env:WINDIR/Personalization/wallpaper.png");
$console.success("  Papel de parede baixado com sucesso!");

$console.puts("  Configurando papel de parede desktop e tela de bloqueio...")
New-Item -Path "HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion/PersonalizationCSP" | Out-Null
New-ItemProperty -PropertyType "DWord" -Value 1 -Name "DesktopImageStatus" "HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion/PersonalizationCSP" | Out-Null;
New-ItemProperty -PropertyType "String" -Value "$env:WINDIR/Personalization/wallpaper.png" -Name "DesktopImagePath" "HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion/PersonalizationCSP" | Out-Null;
New-ItemProperty -PropertyType "DWord" -Value 1 -Name "LockScreenImageStatus" "HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion/PersonalizationCSP" | Out-Null;
New-ItemProperty -PropertyType "String" -Value "$env:WINDIR/Personalization/wallpaper.png" -Name "LockScreenImagePath" "HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion/PersonalizationCSP" | Out-Null;
$console.success("  Papeis de parede configurados com sucesso!");

$console.puts("  Configurando cores do sistema para o usuário administrador...");
[byte[]] $binaryPaletteCode = "94,e0,b1,00,75,c7,95,00,3d,ad,68,00,10,89,3e,00,0b,5c,2a,00,08,42,1e,00,05,2b,14,00,00,b7,c3,00".Split(',') | ForEach-Object { "0x$_" };
Set-ItemProperty -Force -Type "String" -Value "0xff3e8910" -Name "AccentColorMenu" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/Accent";
Set-ItemProperty -Force -Type "Binary" -Value $binaryPaletteCode -Name "AccentPalette" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/Accent";
Set-ItemProperty -Force -Type "String" -Value "0xff2a5c0b" -Name "StartColorMenu" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/Accent";
Set-ItemProperty -Force -Type "DWord" -Value 0 -Name "SystemUsesLightTheme" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize";
Set-ItemProperty -Force -Type "DWord" -Value 0 -Name "AppsUseLightTheme" "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize"
$console.success("  Cores configuradas com sucesso!");

$console.puts("  Ativando fonte suave novamente...");
Set-ItemProperty -Force -Type "String" -Value 2 -Name "FontSmoothing" "HKCU:/Control Panel/Desktop";
$console.success("  Fonte suave ativada com sucesso!");

$console.puts("Execução do arquivo `"style.ps1`" finalizado!");
