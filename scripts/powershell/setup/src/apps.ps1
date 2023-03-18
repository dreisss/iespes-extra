Import-Module "$env:TEMP/utils";

$console = create_console;

$console.puts("Executando arquivo `"apps.ps1`":");

$console.puts("  Utilizando dados salvos em cache...");
$cache = create_cache_manager($env:TEMP);
$cache.read();
$data = $cache.get_data();
$console.success("  Dados utilizados com sucesso!");

$console.puts("  Instalando aplicativos padrão...");
foreach ($app in @()) { winget install $app; } # TODO: add WinRar, Adobe Reader, Firefox, Cpu-z, Microsoft Office
$console.success("  Aplicativos padrão instalados com sucesso!");

$console.puts("  Instalando aplicativos específicos do laboratório $($data["laboratory_number"])...");
if ($data["laboratory_number"] -eq 2) {
  foreach ($app in @()) { winget install $app; }
}

if ($data["laboratory_number"] -eq 4) {
  foreach ($app in @()) { winget install $app; } # TODO: add VSCode, Git, Python, Sqlite, Packet Tracer
}

if ($data["laboratory_number"] -eq 5) {
  foreach ($app in @()) { winget install $app; }
}
$console.success("  Aplicativos específicos do laboratório $($data["laboratory_number"]) instalados com sucesso!");

$console.puts("  Desinstalando aplicativos desnecessários...");
foreach ($app in apps_to_uninstall) { winget uninstall --id $app; }
$console.success("  Aplicativos desinstalados com sucesso!");

$console.puts("Execução do arquivo `"apps.ps1`" finalizado!");
