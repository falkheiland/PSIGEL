#region init
#requires -version 5.0

$DSC = [IO.Path]::DirectorySeparatorChar

if (!(Test-Path .\InvokeDrafts.ps1))
{
  throw 'Set Location to the path where this script is located!'
}

$Config = Import-PowerShellDataFile -Path ('.{0}config.psd1' -f $DSC) -ErrorAction Stop
$PSDefaultParameterValues = $Config.PSDPV

#Get public and private function definition files.
$Public = @( Get-ChildItem -Path ..\source\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path ..\source\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach ($import in @($Public + $Private))
{
  Try
  {
    . $import.fullname
  }
  Catch
  {
    Write-Error -Message ('Failed to import function {0}: {1}' -f $import.fullname, $_)
  }
}

#Export-ModuleMember -Function $Public.Basename

# Use build for draft
# Import-Module -FullyQualifiedName $Config.ModuleBuildPath -Force -ErrorAction Stop -Verbose

if ($PSEdition -eq 'core' -and (-Not $IsWindows))
{
  # PS7 on Linux OR MacOS
  # Dont use the following method in production, since on linux the clixml file is not encrypted
  $Credential = (Import-Clixml -Path $Config.CredentialPath.Linux)
}
else
{
  #PS7 on Windows or Windows PowerShell 5.1
  $Credential = (Import-Clixml -Path $Config.CredentialPath.Windows)
}

$PSDefaultParameterValues.Add('New-UMSAPICookie:Credential', $Credential)
$WebSession = New-UMSAPICookie
$PSDefaultParameterValues.Add('*-UMS*:WebSession', $WebSession)
#endregion

#region stop full script execution via F5
throw 'use F8 to execute the regions individually!'
##endregion

#region Get-UMSFirmware
$params = @{
  #Whatif  = $false
  #Confirm = $false
}
$FirmwareColl = Get-UMSFirmware @params
$FirmwareColl
#endregion

#region end
($WebSession.Cookies) | Remove-UMSAPICookie
#endregion