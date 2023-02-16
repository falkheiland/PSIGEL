function Remove-UMSAPICookie
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
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
  }
  Process
  {
    $BUArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = 'https://{0}:{1}/umsapi/v{2}/' -f $BUArray
    $Cookie = $WebSession.Cookies.GetCookies('https://{0}' -f $Computername)
    $Header = @{
      'Cookie' = ('{0}={1}' -f $Cookie.Name, $Cookie.Value)
    }
    $Params = @{
      Uri              = '{0}logout' -f $BaseURL
      WebSession       = $WebSession
      Headers          = $Header
      Method           = 'Post'
      ContentType      = 'application/json; charset=utf-8'
      SecurityProtocol = $SecurityProtocol
    }
    if ($PSCmdlet.ShouldProcess($Cookie.Value))
    {
      $Result = (Invoke-UMSRestMethod @Params)
    }
    switch ($Result)
    {
      { 'null' -or $null }
      {
        $Cookie.Value
      }
      Default
      {
        Write-Warning ('Could not remove Cookie {0}={1}!' -f $Cookie.Name, $Cookie.Value)
      }
    }
    #>

  }
  End
  {
  }
}