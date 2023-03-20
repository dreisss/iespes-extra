Import-Module "$env:TEMP/utils";

$console = create_console;

$console.puts("Executando arquivo `"apps.ps1`":");

$console.puts("  Utilizando dados salvos em cache...");
$cache = create_cache_manager($env:TEMP);
$cache.read();
$data = $cache.get_data();
$console.success("  Dados utilizados com sucesso!");

$console.puts("  Baixando gerenciador de pacotes Chocolatey...");
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://community.chocolatey.org/install.ps1"));
$console.success("  Chocolatey instalado com sucesso!")

$console.puts("  Instalando aplicativos padrão...");
choco.exe install winrar adobereader firefox cpu-z -yf --ignore-checksums | Out-Null;
$console.success("  Aplicativos padrão instalados com sucesso!");

$console.puts("  Instalando aplicativos específicos do laboratório $($data.laboratory_number)...");
if ($data.laboratory_number -eq 2) {
  # choco.exe install $app -yf --ignore-checksums | Out-Null;
}

if ($data.laboratory_number -eq 4) {
  choco.exe install vscode git python sqlite -yf --ignore-checksums | Out-Null; # install Packet Tracer
}

if ($data.laboratory_number -eq 5) {
  choco.exe install  -yf --ignore-checksums | Out-Null; # install Firebird, Flamerobin
}
$console.success("  Aplicativos específicos do laboratório $($data.laboratory_number) instalados com sucesso!");

$console.puts("Execução do arquivo `"apps.ps1`" finalizado!");
