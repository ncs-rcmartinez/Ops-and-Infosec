#Set the variable search term for the services after "-like"
$Service = Get-WmiObject Win32_service | Where-Object {$_.name -like "bws*"}

#Set the startup mode and account to logon as
$Service.change($null,$null,$null,$null,"Automatic",$null,"NT AUTHORITY\NETWORK SERVICE","")
Foreach ($service in $Service) {
    sc.exe failure $service.name reset= 0 actions= restart/5000
}
