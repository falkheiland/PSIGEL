function Get-UMSDeviceDirectoryAssignment
{
  <#
  .SYNOPSIS
    Gets information on a profile or master profile assignment of a device directory.

  .DESCRIPTION
    Gets information on a profile or master profile assignment of a device directory via API.

  .PARAMETER Computername
    Computername of the UMS Server

  .PARAMETER TCPPort
    TCP Port API

  .PARAMETER SecurityProtocol
    Set SSL/TLS protocol

  .PARAMETER WebSession
    Websession Cookie

  .PARAMETER Id
    ID of the device directory

  .INPUTS
    System.Int32

  .OUTPUTS
    System.Object

  .EXAMPLE
    PS> Get-UMSDeviceDirectoryAssignment -ComputerName 'igelrmserver' -WebSession $WebSession -Id 1731, 1718

    Get profile assignment for device directory with ID 1713 and 1718

  .EXAMPLE
    PS> 1713 | Get-UMSDeviceDirectoryAssignment -ComputerName 'igelrmserver' -WebSession $WebSession

    Get profile assignment for device directory with ID 1713

  .EXAMPLE
    PS> $PSDefaultParameterValues = @{
          '*-UMS*:Computername'         = 'igelrmserver'
          '*-UMS*:WebSession'           = $WebSession
        }
        (Get-UMSDeviceDirectory).where{ $_.name -eq 'DeviceDirectory2_1' } |
          Get-UMSDeviceDirectoryAssignment

    Get profile assignment for device directory with name DeviceDirectory2_1
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol = 'Tls12',

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory)]
    [Int[]]
    $Id
  )

  Begin
  {
    $BaseURL = ('https://{0}:{1}/umsapi/v3/directories/tcdirectories' -f $Computername, $TCPPort)
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{ }
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
  }
  Process
  {
    $result = foreach ($item in $Id)
    {
      $ParamsPS = @{
        Uri = ('{0}/{1}/assignments/profiles' -f $BaseURL, $item)
      }
      #(Invoke-UMSRestMethod @Params @ParamsPS).SyncRoot
      (Invoke-UMSRestMethod @Params @ParamsPS)
    }
    $result
  }
  End
  {
  }
}