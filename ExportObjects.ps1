Export-NAVApplicationObject `
    -DatabaseName "Demo Database NAV (13-0)" `
    -Path "E:\WorkFolder\BC\ACB2.txt" `
    -DatabaseServer ACANTONY\SQL2016 `
    -Filter 'Type=Report;Id=1252' `
    -ExportToNewSyntax 