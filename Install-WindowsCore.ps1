
# Install-WindowsCore.ps1
# Automatische configuratie van Windows Server Core

# === Instellingen aanpassen ===
$hostname   = "SRV-CORE01"
$domain     = "contoso.local"
$ouPath     = "OU=Servers,DC=contoso,DC=local"
$domainUser = "Administrator"
$domainPass = "P@ssw0rd"

# === Computer hernoemen ===
Rename-Computer -NewName $hostname -Force -Restart

# === Netwerk instellen (aanpassen indien nodig) ===
$interfaceIndex = 1
New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress 192.168.1.50 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses 192.168.1.10

# === Aanmelden bij domein ===
$secpass = ConvertTo-SecureString $domainPass -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential("$domain\$domainUser", $secpass)
Add-Computer -DomainName $domain -Credential $creds -OUPath $ouPath -Restart

# === (Optioneel) Domeincontroller installeren ===
# Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
# Install-ADDSForest -DomainName $domain -SafeModeAdministratorPassword $secpass -Force
