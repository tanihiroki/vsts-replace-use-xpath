$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. $here\..\Tasks\$sut

Describe "ReplaceInXmlDocTest" {
    It "Replace element text (No NameSpace)" {

        $xml = [xml]'<root><child1 catt="0">abcde</child1></root>'
        $RepXmlDoc = ReplaceInXmlDoc $xml '//root/child1/text()' 'after-replace' @{}
        $RepXmlDoc.root.child1.InnerText | should be 'after-replace'
        $RepXmlDoc.root.child1.catt | should be '0'
    }
    It "Replace attribute text (No NameSpace)" {

        $xml = [xml]'<root><child1 catt="0">abcde</child1></root>'
        $RepXmlDoc = ReplaceInXmlDoc $xml '//root/child1/@catt' 'after-replace' @{}
        $RepXmlDoc.root.child1.InnerText | should be 'abcde'
        $RepXmlDoc.root.child1.catt | should be 'after-replace'
    }
    It "Replace element text (Use Namespace)" {
      $namespaces = @{
        hoge='http://hoge.com'
        fuga='http://fuga.com'
      }

      $xml = [xml]'<root xmlns="http://hoge.com" xmlns:f="http://fuga.com"><child1 catt="0"></child1><f:child2 f:catt="1">aaaaa</f:child2></root>'

      $ResultDoc1 = ReplaceInXmlDoc $xml '//hoge:root/fuga:child2/text()' 'bbbbb' $namespaces
      $ResultDoc1.root.child2.InnerText | Should Be 'bbbbb'
    }

    It "Replace attribute text (Use Namespace)" {
      $namespaces = @{
        hoge='http://hoge.com'
        fuga='http://fuga.com'
      }

      $xml = [xml]'<root xmlns="http://hoge.com" xmlns:f="http://fuga.com"><child1 catt="0"></child1><f:child2 f:catt="1">aaaaa</f:child2></root>'

      $ResultDoc1 = ReplaceInXmlDoc $xml '//hoge:root/fuga:child2/@fuga:catt' 'bbbbb' $namespaces
      $ResultDoc1.root.child1.catt | Should Be '0'
      $ResultDoc1.root.child1.InnerText | Should Be ''
      $ResultDoc1.root.child2.catt | Should Be 'bbbbb'
      $ResultDoc1.root.child2.InnerText | Should Be 'aaaaa'

      $ResultDoc2 = ReplaceInXmlDoc $xml '//hoge:root/hoge:child1/@catt' 'ccccc' $namespaces

      $ResultDoc2.root.child1.catt | Should Be 'ccccc'
      $ResultDoc2.root.child1.InnerText | Should Be ''
      $ResultDoc2.root.child2.catt | Should Be '1'
      $ResultDoc2.root.child2.InnerText | Should Be 'aaaaa'

      Write-Host $TestDrive

    }

}
Describe "ReplaceInFileTest" {
    It "Replace element japanese text shift-jis" {
      $namespace = @{
        ns='http://schemas.microsoft.com/developer/vsx-schema/2011'
        d='http://schemas.microsoft.com/developer/vsx-schema-design/2011'
      }
      $SourceDoc = Join-Path $here 'data' | Join-Path -ChildPath 'shift-jis' | Join-Path -ChildPath 'source.extension.vsixmanifest'
      $DestDoc = Join-Path $testDrive 'shift-jis.vsixmanifest'
      Copy-Item $SourceDoc $DestDoc

      ReplaceInFile $DestDoc '//ns:PackageManifest/ns:Metadata/ns:Description/text()' '日本語で置換' $namespace

      [xml]$ResultDoc = cat $DestDoc -Encoding Default

        $ResultDoc.PackageManifest.Metadata.Description.InnerText | should be '日本語で置換'
    }
    It "Replace element japanese text utf-8" {
      $namespace = @{
        ns='http://schemas.microsoft.com/developer/vsx-schema/2011'
        d='http://schemas.microsoft.com/developer/vsx-schema-design/2011'
      }
      $SourceDoc = Join-Path $here 'data' | Join-Path -ChildPath 'utf-8' | Join-Path -ChildPath 'source.extension.vsixmanifest'
      $DestDoc = Join-Path $testDrive 'utf-8.vsixmanifest'
      Copy-Item $SourceDoc $DestDoc

      ReplaceInFile $DestDoc '//ns:PackageManifest/ns:Metadata/ns:Description/text()' '日本語で置換' $namespace

      [xml]$ResultDoc = cat $DestDoc -Encoding UTF8

        $ResultDoc.PackageManifest.Metadata.Description.InnerText | should be '日本語で置換'
    }
}
