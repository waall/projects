$banner = @'
, // ,,/ ,.// ,/ ,// / /, // ,/, /, // ,/, //,  //
/, // ,_\_// ,/ ,, ,/, // ,/ /, //, /,/, ///,  /
 /, .-'   `-. ,// ////, // ,/,/, // ///, /, /, /
, ,(         `, // ,,///, // ,/,/, // , // ,/ /
,/ ,^^^^\^^^^^/,// ///  /,,/,/, ///, // , // ,
 / //    \\_O   / , // ,/, //, ///, // ,/ / //
,/ ,,     J_/\   /,,///, // ,/,/, // , /  , /
 /,/          ),  // ,/ ,// / /, // , ./,/.//
/ /,,        /|    . ,  ///, . /, // ,//, /
, / x57      \ \    /. //, ,( ,/,/, // ,/,
       Rain and no More Umbrella!
'@


$serviceName = "csc_umbrellaagent"
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "[-] Este script precisa ser executado como Administrador!" -ForegroundColor Red
    exit
}

Write-Host $banner -ForegroundColor Cyan
Write-Host ""
Write-Host "[!] Execute o comando: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor White
Write-Host "[!] Execute como Administrador" -ForegroundColor White
Write-Host "[!] Atualize os caches e teste em navegação anônima" -ForegroundColor White

try {
  if ($service) {
  if ($service.Status -ne "Stopped") {
      Stop-Service -Name $serviceName -Force
      Write-Host "[+] Serviço '$serviceName' parado." -ForegroundColor Green
  } else {
      Write-Host "[!] Serviço '$serviceName' jÃ¡ estÃ¡ parado." -ForegroundColor Blue
  }

  
  sc.exe config $serviceName start= disabled | Out-Null
  Write-Host "[+] Serviço '$serviceName' desativado com sucesso." -ForegroundColor Green
} else {
  Write-Host "[-] Serviço '$serviceName' não encontrado!" -ForegroundColor Red
}


$umbrellaProcess = Get-Process -Name "acumbrellaagent" -ErrorAction SilentlyContinue
if ($umbrellaProcess) {
  Stop-Process -Id $umbrellaProcess.Id -Force
  Write-Host "[+] Processo acumbrellaagent.exe (PID $($umbrellaProcess.Id)) finalizado." -ForegroundColor Green
} else {
  Write-Host "[!] Processo acumbrellaagent.exe não esta em execução." -ForegroundColor Yellow
}


$dnscrypt = Get-Process -Name "dnscryptproxy" -ErrorAction SilentlyContinue
if ($dnscrypt) {
  Write-Host "[+] dnscryptproxy.exe estÃ¡ em execuÃ§Ã£o (PID $($dnscrypt.Id))." -ForegroundColor Cyan
} else {
  Write-Host "[-] dnscryptproxy.exe nÃ£o encontrado em execuÃ§Ã£o." -ForegroundColor Yellow
}
}
catch [System.Management.Automation.PSSecurityException] {
    
    Write-Host "[-] Erro: A execuÃ§Ã£o de scripts estÃ¡ desabilitada neste sistema."
    Write-Host "[-] Para permitir, execute no PowerShell como administrador:"
    Write-Host "[-] Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
}

	
	

