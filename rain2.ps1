$banner = @'
               R A I N - V 2 
, // ,,/ ,.// ,/ ,// / /, // ,/, /, // ,/,
/, // ,/,_|_// ,/ ,, ,/, // ,/ /, //, /,/
 /, /,.-'   '-. ,// ////, // ,/,/, // ///
, ,/,/         \ // ,,///, // ,/,/, // ,
,/ , ^^^^^|^^^^^ ,// ///  /,,/,/, ///, //
 / //     |  O    , // ,/, //, ///, // ,/
,/ ,,     J\/|\_ ,///, // ,/, , / /// /  , 
 /,/         |   || ,/,/, ///, / / /, ,  /
/ /,,       /|    . ,  ///, . /, // ,//, /
, /         \ \    ). //, ,( ,/,/, // ,/,
WHY KEEP RAINING?               By:x57
'@


$serviceNames = @("csc_umbrellaagent", "csc_swgagent")

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

foreach ($serviceName in $serviceNames) {
    try {
        $service = Get-Service -Name $serviceName -ErrorAction Stop

        if ($service.Status -ne "Stopped") {
            Stop-Service -Name $serviceName -Force -ErrorAction Stop
            Write-Host "[+] Serviço '$serviceName' parado." -ForegroundColor Green
        } else {
            Write-Host "[!] Serviço '$serviceName' já está parado." -ForegroundColor Blue
        }

        sc.exe config $serviceName start= disabled | Out-Null
        Write-Host "[+] Serviço '$serviceName' desativado com sucesso." -ForegroundColor Green
    }
    catch {
        Write-Host "[-] Serviço '$serviceName' não encontrado ou erro: $_" -ForegroundColor Red
    }
}

try {
    $umbrellaProcesses = Get-Process -Name "acumbrellaagent" -ErrorAction SilentlyContinue

    if ($umbrellaProcesses) {
        foreach ($proc in $umbrellaProcesses) {
            Stop-Process -Id $proc.Id -Force
            Write-Host "[+] Processo acumbrellaagent.exe (PID $($proc.Id)) finalizado." -ForegroundColor Green
        }
    } else {
        Write-Host "[!] Processo acumbrellaagent.exe não está em execução." -ForegroundColor Yellow
    }

    $dnscrypt = Get-Process -Name "dnscryptproxy" -ErrorAction SilentlyContinue

    if ($dnscrypt) {
        Write-Host "[+] dnscryptproxy.exe está em execução (PID $($dnscrypt.Id))." -ForegroundColor Cyan
    } else {
        Write-Host "[-] dnscryptproxy.exe não encontrado em execução." -ForegroundColor Yellow
    }
}
catch [System.Management.Automation.PSSecurityException] {
    Write-Host "[-] Erro: A execução de scripts está desabilitada neste sistema."
    Write-Host "[-] Execute:"
    Write-Host "[-] Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
}


