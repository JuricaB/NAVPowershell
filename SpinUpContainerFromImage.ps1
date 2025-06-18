# get SourcePath - exit if blank
$ContainerName = Read-Host "`n Container name, or ENTER to exit (same name will be used for ADMIN password) "    

if($ContainerName -eq "") {
    Write-Host "Don't give up! You can do it!"
    exit
}

 $dockerService = (Get-Service docker -ErrorAction Ignore)
    if (!($dockerService)) {
        throw "Docker Service not found. Docker is not started, not installed or not running Windows Containers."
    }

    if ($dockerService.Status -ne "Running") {
        throw "Docker Service is $($dockerService.Status) (Needs to be running)"
    }

    $dockerVersion = docker version -f "{{.Server.Os}}/{{.Client.Version}}/{{.Server.Version}}"
    $dockerOS = $dockerVersion.Split('/')[0]
    $dockerClientVersion = $dockerVersion.Split('/')[1]
    $dockerServerVersion = $dockerVersion.Split('/')[2]

    if ("$dockerOS" -eq "") {
        throw "Docker service is not yet ready."
    }
    elseif ($dockerOS -ne "Windows") {
        throw "Docker is running $dockerOS containers, you need to switch to Windows containers."
   	}
 Write-Host "Docker Client Version is $dockerClientVersion"
 Write-Host "Docker Server Version is $dockerServerVersion"

$allImages = @(docker images --format "{{.Repository}}:{{.Tag}}")
#Write-Host $allImages

#exit #TEST END

foreach ($Image in $allImages)
    {
    '{0} - {1}' -f ($allImages.IndexOf($Image) + 1), $Image
    }

$Choice = ''
while ([string]::IsNullOrEmpty($Choice))
    {
    Write-Host
    $Choice = Read-Host 'Please choose an image by number '
    if ($Choice -notin 1..$allImages.Count)
        {
        [console]::Beep(1000, 300)
        Write-Warning ''
        Write-Warning ('    Your choice [ {0} ] is not valid.' -f $Choice)
        Write-Warning ('        The valid choices are 1 thru {0}.' -f $allImages.Count)
        Write-Warning '        Please try again ...'
        pause

        $Choice = ''
        }
    }

''
'You chose {0}' -f $allImages[$Choice - 1]


Write-Host 'Select license (MUST use BCLICENSE file for v22 or later):'
#default to OneDrive NAVLauncher folder
$DefDir = [System.Environment]::GetEnvironmentVariable('OneDriveCommercial')
$DefDir = $DefDir + '\NAV Launcher\NAV\Other'

#fall back to NAVLauncher folder on C disk
if ((Test-Path -Path $DefDir) -eq 0){
$DefDir = 'C:\NAV\Other\'
}

#fall back to NAVLauncher folder in user profile
if ((Test-Path -Path $DefDir) -eq 0){
    $DefDir = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile) 
    $DefDir = $DefDir + '\NAV\Other\'
}

#fall back to Desktop (e.g. user needs to figure out where the license is!)
if ((Test-Path -Path $DefDir) -eq 0){
    $DefDir = [System.Environment]::GetFolderPath('Desktop')
}

#File open dialog, defaults to BC License and allows FLF
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = $DefDir
    Filter = 'BC License file (*.bclicense)|*.bclicense|License (*.flf)|*.flf'
}
$null = $FileBrowser.ShowDialog()

$licenseFile = $FileBrowser.FileName
if ((Test-Path -Path $LicenseFile -PathType Leaf) -eq 0){
    Write-Host "You must select a license - this is not valid" 
    EXIT
}
Write-Host 'License selected: ' $licenseFile

#Set password for ADMIN user to be same as container name
$password = $containerName
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
New-BcContainer `
    -accept_eula `
    -shortcuts Desktop `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -isolation HyperV `
    -imageName $allImages[$Choice - 1] `
    -assignPremiumPlan `
    -licenseFile $licenseFile `
    -updateHosts `
    -includeAL #`
    #-includeTestToolkit 
    #-vsixFile (Get-LatestAlLanguageExtensionUrl)