#Set-ExecutionPolicy RemoteSigned -force

$menu = @('Quit','71', '80', '90', '100', '110', '130', '140', '150','160', '170', '180', '190' )

for($i=0;$i -lt $menu.Count;$i++)
    {
    '{0} - {1}' -f $i, $menu[$i]
    }

[string]$Choice = ''
while ([string]::IsNullOrEmpty($Choice))
    {
    Write-Host
    $Choice = Read-Host 'Please choose version by number (0 to quit)'    
    if ($Choice -notin 0..11)  
        {
        [console]::Beep(1000, 300)
        Write-Warning ''
        Write-Warning ('    Your choice [ {0} ] is not valid.' -f $Choice)
        Write-Warning ('        The valid choices are 0 thru {0}.' -f 11)
        Write-Warning '        Please try again ...'
        pause

        $Choice = ''
        }
    }

[String]$result = $menu[$Choice]

Write-Host 'You chose: ' $result

if ($Choice -eq 0){
    Write-Host 'Never give up! Never surrender!'
    exit
}

if (($Choice -gt 5)) #Business Central
    {
        [String]$Path1 = 'C:\Program Files\Microsoft Dynamics 365 Business Central\'
        [String]$Path2 = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\'
    }
else #Dynamics NAV
    {
        [String]$Path1 = 'C:\Program Files\Microsoft Dynamics NAV\'
        [String]$Path2 = 'C:\Program Files (x86)\Microsoft Dynamics NAV\'
    }

[String]$FollowPath1 = '\Service\NavAdminTool.ps1'
[String]$FollowPath2 = '\RoleTailored Client\NavModelTools.ps1'
[String]$FollowPath3 = '\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1'
[String]$FollowPath4 = '\RoleTailored Client\finsql.exe'

$FullPath1 = $Path1 + $result + $FollowPath1 #admin tools
$FullPath2 = $Path2 + $result + $FollowPath2 #NAVModelTools
$FullPath3 = $Path2 + $result + $FollowPath3 #IDE psm
$FullPath4 = $Path2 + $result + $FollowPath4 #finsql

if([System.IO.File]::Exists($FullPath1))
    {
        Write-Host 'Importing module - admin tools : ' $FullPath1    
        Import-Module $FullPath1
    }
else
    {
        Write-Host 'File not found - admin tools: ' $FullPath1
    }

if([System.IO.File]::Exists($FullPath2))
    {
        Write-Host 'Importing module - NAVModelTools: ' $FullPath2    
        Import-Module $FullPath2
    }
else
    {
        Write-Host 'File not found - NAVModelTools: ' $FullPath2
    }

if([System.IO.File]::Exists($FullPath3))
    {
        Write-Host 'Importing module - NAV IDE: ' $FullPath3    
        Import-Module $FullPath3
    }
else
    {
        Write-Host 'File not found - NAV IDE : ' $FullPath3
    }

if([System.IO.File]::Exists($FullPath4))
    {
        Write-Host 'Setting NAV IDE: ' $FullPath4
        $NavIde= $FullPath4
    }
else
    {
        Write-Host 'File not found - finsql.exe: ' $FullPath4
    }