function Get-UMSProfileAssignment
{
  [CmdletBinding(DefaultParameterSetName = 'Device')]
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

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory)]
    [Int]
    $Id,

    [Parameter(ValueFromPipeline, ParameterSetName = 'Directory')]
    [switch]
    $Directory
  )
  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/profiles' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json; charset=utf-8'
      Headers          = @{ }
      SecurityProtocol = ($SecurityProtocol -join ',')
    }

    Switch ($PsCmdlet.ParameterSetName)
    {
      'Device'
      {
        $Params.Add('Uri', ('{0}/{1}/assignments/thinclients' -f $BaseURL, $Id))
      }
      'Directory'
      {
        $Params.Add('Uri', ('{0}/{1}/assignments/tcdirectories' -f $BaseURL, $Id))
      }
    }
    $APIObjectColl = (Invoke-UMSRestMethod @Params).SyncRoot
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $ProfileColl = foreach ($child in $APIObject)
      {
        $ProfileProperties = [ordered]@{
          'Id'                 = [Int]$child.assignee.id
          'Type'               = [String]$child.assignee.type
          'ReceiverId'         = [Int]$child.receiver.id
          'ReceiverType'       = [String]$child.receiver.type
          'AssignmentPosition' = [Int]$child.assignmentPosition
        }
        New-Object psobject -Property $ProfileProperties
      }
      $ProfileColl
    }
    $Result
  }
  End
  {
  }
}