function Get-UMSFirmware
{
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
    [Int]
    $Id
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/firmwares' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{ }
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    Switch ($PsCmdlet.ParameterSetName)
    {
      'All'
      {
        $Params.Add('Uri', ('{0}' -f $BaseURL))
        $APIObjectColl = (Invoke-UMSRestMethod @Params).FwResource
      }
      'Id'
      {
        $Params.Add('Uri', ('{0}/{1}' -f $BaseURL, $Id))
        $APIObjectColl = Invoke-UMSRestMethod @Params
      }
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Id'           = [Int]$APIObject.id
        'Product'      = [String]$APIObject.product
        'Version'      = [String]$APIObject.version
        'FirmwareType' = [String]$APIObject.firmwareType
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}