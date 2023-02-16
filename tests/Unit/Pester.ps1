param
(
  [ValidateSet('UnitTests', 'IntegrationTests')]
  [String]
  $Tags,

  [String[]]
  $Show = ('Header', 'Summary', 'Failed'),

  [Switch]
  $EnableExit = $false
)
$DSC = [IO.Path]::DirectorySeparatorChar
$ProjectRoot = Resolve-Path ('{1}{0}..' -f $DSC, $PSScriptRoot)
$ModuleRoot = Split-Path (Resolve-Path ('{1}{0}*{0}*.psm1' -f $DSC, $ProjectRoot))
$ModuleName = Split-Path $ModuleRoot -Leaf
Import-Module ( '{1}{0}{2}.psm1' -f $DSC, $Script:ModuleRoot, $Script:ModuleName) -Force

$Cfg = Import-PowerShellDataFile -Path ('{1}{0}Tests{0}Config.psd1' -f $DSC, $Script:ProjectRoot)

if ($PSEdition -eq 'Desktop')
{
  $OutputPath = '{1}{0}Tests{0}Data{0}{2}{0}' -f $DSC, $ProjectRoot, $Cfg.OutputPath.Desktop
}
elseif ($IsWindows -and $PSEdition -eq 'Core')
{
  $OutputPath = '{1}{0}Tests{0}Data{0}{2}{0}' -f $DSC, $ProjectRoot, $Cfg.OutputPath.CoreW10
  Import-Module ('{0}\PowerShell\7\Modules\CimCmdlets\CimCmdlets.psd1' -f [Environment]::GetEnvironmentVariable('ProgramFiles')) -Force
  Import-Module -Name Pester -Force
  #Import-Module C:\Users\fheiland\Documents\WindowsPowerShell\Modules\Assert\Assert.psd1
}
elseif ($IsLinux)
{
  $OutputPath = '{1}{0}Tests{0}Data{0}{2}{0}' -f $DSC, $ProjectRoot, $Cfg.OutputPath.CoreWSL
}
else
{
  $OutputPath = '{1}{0}Tests{0}Data{0}{2}{0}' -f $DSC, $ProjectRoot
}
if ($Tags -eq 'IntegrationTests')
{
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
    '*-UMS*:Confirm'          = $false
  }

  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = (New-UMSAPICookie)
  }

}

foreach ($Test in $Cfg.Tests)
{
  $IVPParams = @{ }
  $IVPParams.Add('Tags', $Tags)
  $IVPParams.Add('Show', $Show)
  $IVPParams.Add('EnableExit', $EnableExit)
  $IVPParams.Add('Script', ('{1}{0}Tests{0}{2}.Tests.ps1' -f $DSC, $ProjectRoot, $Test.Name))
  $IVPParams.Add('Outputfile', ('{1}{0}{2}.Tests.xml' -f $DSC, $OutputPath, $Test.Name))
  if (($Test.CodeCoveragePath) -and ($Tags -ne 'IntegrationTests'))
  {
    $IVPParams.Add('CodeCoverage', ('{1}{0}{2}{0}{3}{0}{4}.ps1' -f $DSC, $ProjectRoot, $ModuleName, $Test.CodeCoveragePath, $Test.Name))
  }
  Invoke-Pester @IVPParams
}
