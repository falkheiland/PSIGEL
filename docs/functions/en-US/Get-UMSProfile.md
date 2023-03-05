---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Get-UMSProfile.md
schema: 2.0.0
---

# Get-UMSProfile

## SYNOPSIS
Gets information on a profile.

## SYNTAX

### All (Default)
```
Get-UMSProfile [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [<CommonParameters>]
```

### Id
```
Get-UMSProfile [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [[-Id] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets information on a profile via API.

## EXAMPLES

### Example 1

Get all profiles:

```powershell
Get-UMSProfile -ComputerName 'igelrmserver' -WebSession $WebSession

FirmwareId        : 2
IsMasterProfile   : False
OverridesSessions : False
Id                : 69
Name              : 02|LocalTerminal|OS11
ParentId          : 230
MovedToBin        : False
ObjectType        : profile

FirmwareId        : 2
IsMasterProfile   : False
OverridesSessions : False
Id                : 390
Name              : 01|Browser|OS11
ParentId          : 417
MovedToBin        : False
ObjectType        : profile

FirmwareId        : 2
IsMasterProfile   : False
OverridesSessions : False
Id                : 669
Name              : 07|SSHAccess_root:allow|OS11
ParentId          : 668
MovedToBin        : False
ObjectType        : profile
```

### Example 2

Get profile with ID 69:

```powershell
Get-UMSProfile -ComputerName 'igelrmserver' -WebSession $WebSession -Id 69

FirmwareId        : 2
IsMasterProfile   : False
OverridesSessions : False
Id                : 69
Name              : 02|LocalTerminal|OS11
ParentId          : 230
MovedToBin        : False
ObjectType        : profile
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
ID of the profile

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
