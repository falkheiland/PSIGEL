#region init

if (!(Test-Path .\InvokeDrafts.ps1))
{
  throw 'Set Location to the path where this script is located!'
}

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

$Config = (Get-Item -Path Env:PSIGEL_*).foreach{
  @{$_.Key = $_.Value }
}

$CredentialParams = @{
  TypeName     = 'System.Management.Automation.PSCredential'
  ArgumentList = @(
    $Config.PSIGEL_Username
    (ConvertTo-SecureString -String $Config.PSIGEL_Password -AsPlainText -Force)
  )
}
$Credential = New-Object @CredentialParams
$Credential


$PSDefaultParameterValues = @{
  'New-UMSAPICookie:Credential' = $Credential
  '*-UMS*:Computername'         = $Config.PSIGEL_Computername
  '*-UMS*:TCPPort'              = $Config.PSIGEL_TCPPort
  #'*-UMS*:SecurityProtocol'     = $Config.PSIGEL_SecurityProtocol
  '*-UMS*:Confirm'              = [System.Convert]::ToBoolean($Config.PSIGEL_Confirm)
}
$WebSession = New-UMSAPICookie
$PSDefaultParameterValues.Add('*-UMS*:WebSession', $WebSession)
#$WebSession
#endregion


#region Get-UMSDeviceDirectory
$params = @{
  #Id     = 1713, 1714, 1715
  #Id      = @(1713, 1714, 1715)
  Filter  = 'children'
  #Whatif  = $false
  #Confirm = $false
  Verbose = $true
}
#$DeviceDirectoryColl = Get-UMSDeviceDirectory @params
$DeviceDirectoryColl = 1713, 1714, 1715 | Get-UMSDeviceDirectory @params
$DeviceDirectoryColl #| Out-GridView
#endregion


<#
#region Get-UMSFirmware
'region Get-UMSFirmware'
$params = @{
  #d = 1 #1
  #Id = @(1)
  #Whatif  = $false
  #Confirm = $false
  #Verbose = $true
}
#$FirmwareColl = Get-UMSFirmware @params
$FirmwareColl = 1 | Get-UMSFirmware @params
$FirmwareColl #| Out-GridView
'endregion'
#endregion

#region Get-UMSDevice
$params = @{
  #Id     = 1693 #1693, 1694, 1695
  #Id     = @(1693, 1694, 1695)
  Filter = 'short' # 'short', 'details', 'online', 'shadow', 'deviceattributes', 'networkadapters'
  #Whatif  = $false
  #Confirm = $false
  #Verbose = $true
}
$DeviceColl = Get-UMSDevice @params
#$DeviceColl = 1693, 1694, 1695 | Get-UMSDevice @params
$DeviceColl #| Out-GridView
#endregion

#region Get-UMSProfile
$params = @{
  #Id = 90 #90, 92, 93
  Id = @(90, 92, 93)
  #Whatif  = $false
  #Confirm = $false
  #Verbose = $true
}
$ProfileColl = Get-UMSProfile @params
#$ProfileColl = 90, 92, 93 | Get-UMSProfile @params
$ProfileColl
#endregion

#region https://igelcommunity.slack.com/archives/C8GP9JHQE/p1677627574428399
(Get-UMSDevice -Filter details).where{
  $_.Name -ne $_.NetworkName
} | ForEach-Object {
  'Name of the Device with the Id {0} with the Name {1} has the NetworkName {2}' -f $_.Id, $_.Name, $_.NetworkName
  if ($null -ne $_.NetworkName)
  {
    #Update-UMSDevice -Name $_.NetworkName
  }
}
#endregion

#>

#region end
$null = Remove-UMSAPICookie
#endregion
#endregion