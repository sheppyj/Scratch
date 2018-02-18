####################################################################################
#Download all elements from website using powershell
#
####################################################################################

####################################################################################
#function region
####################################################################################
#download image to location eg www.test.com/test.png to C:\temp\test.png
function Download-Item 
{
    param(
        [STRING]$url,
        [STRING]$output
    )
    (New-Object System.Net.WebClient).DownloadFile($url, $output)
}#end function Download-Item

####################################################################################
#Script Body region
####################################################################################
[STRING]$bookResourceID = "?????"
[INT]$module = ??????
[INT]$resource = ?????
[INT]$maxModuleNumber = ?????
$404Count = 0
$outputLocation = "$env:HOMEDRIVE$env:HOMEPATH/Desktop/$bookResourceID/"

if ( !(Test-Path "$outputLocation") )
{
    New-Item  "$outputLocation" -ItemType Directory    
}

Do
{
    Do
    {
        [STRING]$url = "https://??????.com/$bookResourceID/" + $module.ToString("000000") + "/" + $resource.ToString("00000000") + "/temp.png"
        write-host "Getting; $url" -ForegroundColor Green
        if ( !(Test-Path "$outputLocation\$module") )
        {
            New-Item  "$outputLocation\$module" -ItemType Directory    
        }
        try 
        {
            Download-item -url $url -output "$outputLocation\$module\Element-$resource.png"
        } catch 
        {
            write-host "error getting $resource!" -ForegroundColor Red
            ++$404Count
        }
    } while
    ( 
        ++$resource -le 999999 -and $404Count -le 10 
    )

$404Count = 0
$resource = $resource - 11
} while
(
    ++$module -le $maxModuleNumber
)