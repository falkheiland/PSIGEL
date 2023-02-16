---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/New-UMSProfileAssignment.md
schema: 2.0.0
---

# New-UMSProfileAssignment

## SYNOPSIS
Creates a profile assignment on a device or device directory.

## SYNTAX

```
New-UMSProfileAssignment [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Id] <Int32> [-ReceiverId] <Int32>
 [-ReceiverType] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a profile assignment on a device or device directory via API.

## EXAMPLES

### Example 1

Create profile assignment for profile with ID 390 on device with ID 58:

```powershell
New-UMSProfileAssignment -Computername 'igelrmserver' -WebSession $WebSession -Id 390 -ReceiverId 58 -ReceiverType tc

Message                                Id ReceiverId ReceiverType
-------                                -- ---------- ------------
1 asssignments successfully assigned. 390         58 tc
```

### Example 2

Create profile assignment for profiles with names starting with '01' or '07' on device directory with ID 664:

```powershell
$PSDefaultParameterValues = @{
  '*-UMS*:Credential'   = (Get-Credential)
  '*-UMS*:Computername' = 'igelrmserver'
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = New-UMSAPICookie
}

(Get-UMSProfile).where{$_.Name -match '^(01|07)'} |
  New-UMSProfileAssignment -ReceiverId 664 -ReceiverType tcdirectory

Message                                Id ReceiverId ReceiverType
-------                                -- ---------- ------------
1 asssignments successfully assigned. 390        664 tcdirectory
1 asssignments successfully assigned. 669        664 tcdirectory
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

### -Id
ID of the profile

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ReceiverId
Id of the device or device directory

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

### -ReceiverType
Type of the device or device directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: tc, tcdirectory

Required: True
Position: 7
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

### System.Int32

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
