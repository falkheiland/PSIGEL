function Get-UMSProfile
{
  <#
  .SYNOPSIS
    Gets information on a profile.

  .DESCRIPTION
    Gets information on a profile via API.

  .PARAMETER Computername
    Computername of the UMS Server

  .PARAMETER TCPPort
    TCP Port API

  .PARAMETER ApiVersion
    API Version to use

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
    PS> Get-UMSProfile -ComputerName 'igelrmserver' -WebSession $WebSession

    Get all profiles

  .EXAMPLE
    PS> 90, 92 | Get-UMSProfile -ComputerName 'igelrmserver' -WebSession $WebSession

    Get profile with ID 90 and 92

  .EXAMPLE
    PS> Get-UMSProfile -ComputerName 'igelrmserver' -WebSession $WebSession -Id 90, 92

    Get profile with ID 90 and 92
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

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

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
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/profiles' -f $UriArray)
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
        (Invoke-UMSRestMethod @Params @ParamsPS).SyncRoot
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