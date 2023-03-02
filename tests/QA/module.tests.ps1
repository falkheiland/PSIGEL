BeforeDiscovery {
  $script:DSC = [IO.Path]::DirectorySeparatorChar
  $projectPath = "$($PSScriptRoot)\..\.." | Convert-Path

  <#
        If the QA tests are run outside of the build script (e.g with Invoke-Pester)
        the parent scope has not set the variable $ProjectName.
    #>
  if (-not $ProjectName)
  {
    # Assuming project folder name is project name.
    $ProjectName = Get-SamplerProjectName -BuildRoot $projectPath
  }

  $script:moduleName = $ProjectName

  Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue

  $mut = Get-Module -Name $script:moduleName -ListAvailable |
    Select-Object -First 1 |
    Import-Module -Force -ErrorAction Stop -PassThru

  if (Get-Command -Name Invoke-ScriptAnalyzer -ErrorAction SilentlyContinue)
  {
    $scriptAnalyzerRules = Get-ScriptAnalyzerRule
  }
  else
  {
    if ($ErrorActionPreference -ne 'Stop')
    {
      Write-Warning -Message 'ScriptAnalyzer not found!'
    }
    else
    {
      throw 'ScriptAnalyzer not found!'
    }
  }
  $script:PSSASettingsFile = ('{0}{1}PSScriptAnalyzerSettings.psd1' -f $projectPath, $DSC)
}

