function New-UMSDevice
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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

    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidatePattern('^([0-9a-f]{12})$')]
    [String]
    $Mac,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [Int]
    $FirmwareId,

    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateLength(1, 15)]
    [String]
    $Name,

    [Parameter(ValueFromPipelineByPropertyName)]
    [Int]
    $ParentId = -1,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $Site,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $Department,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $CostCenter,

    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript( { $_ -match [IPAddress]$_ })]
    [String]
    $LastIP,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $Comment,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $AssetId,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $InserviceDate,

    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateLength(18, 18)]
    [String]
    $SerialNumber
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
  }
  Process
  {
    $Body = ConvertTo-Json @{
      mac           = $Mac
      firmwareID    = $FirmwareId.ToString()
      name          = $Name
      parentID      = $ParentId.ToString()
      site          = $Site
      department    = $Department
      costCenter    = $CostCenter
      lastIP        = $LastIP
      comment       = $Comment
      assetID       = $AssetId
      inserviceDate = $InserviceDate
      serialNumber  = $SerialNumber
    }
    $Params = @{
      WebSession       = $WebSession
      Uri              = $BaseURL
      Body             = $Body
      Method           = 'Put'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{ }
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    if ($PSCmdlet.ShouldProcess('MAC: {0}' -f $Mac))
    {
      $APIObjectColl = Invoke-UMSRestMethod @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Mac'      = [String]$Mac
        'Message'  = [String]$APIObject.message
        'Id'       = [Int]$APIObject.id
        'Name'     = [String]$APIObject.name
        'ParentId' = [Int]$APIObject.parentID
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

