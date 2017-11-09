#
# Script replaces content in files based on xpath expression
#

[CmdletBinding()]
Param(
	#for example, '**/*.vsixmanifest'
	[Parameter(Mandatory=$True)]
	[string] $FileMask,
	
	#if wants attribute replace, ex)'//def:PackageManifest/def:Metadata/def:Identity/@Version'
	#if wants element text replace, ex)'//def:PackageManifest/def:Metadata/def:Description/text()'
	[Parameter(Mandatory=$True)]
	[string] $XPath,
	
	#for example, '1.5.2.2'
	[Parameter(Mandatory=$False)]
	[string] $Replacement,

	#@{
	#	def="http://schemas.microsoft.com/developer/vsx-schema/2011"
  # d="http://schemas.microsoft.com/developer/vsx-schema-design/2011"
	#}
	[Parameter(Mandatory=$False)]
	[string]$Namespaces
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. $here\ReplaceModule.ps1

#
# Constants
#
$errorActionPreference = "Stop"


#
# Main programme
#

gci -Recurse $FileMask | %{
	if (! $_.PSIsContainer) {
      [hashtable]$Hash = $Namespaces | ConvertFrom-StringData
      ReplaceInFile $_.FullName $XPath $Replacement $Hash
	}
}

