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

$ImageName = 'alworkspace'
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


#Set password for ADMIN user to be same as container name
$password = $containerName
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'

$DefDir = 'C:\NAV\Other\'
if ((Test-Path -Path $DefDir) -eq 0){
    $DefDir = [Environment]::GetFolderPath('Desktop')
}
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = $DefDir
    Filter = 'License (*.flf)|*.flf'
}
$null = $FileBrowser.ShowDialog()

$licenseFile = $FileBrowser.FileName
if ((Test-Path -Path $LicenseFile -PathType Leaf) -eq 0){
    Write-Host "You must select a license - this is not valid" 
    EXIT
}

New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -isolation Process `
    -credential $credential `
    -auth $auth `
    -imageName $allImages[$Choice - 1] `
    -assignPremiumPlan `
    -licenseFile $licenseFile `
    -includeAL `
    -vsixFile (Get-LatestAlLanguageExtensionUrl) `
    -updateHosts `
    -includeTestToolkit
