---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Get-UMSProfileAssignment.md
schema: 2.0.0
---

# Get-UMSProfileAssignment

## SYNOPSIS
Gets information on a device or device directory assignment of a profile.

## SYNTAX

### Device (Default)
```
Get-UMSProfileAssignment [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Id] <Int32> [<CommonParameters>]
```

### Directory
```
Get-UMSProfileAssignment [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Id] <Int32> [-Directory] [<CommonParameters>]
```

## DESCRIPTION
Gets information on a device or device directory assignment of a profile via API.

## EXAMPLES

### Example 1

Get device assignments for the profile with ID 669:

```powershell
Get-UMSProfileAssignment -ComputerName 'igelrmserver' -WebSession $WebSession -Id 669

Id                 : 669
Type               : profile
ReceiverId         : 195
ReceiverType       : tc
AssignmentPosition : 0
```

### Example 2

Get device directory assignments for the profile with ID 69:

```powershell
69 | Get-UMSProfileAssignment -ComputerName 'igelrmserver' -WebSession $WebSession -Directory

Id                 : 69
Type               : profile
ReceiverId         : 664
ReceiverType       : tcdirectory
AssignmentPosition : 0
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

### -Directory
Switch from devices to device directories

```yaml
Type: SwitchParameter
Parameter Sets: Directory
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id
ID of the profile

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
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

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
