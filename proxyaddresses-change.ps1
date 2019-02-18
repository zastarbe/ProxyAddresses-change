

$Domains = "domeinu1.es","domeinu1.net"
$userou = "OU=Empleados,OU=Usuarios,DC=enpresa,DC=es"
$users = Get-ADUser -Filter * -SearchBase $userou -Properties proxyAddresses

write-host "OU: "$userou
write-host "Erabiltzaile guztiak: "$users
Read-Host -Prompt "ENTER jarraitzeko"

foreach ($user in $users) {
	$addressesToRemove = @($user.proxyAddresses) 
	write-host "Erabiltzailea: "$user
	write-host "Ezabatzeko helbideak: "$addressesToRemove.Count
	write-host $user.proxyAddresses
	Read-Host -Prompt "ENTER jarraitzeko"

	# proxy helbideak baditu, ezabatu
    if ($addressesToRemove.Count -gt 0)
		{
	#   Set-ADUser $user -remove @{proxyAddresses="$addressesToRemove"}
		Set-ADUSER $user -clear proxyAddresses
        }
}


# GEHITU PROXY HELBIDE BERRIAK
write-host "Orain Proxy helbide guztiak gehitu"
Read-Host -Prompt "ENTER jarraitzeko"

Get-ADuser -Filter *  -SearchBase $userou -properties mail | foreach-object {
    $Proxies = @("SMTP:$($_.mail)")
    $Proxies += foreach ($Domain in $Domains)
    {
        "smtp:$($_.sAMAccountName)@$Domain"
    }

    $_ | Set-ADuser -Replace @{ProxyAddresses = $Proxies}
}





