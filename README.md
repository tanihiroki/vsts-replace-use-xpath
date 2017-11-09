# XPath-Replace

A task for replace content in files based on xpath as a build step in VSTS.

## Usage ##
The extension installs and add build task from utility category.

  ### Parameters: ###
  * File Mask
    * The search pattern to the files.
    * This is regular Windows Search Patterns - *NO minimatch*
  * XPath
    * The XPath Expression to **FIND** Node.
    * XPath example is https://msdn.microsoft.com/library/ms256086(v=vs.120).aspx
    * Selected node need have **value** property. attvibute and text has it. 
  * Replacement
    * The text to replace with.
  * Xml Namespaces
    * If file content include **xmlns** or **xmlns:?** attribute , need write setting.
    * If file content in use **xmlns** default namespace attribute, you need new name and setting Namespace (see Examples)

## Examples ##

- Replace version into **source.extension.vsixmanifest** files:

    File Mask: `**/*.vsixmanifest`

    XPath: `//def:PackageManifest/def:Metadata/def:Identity/@Version`

    Replacement: `$(SemanticVersion)`
  
    Xml Namespaces:
    `def=http://schemas.microsoft.com/developer/vsx-schema/2011
     d=http://schemas.microsoft.com/developer/vsx-schema-design/2011
    `

- Replace Description into **source.extension.vsixmanifest** files:

    File Mask: `**/*.vsixmanifest`

    XPath: `//def:PackageManifest/def:Metadata/def:Description/text()`

    Replacement: `Your New Description`

    Xml Namespaces:
    `def=http://schemas.microsoft.com/developer/vsx-schema/2011
     d=http://schemas.microsoft.com/developer/vsx-schema-design/2011
    `

