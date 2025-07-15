# Parameter festlegen
$fixedIP = "192.168.2.60"
$netmask = "255.255.255.0"
$targetMac = "84:BA:59:49:F4:3A"

# Im Windows-Format werden oft Bindestriche verwendet, also ersetzen wir Doppelpunkte durch Bindestriche
$targetMacWin = $targetMac -replace ":", "-"

# Suche den Netzwerkadapter anhand der MAC-Adresse
$adapter = Get-NetAdapter | Where-Object { $_.MacAddress -eq $targetMacWin }
if ($null -eq $adapter) {
    Write-Host "Kein Netzwerkadapter mit MAC $targetMac gefunden!"
    exit 1
}

$interfaceAlias = $adapter.InterfaceAlias
Write-Host "Gefundenes Interface:" $interfaceAlias

# Prüfen, ob die feste IP bereits aktiv reagiert (via Ping-Test)
Write-Host "Pruefe, ob IP $fixedIP bereits in Verwendung ist..."
if (Test-Connection -ComputerName $fixedIP -Count 2 -Quiet) {
    Write-Host "IP $fixedIP scheint bereits aktiv zu sein."
    Write-Host "Wechsle zu DHCP..."
    
    # Umschalten auf DHCP (verwendet das netsh-Kommando)
    netsh interface ip set address name="$interfaceAlias" source=dhcp
    
    Write-Host "DHCP-Konfiguration aktiviert."
}
else {
    Write-Host "IP $fixedIP ist nicht in Benutzung."
    Write-Host "Weise statische IP zu..."
    
    # Setzt die statische IP ohne (nebenbei) ein Gateway anzugeben.
    # Falls ein Default Gateway erforderlich ist, kann z. B. folgender Befehl verwendet werden:
    # netsh interface ip set address name="$interfaceAlias" static 192.168.2.50 255.255.255.0 192.168.2.1
    netsh interface ip set address name="$interfaceAlias" static $fixedIP $netmask
    
    Write-Host "Statische IP-Konfiguration erfolgreich angewendet."
}