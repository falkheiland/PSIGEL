---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/New-UMSDevice.md
schema: 2.0.0
---

# New-UMSDevice

## SYNOPSIS
Creates a new device.

## SYNTAX

```
New-UMSDevice [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Mac] <String> [-FirmwareId] <Int32>
 [[-Name] <String>] [[-ParentId] <Int32>] [[-Site] <String>] [[-Department] <String>] [[-CostCenter] <String>]
 [[-LastIP] <String>] [[-Comment] <String>] [[-AssetId] <String>] [[-InserviceDate] <String>]
 [[-SerialNumber] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new device via API.

## EXAMPLES

### Example 1

Create new device for device with Mac address '1a2b3c4d5e6f' and firmware ID 2:

```powershell
New-UMSDevice -ComputerName 'igelrmserver' -WebSession $WebSession -Mac '1a2b3c4d5e6f' -FirmwareId 2

Mac      : 1a2b3c4d5e6f
Message  : Thin client successfully inserted.
Id       : 722
Name     :
ParentId : -1
```

### Example 2

Create new device for device with Mac address '1a2b3c4d5e6f' and firmware ID 2, using all supported properties:

```powershell
$Params = @{
  ComputerName  = 'igelrmserver'
  WebSession    = $WebSession
  Mac           = '1a2b3c4d5e6f'
  FirmwareId    = 2
  AssetId       = 'AssetId'
  Comment       = 'New Device'
  CostCenter    = '85500'
  Department    = 'Marketing'
  InserviceDate = 'InServiceDate'
  LastIP        = '192.168.56.3'
  Name          = 'V11-02'
  ParentId      = 664
  SerialNumber  = '1234567890121314151'
  Site          = 'Augsburg'
}
New-UMSDevice @Params

Mac      : 1a2b3c4d5e6f
Message  : Thin client successfully inserted.
Id       : 725
Name     : V11-02
ParentId : 664
```

### Example 3

Create new devices from comma separated values:

```powershell
$CSV = @'
Mac, FirmwareId, Name, ParentId, Site
1a2b3c4d5e6f, 2, V11-02, 664, Augsburg
2b3c4d5e6f1a, 3, V10-02, 665, Bremen
'@

ConvertFrom-Csv -InputObject $CSV | New-UMSDevice -Computername 'igelrmserver' -WebSession $WebSession

Mac      : 1a2b3c4d5e6f
Message  : Thin client successfully inserted.
Id       : 731
Name     : V11-02
ParentId : 664

Mac      : 2b3c4d5e6f1a
Message  : Thin client successfully inserted.
Id       : 732
Name     : V10-02
ParentId : 665
```

## PARAMETERS

### -ApiVersion
API Version to use

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:
Accepted values: 3

Required: False
Position: 2
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetId
Device property asset ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Comment
Device property comment

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Computername
Computername of the UMS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CostCenter
Device property cost center

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Department
Device property department

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FirmwareId
Device property firmware ID

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InserviceDate
Device property inservice date

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LastIP
Device property last known IP address

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Mac
Device property MAC address in format '001122AABBCC'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
Device property name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParentId
Device property parent device directory ID

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SecurityProtocol
Set SSL/TLS protocol

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Tls12, Tls11, Tls, Ssl3

Required: False
Position: 3
Default value: Tls12
Accept pipeline input: False
Accept wildcard characters: False
```

### -SerialNumber
Device property serial number

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Site
Device property site

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TCPPort
TCP Port API

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 8443
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebSession
Websession Cookie

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
