#!/usr/bin/env pwsh

Import-Module "./utils";

function get_data {
  $console.puts("Verificando se existe cache:");
  $cache = create_cache_manager($env:TEMP);
  
  $console.puts("Procurando por cache...");
  $cache.read();
  
  if ($cache.exist) {
    $console.puts("Existe cache salvo! Utilizando dados salvos...");
    [bool] $is_notebook = [bool]::Parse($cache.get("is_notebook"));
    [int] $laboratory_number = $cache.get("laboratory_number");
    [int] $computer_number = $cache.get("computer_number");
    $console.success("Dados utilizados com sucesso!");
  }
  else {
    $console.puts("Não existe cache salvo! Informe os dados pedidos abaixo:");
    [bool] $is_notebook = $console.gets("  É um notebook? (s, N)").Equals("s");
    [int] $laboratory_number = $console.gets("  Número do laboratório (2..5)");
    [int] $computer_number = $console.gets("  Número do computador");
    $console.success("Dados salvos com sucesso!");

    $console.puts("Salvando dados no cache...");
    $cache.set("is_notebook", $is_notebook);
    $cache.set("laboratory_number", $laboratory_number);
    $cache.set("computer_number", $computer_number);
    $cache.write();
    $console.success("Cache salvo com sucesso!");
  }

  return $cache.get_data();
}

function verify_network([object] $data) {
  $console.alert("Verificando conexão com a Internet!");
  $network = create_network_manager($data);

  $console.puts("Iniciando teste de conexão:");
  $console.puts("Teste em andamento...");
  $network.try_connection();
  
  if (-not($network.has_connection)) {
    $console.error("O teste de conexão falhou! Configurando novamente...");
    $network.configure();

    $console.puts("Teste em andamento...");
    $network.try_connection();

    if (-not($network.has_connection)) {
      $console.alert_error("O teste de conexão falhou novamente! Parando execução do script!");
      Throw;
    }
  }

  $console.success("Teste de conexão bem sucedido! Continuando execução do script!");
}

function run_initializer_routine {
  $console.alert("Baixando e executando inicializador do script!");
  $console.puts("Baixando inicializador...");
  [System.Net.WebClient] $web_client = New-Object System.Net.WebClient;
  $web_client.DownloadFile("https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/src/main.ps1", "$env:TEMP/main.ps1");
  $web_client.DownloadFile("https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/src/utils.psm1", "$env:TEMP/utils.ps1");
  $console.success("Inicializador baixado com sucesso!");
  
  $console.puts("Executando inicializador...");
  Start-Process powershell -Verb RunAs -ArgumentList ("-Noexit -Noprofile -ExecutionPolicy Bypass -File $env:TEMP/main.ps1 -Elevated");
  $console.success("Inicializador executando com sucesso!")
}

# ===> Running 
if (-not(running_as_admin)) {
  Start-Process powershell -Verb RunAs -ArgumentList ('-Noexit -Noprofile -ExecutionPolicy Bypass -File "{0}" -Elevated' -f ($myinvocation.MyCommand.Definition));
  exit;
}

try {
  $console = create_console;
  $console.alert("Iniciando execução do script!");
  
  [object] $data = get_data;
  verify_network($data);
  run_initializer_routine;
  
  $console.puts("Finalizando execução do script!")
  $console.alert("Script executado com sucesso!")
  exit;
}
catch {
  $console.alert_error("Ocorreu um erro na execução do script!")
  exit;
}
