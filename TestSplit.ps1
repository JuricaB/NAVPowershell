# Define the path to the input file
$inputFilePath = "D:\Temp\Input\Export.txt"

# Read the content of the file
$content = Get-Content $inputFilePath -Raw

# Split the content into individual objects
$objects = $content -split "OBJECT"

# Initialize an empty array to hold the sorted objects
$sortedObjects = @()

# Loop through each object
foreach ($object in $objects) {
    # Skip empty objects
    if ($object.Trim() -ne "") {
        # Extract the object type from the first line of the object
        $objectType = ($object -split "`n")[0].Trim()

        # Add the object to the sorted objects array, with the object type as the key
        $sortedObjects += ,@($objectType, $object)
    }
}

# Sort the objects by object type
$sortedObjects = $sortedObjects | Sort-Object {[string]$_}

# Loop through the sorted objects and write them to individual files
foreach ($sortedObject in $sortedObjects) {
    # Define the output file path
    $outputFilePath = "D:\Temp\Output\" + $sortedObject[0] + ".txt"

    # Write the object to the output file
    $sortedObject[1] | Out-File $outputFilePath
}