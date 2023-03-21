function Get-UMSDeviceDirectory
{
  <#
  .SYNOPSIS
    Gets information on a device directory.

  .DESCRIPTION
    Gets information on a device directory via API.

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
    ID of the device directory

  .INPUTS
    System.Int32

  .OUTPUTS
    System.Object

  .EXAMPLE
    PS> Get-UMSDeviceDirectory -ComputerName 'igelrmserver' -WebSession $WebSession

    Get information on all device directories

  .EXAMPLE
    PS> Get-UMSDeviceDirectory -ComputerName 'igelrmserver' -WebSession $WebSession -Id 71

    Get information on device directory with ID 71

  .EXAMPLE
    PS> 71 | Get-UMSDeviceDirectory -ComputerName 'igelrmserver' -WebSession $WebSession -Filter children

    Get information on device directory with ID 71, including its child directories
  #>
  [cmdletbinding(DefaultParameterSetName = 'All')]
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

    [ValidateSet('children')]
    [String]
    $Filter,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Id')]
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
    if ($true -eq $PSBoundParameters.Filter)
    {
      $FilterString = New-UMSFilterString -Filter $Filter
    }
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

