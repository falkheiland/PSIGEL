# rename this file to config.psd1 (or copy and name it as such)

@{
  CredentialPath = @{
    Windows = ''
    Linux   = ''
  }

  # PSDefaultParameterValues
  PSDPV          = @{
    '*-UMS*:Computername' = 'igelrmserver'
    #'*-UMS*:TCPPort'      = 8443
    '*-UMS*:Confirm'      = $False
    #'*-UMS*:SecurityProtocol'     = 'Tls'
  }
}