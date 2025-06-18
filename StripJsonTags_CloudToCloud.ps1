
$SourceFolder = 'SPECIFYFOLDER\WorkCloud'
$TargetFolder = 'SPECIFYFOLDER\Result'

#Get files from folder
$files = Get-ChildItem $SourceFolder 
foreach ($file in $files)
{
    $pathToJson = $file.FullName

    $json_convert = Get-Content -Path $pathToJson -Raw | ConvertFrom-Json
    
    #remove @odata.context from header
    $json_convert.PSObject.Properties.Remove('@odata.context')

    #filter contents of value collection to Inbound, Completed messages
    $json_convert.value = @($json_convert.value |Where-Object Direction -eq 'Inbound')
    $json_convert.value = @($json_convert.value |Where-Object Status -eq 'Completed')

    #remove unneeded JSON keys/values from value collection
    $json_convert.value = $json_convert.value | Select-Object * -ExcludeProperty '@odata.etag'
    $json_convert.value = $json_convert.value | Select-Object * -ExcludeProperty 'entryNo'
    $json_convert.value = $json_convert.value | Select-Object * -ExcludeProperty 'base64'
    $json_convert.value = $json_convert.value | Select-Object * -ExcludeProperty 'errorText'
    $json_convert.value = $json_convert.value | Select-Object * -ExcludeProperty 'correlationId'
    $json_convert.value = $json_convert.value | Select-Object * -ExcludeProperty 'status'
    $json_convert.value = $json_convert.value | Select-Object * -ExcludeProperty 'createdDateTime'
    $json_convert.value = $json_convert.value | Select-Object * -ExcludeProperty 'processingDuration'
    $json_convert.value = $json_convert.value | Select-Object * -ExcludeProperty 'partnerReferenceId'

     # Create the new JSON structure
     $requests = @()
     $counter = 1
     foreach ($element in $json_convert.value) {
         #Define request JSON structure
         $request = @{
             method = "POST"
             id = "r$counter" # this will be autoincremented from counter
             url = "companies({{companyId}})/integrationMessages" # this uses variable from Postman
             headers = @{
                 "Content-Type" = "application/json"
             }
             body = $element # the element in value collectin (remainder of original message)
         }
         $requests += $request     
         
         #We can only send batches of up to 100 messages to BC. This splits resulting file when counter hits 100 
         if (($counter % 100) -eq 0) { 
            $batchRequest = @{
                requests = $requests
            }        
            $pathToConvertedJson = $TargetFolder + '\' + $file.Basename + ([int] $counter / 100) + 'Fixed.json'
            $batchRequest | ConvertTo-Json -Depth 100 | Out-File $pathToConvertedJson -Force
            #clear global variables - otherwise all following files will contain info already in this file
            Clear-Variable -name batchRequest -Scope Global
            Clear-Variable -name requests -Scope Global
            $requests = @()   
            $exportCounter = $counter                 
         }
     
         $counter++
     }
     #We can only send batches of up to 100 messages to BC. This handles remainder 
     if ($counter -ne ($exportCounter+1)) {
         $batchRequest = @{
             requests = $requests
         }
        $pathToConvertedJson = $TargetFolder + '\' + $file.Basename + 'RemainderFixed.json'
        $batchRequest | ConvertTo-Json -Depth 100 | Out-File $pathToConvertedJson -Force       
    }
}