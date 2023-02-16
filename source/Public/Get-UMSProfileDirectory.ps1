function Get-UMSProfileDirectory
{
  [CmdletBinding(DefaultParameterSetName = 'All')]
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

    [ValidateSet('children')]
    [String]
    $Filter,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Id')]
    [Int]
    $Id
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/profiledirectories' -f $UriArray)
    if ($Filter)
    {
      $FilterString = New-UMSFilterString -Filter $Filter
    }
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
    Switch ($PSCmdlet.ParameterSetName)
    {
      'All'
      {
        $Params.Add('Uri', ('{0}{1}' -f $BaseURL, $FilterString))
        $APIObjectColl = (Invoke-UMSRestMethod @Params).SyncRoot
      }
      'Id'
      {
        $Params.Add('Uri', ('{0}/{1}{2}' -f $BaseURL, $Id, $FilterString))
        $APIObjectColl = Invoke-UMSRestMethod @Params
      }
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Id'         = [Int]$APIObject.id
        'Name'       = [String]$APIObject.name
        'ParentId'   = [Int]$APIObject.parentID
        'MovedToBin' = [System.Convert]::ToBoolean($APIObject.movedToBin)
        'ObjectType' = [String]$APIObject.objectType
      }
      switch ($Filter)
      {
        'children'
        {
          $DirectoryChildren = foreach ($child in $APIObject.DirectoryChildren)
          {
            $ChildProperties = [ordered]@{
              'ObjectType' = [String]$child.objectType
              'Id'         = [Int]$child.id
            }
            New-Object psobject -Property $ChildProperties
          }
          $Properties += [ordered]@{
            'DirectoryChildren' = $DirectoryChildren
          }
        }
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}