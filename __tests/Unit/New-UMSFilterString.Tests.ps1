$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:ScriptName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

Describe "$Script:ScriptName Unit Tests" -Tag 'UnitTests' {

  Context "Basics" {

    It "Is valid Powershell (Has no script errors)" {
      $Content = Get-Content -Path ( '{0}\Private\{1}.ps1' -f $Script:ModuleRoot, $Script:ScriptName) -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($Content, [ref]$ErrorColl)
      $ErrorColl | Should -HaveCount 0
    }

    InModuleScope $Script:ModuleName {

      [object[]]$params = (Get-ChildItem function:\$Content).Parameters.Keys
      $KnownParameters = 'Filter'

      It "Should contain our specific parameters" {
        (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
      }
    }
  }

  InModuleScope $Script:ModuleName {

    Context "General Execution" {

      It "New-UMSFilterString -Filter 'short' Should not throw" {
        { New-UMSFilterString -Filter 'short' } | Should -Not -Throw
      }

      It "New-UMSFilterString -Filter 'nonexisting' -ErrorAction Stop Should throw" {
        { New-UMSFilterString -Filter 'nonexisting' -ErrorAction Stop } | Should -Throw
      }

    }

    Context "Filter short" {

      $Result = New-UMSFilterString -Filter short

      It 'Result should have type String' {
        $Result | Should -HaveType ([String])
      }

      It 'Result should have 1 element' {
        @($Result).Count | Should BeExactly 1
      }

      It "Result should be exactly '?facets=short'" {
        $Result | Should BeExactly '?facets=short'
      }
    }

  }
}
