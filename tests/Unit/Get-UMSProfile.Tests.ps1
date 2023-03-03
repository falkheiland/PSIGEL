BeforeDiscovery {
  $DSC = [IO.Path]::DirectorySeparatorChar
  $ProjectRoot = Resolve-Path ('{0}{1}..{1}..' -f $PSScriptRoot, $DSC)
  $ModuleRoot = Split-Path (Resolve-Path ('{0}{1}*{1}*.psm1' -f $ProjectRoot, $DSC))
  $ModuleName = (Get-ChildItem $ProjectRoot\*\*.psd1 | Where-Object {
  ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
      $(try
        {
          Test-ModuleManifest $_.FullName -ErrorAction Stop
        }
        catch
        {
          $false
        }) }
  ).BaseName
  $FunctionName = ($PSCommandPath.Split("$DSC")[-1]).Replace('.Tests.ps1', '')
  $AddSwitchParameters = @(
    'Components',
    'Documents',
    'Floors',
    'History'
  )
}

BeforeAll {
  $DSC = [IO.Path]::DirectorySeparatorChar
  $ProjectRoot = Resolve-Path ('{0}{1}..{1}..' -f $PSScriptRoot, $DSC)
  $ModuleRoot = Split-Path (Resolve-Path ('{0}{1}*{1}*.psm1' -f $ProjectRoot, $DSC))
  $ModuleName = (Get-ChildItem $ProjectRoot\*\*.psd1 | Where-Object {
  ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
      $(try
        {
          Test-ModuleManifest $_.FullName -ErrorAction Stop
        }
        catch
        {
          $false
        }) }
  ).BaseName
  $FunctionName = ($PSCommandPath.Split("$DSC")[-1]).Replace('.Tests.ps1', '')
  . ('{0}{1}Public{1}{2}' -f $ModuleRoot, $DSC, $FunctionName)
  . ('{0}{1}Private{1}Invoke-UMSRestMethod.ps1' -f $ModuleRoot, $DSC)
  $Content = Get-Content -Path ( '{0}{1}Public{1}{2}.ps1' -f $ModuleRoot, $DSC, $FunctionName) -ErrorAction Stop
  [object[]]$ActualParameters = (Get-ChildItem function:\$FunctionName).Parameters.Keys
  $KnownParameters = @(
    'Computername',
    'TCPPort',
    'SecurityProtocol',
    'WebSession',
    'Id'
  )
}

Describe "$FunctionName Unit Tests" -Tag 'UnitTests' {
  BeforeAll {
    $PSDefaultParameterValues = @{
      '*:WebSession'   = 'WebSession'
      '*:Computername' = 'Computername'
      '*:Confirm'      = $false
    }
  }
  Context 'Basics' {
    It 'Should contain our specific parameters' {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $ActualParameters -IncludeEqual |
          Where-Object SideIndicator -EQ '==').Count) | Should -Be $KnownParameters.Count
    }
  }
  Context 'ParameterSetName All' {
    BeforeAll {
      Mock 'Invoke-UMSRestMethod' {
        [PSCustomObject]@{
          SyncRoot = @(
            [PSCustomObject]@{
              Int    = 1
              String = 'String1'
            },
            [PSCustomObject]@{
              Int    = 2
              String = 'String2'
            }
          )
        }
      }
      $result = . $FunctionName
    }

    It 'Assert Invoke-UMSRestMethod is called exactly 1 time' {
      $params = @{
        CommandName = 'Invoke-UMSRestMethod'
        Times       = 1
        Exactly     = $true
        Scope       = 'Context'
      }
      Should -Invoke @params
    }

    It '$result.Count | Should -BeGreaterThan 0' {
      $result.Count | Should -BeGreaterThan 0
    }
  }
  Context 'ParameterSetName Id' {
    BeforeAll {
      Mock 'Invoke-UMSRestMethod' {
        [PSCustomObject]@{
          Int    = 1
          String = 'String1'
        },
        [PSCustomObject]@{
          Int    = 2
          String = 'String2'
        }
      }
    }
    Context 'No Pipeline' {
      BeforeAll {
        $result = . $FunctionName -Id 1, 2
      }
      It 'Assert Invoke-UMSRestMethod is called exactly 2 times' {
        $params = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 2
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }
      It "$result[1].Int | Should -Be 2" {
        $result[1].Int | Should -Be 2
      }
    }
    Context 'ValueFromPipeline' {
      BeforeAll {
        $result = 1, 2 | . $FunctionName
      }
      It 'Assert Invoke-UMSRestMethod is called exactly 2 times' {
        $params = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 2
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }
      It "$result[1].Int | Should -Be 2" {
        $result[1].Int | Should -Be 2
      }
    }
    Context 'ValueFromPipelineByPropertyName' {
      BeforeAll {
        $result = @(
          [PSCustomObject]@{
            Id     = 1
            String = 'String1'
          },
          [PSCustomObject]@{
            Id     = 2
            String = 'String2'
          }
        ) | . $FunctionName
      }
      It 'Assert Invoke-UMSRestMethod is called exactly 2 times' {
        $params = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 2
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }
      It "$result[1].Int | Should -Be 2" {
        $result[1].Int | Should -Be 2
      }
    }
  }

  Context 'ParameterSetName <_>' -ForEach $AddSwitchParameters {
    BeforeAll {
      Mock 'Invoke-UMSRestMethod' {
        [PSCustomObject]@{
          Items = @(
            [PSCustomObject]@{
              Int    = 1
              String = 'String1'
            },
            [PSCustomObject]@{
              Int    = 2
              String = 'String2'
            }
          )
        }
      }
    }
    Context 'No Pipeline' {
      BeforeAll {
        $params = @{
          Id = 1, 2
          $_ = $true
        }
        $result = . $FunctionName @params
      }
      It 'Assert Invoke-UMSRestMethod is called exactly 2 times' {
        $params = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 2
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }
      It "$result[1].Int | Should -Be 2" {
        $result[1].Int | Should -Be 2
      }
    }
    Context 'ValueFromPipeline' {
      BeforeAll {
        $params = @{
          $_ = $true
        }
        $result = 1, 2 | . $FunctionName @params
      }
      It 'Assert Invoke-UMSRestMethod is called exactly 2 times' {
        $params = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 2
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }
      It "$result[1].Int | Should -Be 2" {
        $result[1].Int | Should -Be 2
      }
    }
    Context 'ValueFromPipelineByPropertyName' {
      BeforeAll {
        $params = @{
          $_ = $true
        }
        $result = @(
          [PSCustomObject]@{
            Id     = 1
            String = 'String1'
          },
          [PSCustomObject]@{
            Id     = 2
            String = 'String2'
          }
        ) | . $FunctionName @params
      }
      It 'Assert Invoke-UMSRestMethod is called exactly 2 times' {
        $params = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 2
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }
      It "$result[1].Int | Should -Be 2" {
        $result[1].Int | Should -Be 2
      }
    }
  }

  Context 'Error Handling' {
    BeforeAll {
      Mock 'Invoke-UMSRestMethod' {
        throw 'Error'
      }
    }
    It 'should throw Error' {
      {
        . $FunctionName
      } | Should -Throw 'Error'
    }
  }
}

AfterAll {
}