function Remove-UMSProfileDirectory
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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
    $Id
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/profiledirectories' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Uri              = ('{0}/{1}' -f $BaseURL, $Id)
      Method           = 'Delete'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{ }
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    if ($PSCmdlet.ShouldProcess('Id: {0}' -f $Id))
    {
      $APIObjectColl = Invoke-UMSRestMethod @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Message' = [String]$APIObject.Message
        'Id'      = [Int]$Id
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}