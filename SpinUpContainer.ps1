# get SourcePath - exit if blank
$ContainerName = Read-Host "`n Container name, or ENTER to exit (same name will be used for ADMIN password) "    

if($ContainerName -eq "") {
    Write-Host "Don't give up! You can do it!"
    exit
}

do {
$ContainerType = Read-Host "`n Sandbox (S) or Onprem (O)  "    
}
until (($ContainerType -eq "S") -or ($ContainerType -eq "O"))

if ($ContainerType -eq "S"){
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


$Country = "nz"

#Set password for ADMIN user to be same as container name
$password = $containerName
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
if ($Version -eq ""){
    $artifactUrl = Get-BcArtifactUrl -type $ContainerType -country $Country -select $Select
}
else {
    $artifactUrl = Get-BcArtifactUrl -type $ContainerType -country $Country -select $Select -version $Version
}
Write-Host $artifactUrl



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
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName 'myimage' `
    -assignPremiumPlan `
    -licenseFile $licenseFile `
    -includeAL `
    -vsixFile (Get-LatestAlLanguageExtensionUrl) `
    -updateHosts `
    -includeTestToolkit