function Get-UMSDeviceAssignment
{
  <#
  .SYNOPSIS
    Gets information on a profile or master profile assignment of a device.

  .DESCRIPTION
    Gets information on a profile or master profile assignment of a device via API.

  .PARAMETER Computername
    Computername of the UMS Server

  .PARAMETER TCPPort
    TCP Port API

  .PARAMETER SecurityProtocol
    Set SSL/TLS protocol

  .PARAMETER WebSession
    Websession Cookie

  .PARAMETER Filter
    Optional filter

  .PARAMETER Id
    ID of the device

  .INPUTS
    System.Int32

  .OUTPUTS
    System.Object

  .EXAMPLE
    PS> Get-UMSDeviceAssignment -ComputerName 'igelrmserver' -WebSession $WebSession -Id 1693, 1694

    Get profile assignment for device with ID 1693, 1694

  .EXAMPLE
    PS> 1693 | Get-UMSDeviceAssignment -ComputerName 'igelrmserver' -WebSession $WebSession

    Get profile assignment for device with ID 1693

  .EXAMPLE
    PS> $PSDefaultParameterValues = @{
          '*-UMS*:Computername'         = 'igelrmserver'
          '*-UMS*:WebSession'           = $WebSession
        }
        (Get-UMSDevice).where{ $_.name -eq 'DEV-012345678901' } |
          Get-UMSDeviceAssignment

    Get profile assignment for device with name Device-012345678901
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
    $BaseURL = ('https://{0}:{1}/umsapi/v3/thinclients' -f $Computername, $TCPPort)
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
        Uri = '{0}/{1}/assignments/profiles' -f $BaseURL, $item
      }
      Invoke-UMSRestMethod @Params @ParamsPS
    }
    $result
  }
  End
  {
  }
}

