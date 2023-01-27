Function Update-ExcelColumn {
    param(
        [string]$filePath,
        [string]$columnBValue,
        [string]$columnCValue
    )
    $excel = New-Object -ComObject Excel.Application
    $workbook = $excel.Workbooks.Open($filePath)
    $worksheet = $workbook.Worksheets.Item(1)
    $usedRange = $worksheet.UsedRange
    $rowCount = $usedRange.Rows.Count
    for ($i = 1; $i -le $rowCount; $i++) {
        $cellValue = $usedRange.Cells.Item($i, 3).Text
        if ($cellValue -eq $columnCValue) {
            $usedRange.Cells.Item($i, 2) = $columnBValue
        }
    }
    $workbook.Save()
    $excel.Quit()
}


# Update-ExcelColumn -filePath "C:\path\to\your\file.xlsx" -columnBValue "X" -columnCValue "Theta"