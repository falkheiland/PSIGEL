---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/New-UMSAPICookie.md
schema: 2.0.0
---

# New-UMSAPICookie

## SYNOPSIS
Creates a websession cookie.

## SYNTAX

```
New-UMSAPICookie [-Computername] <String> [[-TCPPort] <Int32>] [[-Credential] <PSCredential>]
 [[-ApiVersion] <Int32>] [[-SecurityProtocol] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a websession cookie for the UMS API.

## EXAMPLES

### Example 1

Create websession cookie and assign it to variable $WebSession:

```powershell
$WebSession = New-UMSAPICookie -Computername 'igelrmserver' -Credential (Get-Credential)
```

### Example 2

Create / use process to store and read credential to and from file and use it to create a websession cookie for use in $WebSession variable:

```powershell
#Save credential securely to file (one time only):
Get-Credential | Export-Clixml -Path ('{0}\igelums@igelrmserver.cred' -f ${env:\userprofile})

#Load credential from file
$Credential = Import-Clixml -Path ('{0}\igelums@igelrmserver.cred' -f ${env:\userprofile})

#Create websession cookie and assign it to variable $WebSession
$WebSession = New-UMSAPICookie -Computername 'igelrmserver' -Credential $Credential
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
Position: 3
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

### -Credential
Credential for the API request

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 4
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

### Keine

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
