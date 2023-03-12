function Get-UMSFirmware
{
  <#
  .SYNOPSIS
    Gets information on a firmware.

  .DESCRIPTION
    Gets information on a firmware via API.

  .PARAMETER Computername
    Computername of the UMS Server

  .PARAMETER TCPPort
    TCP Port API

  .PARAMETER SecurityProtocol
    Set SSL/TLS protocol

  .PARAMETER WebSession
    Websession Cookie

  .PARAMETER Id
    ID of the device

  .INPUTS
    System.Int32

  .OUTPUTS
    System.Object

  .EXAMPLE
    PS> Get-UMSFirmware -ComputerName 'igelrmserver' -WebSession $WebSession

    Get information on all firmwares

  .EXAMPLE
    PS> Get-UMSFirmware -ComputerName 'igelrmserver' -WebSession $WebSession -Id 2

    Get information on firmware with ID 2

  #>
  [CmdletBinding(DefaultParameterSetName = 'All')]
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

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Id')]
    [Int[]]
    $Id
  )

  Begin
  {
    $BaseURL = ('https://{0}:{1}/umsapi/v3/firmwares' -f $Computername, $TCPPort)
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
    $result = Switch ($PsCmdlet.ParameterSetName)
    {
      'All'
      {
        $ParamsPS = @{
          Uri = ('{0}' -f $BaseURL)
        }
        (Invoke-UMSRestMethod @Params @ParamsPS).FwResource
      }
      'Id'
      {
        foreach ($item in $Id)
        {
          $ParamsPS = @{
            Uri = ('{0}/{1}' -f $BaseURL, $item)
          }
          Invoke-UMSRestMethod @Params @ParamsPS
        }
      }
    }
    $result
  }
  End
  {
  }
}