BeforeAll {
  # Convert-Path required for PS7 or Join-Path fails
  $projectPath = "$($PSScriptRoot)\..\.." | Convert-Path

  <#
        If the QA tests are run outside of the build script (e.g with Invoke-Pester)
        the parent scope has not set the variable $ProjectName.
    #>
  if (-not $ProjectName)
  {
    # Assuming project folder name is project name.
    $ProjectName = Get-SamplerProjectName -BuildRoot $projectPath
  }

  $script:moduleName = $ProjectName
  $script:ModuleManifest = Resolve-Path ('{0}{1}source{1}{2}.psd1' -f $projectPath, $DSC, $ProjectName)
  $script:TestModuleManifest = Test-ModuleManifest -Path $ModuleManifest -ErrorAction Stop -WarningAction SilentlyContinue
  $script:TestModuleManifestGUID = '4834fbc2-faf6-469c-b685-0195954fd878'

  $sourcePath = (
    Get-ChildItem -Path $projectPath\*\*.psd1 |
      Where-Object -FilterScript {
                ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) `
          -and $(
          try
          {
            Test-ModuleManifest -Path $_.FullName -ErrorAction Stop
          }
          catch
          {
            $false
          }
        )
      }
  ).Directory.FullName
}

Describe 'Changelog Management' -Tag 'Changelog' {
  It 'Changelog has been updated' -Skip:(
    -not ([bool](Get-Command git -ErrorAction SilentlyContinue) -and
      [bool](&(Get-Process -Id $PID).Path -NoProfile -Command 'git rev-parse --is-inside-work-tree 2>$null'))
  ) {
    # Get the list of changed files compared with branch main
    $headCommit = &git rev-parse HEAD
    $defaultBranchCommit = &git rev-parse origin/main
    $filesChanged = &git @('diff', "$defaultBranchCommit...$headCommit", '--name-only')
    $filesStagedAndUnstaged = &git @('diff', 'HEAD', '--name-only')

    $filesChanged += $filesStagedAndUnstaged

    # Only check if there are any changed files.
    if ($filesChanged)
    {
      $filesChanged | Should -Contain 'CHANGELOG.md' -Because 'the CHANGELOG.md must be updated with at least one entry in the Unreleased section for each PR'
    }
  }

  It 'Changelog format compliant with keepachangelog format' -Skip:(![bool](Get-Command git -EA SilentlyContinue)) {
    { Get-ChangelogData -Path (Join-Path $ProjectPath 'CHANGELOG.md') -ErrorAction Stop } | Should -Not -Throw
  }

  It 'Changelog should have an Unreleased header' -Skip:$skipTest {
            (Get-ChangelogData -Path (Join-Path -Path $ProjectPath -ChildPath 'CHANGELOG.md') -ErrorAction Stop).Unreleased | Should -Not -BeNullOrEmpty
  }
}

Describe 'Module + Functions' -Tags 'Module' {

  Context 'Module import / removal [<moduleName>]' {
    It 'Should import without errors' {
      { Import-Module -Name $script:moduleName -Force -ErrorAction Stop } | Should -Not -Throw

      Get-Module -Name $script:moduleName | Should -Not -BeNullOrEmpty
    }

    It 'Should remove without error' {
      { Remove-Module -Name $script:moduleName -ErrorAction Stop } | Should -Not -Throw

      Get-Module $script:moduleName | Should -BeNullOrEmpty
    }
  }

  Context 'Manifest [<ModuleManifest>]' {

    It 'should exist' {
      $ModuleManifest | Should -Exist
    }

    It 'Name should be [<ModuleName>]' {
      $TestModuleManifest.Name | Should -Be $ModuleName
    }

    It 'Version should not be null or empty' {
      $TestModuleManifest.Version -as [Version] | Should -Not -BeNullOrEmpty
    }

    It 'Description should not be null or empty' {
      $TestModuleManifest.Description | Should -Not -BeNullOrEmpty
    }

    It 'Author should not be null or empty' {
      $TestModuleManifest.Author | Should -Not -BeNullOrEmpty
    }

    It 'ProjectUri should not be null or empty' {
      $TestModuleManifest.PrivateData.PSData.ProjectUri | Should -Not -BeNullOrEmpty
    }

    It 'LicenseUri should not be null or empty' {
      $TestModuleManifest.PrivateData.PSData.LicenseUri | Should -Not -BeNullOrEmpty
    }

    It "Manifest Root Module should be $('{0}.psm1' -f $ModuleName)" {
      $TestModuleManifest.RootModule | Should -Be ('{0}.psm1' -f $ModuleName)
    }

    It 'GUID should be correct' {
      $TestModuleManifest.Guid | Should -BeExactly $TestModuleManifestGUID
    }

    It 'Exported Format File should be null or empty' {
      $TestModuleManifest.ExportedFormatFiles | Should -BeNullOrEmpty
    }

    It 'Proper Number of Functions Exported compared to Manifest' {
      $ExportedCount = Get-Command -Module $ModuleName -CommandType Function |
        Measure-Object | Select-Object -ExpandProperty Count
      $TestModuleManifestCount = $TestModuleManifest.ExportedFunctions.Count
      $ExportedCount | Should -Be $TestModuleManifestCount
    }

    It 'Proper Number of Functions Exported compared to Files' {
      $ExportedCount = Get-Command -Module $ModuleName -CommandType Function |
        Measure-Object | Select-Object -ExpandProperty Count
      $FileCount = Get-ChildItem -Path ('{0}{1}source{1}Public' -f $projectPath, $DSC) -Filter *.ps1 |
        Measure-Object | Select-Object -ExpandProperty Count
      $ExportedCount | Should -Be $FileCount
    }

  }

  Context 'Script [<_>]' -ForEach @(
    (Get-ChildItem -Path ('{0}{1}source{1}' -f $projectPath, $DSC) -Include '*.ps1', '*.psm1', '*.psd1' -Recurse -Force)
  ) {

    It 'should exist' {
      $_.Fullname | Should -Exist
    }

    It 'should be valid powershell' {
      $ContentColl = Get-Content -Path $_.Fullname -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($ContentColl, [ref]$ErrorColl)
      $ErrorColl.Count | Should -Be 0
    }

    It 'should pass Script Analyzer' -Skip:(-not $scriptAnalyzerRules) {
      if (Test-Path $pssaSettingsFile)
      {
        $pssaResult = (Invoke-ScriptAnalyzer -Path $_.FullName -Settings $pssaSettingsFile)
      }
      else
      {
        $pssaResult = (Invoke-ScriptAnalyzer -Path $_.FullName)
      }
      $report = $pssaResult | Format-Table -AutoSize | Out-String -Width 110
      $pssaResult | Should -BeNullOrEmpty -Because `
        "some rule triggered.`r`n`r`n $report"
    }

  }

  Context 'Public Function [<_>]' -ForEach @(
    (Get-ChildItem -Path ('{0}{1}source{1}Public' -f $projectPath, $DSC) -Filter *.ps1 |
      Select-Object -ExpandProperty Name ) -replace '\.ps1$'
  ) {

    It 'should be in manifest' {
      $TestModuleManifestFunctionColl = $TestModuleManifest.ExportedFunctions.Keys
      $_ -in $TestModuleManifestFunctionColl | Should -Be $true
    }

    It 'should have a unit test' {
      Get-ChildItem -Path ('{0}{1}tests' -f $projectPath, $DSC) -Recurse -Include "$_.Tests.ps1" | Should -Not -BeNullOrEmpty
    }

  }

  Context 'Private Function [<_>]' -ForEach @(
    (Get-ChildItem -Path ('{0}{1}source{1}Private' -f $projectPath, $DSC) -Filter *.ps1 |
      Select-Object -ExpandProperty Name ) -replace '\.ps1$'
  ) {

    It 'is not directly accessible outside the module' {
      { . ('\{0}' -f $FunctionName) } | Should -Throw
    }

    It 'should have a unit test' {
      Get-ChildItem -Path ('{0}{1}tests' -f $projectPath, $DSC) -Recurse -Include "$_.Tests.ps1" | Should -Not -BeNullOrEmpty
    }
  }

  Context 'Exported Aliases' {

    It 'Proper Number of Aliases Exported compared to Manifest' {
      $ExportedCount = Get-Command -Module $ModuleName -CommandType Alias |
        Measure-Object | Select-Object -ExpandProperty Count
      $TestModuleManifestCount = $TestModuleManifest.ExportedAliases.Count

      $ExportedCount | Should -Be $TestModuleManifestCount
    }

    It 'Proper Number of Aliases Exported compared to Files' {
      $AliasCount = Get-ChildItem -Path ('{0}{1}source{1}Public' -f $projectPath, $DSC) -Filter *.ps1 |
        Select-String 'New-Alias' | Measure-Object | Select-Object -ExpandProperty Count
      $TestModuleManifestCount = $TestModuleManifest.ExportedAliases.Count

      $AliasCount | Should -Be $TestModuleManifestCount
    }
  }

  Context 'Command Based Help for [<_.BaseName>]' -ForEach @(
    Get-ChildItem -Path ('{0}{1}source{1}Public' -f $projectPath, $DSC) -Filter *.ps1
  ) {

    It 'should have .SYNOPSIS' {
      #$functionFile = Get-ChildItem -Path $sourcePath -Recurse -Include "$_.ps1"
      #$functionFile = Get-ChildItem -Path ('{0}{1}source{1}Public' -f $projectPath, $DSC) -Recurse -Include "$_.ps1"

      $scriptFileRawContent = Get-Content -Raw -Path $_.FullName
      #Write-Host $scriptFileRawContent

      $abstractSyntaxTree = [System.Management.Automation.Language.Parser]::ParseInput($scriptFileRawContent, [ref] $null, [ref] $null)
      #Write-Host $abstractSyntaxTree

      $astSearchDelegate = { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }
      #Write-Host $args[0]

      $BaseName = $_.BaseName
      $parsedFunction = $abstractSyntaxTree.FindAll( $astSearchDelegate, $true ) |
        Where-Object -FilterScript {
          $_.Name -eq $BaseName
        }

      $functionHelp = $parsedFunction.GetHelpContent()

      $functionHelp.Synopsis | Should -Not -BeNullOrEmpty
    }

    <#
    It 'Should have .DESCRIPTION for <Name>' -ForEach $testCases {
      $functionFile = Get-ChildItem -Path $sourcePath -Recurse -Include "$Name.ps1"

      $scriptFileRawContent = Get-Content -Raw -Path $functionFile.FullName

      $abstractSyntaxTree = [System.Management.Automation.Language.Parser]::ParseInput($scriptFileRawContent, [ref] $null, [ref] $null)

      $astSearchDelegate = { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }

      $parsedFunction = $abstractSyntaxTree.FindAll( $astSearchDelegate, $true ) |
        Where-Object -FilterScript {
          $_.Name -eq $Name
        }

      $functionHelp = $parsedFunction.GetHelpContent()

      $functionHelp.Description | Should -Not -BeNullOrEmpty
    }

    It 'Should have at least one (1) example for <Name>' -ForEach $testCases {
      $functionFile = Get-ChildItem -Path $sourcePath -Recurse -Include "$Name.ps1"

      $scriptFileRawContent = Get-Content -Raw -Path $functionFile.FullName

      $abstractSyntaxTree = [System.Management.Automation.Language.Parser]::ParseInput($scriptFileRawContent, [ref] $null, [ref] $null)

      $astSearchDelegate = { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }

      $parsedFunction = $abstractSyntaxTree.FindAll( $astSearchDelegate, $true ) |
        Where-Object -FilterScript {
          $_.Name -eq $Name
        }

      $functionHelp = $parsedFunction.GetHelpContent()

      $functionHelp.Examples.Count | Should -BeGreaterThan 0
      $functionHelp.Examples[0] | Should -Match ([regex]::Escape($function.Name))
      $functionHelp.Examples[0].Length | Should -BeGreaterThan ($function.Name.Length + 10)

    }

    It 'Should have described all parameters for <Name>' -ForEach $testCases {
      $functionFile = Get-ChildItem -Path $sourcePath -Recurse -Include "$Name.ps1"

      $scriptFileRawContent = Get-Content -Raw -Path $functionFile.FullName

      $abstractSyntaxTree = [System.Management.Automation.Language.Parser]::ParseInput($scriptFileRawContent, [ref] $null, [ref] $null)

      $astSearchDelegate = { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }

      $parsedFunction = $abstractSyntaxTree.FindAll( $astSearchDelegate, $true ) |
        Where-Object -FilterScript {
          $_.Name -eq $Name
        }

      $functionHelp = $parsedFunction.GetHelpContent()

      $parameters = $parsedFunction.Body.ParamBlock.Parameters.Name.VariablePath.ForEach({ $_.ToString() })

      foreach ($parameter in $parameters)
      {
        $functionHelp.Parameters.($parameter.ToUpper()) | Should -Not -BeNullOrEmpty -Because ('the parameter {0} must have a description' -f $parameter)
        $functionHelp.Parameters.($parameter.ToUpper()).Length |
          Should -BeGreaterThan 25 -Because ('the parameter {0} must have descriptive description' -f $parameter)
      }
    }
    #>
  }
}