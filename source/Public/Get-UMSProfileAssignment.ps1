function Get-UMSProfileAssignment
{
  <#
  .SYNOPSIS
    Gets information on a device or device directory assignment of a profile.

  .DESCRIPTION
    Gets information on a device or device directory assignment of a profile via API.

  .PARAMETER Computername
    Computername of the UMS Server

  .PARAMETER TCPPort
    TCP Port API

  .PARAMETER SecurityProtocol
    Set SSL/TLS protocol

  .PARAMETER WebSession
    Websession Cookie

  .PARAMETER Filter
    Optional filter

  .PARAMETER Id
    ID of the profile

  .PARAMETER Directory
    Switch to get assignments to directories. Default ($false) gets assignments to devices

  .INPUTS
    System.Int32

  .OUTPUTS
    System.Object

  .EXAMPLE
    PS> Get-UMSProfileAssignment -ComputerName 'igelrmserver' -WebSession $WebSession -Id 90, 92

    Get profile assignment for profile with ID 90, 92

  .EXAMPLE
    PS> 90 | Get-UMSProfileAssignment -ComputerName 'igelrmserver' -WebSession $WebSession

    Get profile assignment for profile with ID 90

  .EXAMPLE
    PS> $PSDefaultParameterValues = @{
          '*-UMS*:Computername'         = 'igelrmserver'
          '*-UMS*:WebSession'           = $WebSession
        }
        (Get-UMSProfile).where{ $_.name -eq 'Profile01' } |
          Get-UMSProfileAssignment

    Get profile assignment for profile with name Profile01
  #>
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Directory', Justification = 'false positive')]
  [CmdletBinding(DefaultParameterSetName = 'Device')]
  param
  (
    [Parameter(Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol = 'Tls12',

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory)]
    [Int[]]
    $Id,

    [Parameter(ValueFromPipeline, ParameterSetName = 'Directory')]
    [switch]
    $Directory
  )
  Begin
  {
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{ }
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    $BaseURL = ('https://{0}:{1}/umsapi/v3/profiles' -f $Computername, $TCPPort)
    $EndURL = Switch ($PsCmdlet.ParameterSetName)
    {
      'Device'
      {
        'thinclients'
      }
      'Directory'
      {
        'tcdirectories'
      }
    }
  }
  Process
  {
    $result = foreach ($item in $Id)
    {
      $ParamsPS = @{
        Uri = ('{0}/{1}/assignments/{2}' -f $BaseURL, $item, $EndURL)
      }
      (Invoke-UMSRestMethod @Params @ParamsPS).SyncRoot
    }
    $result
  }
  End
  {
  }
}