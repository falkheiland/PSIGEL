$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

Describe "General project validation: $ModuleName" {

  Context 'Basic Module Testing' {
    $ScriptColl = Get-ChildItem $ModuleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

    $TestCase = $ScriptColl | ForEach-Object {
      @{
        File = $_
      }
    }
    It "Script <file> should be valid powershell" -TestCases $TestCase {
      param(
        $File
      )

      $File.Fullname | Should Exist

      $ContentColl = Get-Content -Path $File.Fullname -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($ContentColl, [ref]$ErrorColl)
      $ErrorColl.Count | Should Be 0
    }

    It "Module '$ModuleName' can import cleanly" {
      { Import-Module ( '{0}/{1}.psm1' -f $ModuleRoot, $ModuleName) } | Should Not Throw
    }
  }

  Context 'Manifest Testing' {
    It 'Test Module Manifest should not throw' {
      {
        $Script:Manifest = Test-ModuleManifest -Path $ModuleManifest -ErrorAction Stop -WarningAction SilentlyContinue
      } | Should Not Throw
    }
    #It 'Must have correct Manifest Name' {
    It "Manifest Name should be $ModuleName" {
      $Script:Manifest.Name | Should be $ModuleName
    }
    It 'Manifest Version as [Version] should not be null or empty' {
      $Script:Manifest.Version -as [Version] | Should Not BeNullOrEmpty
    }
    It 'Manifest Description as [Version] should not be null or empty' {
      $Script:Manifest.Description | Should Not BeNullOrEmpty
    }
    It 'Manifest Author as [Version] should not be null or empty' {
      $Script:Manifest.Author | Should Not BeNullOrEmpty
    }
    It 'Manifest LicenseUri and/or ProjectUri should not be null or empty' {
      ($Script:Manifest.PrivateData.PSData.LicenseUri + $Script:Manifest.PrivateData.PSData.ProjectUri) | Should Not BeNullOrEmpty
    }
    It "Manifest Root Module should be $('{0}.psm1' -f $ModuleName)" {
      $Script:Manifest.RootModule | Should Be ('{0}.psm1' -f $ModuleName)
    }
    It 'Manifest GUID should be correct' {
      $Script:Manifest.Guid | Should be '4834fbc2-faf6-469c-b685-0195954fd878'
    }
    It 'Manifest Exported Format File should be null or empty' {
      $Script:Manifest.ExportedFormatFiles | Should BeNullOrEmpty
    }
  }

  Context 'Public Functions' {
    $PublicFunctionColl = (Get-ChildItem -Path ('{0}\Public' -f $ModuleRoot) -Filter *.ps1 |
      Select-Object -ExpandProperty Name ) -replace '\.ps1$'

    $TestCase = $PublicFunctionColl | ForEach-Object {
      @{
        ScriptName = $_
      }
    }

    It "Function <ScriptName> should be in manifest" -TestCases $TestCase {
      param(
        $ScriptName
      )

      $ManifestFunctionColl = $Manifest.ExportedFunctions.Keys
      $ScriptName -in $ManifestFunctionColl | Should Be $true
    }

    It 'Proper Number of Functions Exported compared to Manifest' {
      $ExportedCount = Get-Command -Module $ModuleName -CommandType Function |
      Measure-Object | Select-Object -ExpandProperty Count
      $ManifestCount = $Manifest.ExportedFunctions.Count
      $ExportedCount | Should be $ManifestCount
    }

    It 'Proper Number of Functions Exported compared to Files' {
      $ExportedCount = Get-Command -Module $ModuleName -CommandType Function |
      Measure-Object | Select-Object -ExpandProperty Count
      $FileCount = Get-ChildItem -Path ('{0}\Public' -f $ModuleRoot) -Filter *.ps1 |
      Measure-Object | Select-Object -ExpandProperty Count
      $ExportedCount | Should be $FileCount
    }
  }

  Context 'Private Functions' {
    $PrivateFunctionColl = (Get-ChildItem -Path ('{0}\Private' -f $ModuleRoot) -Filter *.ps1 |
      Select-Object -ExpandProperty Name ) -replace '\.ps1$'
    $TestCase = $PrivateFunctionColl | ForEach-Object {
      @{
        ScriptName = $_
      }
    }

    It "Private function <ScriptName> is not directly accessible outside the module" -TestCases $TestCase {
      param(
        $ScriptName
      )
      { . ('\{0}' -f $ScriptName) } | Should Throw
    }
  }

  Context 'Exported Aliases' {
    It 'Proper Number of Aliases Exported compared to Manifest' {
      $ExportedCount = Get-Command -Module $ModuleName -CommandType Alias |
      Measure-Object | Select-Object -ExpandProperty Count
      $ManifestCount = $Manifest.ExportedAliases.Count

      $ExportedCount | Should be $ManifestCount
    }

    It 'Proper Number of Aliases Exported compared to Files' {
      $AliasCount = Get-ChildItem -Path "$ModuleRoot\Public" -Filter *.ps1 |
      Select-String "New-Alias" | Measure-Object | Select-Object -ExpandProperty Count
      $ManifestCount = $Manifest.ExportedAliases.Count

      $AliasCount | Should be $ManifestCount
    }
  }
}

