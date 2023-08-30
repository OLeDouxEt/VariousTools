$Browser = 'msedge'
$Link_List = "https://urlhaus.abuse.ch/downloads/text/"


<#
.DESCRIPTION
Function to retrieve list of malicious URLS from Abuse.ch's URL Haus text only
list of URLs. This function will return the links as a list minus any lines that
begins with the '#' symbol.
#>
Function Get-MaliciousLinks {
    Param(
        [String]$Link
    )
    $mal_Urls = New-Object System.Collections.Generic.List[System.Object]
    $res = Invoke-WebRequest -Uri $Link
    $raw_List = $res.Content.Split([string[]]"`r`n",[StringSplitOptions]::None)
    foreach($url in $raw_List){
        if($url[0] -ne '#'){
            $mal_Urls.Add($url)
        }
    }
    Return $mal_Urls
}

$Urls = Get-MaliciousLinks -Link $Link_List
# Opening up Edge
Start-Process -FilePath $Browser -ArgumentList '--new-window'
# Opening a new tab in with a link from the 'Urls' list, but limiting
# the amount as to not open up too many tabs and utilize too many resources.
for($i=0;$i -lt 20; $i++){
    Start-Process -FilePath $Browser -ArgumentList "--no-new-window $($Urls[$i])"
    Start-Sleep -Seconds 5
}

# If you want to open them all...
<#
foreach($link in $Urls){
    Start-Process -FilePath $Browser -ArgumentList "--no-new-window $link"
    Start-Sleep -Seconds 5
}
#>