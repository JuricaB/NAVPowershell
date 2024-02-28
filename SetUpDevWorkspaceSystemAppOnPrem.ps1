### Extracts the source code from the container saved to BCArtifacts.Cache folder into C:\ProgramData\BcContainerHelper\Extensions\Original folder, 
### and sets up workspace for AL Prism which includes Base App and  System App

### must have docker and BCContainerHelper installed


Write-Host "Setting up AL development workspace"
Write-Host "Getting BC version from docker container..."
$allcontainers = @(docker container ls --format "{{.Names}}")

foreach ($container in $allcontainers)
    {
    '{0} - {1}' -f ($allcontainers.IndexOf($container) + 1), $container
    }

$Choice = ''
while ([string]::IsNullOrEmpty($Choice))
    {
    Write-Host
    $Choice = Read-Host 'Please choose an image by number '
    if ($Choice -notin 1..$allcontainers.Count)
        {
        [console]::Beep(1000, 300)
        Write-Warning ''
        Write-Warning ('    Your choice [ {0} ] is not valid.' -f $Choice)
        Write-Warning ('        The valid choices are 1 thru {0}.' -f $allcontainers.Count)
        Write-Warning '        Please try again ...'
        pause

        $Choice = ''
        }
    }

''
'You chose {0}' -f $allcontainers[$Choice - 1]

$Version = Get-BcContainerNavVersion -containerOrImageName $allcontainers[$Choice - 1]

$AppFolder = 'C:\ProgramData\BcContainerHelper\Extensions\Original-' + $Version + '-al\'
if (Test-Path -Path $AppFolder) {
    Write-Host "Application Folder : $AppFolder"
} else {
    Write-Host "Application Folder : $AppFolder does not exist!"
    exit
}
$SourceFile = $AppFolder + 'SystemBaseAndTests.code-workspace'
$TargetFile = $AppFolder + 'SystemAppsBaseAndTests.code-workspace'

if (Test-Path -Path $TargetFile) {
    Write-Host "AL Development workspace already configured: $TargetFile"
    exit
}

Copy-Item $SourceFile -Destination $TargetFile

#add folder to JSON file-start
$WorkspaceConfigsPath = $AppFolder + 'SystemAppsBaseAndTests.code-workspace'
$WorkspaceFolders = Get-Content $WorkspaceConfigsPath -raw | ConvertFrom-Json
[System.Collections.ArrayList]$WorkspaceFolder = $WorkspaceFolders.folders
$WorkspaceFolder.Add(@{
                        name = "System Application"
                        path = ".\Modules\System Application"            
                    }) > $null
$WorkspaceFolders.folders = $WorkspaceFolder;

$WorkspaceFolders | ConvertTo-Json | Set-Content $WorkspaceConfigsPath -NoNewline
#add folder to JSON file-end

[System.IO.Directory]::CreateDirectory($AppFolder + 'Modules\System Application\')

#$Version = $Version.Replace("-NZ", '')

$PlatformFolder = 'C:\bcartifacts.cache\onprem\21.4.52563.52785\platform\Applications\system application\source\'
$PlatformZip = $PlatformFolder + 'System Application.Source.zip'
if (Test-Path -Path $PlatformZip) {
    Write-Host "Platform ZIP File : $PlatformZip"
} else {
    Write-Host "Platform ZIP File : $PlatformZip does not exist!"
    exit
}

#unzip file from 
#  C:\bcartifacts.cache\onprem\xx.x.xxxxx.0\platform\Applications\system application\source\System Application.Source.zip 
#to 
#  C:\ProgramData\BcContainerHelper\Extensions\Original-xx.x.xxxxx.0-NZ-al\Modules\System Application\
$TargetPath = $AppFolder + 'Modules\System Application\'
Expand-Archive $PlatformZip -DestinationPath $TargetPath -Force

Write-Host "Workspace setup complete!"
Write-Host "For complete coverage, open System.app package from Prism once, then tick Search Package Cache in Prism control panel before opening workspace"
Write-Host "Workspace file: $TargetFile"