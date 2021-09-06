#TODO: strip functionality from Convert-PermissionSets to read object names per type/ID

$AppJson = Get-Content -Path "C:\AL\erp-ext-root\MAIN\app.json" | ConvertFrom-Json
#get ID = make it same as beginnning of ID range
$AppJsonRanges = $AppJson.idRanges
$PermSetID =  $AppJsonRanges.from
#Write-Host $PermSetID
[string]$PermName = $AppJson.name
if($PermName.Length -gt 16){
    $PermName = $PermName.Substring(0,16)
}
$PermName = $PermName + "_TSL" 

[xml]$XmlDocument = Get-Content -Path "C:\AL\erp-ext-root\MAIN\extensionsPermissionSet.xml"
$PermSets = $XmlDocument.PermissionSets.PermissionSet

Write-Host "permissionset $PermSetID `"$PermName`""

Write-Host '{'
Write-Host "    Caption =  `'$PermName`' ;"
Write-Host "    Assignable = true;"
Write-Host "    Permissions ="

$i = 0
$Permissions = $XmlDocument.PermissionSets.PermissionSet.Permission

foreach ($Permission in $Permissions) {
    $i = $i + 1
    #$Permission = $XmlDocument.PermissionSets.PermissionSet.Permission 
    $ObjType  = $Permission.ObjectType
    switch ($ObjType)
    {
        0 {$ObjTypeName = 'tabledata'}
        1 {$ObjTypeName = 'table'}
        3 {$ObjTypeName = 'report'}
        5 {$ObjTypeName = 'codeunit'}
        6 {$ObjTypeName = 'xmlort'}
        7 {$ObjTypeName = 'menusuite'}
        8 {$ObjTypeName = 'page'}
        9 {$ObjTypeName = 'query'}
        10 {$ObjTypeName = 'system'}
    }    

    $ObjID  = $Permission.ObjectID

    $Read = ''
    $Insert = ''
    $Modify = ''
    $Delete = ''
    $Execute = ''
    #Security filter not supported
    if ($Permission.ReadPermission -eq 1){
        $Read = 'R'
    }
    if ($Permission.InsertPermission -eq 1){
        $Insert = 'I'
    }
    if ($Permission.ModifyPermission -eq 1){
        $Modify = 'M'
    }
    if ($Permission.DeletePermission -eq 1){
        $Delete = 'D'
    }
    if ($Permission.ExecutePermission -eq 1){
        $Execute = 'X'
    }

    if ($i -eq $Permissions.Count) {
        $LineTerminator = ';'
    }
    else {
        $LineTerminator = ','
    }
    Write-Host "        $ObjTypeName `"$ObjID`" = $Read$Insert$Modify$Delete$Execute$LineTerminator"
}

Write-Host '}'

