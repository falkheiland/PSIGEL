BeforeDiscovery {
  # $DSC = [IO.Path]::DirectorySeparatorChar
  # $ProjectRoot = Resolve-Path ('{0}{1}..{1}..' -f $PSScriptRoot, $DSC)
  # $ModuleRoot = Split-Path (Resolve-Path ('{0}{1}*{1}*.psm1' -f $ProjectRoot, $DSC))
  # $ModuleName = (Get-ChildItem $ProjectRoot\*\*.psd1 | Where-Object {
  # ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
  #     $(try
  #       {
  #         Test-ModuleManifest $_.FullName -ErrorAction Stop
  #       }
  #       catch
  #       {
  #         $false
  #       }) }
  # ).BaseName
  # $FunctionName = ($PSCommandPath.Split("$DSC")[-1]).Replace('.Tests.ps1', '')
  # $AddSwitchParameters = @(
  #   'Components',
  #   'Documents',
  #   'Floors',
  #   'History'
  # )
}

BeforeAll {
  $ProjectPath = Resolve-Path ('{0}\..\..' -f $PSScriptRoot)
  if (-not $ProjectName)
  {
    # Assuming project folder name is project name.
    $ProjectName = Get-SamplerProjectName -BuildRoot $ProjectPath
  }
  $ModuleRoot = Split-Path (Resolve-Path ('{0}\source\{1}.psm1' -f $ProjectPath, $ProjectName))
  $ModuleName = $ProjectName
  $FunctionName = ($PSCommandPath.Split('\')[-1]).Replace('.Tests.ps1', '')
  . ('{0}\Public\{1}' -f $ModuleRoot, $FunctionName)
  . ('{0}\Private\Invoke-UMSRestMethod.ps1' -f $ModuleRoot)
  $ContentColl = Get-Content -Path ( '{0}\Public\{1}.ps1' -f $ModuleRoot, $FunctionName) -ErrorAction Stop
  [object[]]$ActualParameters = (Get-ChildItem function:\$FunctionName).Parameters.Keys
  $KnownParameters = @(
    'Computername',
    'TCPPort',
    'SecurityProtocol',
    'WebSession',
    'Id'
  )
  $AddSwitchParameters = @(
  )
}

Describe 'Unit Tests' -Tag 'UnitTests_UT' {

  BeforeAll {
    $PSDefaultParameterValues = @{
      '*:WebSession'   = 'WebSession'
      '*:Computername' = 'Computername'
      '*:Confirm'      = $false
    }
    $Mock1 = 'Invoke-UMSRestMethod'
    $Mock1ObjSyncRoot = [PSCustomObject]@{
      SyncRoot = @(
        [PSCustomObject]@{
          Id     = 1
          String = 'String1'
        },
        [PSCustomObject]@{
          Id     = 2
          String = 'String2'
        }
      )
    }
    $Mock1Obj = [PSCustomObject]@(
      [PSCustomObject]@{
        Id     = 1
        String = 'String1'
      },
      [PSCustomObject]@{
        Id     = 2
        String = 'String2'
      }
    )
  }

  Context 'Parameter' -Tag 'UT_Basics' {
    It '[<FunctionName>] should contain parameters [<KnownParameters>]' {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $ActualParameters -IncludeEqual |
          Where-Object SideIndicator -EQ '==').Count) | Should -Be $KnownParameters.Count
    }
  }

  Context 'ParameterSetName [All]' -Tag 'UT_PSN_All' {

    BeforeAll {
      # $Mock1 = 'Invoke-UMSRestMethod'
      Mock $Mock1 {
        $Mock1ObjSyncRoot
      }
      $result = . $FunctionName
    }

    It 'Assert <Mock1> is called exactly <Mock1ObjSyncRoot.Count> time' {
      $params = @{
        CommandName = $Mock1
        Times       = $Mock1ObjSyncRoot.Count
        Exactly     = $true
        Scope       = 'Context'
      }
      Should -Invoke @params
    }

    It '$result.Count | Should -BeExactly <Mock1ObjSyncRoot.SyncRoot.Count>' {
      $result.Count | Should -BeExactly $Mock1ObjSyncRoot.SyncRoot.Count
    }

  }

  Context 'ParameterSetName [Id]' {

    BeforeAll {
      Mock $Mock1 {
        $Mock1Obj
      }
    }

    Context 'No Pipeline' {

      BeforeAll {
        $result = . $FunctionName -Id 1, 2
      }

      It 'Assert <Mock1> is called exactly <Mock1Obj.Count> times' {
        $params = @{
          CommandName = $Mock1
          Times       = $Mock1Obj.Count
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }

      It '$result[1].Id | Should -BeExactly <Mock1Obj[1].Id>' {
        $result[1].Id | Should -BeExactly $Mock1Obj[1].Id
      }

    }

    Context 'ValueFromPipeline' {

      BeforeAll {
        $result = 1, 2 | . $FunctionName
      }

      It 'Assert <Mock1> is called exactly <Mock1Obj.Count> times' {
        $params = @{
          CommandName = $Mock1
          Times       = $Mock1Obj.Count
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }

      It '$result[1].Id | Should -BeExactly <Mock1Obj[1].Id>' {
        $result[1].Id | Should -BeExactly $Mock1Obj[1].Id
      }

    }

    Context 'ValueFromPipelineByPropertyName' {

      BeforeAll {
        $InputObj = $Mock1Obj # the same structure and values, not the same thing though
        $result = $InputObj | . $FunctionName
      }

      It 'Assert <Mock1> is called exactly 2 times' {
        $params = @{
          CommandName = $Mock1
          Times       = $Mock1Obj.Count
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }

      It '$result[1].Id | Should -BeExactly <Mock1Obj[1].Id>' {
        $result[1].Id | Should -BeExactly $Mock1Obj[1].Id
      }

    }

  }

  Context 'ParameterSetName <_>' -ForEach $AddSwitchParameters {

    BeforeAll {
      Mock 'Invoke-UMSRestMethod' {
        [PSCustomObject]@{
          Items = @(
            [PSCustomObject]@{
              Id     = 1
              String = 'String1'
            },
            [PSCustomObject]@{
              Id     = 2
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

      It "$result[1].Id | Should -Be 2" {
        $result[1].Id | Should -Be 2
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

      It "$result[1].Id | Should -Be 2" {
        $result[1].Id | Should -Be 2
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

      It 'Assert Invoke-UMSRestMethod<Mock1> is called exactly 2 times' {
        $params = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 2
          Exactly     = $true
          Scope       = 'Context'
        }
        Should -Invoke @params
      }

      It "$result[1].Id | Should -Be 2" {
        $result[1].Id | Should -Be 2
      }

    }

  }

  Context 'Error Handling' {

    BeforeAll {
      Mock $Mock1 {
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