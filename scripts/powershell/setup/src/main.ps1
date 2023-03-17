#!/usr/bin/env pwsh

Import-Module "$env:TEMP/utils";

try {
  $console = create_console;
  $console.alert("Iniciando execução do script!");
  
  $console.puts("Verificando se existe cache:");
  $cache = create_cache_manager($env:TEMP);
  
  $console.puts("Procurando por cache...");
  $cache.read();
  
  if ($cache.exist) {
    $console.success("Existe cache salvo! Continuando execução do script!");
  }
  else {
    $console.alert_error("Não existe cache salvo! Parando execução do script!");
    Throw;
  }

  $console.alert("Baixando e executando scripts auxiliares!");
  $console.puts("Baixando scripts auxiliares...");
  $scripts = create_script_manager @($env:TEMP, "https://raw.githubusercontent.com/dreisss/iespes-extra/main/scripts/powershell/setup/src");
  $scripts.download(@("general", "apps", "optimize", "style", "permissions", "other"));
  $console.success("Scripts auxiliares baixados com sucesso!");
  
  $console.puts("Executando scripts auxiliares...");
  $scripts.run(@("general", "apps", "optimize", "style", "permissions", "other"));
  $console.success("Scripts auxiliares executados com sucesso!");
  
  $console.puts("Removendo scripts auxiliares...");
  $scripts.delete(@("general", "apps", "optimize", "style", "permissions", "other"));
  $console.success("Scripts auxiliares removidos com sucesso!");
  
  $console.puts("Configurando política de execução como restrita")
  Set-ExecutionPolicy "Restricted" -Scope "LocalMachine" -Force
  $console.success("Política de execução configurada com sucesso!")

  $console.puts("Finalizando execução do script!")
  $console.alert("Script executado com sucesso!")
  exit;
}
catch {
  $console.alert_error("Ocorreu um erro na execução do script!")
  exit;
}
