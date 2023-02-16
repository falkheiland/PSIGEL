---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Move-UMSDevice.md
schema: 2.0.0
---

# Move-UMSDevice

## SYNOPSIS
Moves a device to a device directory.

## SYNTAX

```
Move-UMSDevice [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Id] <Int32> [-DestId] <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Moves a device to a device directory via UMS.

## EXAMPLES

### Example 1

Move device with ID 58 to device directory with ID 665:

```powershell
Move-UMSDevice -ComputerName 'igelrmserver' -WebSession $WebSession -Id 58 -DestId 665

Id Message
-- -------
58 successful.
```

### Example 2

Move devices with last known IP addresses starting with '192.168.56.' to device directory with name 'Augsburg':

```powershell
$PSDefaultParameterValues = @{
  '*-UMS*:Credential'       = (Get-Credential)
  '*-UMS*:Computername'     = 'igelrmserver'
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession'   = New-UMSAPICookie
}
(Get-UMSDevice -Filter details).where{$_.LastIp -match '^192.168.56'} |
  Move-UMSDevice -DestId ((Get-UMSDeviceDirectory).where{$_.name -eq 'Augsburg'})[0].Id

 Id Message
 -- -------
 58 successful.
195 successful.
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

### -DestId
ID of the destination device directory

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
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
