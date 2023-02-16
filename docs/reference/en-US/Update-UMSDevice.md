---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Update-UMSDevice.md
schema: 2.0.0
---

# Update-UMSDevice

## SYNOPSIS
Updates properties of a device.

## SYNTAX

```
Update-UMSDevice [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Id] <Int32> [[-Name] <String>] [[-Site] <String>]
 [[-Department] <String>] [[-CostCenter] <String>] [[-LastIP] <String>] [[-Comment] <String>]
 [[-AssetId] <String>] [[-InserviceDate] <String>] [[-SerialNumber] <String>] [[-DeviceAttributes] <Hashtable>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates properties of a device via API.

## EXAMPLES

### Example 1

Update property name of the device with ID 195 to 'NewName':

```powershell
Update-UMSDevice -Computername 'igelrmserver' -WebSession $WebSession -Id 195 -Name 'NewName'

Message             Id
-------             --
Update successful. 195
```

### Example 2

Update property name to 'Dev[MacAddress]' for all devices which name starts with 'V':

```powershell
$PSDefaultParameterValues = @{
  '*-UMS*:Credential'   = (Get-Credential)
  '*-UMS*:Computername' = 'igelrmserver'
  '*-UMS*:Confirm'      = $false
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = New-UMSAPICookie
}

(Get-UMSDevice -Filter details).where{$_.Name -match '^V'} |
  ForEach-Object {
  $_ | Update-UMSDevice -Name ('Dev{0}' -f $_.Mac)
}

Message             Id
-------             --
Update successful.  58
Update successful. 195
```

### Example 3

Update the Value of the DeviceAttribute with the Identifier 'devattr1' on the device with ID 195 to 'NewValue' 
and remove the Value of the DeviceAttribute with the Identifier 'devattr2' from the device with ID 195:

```powershell
Update-UMSDevice -Computername 'igelrmserver' -WebSession $WebSession -Id 195 -DeviceAttributes @{'devattr1' = 'NewValue'; 'devattr2' = ''}

Message             Id
-------             --
Update successful. 195
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

### -AssetId
Device property asset ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
Device property comment

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
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

### -CostCenter
Device property cost center

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Department
Device property department

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

### -InserviceDate
Device property inservice date

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastIP
Device property last known IP address

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Device property name

```yaml
Type: String
Parameter Sets: (All)
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

### -SerialNumber
Device property serial number

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Site
Device property site

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceAttributes
Custom Device Attributes

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
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
