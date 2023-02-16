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
      $MoveParams = $TestCfg.MoveParams
      $UpdateParams = $TestCfg.UpdateParams
      Write-Host $Params1.Mac
      { $Script:Result = @(
          $null = [pscustomobject]$MoveParams |
          Move-UMSProfile -DestId $MoveParams.DestId | Tee-Object -Variable 'MoveUMSProfile' |
          Update-UMSProfile  @UpdateParams | Tee-Object -Variable 'UpdateUMSProfile' |
          Remove-UMSProfile | Tee-Object -Variable 'RemoveUMSProfile'
          $MoveUMSProfile
          $UpdateUMSProfile
          $RemoveUMSProfile
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
  }

  Context "ValueFromPipelineByPropertyName" {

    $Script:Result
    $TestCfg = (($Cfg.Tests).where{ $_.Name -eq $ScriptName }).ParameterSets.ValueFromPipelineByPropertyName

    It "doesn't throw" {
      $MoveParams = $TestCfg.MoveParams
      $UpdateParams = $TestCfg.UpdateParams
      Write-Host $Params1.Mac
      { $Script:Result = @(
          $null = (($MoveParams.Id |
              Move-UMSProfile -DestId $MoveParams.DestId | Tee-Object -Variable 'MoveUMSProfile').Id |
            Update-UMSProfile @UpdateParams | Tee-Object -Variable 'UpdateUMSProfile').Id |
          Remove-UMSProfile | Tee-Object -Variable 'RemoveUMSProfile'
          $MoveUMSProfile
          $UpdateUMSProfile
          $RemoveUMSProfile
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
  }

}