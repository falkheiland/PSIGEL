function Get-UMSDevice
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

    [ValidateSet('short', 'details', 'online', 'shadow', 'deviceattributes', 'networkadapters')]
    [String]
    $Filter = 'short',

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Id')]
    [Int]
    $Id
  )
  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
    $FilterString = New-UMSFilterString -Filter $Filter
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
        'ObjectType' = [String]$APIObject.objectType
        'UnitId'     = [String]$APIObject.unitID
        'Mac'        = [String]$APIObject.mac
        'Name'       = [String]$APIObject.name
        'ParentId'   = [Int]$APIObject.parentID
        'FirmwareId' = [Int]$APIObject.firmwareID
        'LastIp'     = [String]$APIObject.lastIP
        'MovedToBin' = [System.Convert]::ToBoolean($APIObject.movedToBin)
      }
      switch ($Filter)
      {
        online
        {
          $Properties += [ordered]@{
            'Online' = [System.Convert]::ToBoolean($APIObject.online)
          }
        }
        shadow
        {
          $Properties += [ordered]@{
            'ShadowSecret' = $APIObject.shadowSecret
          }
        }
        details
        {
          $Properties += [ordered]@{
            'NetworkName'               = [String]$APIObject.networkName
            'Site'                      = [String]$APIObject.site
            'Comment'                   = [String]$APIObject.comment
            'Department'                = [String]$APIObject.department
            'CostCenter'                = [String]$APIObject.costCenter
            'AssetID'                   = [String]$APIObject.assetID
            'InServiceDate'             = [String]$APIObject.inServiceDate
            'SerialNumber'              = [String]$APIObject.serialNumber
            'ProductId'                 = [String]$APIObject.productId
            'CpuSpeed'                  = [Int]$APIObject.cpuSpeed
            'CpuType'                   = [String]$APIObject.cpuType
            'DeviceType'                = [String]$APIObject.deviceType
            'DeviceSerialNumber'        = [String]$APIObject.deviceSerialNumber
            'OsType'                    = [String]$APIObject.osType
            'FlashSize'                 = [Int]$APIObject.flashSize
            'MemorySize'                = [Int]$APIObject.memorySize
            'NetworkSpeed'              = [Int]$APIObject.networkSpeed
            'GraphicsChipset0'          = [String]$APIObject.graphicsChipset0
            'GraphicsChipset1'          = [String]$APIObject.graphicsChipset1
            'MonitorVendor1'            = [String]$APIObject.monitorVendor1
            'MonitorModel1'             = [String]$APIObject.monitorModel1
            'MonitorSerialnumber1'      = [String]$APIObject.monitorSerialnumber1
            'MonitorSize1'              = [Int]$APIObject.monitorSize1
            'MonitorNativeResolution1'  = [String]$APIObject.monitorNativeResolution1
            'Monitor1YearOfManufacture' = [Int]$APIObject.monitor1YearOfManufacture
            'Monitor1WeekOfManufacture' = [Int]$APIObject.monitor1WeekOfManufacture
            'MonitorVendor2'            = [String]$APIObject.monitorVendor2
            'MonitorModel2'             = [String]$APIObject.monitorModel2
            'MonitorSerialnumber2'      = [String]$APIObject.monitorSerialnumber2
            'MonitorSize2'              = [Int]$APIObject.monitorSize2
            'MonitorNativeResolution2'  = [String]$APIObject.monitorNativeResolution2
            'Monitor2YearOfManufacture' = [Int]$APIObject.monitor2YearOfManufacture
            'Monitor2WeekOfManufacture' = [Int]$APIObject.monitor2WeekOfManufacture
            'BiosVendor'                = [String]$APIObject.biosVendor
            'BiosVersion'               = [String]$APIObject.biosVersion
            'TotalUsagetime'            = [Int64]$APIObject.totalUsagetime
            'TotalUptime'               = [Int64]$APIObject.totalUptime
            'BatteryLevel'              = [Int]$APIObject.batteryLevel
          }
          if ($APIObject.lastBoottime)
          {
            $Properties.Add('LastBootTime', [datetime]$APIObject.lastBoottime)
          }
          else
          {
            $Properties.Add('LastBootTime', '')
          }
          if ($APIObject.biosDate)
          {
            $Properties.Add('BiosDate', [datetime]$APIObject.biosDate)
          }
          else
          {
            $Properties.Add('BiosDate', '')
          }
        }
        deviceattributes
        {
          $AttributeCount = 0
          if ($APIObject.deviceAttributes)
          {
            $Properties.Add('DeviceAttributes', $APIObject.deviceAttributes)
            foreach ($DeviceAttribute in $APIObject.deviceAttributes)
            {
              $AttributeProperties = [ordered]@{
                'Identifier' = [String]$DeviceAttribute.identifier
                'Name'       = [String]$DeviceAttribute.name
                'Type'       = [String]$DeviceAttribute.type
              }
              switch ([String]$DeviceAttribute.type)
              {
                range
                {
                  $AttributeProperties.Add('Value', $DeviceAttribute.value)
                  $AttributeProperties.Add('AllowedValues', $DeviceAttribute.allowedValues)
                }
                date
                {
                  $AttributeProperties.Add('Value', [datetime]$DeviceAttribute.value)
                }
                string
                {
                  $AttributeProperties.Add('Value', [String]$DeviceAttribute.value)
                }
                number
                {
                  $AttributeProperties.Add('Value', [Single]$DeviceAttribute.value)
                }
              }
              $AttributePropertiesObject = New-Object PSObject -Property $AttributeProperties
              $Properties.Add( -join ('DeviceAttribute_', $([String]$DeviceAttribute.identifier)), $AttributePropertiesObject)
              $AttributeCount += 1
            }
          }
          else
          {
            $Properties.Add('DeviceAttributes', '')
          }
          $Properties.Add('DeviceAttributeCount', [Int]$AttributeCount)
        }
        networkadapters
        {
          $AdapterCount = 0
          if ($APIObject.networkAdapters)
          {
            $Properties.Add('NetworkAdapters', $APIObject.networkAdapters)
            foreach ($NetworkAdapter in $APIObject.networkAdapters)
            {
              $AdapterProperties = [ordered]@{
                'Name'  = [String]$NetworkAdapter.name
                'Type'  = [String]$NetworkAdapter.type
                'Mac'   = [String]$NetworkAdapter.mac
                'State' = [String]$NetworkAdapter.state
              }
              $AdapterPropertiesObject = New-Object PSObject -Property $AdapterProperties
              $Properties.Add( -join ('NetworkAdapter', $($AdapterCount)), $AdapterPropertiesObject)
              $AdapterCount += 1
            }
          }
          else
          {
            $Properties.Add('NetworkAdapters', '')
          }
          $Properties.Add('NetworkAdapterCount', [Int]$AdapterCount)
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
