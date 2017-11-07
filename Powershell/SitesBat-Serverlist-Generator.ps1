#########################################################################
#Sites.bat Serverlist Generator
#########################################################################
#Supply a .csv of servers and environments, this script will generate 
#a spreadsheet of all sites on servers by stripping data out of sites.bat
#supplied csv should have;
#Environment|Server
#This requires your $ account for access to each Quest server
#########################################################################

#########################################################################
#Function to make a session on the server
#########################################################################
function make-session 
{	
	Param($ServerName, $Credentials)
	Write-Host "Creating session on $ServerName"
	$Session = New-PSSession -ComputerName $ServerName -Credential $Credentials
    Return $Session
}
#########################################################################
#Function to create custom objects so all useful data tied together
#########################################################################
function Get-SitesBat
{
	Param($ServerName, $Environment)
	
    <#example sites.bat #>
    <#Call sitep %1 QSTDSVH JS 50000 JP Jack_Surveyors #>
    <#strip relevant fields out of sites.bat #>
    [array]$SitesArray = ForEach ( $Line in ( Get-Content C:\Apps\Sites.bat | where { $_ -match '^call.*'} ) )
    {

        $split = $line.Split(" ")
		$syncCode = $split[4]
		$syncId = $split[6]
		$Name = $split[7]

        $Obj = New-Object -TypeName PSObject
        $Obj | Add-Member -MemberType Noteproperty -Name 'Server' -Value $ServerName
        $Obj | Add-Member -MemberType Noteproperty -Name 'Environment' -Value $Environment
        $Obj | Add-Member -MemberType Noteproperty -Name 'Name' -Value $Name
        $Obj | Add-Member -MemberType Noteproperty -Name 'Root' -Value "C:\sites\$syncCode\$syncId\"

        $obj

    }

    return $SitesArray
}
#########################################################################
#Script body
#########################################################################
<#Ask for path to csv, import csv#>
$csv = Import-Csv ".\serverlist-sitesbat-template.csv"

<#Make session on servers found in csv, tie all data together into an object#>
$Credentials = Get-Credential
$SitesBatArray = ForEach ( $line in $csv )
{ 
	$session = make-session $line.Server $Credentials
	Invoke-Command -Session $Session -ScriptBlock ${function:Get-SitesBat} -ArgumentList $line.Server,$line.Environment
	Remove-PSSession $session
}

$Properties = $SitesBatArray | ForEach-Object { $_ | Get-Member -MemberType NoteProperty } | Sort-Object -Descending | Select-Object -ExpandProperty Name -Unique
$SitesBatArray | Select-Object $Properties -ExcludeProperty RunspaceId,PSShowComputerName,PSComputerName | Export-Csv -Path .\ServerList-QSTDSVH.csv -NoTypeInformation