Add-Type -AssemblyName Microsoft.Office.Interop.Excel

$excelFile = 'C:\Temp\DocTest.xlsx' 

$searchFor            = 'Theta Comment'

$excel                = New-Object -ComObject Excel.Application
$excel.Visible        = $true
$excel.ScreenUpdating = $true

$workbook  = $excel.Workbooks.Open( $excelFile ,$null, $false )

$ws        = $workbook.WorkSheets.item(1) 

[void]$ws.Activate()

$searchRange  = $ws.UsedRange

$searchResult = $searchRange.Find( $searchFor, [System.Type]::Missing, [System.Type]::Missing, 
                                               [Microsoft.Office.Interop.Excel.XlLookAt]::xlPart, 
                                               [Microsoft.Office.Interop.Excel.XlSearchOrder]::xlByRows, 
                                               [Microsoft.Office.Interop.Excel.XlSearchDirection]::xlNext )

while( $searchResult ) {

    $row = $searchResult.Row    

    $ws.Cells( $row, 2 ).Value2 = 'Theta'
    $searchResult = $searchRange.FindNext( $searchResult )

    if( $searchResult -and $searchResult.Row -le $row ) {
        break
    }
}

[void]$workbook.Save()
[void]$workbook.Close()
[void]$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null