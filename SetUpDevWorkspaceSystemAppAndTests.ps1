### Extracts the source code from the container saved to BCArtifacts.Cache folder into C:\ProgramData\BcContainerHelper\Extensions\Original folder, 
### and sets up workspace for AL Prism which includes Base App, System App, and all MS TEST apps

### must have docker and BCContainerHelper installed

function UnzipFolder {
param(
[Parameter (Mandatory = $false)] $Version,
[Parameter (Mandatory = $false)] [String]$SourceFolder,
[Parameter (Mandatory = $false)] [String]$AppFolder,
[Parameter (Mandatory = $false)] [String]$Filter
)
    $TargetPath = $AppFolder + 'Modules\' + $Filter + '\'    
    $FullFilter = '*' + $Filter + '*.Source.zip'    #added prefix filter to cover for _Exclude apps
    $files = Get-ChildItem $SourceFolder -Filter $FullFilter
    $files | ForEach-Object -Process {    
        $filename = $_.BaseName
        $filename = $filename -replace '.Source',''
        $TempTargetPath = $TargetPath + $filename
        $TempSourcePath = $_.FullName
        Expand-Archive $TempSourcePath -DestinationPath $TempTargetPath -Force
        $WorkspaceFolder.Add(@{
            name = $filename
            path = '.\Modules\'+ $Filter + '\' + $filename
        }) > $null
}
}

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

Write-Host 'You chose:' $allcontainers[$Choice - 1]

$Version = Get-BcContainerNavVersion -containerOrImageName $allcontainers[$Choice - 1]

Write-Host "BC Version: $Version" -ForegroundColor Green

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

#Open JSON file to add folder-start
$WorkspaceConfigsPath = $AppFolder + 'SystemAppsBaseAndTests.code-workspace'
$WorkspaceFolders = Get-Content $WorkspaceConfigsPath -raw | ConvertFrom-Json
[System.Collections.ArrayList]$WorkspaceFolder = $WorkspaceFolders.folders
#Open JSON file to add folder-end

#unzip the NZ-specific files
$Version = $Version.Replace("-NZ", '')

$SourceFolder = 'C:\bcartifacts.cache\sandbox\' + $Version + '\nz\Applications.NZ'

UnzipFolder -Version $Version -SourceFolder $SourceFolder -AppFolder $AppFolder -Filter 'Tests' 
UnzipFolder -Version $Version -SourceFolder $SourceFolder -AppFolder $AppFolder -Filter 'Library'
UnzipFolder -Version $Version -SourceFolder $SourceFolder -AppFolder $AppFolder -Filter 'System Application'
UnzipFolder -Version $Version -SourceFolder $SourceFolder -AppFolder $AppFolder -Filter 'Any'
UnzipFolder -Version $Version -SourceFolder $SourceFolder -AppFolder $AppFolder -Filter 'Permissions Mock'

#unzip platform files - format of source folder is different
$FilterText = 'APIV1'
$SourceFolder = 'C:\bcartifacts.cache\sandbox\' + $Version + '\platform\Applications\' + $FilterText + '\Source'
UnzipFolder -Version $Version -SourceFolder $SourceFolder -AppFolder $AppFolder -Filter $FilterText 
$FilterText = 'APIV2'
$SourceFolder = 'C:\bcartifacts.cache\sandbox\' + $Version + '\platform\Applications\' + $FilterText + '\Source'
UnzipFolder -Version $Version -SourceFolder $SourceFolder -AppFolder $AppFolder -Filter $FilterText 

$FilterText = 'MasterDataManagement'
$SourceFolder = 'C:\bcartifacts.cache\sandbox\' + $Version + '\platform\Applications\' + $FilterText + '\Source'
UnzipFolder -Version $Version -SourceFolder $SourceFolder -AppFolder $AppFolder -Filter $FilterText 

# finalize JSON file - begin
$WorkspaceFolders.folders = $WorkspaceFolder;
$WorkspaceFolders | ConvertTo-Json | Set-Content $WorkspaceConfigsPath -NoNewline
# finalize JSON file - end

$DuplicatePath = "C:\ProgramData\BcContainerHelper\Extensions\Original-21.4.52563.52989-NZ-al\Modules\Test\System Application Test Library\"
if (Test-Path -Path $DuplicatePath) {
    Remove-Item -Path $DuplicatePath -Recurse
}
Write-Host "Workspace setup complete!"
Write-Host "For complete coverage, open System.app package from Prism once, then tick Search Package Cache in Prism control panel before opening workspace"
Write-Host "Workspace file: $TargetFile" -ForegroundColor Green
