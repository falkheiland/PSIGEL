function Get-UMSProfileDirectory
{
  <#
  .SYNOPSIS
    Gets information on a profile directory.

  .DESCRIPTION
    Gets information on a profile directory via API.

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

  .INPUTS
    System.Int32

  .OUTPUTS
    System.Object

  .EXAMPLE
    PS> Get-UMSProfileDirectory -ComputerName 'igelrmserver' -WebSession $WebSession

    Get information on all profile directories

  .EXAMPLE
    PS> Get-UMSProfileDirectory -ComputerName 'igelrmserver' -WebSession $WebSession -Id 1840, 1841

    Get information on profile directory with ID 1840 and 1841

  .EXAMPLE
    PS> 1840, 1841 | Get-UMSProfileDirectory -ComputerName 'igelrmserver' -WebSession $WebSession -Filter children

    Get information on profile directory with ID 1840 and 1841, including its child directories
  #>
  [CmdletBinding(DefaultParameterSetName = 'All')]
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

    [ValidateSet('children')]
    [String]
    $Filter,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Id')]
    [Int[]]
    $Id
  )

  Begin
  {
    $BaseURL = ('https://{0}:{1}/umsapi/v3/directories/profiledirectories' -f $Computername, $TCPPort)
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{ }
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    if ($true -eq $PSBoundParameters.Filter)
    {
      #'true'
      $FilterString = New-UMSFilterString -Filter $Filter
      #$FilterString
    }
  }
  Process
  {
    $result = Switch ($PsCmdlet.ParameterSetName)
    {
      'All'
      {
        $ParamsPS = @{
          Uri = (('{0}{1}' -f $BaseURL, $FilterString))
        }
        (Invoke-UMSRestMethod @Params @ParamsPS).SyncRoot
      }
      'Id'
      {
        foreach ($item in $Id)
        {
          $ParamsPS = @{
            Uri = ('{0}/{1}{2}' -f $BaseURL, $item, $FilterString)
          }
          Invoke-UMSRestMethod @Params @ParamsPS
        }
      }
    }
    $result
  }
  End
  {
  }
}