$Path = 'C:\Temp\AMTMobileTimesheets.g.xlf'

[xml]$xml = Get-Content $path


$sourceNodes= $xml.SelectNodes("//xliff/file/body/group/trans-unit/source")

foreach ($source in $sourceNodes)
{
  $parent = $source.parentNode
  $newNode = $xml.CreateElement("target")
  $newNode.InnerText = $source.InnerText;  
  $parent.AppendChild($newNode)    
}

$xml.Save("c:\Temp\test.xlf")