$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:ScriptName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

Describe "$Script:ScriptName Unit Tests" -Tag 'UnitTests' {

  BeforeAll {
    if ($null -ne $Result)
    {
      Clear-Variable -Name $Result -ErrorAction SilentlyContinue
      $Script:Result = ''
    }
  }

  Context "Basics" {

    It "Is valid Powershell (Has no script errors)" {
      $Content = Get-Content -Path ( '{0}\Public\{1}.ps1' -f $Script:ModuleRoot, $Script:ScriptName) -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($Content, [ref]$ErrorColl)
      $ErrorColl | Should -HaveCount 0
    }

    [object[]]$params = (Get-ChildItem function:\$Script:ScriptName).Parameters.Keys
    $KnownParameters = 'Id', 'DirectoryColl', 'ElementColl'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
          Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    <#
    $PSDefaultParameterValues = @{
      '*:Id'            = 999
      '*:DirectoryColl' = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
      '*:ElementColl'   = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
    }
    #>

    Context "General Execution" {

      $Script:Result = ''

      Mock 'Get-UMSDirectoryRecursive' { }

      It 'Get-UMSDirectoryRecursive Should not throw' {
        { Get-UMSDirectoryRecursive -Id 99 -DirectoryColl @{ } } | Should -Not -Throw
      }

      It 'Get-UMSDirectoryRecursive -ApiVersion 10 Stop Should throw' {
        { Get-UMSDirectoryRecursive -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }

    }

    Context "Mock Get-UMSDirectoryRecursive" {

      $Script:Result = ''

      $DirectoryColl = @(
        [pscustomobject]@{
          Id         = 99
          Name       = 'Directory1'
          ParentId   = 9
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        },
        [pscustomobject]@{
          Id         = 999
          Name       = 'Directory11'
          ParentId   = 99
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        },
        [pscustomobject]@{
          Id         = 9999
          Name       = 'Directory111'
          ParentId   = 999
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        }
      )
      Mock 'Get-UMSDirectoryRecursive' { $DirectoryColl }

      Get-UMSDirectoryRecursive -Id 99 -DirectoryColl $DirectoryColl

      It 'Assert Get-UMSDirectoryRecursive is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'Get-UMSDirectoryRecursive'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }
    }
    #>

    #<#
    Context "ParameterSetName Directory" {

      $Script:Result = ''

      $DirectoryColl = @(
        [pscustomobject]@{
          Id         = 99
          Name       = 'Directory1'
          ParentId   = 9
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        },
        [pscustomobject]@{
          Id         = 999
          Name       = 'Directory11'
          ParentId   = 99
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        },
        [pscustomobject]@{
          Id         = 9999
          Name       = 'Directory111'
          ParentId   = 999
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        },
        [pscustomobject]@{
          Id         = 8888
          Name       = 'Directory888'
          ParentId   = 888
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        }
      )

      It "doesn't throw" {
        { $Script:Result = Get-UMSDirectoryRecursive -Id 99 -DirectoryColl $DirectoryColl } | Should Not Throw
      }

      It 'Result should not be null or empty' {
        $Result | Should not BeNullOrEmpty
      }

      It 'Result should have type pscustomobject' {
        $Result | Should -HaveType ([pscustomobject])
      }

      It 'Result should have 3 elements' {
        @($Result).Count | Should BeExactly 3
      }

      It 'Result.Id should mot contain 8888' {
        $Result.Id | Should Not Contain 8888
      }

      It 'Result[0].Id should be exactly 99' {
        $Result[0].Id | Should Be 99
      }

      It 'Result[0].Id should have type [Int]' {
        $Result[0].Id | Should -HaveType [Int]
      }
    }

    Context "ParameterSetName Element" {

      $Script:Result = ''

      $DirectoryColl = @(
        [pscustomobject]@{
          Id         = 99
          Name       = 'Directory1'
          ParentId   = 9
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        },
        [pscustomobject]@{
          Id         = 999
          Name       = 'Directory11'
          ParentId   = 99
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        },
        [pscustomobject]@{
          Id         = 9999
          Name       = 'Directory111'
          ParentId   = 999
          MovedToBin = 'False'
          ObjectType = 'tcdirectory'
        }
      )
      $ElementColl = @(
        [pscustomobject]@{
          Id         = 11
          ObjectType = 'tc'
          UnitId     = '112233445566'
          Mac        = '112233445566'
          Name       = 'Element1'
          ParentId   = 99
          FirmwareId = 2
          LastIp     = ''
          MovedToBin = 'False'
        },
        [pscustomobject]@{
          Id         = 111
          ObjectType = 'tc'
          UnitId     = '223344556677'
          Mac        = '223344556677'
          Name       = 'Element11'
          ParentId   = 999
          FirmwareId = 2
          LastIp     = ''
          MovedToBin = 'False'
        },
        [pscustomobject]@{
          Id         = 1111
          ObjectType = 'tc'
          UnitId     = '334455667788'
          Mac        = '334455667788'
          Name       = 'Element111'
          ParentId   = 9999
          FirmwareId = 2
          LastIp     = ''
          MovedToBin = 'False'
        },
        [pscustomobject]@{
          Id         = 8888
          ObjectType = 'tc'
          UnitId     = '445566778899'
          Mac        = '445566778899'
          Name       = 'Element888'
          ParentId   = 888
          FirmwareId = 2
          LastIp     = ''
          MovedToBin = 'False'
        }
      )

      It "doesn't throw" {
        { $Script:Result = Get-UMSDirectoryRecursive -Id 99 -DirectoryColl $DirectoryColl -ElementColl $ElementColl } | Should Not Throw
      }

      It 'Result should have type pscustomobject' {
        $Result | Should -HaveType ([pscustomobject])
      }

      It 'Result should have 3 elements' {
        @($Result).Count | Should BeExactly 3
      }

      It 'Result.Id should mot contain 8888' {
        $Result.Id | Should Not Contain 8888
      }

      It 'Result[0].Name should be Element1' {
        $Result[0].Name | Should Be 'Element1'
      }

      It 'Result[0].Id should be 11' {
        $Result[0].Id | Should Be 11
      }

      It 'Result[0].ObjectType should be tc' {
        $Result[0].ObjectType | Should be 'tc'
      }

      It 'Result[0].Id should have type [Int]' {
        $Result[0].Id | Should -HaveType [Int]
      }
    }

    Context "Error Handling" {

      $Script:Result = ''
      Write-Host $Result

      Mock 'Get-UMSDirectoryRecursive' { throw 'Error' }

      It 'should throw Error' {
        { $Script:Result = Get-UMSDirectoryRecursive -Id 99 -DirectoryColl @{ } -ElementColl @{ } } | Should throw 'Error'
      }

      It 'Result should be null or empty' {
        $Script:Result | Should BeNullOrEmpty
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
      $Params1.Add('DirectoryColl', (Get-UMSDeviceDirectory))
      { $Script:Result = @(
          Get-UMSDirectoryRecursive @Params1
        ) } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should have type [Int]' {
      $Result[0].Id | Should -HaveType [Int]
    }

    It 'Result[0].Name should have type [String]' {
      $Result[0].Name | Should -HaveType [String]
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

  Context "ParameterSetName Element" {

    $Script:Result = ''
    $TestCfg = (($Cfg.Tests).where{ $_.Name -eq $ScriptName }).ParameterSets.Element

    It "doesn't throw" {
      $Params1 = $TestCfg.Params1
      $Params1.Add('DirectoryColl', (Get-UMSDeviceDirectory))
      $Params1.Add('ElementColl', (Get-UMSDevice))
      { $Script:Result = @(
          Get-UMSDirectoryRecursive @Params1
        ) } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should have type [Int]' {
      $Result[0].Id | Should -HaveType [Int]
    }

    It 'Result[0].Name should have type [String]' {
      $Result[0].Name | Should -HaveType [String]
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