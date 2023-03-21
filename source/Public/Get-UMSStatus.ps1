function Get-UMSStatus
{
  <#
  .SYNOPSIS
    Gets information on the UMS.

  .DESCRIPTION
    Gets information on the UMS via API.

  .PARAMETER Computername
    Computername of the UMS Server

  .PARAMETER TCPPort
    TCP Port API

  .PARAMETER SecurityProtocol
    Set SSL/TLS protocol

  .PARAMETER WebSession
    Websession Cookie

  .INPUTS
    None

  .OUTPUTS
    System.Object

  .EXAMPLE
    PS> Get-UMSStatus -ComputerName 'igelrmserver' -WebSession $WebSession

    Get information on the UMS, 20230320 there is a known bug in the IMI API which returns no values
  #>
  [cmdletbinding()]
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
    $WebSession
  )

  Begin
  {
    $BaseURL = ('https://{0}:{1}/umsapi/v3/serverstatus' -f $Computername, $TCPPort)
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json; charset=utf-8'
      Uri              = ('{0}' -f $BaseURL)
      Headers          = @{ }
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
  }
  Process
  {
    $result = Invoke-UMSRestMethod @Params
    $result
  }
  End
  {
  }
}

