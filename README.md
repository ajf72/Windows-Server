
# 🖥️ Windows Server Core Automatische Setup

Deze repository bevat een PowerShell-script om een Windows Server Core machine automatisch te configureren, inclusief:

- Naamgeving van de server
- IP-adres en DNS configuratie
- Lid maken van Active Directory domein
- (Optioneel) Installatie van ADDS (Active Directory Domain Services)

## 📁 Bestanden

- `Install-WindowsCore.ps1` – hoofdscript voor configuratie
- `README.md` – deze uitleg

## ⚙️ Voorwaarden

- Windows Server Core 2019/2022
- Netwerktoegang tot domeincontroller
- Domeinaccount met rechten om machines toe te voegen
- Uitvoeringsrechten voor PowerShell-scripts (`Set-ExecutionPolicy RemoteSigned`)

## 🛠️ Scriptuitleg

### Server hernoemen
```powershell
Rename-Computer -NewName "SRV-CORE01" -Force -Restart
```

### IP en DNS instellen
```powershell
New-NetIPAddress -InterfaceIndex 1 -IPAddress 192.168.1.50 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 1 -ServerAddresses 192.168.1.10
```

### Lid maken van domein
```powershell
$secpass = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential("contoso\Administrator", $secpass)
Add-Computer -DomainName "contoso.local" -Credential $creds -OUPath "OU=Servers,DC=contoso,DC=local" -Restart
```

### (Optioneel) Domeincontroller maken
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "contoso.local" -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Force
```

## 🔐 Veiligheid

Sla wachtwoorden niet in platte tekst op in productie! Gebruik beveiligde referentie-opslag of injecteer credentials via een veilige methode.

## 📦 Toepassing

Deze repository is geschikt voor:

- Virtuele labomgevingen (Hyper-V, VMware, Proxmox)
- Automatisering van Windows Server Core deployments
- AD-testomgevingen

---

> Gemaakt voor educatieve doeleinden. Pas aan voor productiegebruik.
