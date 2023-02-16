$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:ScriptName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

Describe "$Script:ScriptName Unit Tests" -Tag 'UnitTests' {

  Context "Basics" {

    It "Is valid Powershell (Has no script errors)" {
      $Content = Get-Content -Path ( '{0}\Public\{1}.ps1' -f $Script:ModuleRoot, $Script:ScriptName) -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($Content, [ref]$ErrorColl)
      $ErrorColl | Should -HaveCount 0
    }

    [object[]]$params = (Get-ChildItem function:\$Script:ScriptName).Parameters.Keys
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession', 'Id', 'Name',
    'Site', 'Department', 'CostCenter', 'LastIP', 'Comment', 'AssetId', 'InserviceDate', 'SerialNumber'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
          Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    $PSDefaultParameterValues = @{
      '*:WebSession'   = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
      '*:Computername' = 'igelrmserver.acme.org'
    }

    Context "General Execution" {

      Mock 'Invoke-UMSRestMethod' { }

      It "Update-UMSDevice -Id 2 -Name 'NameNew' Should not throw" {
        { Update-UMSDevice -Id 2 -Name 'NameNew' } | Should -Not -Throw
      }

      It "Update-UMSDevice -Id 2 -Name 'NameNew' -ApiVersion 10 Stop Should throw" {
        { Update-UMSDevice -Id 2 -Name 'NameNew' -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }

      It "Update-UMSDevice -Id 2 Should throw" {
        { Update-UMSDevice -Id 2 } | Should -Throw
      }

    }

    Context "ParameterSet Set" {

      Mock 'Invoke-UMSRestMethod' {
        (
          [pscustomobject]@{
            message = 'Update successful'
          }
        )
      }

      $Params = @{
        Id            = 2
        Name          = 'NameNew'
        Site          = 'NewSite'
        Department    = 'NewDepartment'
        CostCenter    = 'NewCostCenter'
        LastIP        = '192.168.0.1'
        Comment       = 'NewComment'
        AssetId       = 'NewAssetId'
        InserviceDate = 'NewInserviceDate'
        SerialNumber  = '012345678901234567'
      }
      $Result = Update-UMSDevice @Params

      It 'Assert Invoke-UMSRestMethod is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

      It 'Result should have type pscustomobject' {
        $Result | Should -HaveType ([pscustomobject])
      }

      It 'Result should have 1 element' {
        @($Result).Count | Should BeExactly 1
      }

      It 'Result[0] should have type [pscustomobject]' {
        $Result[0] | Should -HaveType [pscustomobject]
      }

      It 'Result[0].Id should be exactly 2' {
        $Result[0].Id | Should BeExactly 2
      }

      It 'Result[0].Id should have type [Int]' {
        $Result[0].Id | Should -HaveType [Int]
      }

      It "Result[0].Message should be exactly 'Update successful.'" {
        $Result[0].Message | Should BeExactly 'Update successful.'
      }
    }

    Context "Whatif" {

      Mock 'Invoke-UMSRestMethod' { }

      $Result = Update-UMSDevice -Id 2 -Name 'NameNew' -WhatIf

      It 'Assert Invoke-UMSRestMethod is called exactly 0 times' {
        $AMCParams = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 0
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethod' { throw 'Error' }

      It "Update-UMSDevice -Id 2 -Name 'NameNew' -ApiVersion 10 -ErrorAction Stop should throw Error" {
        { Update-UMSDevice -Id 2 -Name 'NameNew' -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }

    }
  }
}

Describe "$Script:ScriptName Integration Tests" -Tag "IntegrationTests" {
  $Cfg = Import-PowerShellDataFile -Path ('{0}\Tests\Config.psd1' -f $Script:ProjectRoot)
  if ($IsLinux)
  {
    $Credential = Import-Clixml -Path $Cfg.CredPathWsl
  }
  else
  {
    $Credential = Import-Clixml -Path $Cfg.CredPath
  }

  $PSDefaultParameterValues = @{
    '*-UMS*:Credential'       = $Credential
    '*-UMS*:Computername'     = $Cfg.Computername
    '*-UMS*:TCPPort'          = $Cfg.TCPPort
    '*-UMS*:SecurityProtocol' = $Cfg.SecurityProtocol
    '*-UMS*:Confirm'          = $False
  }

  $WebSession = New-UMSAPICookie
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ParameterSetName Default" {

    $TestCfg = (($Cfg.Tests).where{ $_.Name -eq $ScriptName }).ParameterSets.Default

    It "doesn't throw" {
      $Params1 = $TestCfg.Params1
      $Params2 = $TestCfg.Params2
      $Params3 = $TestCfg.Params3
      $Params4 = $TestCfg.Params4
      { $Script:Result = @(
          Update-UMSDevice @Params1
          Update-UMSDevice @Params2
          Update-UMSDevice @Params3
          Update-UMSDevice @Params4
        ) } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should have type [Int]' {
      $Result[0].Id | Should -HaveType [Int]
    }

    It 'Result[0].Message should have type [String]' {
      $Result[0].Message | Should -HaveType [String]
    }

    It "Result should be Equivalent to Expected" {
      [array]$Expected = foreach ($item In $TestCfg.Expected)
      {
        New-Object psobject -Property $item
      }
      Assert-Equivalent -Actual $Result -Expected $Expected -Options @{
        ExcludedPaths = $TestCfg.Options.ExcludedPaths
      }
    }
  }
}