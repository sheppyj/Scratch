####################################################################################
#AddTenantToMachine.ps1
#
#This script will pin a Tenant to a machine
#
####################################################################################

#import resources
Add-Type -Path ".\Octopus.Client.dll" #for client.dll

#Create endpoint for http calls
[STRING]$apikey = 'API-XXXXXXXXXXXXXXXXXXX' #my api key
[STRING]$octopusURI = 'https://XXXXXXXXXXXXXXXXXXX' #octopus address
$endpoint = New-Object Octopus.Client.OctopusServerEndpoint $octopusURI, $apiKey #create endpoint
$repository = New-Object Octopus.Client.OctopusRepository $endpoint #get info

#What projects to add tenants to
[STRING]$TagSetName = "XXXXXXXXXXXXXXX" #Tagset, make sorting easier
[STRING]$DeployProjectName = "XXXXXXXXXXXXXXXXXXX" #Deployment project to associate tenants to

Function AddTenantToMachine #AddTenantToMachine -Computer "QUTESTSERVER01" -Customer "Jack_Surveyors"
{
    Param(
        [STRING]$Computer,
        [STRING]$Customer
    ) #end param

$machine = $repository.Machines.FindByName($Computer)
$Tenant = $repository.Tenants.FindByName($Customer)
$machine.AddOrUpdateTenants($Tenant)
$repository.Machines.Modify($machine)

}#end function AddTenantToMachine