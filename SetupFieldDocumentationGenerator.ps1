# declarations #
using namespace System.Collections.Generic #simplifies List declaration

class PageField { #declares PageField class used later to populate properties onto array
    [string]$Filename    
    [int]$LineNumber
    [string] $LineType
    [string]$Line
`
    PageField( #new record generation
    [string]$Filename,
    [int]$LineNumber,
    [string] $LineType,
    [string]$Line
    ){
        $this.Filename = $Filename
        $this.LineNumber = $LineNumber
        $this.LineType = $LineType
        $this.Line = $Line
    }
}

$array = [List[PageField]]@() #declare empty list of PageFields


# get SourcePath - exit if blank
Do {
    $SourcePath = Read-Host "`n Valid App folder, or ENTER to exit"
    [bool] $PathValid = Test-Path -Path $SourcePath
}
Until (($SourcePath -eq "") -or ($PathValid -eq 1))

if($SourcePath -eq "") {
    exit
}

if($SourcePath.substring($SourcePath.length - 1, 1) -ne "\"){
$SourcePath = $SourcePath + "\"
}
$SourcePath = $SourcePath + "*Setup.Page.al"

# get TargetPath - exit if blank
Do {
    $TargetPath = Read-Host "`n Target file name (should not be in same folder!) "
    #this time check that file does NOT exist
    [bool] $PathValid = Test-Path -Path $TargetPath -PathType Leaf    
}
Until (($TargetPath -eq "") -or ($PathValid -eq 0))

if($TargetPath -eq "") {
    exit
}

# find all lines in Base app folder which contain SourceTable 
$object = Select-String -Path $SourcePath -Pattern '\bSourceTable\b' -CaseSensitive

# loop through the found lines and populate CurrPageField object
$object | ForEach-Object {

  $object = $_

  # select specific properties in this object
  $columns = $_ | Select-Object -Property Filename, LineNumber, Line 
    
  [string]$LineHandler = $columns.Line.Trim() #removes leading.trailing spaces
  $LineHandler = $LineHandler.Substring(14) #remove "SourceTable = "  
  $LineHandler = $LineHandler.Trim(";") #remove trailing ";"
  $LineHandler = $LineHandler.Trim('"') #remove double-quotes around the table name
  $CurrPageField = [PageField]::new($columns.Filename, $columns.LineNumber, "Table Name", $LineHandler)  #populate record
  $array.Add($CurrPageField) #add to array    
} 

# find all lines in Base app folder which contain case-sensitive "field(" 
# * used as otherwise does not show fields starting with "
$object = Select-String -Path $SourcePath -Pattern '\bfield\(\b*' -CaseSensitive


# loop through the found lines and populate CurrPageField object
$object | ForEach-Object {

  $object = $_

  # select specific properties in this object
  $columns = $_ | Select-Object -Property Filename, LineNumber, Line 
    
  [string]$LineHandler = $columns.Line.Trim() #removes leading.trailing spaces
  [int]$pos = $LineHandler.IndexOf(";") #find ";"
  $LineHandler = $LineHandler.Substring(0, $pos) #remove ";" onwards  - e.g. field(xxx;xxx)
  $LineHandler = $LineHandler.Substring(6) #remove "field("
  $LineHandler = $LineHandler.Trim('"') #remove double-quotes around the field name
  $CurrPageField = [PageField]::new($columns.Filename, $columns.LineNumber, "Field Name", $LineHandler)  #populate record
  $array.Add($CurrPageField) #add to array    
} 

# find all lines in Base app folder which contain ToolTip (not case sensitive as MS messed up on some objects!) 
$object = Select-String -Path $SourcePath -Pattern '\bToolTip\b' #repeat all above for ToolTip lines - only difference is treatment of Line field

$object | ForEach-Object {

  $object = $_

  # determine the property names in this object and create a sorted list
  $columns = $_ | Select-Object -Property Filename, LineNumber, Line 
    
  [string]$LineHandler = $columns.Line.Trim()    
  $LineHandler = $LineHandler.Substring(11) #remove "ToolTip = '"
  $LineHandler = $LineHandler.Trim("';"); #remove trailing "';"
  $CurrPageField = [PageField]::new($columns.Filename, $columns.LineNumber, "Tool Tip", $LineHandler)  
  $array.Add($CurrPageField)  
} 


$array|Sort-Object -Property Filename, LineNumber|Export-Csv -Path $TargetPath