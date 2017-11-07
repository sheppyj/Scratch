####################################################################################
#RemoveTenantFromOctopus.ps1
#
#This script will remove a tenant from octopus (need to removed from associated machines first!)
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

function RemoveTenantFromOctopus #RemoveTenantFromOctopus -Customer "Jack_Surveyors"
{
    Param(
        [STRING]$Customer
    ) #end param


$TenantEditor = $repository.Tenants.CreateOrModify($Customer)
$TenantEditor.ClearTags()
$TenantEditor.Save()

$Tenant = $repository.Tenants.FindByName($Customer)
$repository.Tenants.Delete($Tenant)

}#end function RemoveTenanFromOctopus