####################################################################################
#Download all resources from an s3 bucket using powershell
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
$productID = "?????"
$increment = 1
$404Count = 0
$outputLocation = "$env:HOMEDRIVE$env:HOMEPATH/Desktop/$productID/"

if ( !(Test-Path "$outputLocation") )
{
    New-Item  "$outputLocation" -ItemType Directory    
}

Do
    {
        write-host "Getting page $increment" -ForegroundColor Green
        try
        {
            $baseURL = "https://?????.s3.amazonaws.com/$productID/??????/$productID-" + $increment.ToString("000") + ".jpg"
            Download-item -url $baseURL -output "$outputLocation/Page-$increment.jpg"
        } catch
        {
            write-host "error getting $increment!" -ForegroundColor Red
            ++$404Count
        }

    } While
    (
        ++$increment -and $404Count -le 5 
    )