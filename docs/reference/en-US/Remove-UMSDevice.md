---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Remove-UMSDevice.md
schema: 2.0.0
---

# Remove-UMSDevice

## SYNOPSIS
Removes a device.

## SYNTAX

### Offline (Default)
```
Remove-UMSDevice [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Id] <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Online
```
Remove-UMSDevice [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Id] <Int32> [-Online] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Removes a device completely (without recycle bin) via API. Per default the device is removed even if it is offline. With the switch "Online" it removes it only if it is online.

## EXAMPLES

### Example 1

Remove device with ID 754 offline:

```powershell
Remove-UMSDevice -Computername 'igelrmserver' -WebSession $WebSession -Id 754

Bestätigung
Möchten Sie diese Aktion wirklich ausführen?
Ausführen des Vorgangs "Remove-UMSDevice" für das Ziel "Id: 754".
[J] Ja [A] Ja, alle [N] Nein [K] Nein, keine [H] Anhalten [?] Help (default is "Ja"):

Message                       Id
-------                       --
Offline deletion successful. 754
```

### Example 2

Remove device with ID 195 online:

```powershell
Remove-UMSDevice -Computername 'igelrmserver' -WebSession $WebSession -Id 195 -Online

Bestätigung
Möchten Sie diese Aktion wirklich ausführen?
Ausführen des Vorgangs "Remove-UMSDevice" für das Ziel "Id: 195".
[J] Ja [A] Ja, alle [N] Nein [K] Nein, keine [H] Anhalten [?] Help (default is "Ja"):


Message  : OK.
Id       : 195
ExecId   : ID-IGELRMSERVER-50980-1552032799145-17-0
Mac      :
ExecTime : 0
State    : SUCCESS
```

### Example 3

Remove devices with names starting with "V" and ending with "02" or "03" offline, disabling confirmation:

```powershell
$PSDefaultParameterValues = @{
  '*-UMS*:Credential'   = (Get-Credential)
  '*-UMS*:Computername' = 'igelrmserver'
  '*-UMS*:Confirm'      = $false
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = New-UMSAPICookie
}

(Get-UMSDevice).where{$_.Name -match '^V.+(02|03)$'} |
  Remove-UMSDevice

Message                       Id
-------                       --
Offline deletion successful. 749
Offline deletion successful. 750
Offline deletion successful. 751
Offline deletion successful. 752
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
Position: Benannt
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Online
Switch to remove the device only if it is online

```yaml
Type: SwitchParameter
Parameter Sets: Online
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
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
