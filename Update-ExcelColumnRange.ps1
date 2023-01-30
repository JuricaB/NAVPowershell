Function Update-ExcelColumnRange {
    param(
        [string]$filePath,
        [string]$columnBValue,
        [string]$columnIValue
    )
    $excel = New-Object -ComObject Excel.Application
    $workbook = $excel.Workbooks.Open($filePath)
    $worksheet = $workbook.Worksheets.Item(1)
    $usedRange = $worksheet.UsedRange
    $rowCount = $usedRange.Rows.Count    
    $FoundFirst = 0
    $FoundSecond = 0
    $1strow = 0
    $2ndRow = 0
    for ($i = 1; $i -le $rowCount; $i++) {
    #for ($i = 1; $i -le 1000; $i++) {
        $cellValue = $usedRange.Cells.Item($i, 9).Text
        if ($cellValue.StartsWith($columnIValue)) {
			if ($FoundFirst -eq 0) {				
				$FoundFirst = 1
				$1strow = $i
			} else {
                $FoundSecond = 1
                $2ndRow = $i
            }										
            if (($FoundFirst -eq 1) -and ($FoundSecond -eq 1)) {
				for ($j = $1stRow; $j -le $2ndRow; $j++) {
					$usedRange.Cells.Item($j, 2) = $columnBValue
				}
                $FoundFirst = 0
                $FoundSecond = 0
			}
        }
    }
    $workbook.Save()
    $excel.Quit()
}


Update-ExcelColumnRange -filePath "C:\Temp\DocTest.xlsx" -columnBValue "Theta" -columnIValue "Theta Comment"