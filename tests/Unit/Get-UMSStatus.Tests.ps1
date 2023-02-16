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
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession'

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

      It 'Get-UMSStatus Should not throw' {
        { Get-UMSStatus } | Should -Not -Throw
      }

      It 'Get-UMSStatus -ApiVersion 10 Stop Should throw' {
        { Get-UMSStatus -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }
    }

    Context "All" {

      Mock 'Invoke-UMSRestMethod' {
        [pscustomobject]@{
          rmGuiServerVersion = '6.01.100'
          buildNumber        = '40023'
          activeMQVersion    = '5.6.0'
          derbyVersion       = '10.12.1.1'
          serverUUID         = '472dc383-45d2-47ec-9743-c3441c461425'
          server             = 'igelrmserver.acme.org'
        }
      }

      $Result = Get-UMSStatus

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

      It 'Result.BuildNumber should be exactly 40023' {
        $Result.BuildNumber | Should Be 40023
      }

      It 'Result.BuildNumber should have type [Int]' {
        $Result.BuildNumber | Should -HaveType [Int]
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethod' { throw 'Error' }

      It 'should throw Error' {
        { Get-UMSStatus } | Should throw 'Error'
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
  }

  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = New-UMSAPICookie
  }

  Context "ParameterSetName Default" {

    $TestCfg = (($Cfg.Tests).where{ $_.Name -eq $ScriptName }).ParameterSets.Default

    It "doesn't throw" {
      { $Script:Result = Get-UMSStatus } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result.RmGuiServerVersion[0] should have type [Version]' {
      $Result.RmGuiServerVersion[0] | Should -HaveType [Version]
    }

    It 'Result.BuildNumber[0] should have type [Int]' {
      $Result.BuildNumber[0] | Should -HaveType [Int]
    }

    It 'Result.activeMQVersion[0] should have type [Version]' {
      $Result.activeMQVersion[0] | Should -HaveType [Version]
    }

    It 'Result.derbyVersion[0] should have type [Version]' {
      $Result.derbyVersion[0] | Should -HaveType [Version]
    }

    It 'Result.serverUUID[0] should have type [Char]' {
      $Result.serverUUID[0] | Should -HaveType [Char]
    }

    It 'Result.server[0] should have type [Char]' {
      $Result.server[0] | Should -HaveType [Char]
    }

    It "Result should be Equivalent to Expected" {
      $Expected = foreach ($item In $TestCfg.Expected)
      {
        New-Object psobject -Property $item
      }
      Assert-Equivalent -Actual $Result -Expected $Expected -Options @{
        ExcludedPaths = $TestCfg.Options.ExcludedPaths
      }
    }

  }
}