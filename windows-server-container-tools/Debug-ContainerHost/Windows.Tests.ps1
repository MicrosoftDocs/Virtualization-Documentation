Describe "Windows Version and Prerequisites" {
    $buildNumber = (Get-CimInstance -Namespace root\cimv2 Win32_OperatingSystem).BuildNumber
    It "Is Windows 10 Anniversary Update or Windows Server 2016" {
        $buildNumber -ge 14393 | Should Be $true
    }
    It "Has KB3192366 installed if running Windows build 14393" {
        if ($buildNumber -eq 14393)
        {
            Get-CimInstance -n root\cimv2 -Query "SELECT * FROM Win32_QuickFixEngineering WHERE HotFixID = 'KB3192366'" | Should Not Be $null
        }
    }
    It "Is not a build with blocking issues" {
        $buildNumber | Should Not Be 1 # TODO: Placeholder, not a bad build
        $buildNumber | Should Not Be 2 # TODO: Placeholder, not a bad build
    }
    # TODO Add test for supported host SKUs
}

Describe "Windows container settings are correct" {
     It "Do not have DisableVSmbOplock set" {
         $regvalues = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Containers"
         ($regvalues | Get-Member VSmbDisableOplocks | Measure-Object).Count | Should Be 0
     }
     It "Do not have zz values set" {
         $regvalues = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Containers"
         ($regvalues | Get-Member zz* | Measure-Object).Count | Should Be 0
     }
 }