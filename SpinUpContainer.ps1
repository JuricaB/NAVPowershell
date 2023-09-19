#Change country code here if you need different one
$Country = "nz"

# get SourcePath - exit if blank
$ContainerName = Read-Host "`n Container name, or ENTER to exit (same name will be used for ADMIN password) "    

if($ContainerName -eq "") {
    Write-Host "Don't give up! You can do it!"
    exit
}

do {
$ContainerSelection = Read-Host "`n Sandbox (S) or Onprem (O) or Preview (P)"    
}
until (($ContainerSelection -eq "S") -or ($ContainerSelection -eq "O") -or ($ContainerSelection -eq "P"))

if (($ContainerSelection -eq "S") -or ($ContainerSelection -eq "P")){
$ContainerType = "Sandbox"
} else {
$ContainerType = "OnPrem"
}


$Version = Read-Host "`n Version (specific version or ENTER for latest)  "    

if ($Version -eq "")
{
$Select = 'Latest'
}
else
{
$Select = 'Closest'
}

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
if ($Version -eq ""){    
    if ($ContainerSelection -eq "P") {    
        $artifactUrl = Get-BcArtifactUrl -country $Country -storageAccount 'BCPublicPreview'
    }
    else{
        $artifactUrl = Get-BcArtifactUrl -type $ContainerType -country $Country -select $Select    
    }
}
else {
    if ($ContainerSelection -eq "P") {    
        $artifactUrl = Get-BcArtifactUrl -country $Country -version $Version -storageAccount 'BCPublicPreview'
    }
    else{
        $artifactUrl = Get-BcArtifactUrl -type $ContainerType -country $Country -select $Select -version $Version
    }
}
Write-Host 'Artifact URL: ' $artifactUrl

New-BcContainer `
    -accept_eula `
    -shortcuts None `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -isolation process `
    -imageName 'myimage' `
    -assignPremiumPlan `
    -licenseFile $licenseFile `
    -includeAL `
    -vsixFile (Get-LatestAlLanguageExtensionUrl) `
    -updateHosts `
    -includeTestToolkit #'
    #-includeCSide #only for BC14 or older