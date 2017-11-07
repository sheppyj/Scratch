####################################################################################
#AddVariablesToTenants.ps1
#
#This script will apply a variable to a tenant in octopus
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

Function AddVariablesToTenants #AddVariablesToTenants -SyncID "STD/QX*JS" -Customer "Jack_Surveyors" -Environment "UAT"
{
    Param(
        [STRING]$SyncID,
        [STRING]$Customer,
        [STRING]$Environment
    ) #end param

    $Tenant = $repository.Tenants.FindByName("$Customer")
    #I know the environment name but I need to find Octopus ID for it so that I can use it to associate Variable with environment
    $EnvName = ($repository.Environments.FindAll().Where( { $_.Name -eq "$Environment"} )).ID
    $TenantVariableProperty = $repository.Tenants.GetVariables($Tenant)
    $VariableAddPropery= "$SyncID"
    $TemplateID = $TenantVariableProperty.ProjectVariables.Values.Templates.ID
    #Using environment name that was mentioned above
    $projectVariables = $TenantVariableProperty.ProjectVariables.Values.Variables."$EnvName"
    $projectVariables.Add($TemplateID, $VariableAddPropery)
    $repository.Tenants.ModifyVariables($Tenant, $TenantVariableProperty)

}#end function AddVariablesToTenants