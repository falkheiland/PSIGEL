---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Stop-UMSDevice.md
schema: 2.0.0
---

# Stop-UMSDevice

## SYNOPSIS
Shuts down a device.

## SYNTAX

```
Stop-UMSDevice [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Id] <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Shuts down a device via API. Runs in timeout if device is not online.

## EXAMPLES

### Example 1

Shut down the device with ID 195:

```powershell
Stop-UMSDevice -Computername 'igelrmserver' -WebSession $WebSession -Id 195:

Message  : OK.
Id       : 195
ExecId   : ID-igelrmserver-53613-1552120204100-39-0
Mac      : 00515734C234
ExecTime : 1552123564989
State    : SUCCESS
```

### Example 2

Shut down all device which were started today:

```powershell
$PSDefaultParameterValues = @{
  '*-UMS*:Credential'   = (Get-Credential)
  '*-UMS*:Computername' = 'igelrmserver'
  '*-UMS*:Confirm'      = $false
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = New-UMSAPICookie
}

(Get-UMSDevice -Filter details).where{$_.LastBootTime -gt ((Get-Date)).AddDays(-1)} |
  Stop-UMSDevice

Message  : OK.
Id       : 58
ExecId   : ID-igelrmserver-53613-1552120204100-40-0
Mac      : 080027B0F6E2
ExecTime : 1552123656488
State    : SUCCESS

Message  : OK.
Id       : 195
ExecId   : ID-igelrmserver-53613-1552120204100-41-0
Mac      : 00515734C234
ExecTime : 1552123656947
State    : SUCCESS
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
ID of the device

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

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
