---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Get-UMSDevice.md
schema: 2.0.0
---

# Get-UMSDevice

## SYNOPSIS
Gets information on a device.

## SYNTAX

### All (Default)
```
Get-UMSDevice [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [[-Filter] <String>] [<CommonParameters>]
```

### Id
```
Get-UMSDevice [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [[-Filter] <String>] [[-Id] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets information on a device via API.

## EXAMPLES

### Example 1
Get 'short' information on all devices:

```powershell
Get-UMSDevice -ComputerName 'igelrmserver' -WebSession $WebSession


Id         : 58
ObjectType : tc
UnitId     : 080027B0F6E2
Mac        : 080027B0F6E2
Name       : V10-01
ParentId   : 71
FirmwareId : 3
LastIp     : 192.168.56.102
MovedToBin : False

Id         : 195
ObjectType : tc
UnitId     : 00515734C234
Mac        : 00515734C234
Name       : V11-01
ParentId   : 71
FirmwareId : 2
LastIp     : 192.168.56.101
MovedToBin : False
```

### Example 2

Get 'online' information on device with ID 195:

```powershell
Get-UMSDevice -ComputerName 'igelrmserver' -WebSession $WebSession -Id 58 -Filter online

Id         : 195
ObjectType : tc
UnitId     : 00515734C234
Mac        : 00515734C234
Name       : V11-01
ParentId   : 71
FirmwareId : 2
LastIp     : 192.168.56.101
MovedToBin : False
Online     : True
```

### Example 3
Get 'details' information on device with ID 195:

```powershell
195 | Get-UMSDevice -ComputerName 'igelrmserver' -WebSession $WebSession -Filter details


Id                        : 195
ObjectType                : tc
UnitId                    : 00515734C234
Mac                       : 00515734C234
Name                      : V11-01
ParentId                  : 71
FirmwareId                : 2
LastIp                    : 192.168.56.101
MovedToBin                : False
NetworkName               : V11-01
Site                      :
Comment                   : [SingleLicensed]
Department                :
CostCenter                :
AssetID                   :
InServiceDate             :
SerialNumber              :
ProductId                 : UC1-LX
CpuSpeed                  : 1608
CpuType                   : Intel(R) Core(TM) i7-7Y75 CPU @ 1.30GHz
DeviceType                : Legacy x86 system
DeviceSerialNumber        : 0
OsType                    : IGEL Linux 11 (Kernel Version 4.18.20)
FlashSize                 : 1985
MemorySize                : 1990
NetworkSpeed              : 100
GraphicsChipset0          : VMware Inc. Abstract VGA II Adapter
GraphicsChipset1          :
MonitorVendor1            :
MonitorModel1             :
MonitorSerialnumber1      :
MonitorSize1              : 0
MonitorNativeResolution1  :
Monitor1YearOfManufacture : 0
Monitor1WeekOfManufacture : 0
MonitorVendor2            :
MonitorModel2             :
MonitorSerialnumber2      :
MonitorSize2              : 0
MonitorNativeResolution2  :
Monitor2YearOfManufacture : 0
Monitor2WeekOfManufacture : 0
BiosVendor                : innotek GmbH
BiosVersion               : VirtualBox
TotalUsagetime            : 40341000
TotalUptime               : 1035000
BatteryLevel              : 63
LastBootTime              : 07.03.2019 15:45:00
BiosDate                  : 01.12.2006 00:00:00
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
Accepted values: short, details, online, shadow, deviceattributes, networkadapters

Required: False
Position: Benannt
Default value: short
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the device

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
