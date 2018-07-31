#
# Function
#

function ReplaceInXmlDoc(){
  Param(
    [Parameter(Mandatory=$True)]
    $XmlDoc,
    [Parameter(Mandatory=$True)]
    $XPath,
    [Parameter(Mandatory=$False)]
    $Replacement,
    [Parameter(Mandatory=$True)]
    [hashtable]$nameSpaces
  )

  Write-Host "--- NameSpaces:"
  Write-Host ($NameSpaces | Out-String -Width 256)
  Write-Host "--- XPath: $XPath"

  $cloneDoc = $xmlDoc.Clone()

  if ($nameSpaces.count -gt 0) {
    $nodes = $cloneDoc | Select-Xml $XPath -Namespace $nameSpaces
  }
  else {
    $nodes = $cloneDoc | Select-Xml $XPath
  }
  Write-Host found: $nodes.count
  if($nodes.count -gt 0 ){
    $nodes | ReplaceNodeValue -Replacement $Replacement
  }

  $cloneDoc
}


function ReplaceInFile() {
  param(
    [Parameter(Mandatory=$True)]
    [string]$file,
    [Parameter(Mandatory=$True)]
    [string]$XPath,
    [Parameter(Mandatory=$False)]
    [string]$Replacement,
    [Parameter(Mandatory=$True)]
    [hashtable]$nameSpaces
  )
  Write-Host "`n--- Processing file: $file"
#Write-Host "--- NameSpaces:"
#$nameSpaces.Keys | %{Write-Host $_ "=" $nameSpaces[$_]}
#Write-Host "--- XPath: $XPath"

  $xmlDoc = new-object System.Xml.XmlDocument
  $xmlDoc.Load($file)

  $ReplaceDoc = ReplaceInXmlDoc $xmlDoc $XPath $Replacement $nameSpaces
  $ReplaceDoc.Save($file)

}

function PrintNodes(){
  param(
    [parameter(ValueFromPipeline=$true)]
    [System.Xml.XmlNode]$node,
    [string]$prefix = ""
  )
  process
  {
    Write-Host $prefix $nodes.GetType().FullName
    Write-Host $prefix "Type:"$node.NodeType "  Name:"  $node.name "  value:" $node.value "  text:"$node.innerText
    if($node.hasChildNodes){
      $node.ChildNodes | PrintNodes -prefix "  $prefix"
    }
  }
}

function ReplaceNodeValue(){
  param(
      [parameter(ValueFromPipeline = $true)]
      $node,
      $Replacement
  )
  process
  {
    if(!$node){return}
    $RepStr = [Environment]::ExpandEnvironmentVariables($Replacement)
    Write-Host $node.Node.value => $RepStr
    $node.Node.value = $RepStr
  }
}

