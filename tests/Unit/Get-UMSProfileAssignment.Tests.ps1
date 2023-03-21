BeforeAll {
  $ProjectPath = Resolve-Path ('{0}\..\..' -f $PSScriptRoot)
  if (-not $ProjectName)
  {
    # Assuming project folder name is project name.
    $ProjectName = Get-SamplerProjectName -BuildRoot $ProjectPath
  }
  $ModuleRoot = Split-Path (Resolve-Path ('{0}\source\{1}.psm1' -f $ProjectPath, $ProjectName))
  $ModuleName = $ProjectName
  $FunctionName = (($PSCommandPath -split '\\|/')[-1]).Replace('.Tests.ps1', '')
  . ('{0}\Public\{1}.ps1' -f $ModuleRoot, $FunctionName)
  . ('{0}\Private\Invoke-UMSRestMethod.ps1' -f $ModuleRoot)
  . ('{0}\Private\New-UMSFilterString.ps1' -f $ModuleRoot)
  $ContentColl = Get-Content -Path ( '{0}\Public\{1}.ps1' -f $ModuleRoot, $FunctionName) -ErrorAction Stop
  [object[]]$ActualParameters = (Get-ChildItem function:\$FunctionName).Parameters.Keys
  $KnownParameters = @(
    'Computername',
    'TCPPort',
    'SecurityProtocol',
    'WebSession',
    'Id',
    'Directory'
  )
  $FilterString = 'short'
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
  }

  Context 'Parameter' -Tag 'UT_Basics' {
    It '[<FunctionName>] should contain parameters [<KnownParameters>]' {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $ActualParameters -IncludeEqual |
          Where-Object SideIndicator -EQ '==').Count) | Should -Be $KnownParameters.Count
    }
  }

  Context 'ParameterSetName [Device]' {

    BeforeAll {
      Mock $Mock1 {
        $Mock1ObjSyncRoot
      }
      $result = . $FunctionName -Id 1
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

  Context 'ParameterSetName [Directory]' {

    BeforeAll {
      Mock $Mock1 {
        $Mock1ObjSyncRoot
      }
      $result = . $FunctionName -Id 1 -Directory
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

  Context 'Error Handling' {

    BeforeAll {
      Mock $Mock1 {
        throw 'Error'
      }
    }

    It 'Should throw Error' {
      {
        . $FunctionName -Id 1
      } | Should -Throw 'Error'
    }

  }

}

AfterAll {
}