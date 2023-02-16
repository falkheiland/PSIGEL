function Reset-UMSDevice
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
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
  }
  Process
  {
    $Body = ConvertTo-Json @(
      @{
        id   = $Id
        type = "tc"
      }
    )
    $Params = @{
      WebSession       = $WebSession
      Uri              = ('{0}?command=tcreset2facdefs' -f $BaseURL)
      Body             = $Body
      Method           = 'Post'
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
        'Message'  = [String]('{0}.' -f $APIObject.CommandExecList.message)
        'Id'       = [Int]$Id
        'ExecId'   = [String]$APIObject.CommandExecList.execID
        'Mac'      = [String]$APIObject.CommandExecList.mac
        'ExecTime' = [String]$APIObject.CommandExecList.exectime
        'State'    = [String]$APIObject.CommandExecList.state
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

