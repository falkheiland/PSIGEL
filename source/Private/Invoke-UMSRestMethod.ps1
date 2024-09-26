function Invoke-UMSRestMethod
{
  <#
  .SYNOPSIS
    Invoke-RestMethod Wrapper for UMS API

  .DESCRIPTION
    Invoke-RestMethod Wrapper for UMS API

  .PARAMETER SecurityProtocol
    Set SSL/TLS protocol

  .PARAMETER WebSession
    Websession Cookie

  .PARAMETER Uri
    Uniform Resource Identifier (URI) of the internet resource to which the request is sent

  .PARAMETER Body
    Body of the request

  .PARAMETER ContentType
    Content type of the request

  .PARAMETER Headers
    Headers of the request

  .PARAMETER Method
    Method of the request

  .INPUTS
    System.Object

  .OUTPUTS
    System.Object

  .EXAMPLE
    PS> $Params = @{
      WebSession       = $WebSession
      Uri              = $Uri
      Method           = 'Get'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    Invoke-UMSRestMethod @Params

    Invokes a GET Method call.

  .EXAMPLE
    PS>  $Params = @{
      WebSession       = $WebSession
      Uri              = $Uri
      Body             = $Body
      Method           = 'Put'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    Invoke-UMSRestMethod @Params

    Invokes a PUT Method call.
  #>

  [CmdletBinding(DefaultParameterSetName = 'Login')]
  param (
    [Parameter(Mandatory, ParameterSetName = 'Function')]
    $WebSession,

    [Parameter(Mandatory, ParameterSetName = 'Function')]
    [Parameter(Mandatory, ParameterSetName = 'Login')]
    [ValidateSet('Tls13', 'Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol,

    [Parameter(Mandatory, ParameterSetName = 'Function')]
    [Parameter(Mandatory, ParameterSetName = 'Login')]
    [String]
    $Uri,

    [Parameter(ParameterSetName = 'Function')]
    [Parameter(ParameterSetName = 'Login')]
    [String]
    $Body,

    [Parameter(ParameterSetName = 'Function')]
    [Parameter(ParameterSetName = 'Login')]
    [String]
    $ContentType,

    [Parameter(ParameterSetName = 'Function')]
    [Parameter(Mandatory, ParameterSetName = 'Login')]
    $Headers,

    [Parameter(Mandatory, ParameterSetName = 'Function')]
    [Parameter(Mandatory, ParameterSetName = 'Login')]
    [ValidateSet('Get', 'Post', 'Put', 'Delete')]
    [String]
    $Method
  )

  begin
  {
  }
  process
  {
    $null = $PSBoundParameters.Remove('SecurityProtocol')
    $null = $PSBoundParameters.Add('ErrorAction', 'Stop')
    Switch (Get-Variable -Name PSEdition -ValueOnly)
    {
      'Core'
      {
        $null = $PSBoundParameters.Add('SslProtocol', $SecurityProtocol)
        $null = $PSBoundParameters.Add('SkipCertificateCheck', $true)
      }
    }
    try
    {
      Invoke-RestMethod @PSBoundParameters
    }
    catch
    {
      throw
    }
  }
  end
  {
  }
}