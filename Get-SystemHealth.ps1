# Get-SystemHealth.ps1
# Uso: .\Get-SystemHealth.ps1

Write-Host "=== HEALTHCHECK: $(hostname) ===" -ForegroundColor Cyan
Write-Host "Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# Uptime
Write-Host "== UPTIME ==" -ForegroundColor Yellow
$uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
Write-Host "Ligado há: $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"
Write-Host ""

# CPU
Write-Host "== CPU ==" -ForegroundColor Yellow
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
Write-Host "Cores: $($cpu.NumberOfCores) | Threads: $($cpu.NumberOfLogicalProcessors)"
$cpuUsage = (Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor | Where-Object Name -eq "_Total").PercentProcessorTime
Write-Host "Uso: $cpuUsage%"
Write-Host ""

# Memória
Write-Host "== MEMÓRIA ==" -ForegroundColor Yellow
$mem = Get-CimInstance Win32_OperatingSystem
$totalMem = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 2)
$freeMem = [math]::Round($mem.FreePhysicalMemory / 1MB, 2)
$usedMem = $totalMem - $freeMem
$memPercent = [math]::Round(($usedMem / $totalMem) * 100, 2)
Write-Host "Total: ${totalMem}GB | Usado: ${usedMem}GB ($memPercent%) | Livre: ${freeMem}GB"
Write-Host ""

# Disco
Write-Host "== DISCO ==" -ForegroundColor Yellow
Get-Volume | Where-Object {$_.DriveType -eq 'Fixed'} | ForEach-Object {
    $percentUsed = [math]::Round(($_.SizeRemaining / $_.Size) * 100, 2)
    $percentUsed = 100 - $percentUsed
    Write-Host "$($_.DriveLetter): $percentUsed% usado (Livre: $([math]::Round($_.SizeRemaining / 1GB, 2))GB)"
}
Write-Host ""

# Rede
Write-Host "== REDE ==" -ForegroundColor Yellow
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"} | ForEach-Object {
    Write-Host "$($_.InterfaceAlias): $($_.IPAddress)"
}
Write-Host ""

# Serviços críticos
Write-Host "== SERVIÇOS CRÍTICOS ==" -ForegroundColor Yellow
$services = @('Winlogon', 'RpcSs', 'Dhcp', 'DNS')
foreach ($svc in $services) {
    $status = (Get-Service -Name $svc -ErrorAction SilentlyContinue).Status
    if ($status) {
        $color = if ($status -eq 'Running') { 'Green' } else { 'Red' }
        Write-Host "$svc : $status" -ForegroundColor $color
    }
}
