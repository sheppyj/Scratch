#########################################################################
#Quest Release checker
#########################################################################
#Supply a .csv of servers for a Buildtype and this script will compare
#environments for differences. Csv should have the headings;
#Environment|Server|Name|Root
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
function Get-Releases
{
	Param($SiteName, $ServerName, $Environment, $RootDir)
	
	[array]$Releases = Get-ChildItem -Path $RootDir -Filter *.lst | Where-Object { $_.Name -notlike "*bk.lst" } | sort-object
	
	$Obj = New-Object -TypeName PSObject
    $Obj | Add-Member -MemberType Noteproperty -Name 'SiteName' -Value $SiteName
	$Obj | Add-Member -MemberType Noteproperty -Name 'ServerName' -Value $ServerName
    $Obj | Add-Member -MemberType Noteproperty -Name 'Environment' -Value $Environment
	
	ForEach ($Release in $Releases)
    	{
        	$Obj | Add-Member -MemberType Noteproperty -Name $Release -Value 'X' -Force
    	}

	return $Obj
}
#########################################################################
#Script body
#########################################################################
<#Ask for path to csv, import csv#>
$csv = Import-Csv ".\serverlist-template.csv"

<#Make session on servers found in csv, get releases, tie all data together into an object#>
$Credentials = Get-Credential
$ReleaseArray = ForEach ( $line in $csv )
{ 
	$session = make-session $line.Server $Credentials
	Invoke-Command -Session $Session -ScriptBlock ${function:Get-Releases} -ArgumentList $line.Name,$line.Server,$line.Environment,$line.Root
	Remove-PSSession $session
}

<#Get a unique sorted list of every property found from the ReleaseArray (eg 001.lst,002.lst,Environment,servername etc)#>
$Properties = $ReleaseArray | ForEach-Object { $_ | Get-Member -MemberType NoteProperty } | Sort-Object -Descending | Select-Object -ExpandProperty Name -Unique
<#Output to spreadsheet, sort by properties found. Doing this gives NULL values where releases are not found. Exclude any unwanted columns from here#>
$ReleaseArray | Select-Object $Properties -ExcludeProperty RunspaceId,PSShowComputerName,PSComputerName | Export-Csv ???.csv -NoTypeInformation
