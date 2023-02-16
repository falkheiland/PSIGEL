function Get-UMSStatus
{
  [cmdletbinding()]
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
    $WebSession
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/serverstatus' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{ }
      Uri              = $BaseURL
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    $APIObjectColl = Invoke-UMSRestMethod @Params

    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'RmGuiServerVersion' = [Version]::new($APIObject.rmGuiServerVersion)
        'BuildNumber'        = [Int]$APIObject.buildNumber
        'ActiveMqVersion'    = [Version]::new($APIObject.activeMQVersion)
        'DerbyVersion'       = [String]$APIObject.derbyVersion
        'ServerUuid'         = [String]$APIObject.serverUUID
        'Server'             = [String]$APIObject.server
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