Describe "$ModuleName ScriptAnalyzer" -Tag 'Compliance' {
  $PSScriptAnalyzerSettingColl = @{
    Severity    = @('Error', 'Warning')
    ExcludeRule = @('')
  }
  $ScriptAnalyzerErrorColl = @()
  $ScriptAnalyzerErrorColl += Invoke-ScriptAnalyzer -Path "$ModuleRoot\Public" @PSScriptAnalyzerSettingColl
  $ScriptAnalyzerErrorColl += Invoke-ScriptAnalyzer -Path "$ModuleRoot\Private" @PSScriptAnalyzerSettingColl
  $PrivateFunctionColl = Get-ChildItem -Path "$ModuleRoot\Private" -Filter *.ps1 |
  Select-Object -ExpandProperty Name
  $PublicFunctionColl = Get-ChildItem -Path "$ModuleRoot\Public" -Filter *.ps1 |
  Select-Object -ExpandProperty Name
  $AllFunctionColl = ($PrivateFunctionColl + $PublicFunctionColl) | Sort-Object
  $FunctionWithErrorColl = $ScriptAnalyzerErrorColl.ScriptName | Sort-Object -Unique
  if ($ScriptAnalyzerErrorColl)
  {
    $TestCase = $ScriptAnalyzerErrorColl | ForEach-Object {
      @{
        RuleName   = $_.RuleName
        ScriptName = $_.ScriptName
        Message    = $_.Message
        Severity   = $_.Severity
        Line       = $_.Line
      }
    }
    $FunctionWithoutErrorColl = Compare-Object -ReferenceObject $AllFunctionColl -DifferenceObject $FunctionWithErrorColl |
    Select-Object -ExpandProperty InputObject
    Context 'ScriptAnalyzer Testing' {
      It "Function <ScriptName> should not use <Message> on line <Line>" -TestCases $TestCase {
        param(
          $RuleName,
          $ScriptName,
          $Message,
          $Severity,
          $Line
        )
        $ScriptName | Should BeNullOrEmpty
      }
    }
  }
  else
  {
    $FunctionWithoutErrorColl = $AllFunctionColl
  }

  Context 'Successful ScriptAnalyzer Testing' {
    $TestCase = $FunctionWithoutErrorColl | ForEach-Object {
      @{
        ScriptName = $_
      }
    }
    It "Function <ScriptName> has no ScriptAnalyzerErrors" -TestCases $TestCase {
      param(
        $ScriptName
      )
      $ScriptName | Should Not BeNullOrEmpty
    }
  }
}