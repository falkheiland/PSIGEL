---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Get-UMSFirmware.md
schema: 2.0.0
---

# Get-UMSFirmware

## SYNOPSIS
Gets information on a firmware.

## SYNTAX

### All (Default)
```
Get-UMSFirmware [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [<CommonParameters>]
```

### Id
```
Get-UMSFirmware [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [[-Id] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets information on a firmware via API.

## EXAMPLES

### Example 1

Get all firmwares:

```powershell
Get-UMSFirmware -ComputerName 'igelrmserver' -WebSession $WebSession

Id Product                     Version      FirmwareType
-- -------                     -------      ------------
 2 IGEL OS 11                  11.01.100.01 LX
 3 IGEL Universal Desktop OS 3 10.05.500.01 LX
```

### Example 2

Get firmware with ID 2:

```powershell
Get-UMSFirmware -ComputerName 'igelrmserver' -WebSession $WebSession -Id 2

Id Product    Version      FirmwareType
-- -------    -------      ------------
 2 IGEL OS 11 11.01.100.01 LX
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
Position: Benannt
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -Computername
Computername of the UMS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the firmware

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
Position: Benannt
Default value: Tls12
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCPPort
TCP Port API

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
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
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
