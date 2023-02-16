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
    $KnownParameters = 'Computername', 'TCPPort', 'Credential', 'ApiVersion', 'SecurityProtocol'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
          Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    $User = "User"
    $PassWord = ConvertTo-SecureString -String "Password" -AsPlainText -Force
    $PSDefaultParameterValues = @{
      '*:Credential'   = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PassWord
      '*:Computername' = 'igelrmserver.acme.org'
    }

    Context "General Execution" {

      Mock 'Invoke-UMSRestMethod' {
        (
          [pscustomobject]@{
            message = 'JSESSIONID=3FB2F3F6A089FE9029DFD6DAFEF146DC'
          }
        )
      }

      It "New-UMSAPICookie" {
        { New-UMSAPICookie } | Should -Not -Throw
      }

      It 'New-UMSAPICookie -ApiVersion 10 -ErrorAction Stop Should throw' {
        { New-UMSAPICookie -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }

    }

    Context "All" {

      Mock 'Invoke-UMSRestMethod' {
        (
          [pscustomobject]@{
            message = 'JSESSIONID=3FB2F3F6A089FE9029DFD6DAFEF146DC'
          }
        )
      }

      $Result = New-UMSAPICookie

      It 'Assert Invoke-UMSRestMethod is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

      It 'Result should have type Microsoft.Powershell.Commands.Webrequestsession' {
        $Result | Should -HaveType ([Microsoft.Powershell.Commands.Webrequestsession])
      }

      It 'Result should have 1 element' {
        @($Result).Count | Should BeExactly 1
      }

      It 'Result[0].Cookies should have type [System.Net.CookieContainer]' {
        $Result[0].Cookies | Should -HaveType [System.Net.CookieContainer]
      }

      It 'Result[0].Cookies.Count should be exactly 1' {
        $Result[0].Cookies.Count | Should BeExactly 1
      }

    }

    Context "Error Handling" {

      Mock 'Invoke-RestMethod' { throw 'Error' }

      It 'should throw Error' -Skip {
        { 'New-UMSAPICookie -ErrorAction Stop' } | Should throw 'Error'
      } # cant get to throw

      It 'Result should be null or empty' -Skip {
        New-UMSAPICookie | Should BeNullOrEmpty
      } # only useful with above working
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

  Context "ParameterSetName Default" {

    It "doesn't throw" {
      { $Script:Result = New-UMSAPICookie } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result should have type [System.Object]' {
      $Result | Should -HaveType [System.Object]
    }

    It "Result.GetType().Name should be exactly WebRequestSession" {
      $Result.GetType().Name | Should -BeExactly 'WebRequestSession'
    }

    It 'Result[0].Cookies should have type [System.Net.CookieContainer]' {
      $Result[0].Cookies | Should -HaveType [System.Net.CookieContainer]
    }

    It 'Result[0].Cookies.Count should be exactly 1' {
      $Result[0].Cookies.Count | Should BeExactly 1
    }

    It "Result[0].Cookies.GetCookies('https://{0}' -f $($Cfg.Computername)).Name should have type [String]" {
      $Result[0].Cookies.GetCookies('https://{0}' -f $($Cfg.Computername)).Name | Should -HaveType [String]
    }

    It "Result[0].Cookies.GetCookies('https://{0}' -f $($Cfg.Computername)).Name should be exactly JSESSIONID" {
      $Result[0].Cookies.GetCookies('https://{0}' -f $($Cfg.Computername)).Name | Should BeExactly 'JSESSIONID'
    }

  }
}