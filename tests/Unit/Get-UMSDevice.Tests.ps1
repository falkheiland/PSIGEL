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
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession', 'Filter', 'Id'

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

      It 'Get-UMSDevice Should not throw' {
        { Get-UMSDevice } | Should -Not -Throw
      }

      It 'Get-UMSDevice -Details Error -ErrorAction Stop Should throw' {
        { Get-UMSDevice -Details Error -ErrorAction Stop } | Should -Throw
      }

    }

    Context "ParameterSetName All" {

      Mock 'Invoke-UMSRestMethod' {
        [pscustomobject]@{
          SyncRoot = @{
            mac        = '0123456789AB'
            firmwareID = '1'
            lastIP     = '192.168.0.1'
            id         = '2'
            name       = 'device01'
            parentID   = '3'
            movedToBin = 'False'
            objectType = 'tc'
            links      = '{}'
          }
        }
      }
      Mock 'New-UMSFilterString' { }

      $Result = Get-UMSDevice

      It 'Assert New-UMSFilterString is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'New-UMSFilterString'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

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

      It 'Result.Id should be exactly 2' {
        $Result.Id | Should BeExactly 2
      }

      It 'Result.Id should have type [Int]' {
        $Result.Id | Should -HaveType [Int]
      }
    }

    Context "ParameterSetName ID" {

      Mock 'Invoke-UMSRestMethod' {
        [pscustomobject]@{
          mac        = '0123456789AB'
          firmwareID = '1'
          lastIP     = '192.168.0.1'
          id         = '2'
          name       = 'device01'
          parentID   = '3'
          movedToBin = 'False'
          objectType = 'tc'
          links      = '{}'
        }
      }
      Mock 'New-UMSFilterString' { }

      $Result = Get-UMSDevice -Id 2

      It 'Assert New-UMSFilterString is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'New-UMSFilterString'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

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

      It 'Result.Id should be exactly 2' {
        $Result.Id | Should BeExactly 2
      }

      It 'Result.Id should have type [Int]' {
        $Result.Id | Should -HaveType [Int]
      }
    }

    Context "Filter online" {

      Mock 'Invoke-UMSRestMethod' {
        [pscustomobject]@{
          mac        = '0123456789AB'
          firmwareID = '1'
          lastIP     = '192.168.0.1'
          online     = 'False'
          id         = '2'
          name       = 'device01'
          parentID   = '3'
          movedToBin = 'False'
          objectType = 'tc'
        }
      }
      Mock 'New-UMSFilterString' { }

      $Result = Get-UMSDevice -Id 2 -Filter online

      It 'Assert New-UMSFilterString is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'New-UMSFilterString'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

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

      It 'Result.Online should be exactly $false' {
        $Result.Online | Should Be $false
      }

      It 'Result.Online should have type [bool]' {
        $Result.Online | Should -HaveType [bool]
      }
    }

    Context "Filter shadow" {

      Mock 'Invoke-UMSRestMethod' {
        [pscustomobject]@{
          mac          = '0123456789AB'
          firmwareID   = '1'
          lastIP       = '192.168.0.1'
          shadowSecret = @{
            certificate = '-----BEGIN CERTIFICATE-----..-----END CERTIFICATE-----'
            password    = '80a4f77b-552e-488d-b077-4f34ac59028e'
          }
          id           = '2'
          name         = 'device01'
          parentID     = '3'
          movedToBin   = 'False'
          objectType   = 'tc'
        }
      }
      Mock 'New-UMSFilterString' { }

      $Result = Get-UMSDevice -Id 2 -Filter shadow

      It 'Assert New-UMSFilterString is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'New-UMSFilterString'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

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

      It 'Result.ShadowSecret should have type [pscustomobject]' {
        $Result.ShadowSecret | Should -HaveType [pscustomobject]
      }
    }

    Context "Filter details" {

      Mock 'Invoke-UMSRestMethod' {
        [pscustomobject]@{
          mac                       = '0123456789AB'
          firmwareID                = '1'
          lastIP                    = '192.168.0.1'
          comment                   = 'comment'
          productId                 = 'UC1-LX'
          cpuSpeed                  = '1608'
          cpuType                   = 'Intel(R) Core(TM) i7-7Y75 CPU @ 1.30GHz'
          deviceType                = 'Legacy x86 system'
          deviceSerialNumber        = '0'
          osType                    = 'IGEL Linux 11 (Kernel Version 4.18.20)'
          flashSize                 = '1985'
          memorySize                = '1990'
          networkSpeed              = '100'
          graphicsChipset0          = 'VMware Inc. Abstract VGA II Adapter'
          graphicsChipset1          = ''
          monitorVendor1            = ''
          monitorModel1             = ''
          monitorSerialnumber1      = ''
          monitorNativeResolution1  = ''
          monitor1YearOfManufacture = ''
          monitor1WeekOfManufacture = ''
          monitorVendor2            = ''
          monitorModel2             = ''
          monitorSerialnumber2      = ''
          monitorSize2              = '0,0'
          monitorNativeResolution2  = ''
          monitor2YearOfManufacture = ''
          monitor2WeekOfManufacture = ''
          biosVendor                = 'innotek GmbH'
          biosVersion               = 'VirtualBox'
          biosDate                  = '12/01/2006'
          totalUsagetime            = '5433000'
          totalUptime               = '5472000'
          lastBoottime              = '2019-02-20 14:19'
          batteryLevel              = '97'
          id                        = '2'
          name                      = 'device01'
          parentID                  = '3'
          movedToBin                = 'False'
          objectType                = 'tc'
        }
      }
      Mock 'New-UMSFilterString' { }

      $Result = Get-UMSDevice -Id 2 -Filter details

      It 'Assert New-UMSFilterString is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'New-UMSFilterString'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

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

      It 'Result.NetworkSpeed should have type [Int]' {
        $Result.NetworkSpeed | Should -HaveType [Int]
      }

      It 'Result.LastBoottime should have type [datetime]' {
        $Result.LastBoottime | Should -HaveType [datetime]
      }
    }

    Context "Filter details no datetime" {

      Mock 'Invoke-UMSRestMethod' {
        [pscustomobject]@{
          mac                       = '0123456789AB'
          firmwareID                = '1'
          lastIP                    = '192.168.0.1'
          comment                   = 'comment'
          productId                 = 'UC1-LX'
          cpuSpeed                  = '1608'
          cpuType                   = 'Intel(R) Core(TM) i7-7Y75 CPU @ 1.30GHz'
          deviceType                = 'Legacy x86 system'
          deviceSerialNumber        = '0'
          osType                    = 'IGEL Linux 11 (Kernel Version 4.18.20)'
          flashSize                 = '1985'
          memorySize                = '1990'
          networkSpeed              = '100'
          graphicsChipset0          = 'VMware Inc. Abstract VGA II Adapter'
          graphicsChipset1          = ''
          monitorVendor1            = ''
          monitorModel1             = ''
          monitorSerialnumber1      = ''
          monitorNativeResolution1  = ''
          monitor1YearOfManufacture = ''
          monitor1WeekOfManufacture = ''
          monitorVendor2            = ''
          monitorModel2             = ''
          monitorSerialnumber2      = ''
          monitorSize2              = '0,0'
          monitorNativeResolution2  = ''
          monitor2YearOfManufacture = ''
          monitor2WeekOfManufacture = ''
          biosVendor                = 'innotek GmbH'
          biosVersion               = 'VirtualBox'
          biosDate                  = ''
          totalUsagetime            = '5433000'
          totalUptime               = '5472000'
          lastBoottime              = ''
          batteryLevel              = '97'
          id                        = '2'
          name                      = 'device01'
          parentID                  = '3'
          movedToBin                = 'False'
          objectType                = 'tc'
        }
      }
      Mock 'New-UMSFilterString' { }

      $Result = Get-UMSDevice -Id 2 -Filter details

      It 'Assert New-UMSFilterString is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'New-UMSFilterString'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

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

      It 'Result.BiosDate should be null or empty' {
        $Result.BiosDate | Should -BeNullOrEmpty
      }

      It 'Result.LastBoottime should be null or empty' {
        $Result.LastBoottime | Should -BeNullOrEmpty
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethod' { throw 'Error' }

      It 'should throw Error' {
        { Get-UMSDevice } | Should throw 'Error'
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
    if ($IsLinux)
    {
      $Credential = Import-Clixml -Path $Cfg.CredPathWsl
    }
    else
    {
      $Credential = Import-Clixml -Path $Cfg.CredPath
    }
  }
  else
  {
    if ($IsLinux)
    {
      $Credential = Import-Clixml -Path $Cfg.CredPathWsl
    }
    else
    {
      $Credential = Import-Clixml -Path $Cfg.CredPath
    }
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
      { $Script:Result = @(
          Get-UMSDevice
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

    It 'Result[0].MovedToBin should have type [Bool]' {
      $Result[0].MovedToBin | Should -HaveType [Bool]
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

  Context "ParameterSetName Details" {

    $Script:Result = ''
    $TestCfg = (($Cfg.Tests).where{ $_.Name -eq $ScriptName }).ParameterSets.Details

    It "doesn't throw" {
      $Params1 = $TestCfg.Params1
      { $Script:Result = @(
          Get-UMSDevice @Params1
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

    It 'Result[0].MovedToBin should have type [Bool]' {
      $Result[0].MovedToBin | Should -HaveType [Bool]
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

  Context "ParameterSetName Online" {

    $Script:Result = ''
    $TestCfg = (($Cfg.Tests).where{ $_.Name -eq $ScriptName }).ParameterSets.Online

    It "doesn't throw" {
      $Params1 = $TestCfg.Params1
      { $Script:Result = @(
          Get-UMSDevice @Params1
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

    It 'Result[0].MovedToBin should have type [Bool]' {
      $Result[0].MovedToBin | Should -HaveType [Bool]
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