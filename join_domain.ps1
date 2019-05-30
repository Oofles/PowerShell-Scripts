# Grab the MAC Address and establish a unique computer name based on MAC
$mac = (Get-WmiObject win32_networkadapterconfiguration -filter 'ipenabled = "true"').MACAddress
$newMac = $mac.Substring(9,8) -replace ':',"-"
$newName = "Windows-$newMac"

# Sets the domain name and prompts for credentials
$domain = "domain.local"
$username = "$domain\domainadmin"
$password = Read-Host -Prompt "Ender password for $username" -AsSecureString
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

# Finally joins the computer to the domain with a new name and forces restart
Add-Computer -DomainName $domain -NewName $newName -Credential $credential -Restart
