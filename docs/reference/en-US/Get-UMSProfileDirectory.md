---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Get-UMSProfileDirectory.md
schema: 2.0.0
---

# Get-UMSProfileDirectory

## SYNOPSIS
Gets information on a profile directory.

## SYNTAX

### All (Default)
```
Get-UMSProfileDirectory [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [[-Filter] <String>] [<CommonParameters>]
```

### Id
```
Get-UMSProfileDirectory [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [[-Filter] <String>] [[-Id] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets information on a profile directory via API.

## EXAMPLES

### Example 1

Get all profile directories:

```powershell
Get-UMSProfileDirectory -ComputerName 'igelrmserver' -WebSession $WebSession

Id         : 417
Name       : 01
ParentId   : 666
MovedToBin : False
ObjectType : profiledirectory

Id         : 230
Name       : 02
ParentId   : 666
MovedToBin : False
ObjectType : profiledirectory

Id         : 666
Name       : IGELOS
ParentId   : -2
MovedToBin : False
ObjectType : profiledirectory

Id         : 668
Name       : 07
ParentId   : 666
MovedToBin : False
ObjectType : profiledirectory
```

### Example 2

Get profile directory with ID 668 including its children:

```powershell
Get-UMSProfileDirectory -ComputerName 'igelrmserver' -WebSession $WebSession -Id 668 -Filter children

Id                : 668
Name              : 07
ParentId          : 666
MovedToBin        : False
ObjectType        : profiledirectory
DirectoryChildren : @{ObjectType=profile; Id=669}
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

### -Filter
Optional filter

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: children

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the profile directory

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
