####################################################################################
#AddTenantTags.ps1
#
#This script will add a tag to a tenant
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

Function AddTenantTags #AddTenantTags -Customer "Jack_Surveyors" -environment "UAT"
{
    Param(
        [STRING]$Customer,
        [STRING]$Environment
    ) #end param

    $tagset = $repository.TagSets.FindByName("$TagSetName").Tags
    $Tenant = $repository.Tenants.FindByName($Customer)
    $TenantEditor = $repository.Tenants.CreateOrModify($Customer)
    
    #Doing this so I can append a new Tag even if the Tenant has been tagged before EG UAT
    ForEach ( $Tag in $tagset )
    {
        If ( $Tag.Name -eq $Environment.ToUpper() )
            {
                $TenantEditor.WithTag($Tag)
                $TenantEditor.Save()
            }
    }

}#end function AddTenantTags