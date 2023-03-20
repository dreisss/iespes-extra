Import-Module "$env:TEMP/utils";

$console = create_console;

$console.puts("Executando arquivo `"general.ps1`":");

$console.puts("  Utilizando dados salvos em cache...");
$cache = create_cache_manager($env:TEMP);
$cache.read();
$data = $cache.get_data();
$console.success("  Dados utilizados com sucesso!");

$console.puts("  Renomeando computador...");
$lab = $data.laboratory_number.PadLeft(2, [char] "0");
$comp = $data.computer_number.PadLeft(2, [char] "0");
Rename-Computer -NewName "LABIN$lab-PC$comp" | Out-Null
$console.success("  Computador renomeado com sucesso!");

$console.puts("  Ativando Windows...");
cmd.exe /c slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
cmd.exe /c slmgr /skms kms8.msguides.com
cmd.exe /c slmgr /ato
$console.success("  Windows ativado com sucesso!")

$console.puts("Execução do arquivo `"general.ps1`" finalizado!");
