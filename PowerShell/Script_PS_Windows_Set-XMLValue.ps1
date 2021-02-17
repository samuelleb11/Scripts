function Set-XMLValue ($XMLFile,$Element,$Value)
{
    $xml = New-Object XML
    $xml.Load($XMLFile)
    $nodes = $xml.SelectNodes($element)
    $nodes | foreach {$_.InnerXml = $Value}
    $xml.Save($XMLFile)
}

Set-XMLValue -XMLFile "C:\MyFile.xml" -Element ParentNode/ChildNode -Value "MyValue"