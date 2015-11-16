# Pass in script file - array trick from http://powershell.com/cs/forums/t/4169.aspx
function copyTextFileIntoVM([string]$VMName, $cred, [string]$sourceFilePath, [string]$destinationFilePath){
   $content = Get-Content $sourceFilePath
   icm -VMName $VMName  -Credential $cred {param($Script, $file)
         $script | set-content $file} -ArgumentList (,$content), $destinationFilePath}