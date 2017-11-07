####################################################################################
#AddOctopusTenants.ps1
#
#This script will create Tenants in octopus
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

#Adds Tenant to Octopus
Function AddOctopusTenant #AddOctopusTenant -Customer "Jack_Surveyors" -Environment "TST"
{
    Param(
        [STRING]$Customer,
        [STRING]$Environment
    ) #end param

    #Doing the below returns me an array of environments currently associated with the tenant, I then append the environment I want to add
    #so that I recreate the tenant with an array of environments
    #This is because the .add function doesn't appear to work how I want it to as it appears to wipe the environments completely
    $CurrentTenantEnvironments = $repository.Tenants.FindByName($Customer).ProjectEnvironments.Values
    [ARRAY]$EnvironmentArray = $repository.Environments.FindAll().Where( { $_.Name -eq "$Environment"} )
    Foreach ( $Addition in $CurrentTenantEnvironments )
    {
        
        [ARRAY]$EnvironmentArray += $repository.Environments.FindAll().Where( { $_.ID -eq "$Addition"} )

    }
    $project = $repository.Projects.FindByName("$DeployProjectName")
    $tenantEditor = $repository.Tenants.CreateOrModify("$Customer")
    $tenantEditor.ConnectToProjectAndEnvironments($project, $EnvironmentArray)
    $tenantEditor.Save()

}#end function AddOctopusTenant