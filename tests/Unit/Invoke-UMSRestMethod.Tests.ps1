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

      [object[]]$params = (Get-ChildItem function:\$Script:ScriptName).Parameters.Keys
      $KnownParameters = 'WebSession', 'SecurityProtocol', 'Uri', 'Body', 'ContentType', 'Headers', 'Method'

      It "Should contain our specific parameters" {
        (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
      }
    }
  }

  InModuleScope $Script:ModuleName {

    $PSDefaultParameterValues = @{
      #'*:WebSession'       = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
      '*:WebSession'       = New-MockObject -Type 'Microsoft.PowerShell.Commands.WebRequestSession'
      '*:SecurityProtocol' = 'Tls12'
      #'*:Uri'              = 'Uri'
      '*:Uri'              = 'https://igelrmserver/api/'
      #'*:Body'             = 'Body'
      #'*:ContentType'      = 'ContentType'
      #'*:Headers'          = @{ }
      '*:Method'           = 'Get'
    }

    Context "Desktop General Execution" {

      Mock 'Invoke-RestMethod' {
        [pscustomobject]@{ }
      }

      It "Invoke-UMSRestMethod Should not throw" {
        { Invoke-UMSRestMethod } | Should -Not -Throw
      }

      It "Invoke-UMSRestMethod -Method 'nonexisting' -ErrorAction Stop Should throw" {
        { Invoke-UMSRestMethod -Method 'nonexisting' -ErrorAction Stop } | Should -Throw
      }

    }

    Switch (Get-Variable -Name PSEdition -ValueOnly)
    {
      'Desktop'
      {

        Context "Desktop Desktop:Invoke-UMSRestMethod" {

          Mock 'Get-Variable' {
            'Desktop'
          }

          Mock 'Invoke-RestMethod' {
            [pscustomobject]@{ Test = 'Test' }
          }

          $Result = Invoke-UMSRestMethod

          It 'Assert Invoke-RestMethod is called exactly 1 time' {
            $AMCParams = @{
              CommandName = 'Invoke-RestMethod'
              Times       = 1
              Exactly     = $true
            }
            Assert-MockCalled @AMCParams
          }

          It 'Result should have type PSCustomObject' {
            $Result | Should -HaveType ([PSCustomObject])
          }

          It 'Result should have 1 element' {
            @($Result).Count | Should BeExactly 1
          }

          It "Result.Test should be exactly 'Test'" {
            $Result.Test | Should BeExactly 'Test'
          }
        }
        Mock 'Get-Variable' {
          'Desktop'
        }
      }
      'Core'
      {
        Mock 'Get-Variable' {
          'Core'
        }
        Context "Core Invoke-RestMethod" {

          Mock 'Invoke-RestMethod' {
            [pscustomobject]@{ Test = 'Test' }
          }

          $Result = Invoke-UMSRestMethod

          It 'Assert Invoke-RestMethod is called exactly 1 time' {
            $AMCParams = @{
              CommandName = 'Invoke-RestMethod'
              Times       = 1
              Exactly     = $true
            }
            Assert-MockCalled @AMCParams
          }

          It 'Result should have type PSCustomObject' {
            $Result | Should -HaveType ([PSCustomObject])
          }

          It 'Result should have 1 element' {
            @($Result).Count | Should BeExactly 1
          }

          It "Result.Test should be exactly 'Test'" {
            $Result.Test | Should BeExactly 'Test'
          }
        }
      }
    }

    Context "Mock an exception" {

      Mock 'Invoke-RestMethod' {
        [System.Net.WebException]::new('400') |
        Add-Member -NotePropertyName Response -PassThru -Force -NotePropertyValue (
          [PSCustomObject]@{ StatusCode = [System.Net.HttpStatusCode]::BadRequest }
        ) # work in progress
      }

      It Invoke-UMSRestMethod' should throw' -Skip {
        { Invoke-UMSRestMethod } | Should Throw 'some error'
      } # makes no sense without above
    }

  }
}
