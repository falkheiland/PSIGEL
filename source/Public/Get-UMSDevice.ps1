function Get-UMSDevice
{
  <#
  .SYNOPSIS
    Gets information on a device.

  .DESCRIPTION
    Gets information on a device via API.

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
    PS> Get-UMSDevice -ComputerName 'igelrmserver' -WebSession $WebSession

    Get 'short' information on all devices

  .EXAMPLE
    PS> Get-UMSDevice -ComputerName 'igelrmserver' -WebSession $WebSession -Id 58 -Filter online

    Get 'online' information on device with ID 195

  .EXAMPLE
    PS> 195 | Get-UMSDevice -ComputerName 'igelrmserver' -WebSession $WebSession -Filter details

    Get 'details' information on device with ID 195
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

    [ValidateSet('short', 'details', 'online', 'shadow', 'deviceattributes', 'networkadapters')]
    [String]
    $Filter = 'short',

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Id')]
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
    $FilterString = New-UMSFilterString -Filter $Filter
  }
  Process
  {
    $result = Switch ($PsCmdlet.ParameterSetName)
    {
      'All'
      {
        $ParamsPS = @{
          Uri = (('{0}{1}' -f $BaseURL, $FilterString))
        }
        (Invoke-UMSRestMethod @Params @ParamsPS).SyncRoot
      }
      'Id'
      {
        foreach ($item in $Id)
        {
          $ParamsPS = @{
            Uri = ('{0}/{1}{2}' -f $BaseURL, $item, $FilterString)
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
