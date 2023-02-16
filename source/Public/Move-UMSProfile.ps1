function Move-UMSProfile
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
    [Int]
    $Id,

    [Parameter(Mandatory)]
    [Int]
    $DestId
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/profiledirectories' -f $UriArray)
  }
  Process
  {
    $Body = ConvertTo-Json @(
      @{
        id   = $Id
        type = "profile"
      }
    )
    $Params = @{
      WebSession       = $WebSession
      Uri              = ('{0}/{1}?operation=move' -f $BaseURL, $DestId)
      Body             = $Body
      Method           = 'Put'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{ }
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    if ($PSCmdlet.ShouldProcess(('Id: {0} to DestID: {1}' -f $Id, $DestId)))
    {
      $APIObjectColl = Invoke-UMSRestMethod @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Id'      = [Int]$APIObject.id
        'Message' = [String]$APIObject.results
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}