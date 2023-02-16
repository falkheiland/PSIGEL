$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:ScriptName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

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

  Context "ValueFromPipeline" {

    $TestCfg = (($Cfg.Tests).where{ $_.Name -eq $ScriptName }).ParameterSets.ValueFromPipeline

    It "doesn't throw" {
      $NewParams = $TestCfg.NewParams
      $MoveParams = $TestCfg.MoveParams
      $UpdateParams = $TestCfg.UpdateParams
      Write-Host $Params1.Mac
      { $Script:Result = @(
          $null = [pscustomobject]$NewParams |
          New-UMSDeviceDirectory | Tee-Object -Variable 'NewUMSDeviceDirectory' |
          Move-UMSDeviceDirectory @MoveParams | Tee-Object -Variable 'MoveUMSDeviceDirectory' |
          Update-UMSDeviceDirectory @UpdateParams | Tee-Object -Variable 'UpdateUMSDeviceDirectory' |
          Remove-UMSDeviceDirectory | Tee-Object -Variable 'RemoveUMSDeviceDirectory'
          $NewUMSDeviceDirectory
          $MoveUMSDeviceDirectory
          $UpdateUMSDeviceDirectory
          $RemoveUMSDeviceDirectory
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
    $Result = ''

  }

  Context "ValueFromPipelineByPropertyName" {

    $TestCfg = (($Cfg.Tests).where{ $_.Name -eq $ScriptName }).ParameterSets.ValueFromPipelineByPropertyName

    It "doesn't throw" {
      $NewParams = $TestCfg.NewParams
      $MoveParams = $TestCfg.MoveParams
      $UpdateParams = $TestCfg.UpdateParams
      { $Script:Result = @(
          #<#
          $null = ((($NewParams.Name |
                New-UMSDeviceDirectory | Tee-Object -Variable 'NewUMSDeviceDirectory').Id |
              Move-UMSDeviceDirectory @MoveParams | Tee-Object -Variable 'MoveUMSDeviceDirectory').Id |
            Update-UMSDeviceDirectory @UpdateParams | Tee-Object -Variable 'UpdateUMSDeviceDirectory').Id |
          Remove-UMSDeviceDirectory | Tee-Object -Variable 'RemoveUMSDeviceDirectory'
          $NewUMSDeviceDirectory
          $MoveUMSDeviceDirectory
          $UpdateUMSDeviceDirectory
          $RemoveUMSDeviceDirectory
          #>
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
    $Result = ''

  }
}
