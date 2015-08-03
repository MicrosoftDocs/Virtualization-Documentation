# Seperate file for variables - this when you pull down the latest factory file you can keep your paths / product keys etc...
$workingDir = "C:\FactoryTest"
$logFile = "$($workingDir)\Share\Details.csv"
$factoryVMName = "Factory VM"
$virtualSwitchName = "Virtual Switch"
$ResourceDirectory = "$($workingDir)\Resources\Bits" 
$Organization = "The Power Elite"
$Owner = "Ben Armstrong"
$Timezone = "Pacific Standard Time"
$adminPassword = "P@ssw0rd"
$userPassword = "P@ssw0rd"

# Keys
$Windows10Key = ""
$Windows81Key = ""
$Windows2012R2Key = ""
$Windows8Key = ""
$Windows2012Key = ""

# ISOs /  WIMs
$2012Image = "$($workingDir)\ISOs\en_windows_server_2012_x64_dvd_915478.wim"
$2012R2Image = "$($workingDir)\ISOs\en_windows_server_2012_r2_x64_dvd_2707946.wim"
$8x86Image = "$($workingDir)\ISOs\en_windows_8_x86_dvd_915417.wim"
$8x64Image = "$($workingDir)\ISOs\en_windows_8_x64_dvd_915440.wim"
$81x86Image = "$($workingDir)\ISOs\en_windows_8_1_x86_dvd_2707392.wim"
$81x64Image = "$($workingDir)\ISOs\en_windows_8_1_x64_dvd_2707217.wim"
$10x86Image = "$($workingDir)\ISOs\en_windows_10_multiple_editions_x86_dvd_6848465.wim"
$10x64Image = "$($workingDir)\ISOs\en_windows_10_multiple_editions_x64_dvd_6846432.wim"