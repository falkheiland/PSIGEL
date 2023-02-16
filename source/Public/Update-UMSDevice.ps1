function Update-UMSDevice
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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
    $Id,

    [Parameter(ParameterSetName = 'Set')]
    [ValidateLength(1, 15)]
    [String]
    $Name,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $Site,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $Department,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $CostCenter,

    [Parameter(ParameterSetName = 'Set')]
    [ValidateScript( { $_ -match [IPAddress]$_ })]
    [String]
    $LastIP,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $Comment,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $AssetId,

    [Parameter(ParameterSetName = 'Set')]
    [String]
    $InserviceDate,

    [Parameter(ParameterSetName = 'Set')]
    [ValidateLength(18, 18)]
    [String]
    $SerialNumber,

    [Parameter(ParameterSetName = 'Set')]
    [Hashtable]
    $DeviceAttributes
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
  }
  Process
  {
    Switch ($PsCmdlet.ParameterSetName)
    {
      'Set'
      {
        $BodyHashTable = @{ }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'Name' })
        {
          $BodyHashTable.Add('name', $Name)
        }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'Site' })
        {
          $BodyHashTable.Add('site', $Site)
        }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'Department' })
        {
          $BodyHashTable.Add('department', $Department)
        }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'CostCenter' })
        {
          $BodyHashTable.Add('costCenter', $CostCenter)
        }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'LastIP' })
        {
          $BodyHashTable.Add('lastIP', $LastIP)
        }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'Comment' })
        {
          $BodyHashTable.Add('comment', $Comment)
        }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'AssetId' })
        {
          $BodyHashTable.Add('assetID', $AssetId)
        }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'InserviceDate' })
        {
          $BodyHashTable.Add('inserviceDate', $InserviceDate)
        }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'SerialNumber' })
        {
          $BodyHashTable.Add('serialNumber', $SerialNumber)
        }
        if ($PSBoundParameters.GetEnumerator().Where{ $_.Key -eq 'DeviceAttributes' })
        {
	  $DeviceAttributesArray = @()
          foreach ($DeviceAttribute in $DeviceAttributes.GetEnumerator()) {
            $DeviceAttributesArray += @(
              @{
               'identifier' = $DeviceAttribute.Key
               'value' = $DeviceAttribute.Value
              }
            )
          }
          $BodyHashTable.Add('deviceAttributes', $DeviceAttributesArray)
        }
        $Body = ConvertTo-Json $BodyHashTable
        $Params = @{
          WebSession       = $WebSession
          Uri              = ('{0}/{1}' -f $BaseURL, $Id)
          Body             = $Body
          Method           = 'Put'
          ContentType      = 'application/json; charset=utf-8'
          Headers          = @{ }
          SecurityProtocol = ($SecurityProtocol -join ',')
        }
        if ($PSCmdlet.ShouldProcess(('Id: {0}' -f $Id)))
        {
          $APIObjectColl = Invoke-UMSRestMethod @Params
        }
        $Result = foreach ($APIObject in $APIObjectColl)
        {
          $Properties = [ordered]@{
            'Message' = [String]('{0}.' -f $APIObject.message)
            'Id'      = [Int]$Id
          }
          New-Object psobject -Property $Properties
        }
        $Result
      }
      Default
      {
        throw "Specify at least one property to update!"
      }
    }
  }
  End
  {
  }
}

