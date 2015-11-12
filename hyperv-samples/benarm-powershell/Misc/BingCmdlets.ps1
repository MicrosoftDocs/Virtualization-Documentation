Add-Type -Assembly System.Web
$WebClient = New-Object system.Net.WebClient

Function Get-BingCount([string] $Term) {

    # Add plus and quotes, encodes for URL
    $Term = '+"' + $Term + '"'
    $Term = [System.Web.HttpUtility]::UrlEncode($Term)

    # Load the page as a string
    $URL = "http://www.bing.com/search?q=" + $Term
    $Page = $WebClient.DownloadString($URL)

    # searches for the string before the number of hits on the page
    $String1 = '<span class="sb_count">'
    $Index1 = $Page.IndexOf($String1)

    # if found the right string, finds the exact end of the number
    If ($Index1 -ne -1) {
        $Index1 += $String1.Length
        $Index2 = $Page.IndexOf(" ", $Index1)
        $result = $Page.Substring($Index1, $Index2 - $index1)
    } else { $result = "0" }

    # Return the count
    return $result
}

$CmdletList = Get-Command -Module Hyper-V | Select Name
$CmdletCount = $CmdletList.Count -1 
$hashTable = $null
$hashTable = @{}

0..$CmdletCount | % {

    # Tracks progress
    Write-Progress -Activity "Checking cmdlet popularity" -PercentComplete ($_ * 100 / $CmdletCount)

    # Check the popularity with Bing
    $cmdlet = $CmdletList[$_].Name
    $count = [int] (Get-BingCount $cmdlet)

    # Put data in a hashtable
    $hashTable.add($cmdlet, $count)
}

$hashTable.GetEnumerator() | sort value -Descending | select @{N="Cmdlet";E={$_.Name}}, @{N="Popularity";E={$_.Value}}

Write-Progress -Activity "Checking cmdlet popularity" -Completed

# Releases resources used by the web client
$WebClient.Dispose()
