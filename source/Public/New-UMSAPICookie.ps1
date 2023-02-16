function New-UMSAPICookie
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

    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $Credential = (Get-Credential -Message 'Enter your credentials'),

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol = 'Tls12'
  )

  Begin
  {
  }
  Process
  {
    $Username = $Credential.Username
    $Password = $Credential.GetNetworkCredential().password
    $BUArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = 'https://{0}:{1}/umsapi/v{2}/' -f $BUArray
    $Header = @{
      'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Username + ':' + $Password))
    }
    $Params = @{
      Uri              = '{0}login' -f $BaseURL
      Headers          = $Header
      Method           = 'Post'
      ContentType      = 'application/json; charset=utf-8'
      SecurityProtocol = $SecurityProtocol
    }
    switch (Get-Variable -Name PSEdition -ValueOnly)
    {
      'Desktop'
      {
        Add-Type -AssemblyName Microsoft.PowerShell.Commands.Utility
        Add-Type -TypeDefinition @'
          using System.Net;
          using System.Security.Cryptography.X509Certificates;
          public class TrustAllCertsPolicy : ICertificatePolicy {
              public bool CheckValidationResult(
                  ServicePoint srvPoint, X509Certificate certificate,
                  WebRequest request, int certificateProblem) {
                    return true;
                  }
                }
'@
        [Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
        [Net.ServicePointManager]::SecurityProtocol = $SecurityProtocol -join ','
      }
    }
    $SessionResponse = Invoke-UMSRestMethod @Params

    if ($SessionResponse)
    {
      $Cookie = New-Object -TypeName System.Net.Cookie
      $Cookie.Name = ($SessionResponse.Message).Split('=')[0]
      $Cookie.Path = '/'
      $Cookie.Value = ($SessionResponse.Message).Split('=')[1]
      $Cookie.Domain = $Computername

      if ($PSCmdlet.ShouldProcess($Computername))
      {
        $WebSession = New-Object -TypeName Microsoft.Powershell.Commands.Webrequestsession
        $WebSession.Cookies.Add($Cookie)
        $Result = $WebSession
        $Result
      }
    }
  }
  End
  {
  }
}