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
  . ('{0}\Private\{1}.ps1' -f $ModuleRoot, $FunctionName)
  $ContentColl = Get-Content -Path ( '{0}\Private\{1}.ps1' -f $ModuleRoot, $FunctionName) -ErrorAction Stop
  [object[]]$ActualParameters = (Get-ChildItem function:\$FunctionName).Parameters.Keys
  $KnownParameters = @(
    'Filter'
  )
}

Describe 'Unit Tests' -Tag 'UnitTests_UT' {
  
  BeforeAll {
    $Filter = 'online'
  }

  Context 'Parameter' -Tag 'UT_Basics' {
    It '[<FunctionName>] should contain parameters [<KnownParameters>]' {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $ActualParameters -IncludeEqual |
          Where-Object SideIndicator -EQ '==').Count) | Should -Be $KnownParameters.Count
    }
  }

  Context 'ParameterSetName [None]' -Tag 'UT_PSN_None' {

    BeforeAll {
    }

    Context '$Filter = <Filter>' {

      BeforeAll {
        $result = . $FunctionName -Filter $Filter
      }

      It '$result | Should -HaveType ([String])' {
        $result | Should -HaveType ([String])
      }

      It '@($result).Count | Should -BeExactly 1' {
        @($result).Count | Should -BeExactly 1
      }

      It '$result | Should -BeExactly ("?facets= {0}" -f <Filter>)' {
        $result | Should -BeExactly ('?facets={0}' -f $Filter)
      }
    }

  }

}

AfterAll {
}