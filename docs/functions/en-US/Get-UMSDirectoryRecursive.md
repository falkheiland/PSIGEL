---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Reference/Get-UMSDirectoryRecursive.md
schema: 2.0.0
---

# Get-UMSDirectoryRecursive

## SYNOPSIS
Gets either all directory or element ids from below given directory id.

## SYNTAX

### Directory (Default)
```
Get-UMSDirectoryRecursive [-Id] <Int32> [-DirectoryColl] <Object> [<CommonParameters>]
```

### Element
```
Get-UMSDirectoryRecursive [-Id] <Int32> [-DirectoryColl] <Object> [-ElementColl] <Object> [<CommonParameters>]
```

## DESCRIPTION
Gets either all directory or element ids from below given directory id.

## EXAMPLES

### Example 1
Get information on all directories below device directory with the ID 197:

```powershell
$DeviceDirectoryColl = Get-UMSDeviceDirectory -ComputerName 'igelrmserver' -WebSession $WebSession
Get-UMSDirectoryRecursive -Id 197 -DirectoryColl $DeviceDirectoryColl

Id         : 197
Name       : Computers
ParentId   : 48
MovedToBin : False
ObjectType : tcdirectory

Id         : 198
Name       : Computers01
ParentId   : 197
MovedToBin : False
ObjectType : tcdirectory

Id         : 199
Name       : Room1013
ParentId   : 198
MovedToBin : False
ObjectType : tcdirectory

Id         : 200
Name       : Room1014
ParentId   : 198
MovedToBin : False
ObjectType : tcdirectory

Id         : 201
Name       : Room1015
ParentId   : 198
MovedToBin : False
ObjectType : tcdirectory

Id         : 202
Name       : Room1108
ParentId   : 198
MovedToBin : False
ObjectType : tcdirectory

Id         : 203
Name       : Room1U07
ParentId   : 198
MovedToBin : False
ObjectType : tcdirectory

Id         : 208
Name       : Computers2
ParentId   : 197
MovedToBin : False
ObjectType : tcdirectory

Id         : 209
Name       : Room2204
ParentId   : 208
MovedToBin : False
ObjectType : tcdirectory
```

### Example 2
Get 'short' information on all devices below device directory with the ID 197:

```powershell
$DeviceColl = Get-UMSDevice -ComputerName 'igelrmserver' -WebSession $WebSession
$DeviceDirectoryColl = Get-UMSDeviceDirectory -ComputerName 'igelrmserver' -WebSession $WebSession
Get-UMSDirectoryRecursive -Id 197 -DirectoryColl $DeviceDirectoryColl -ElementColl $DeviceColl

Id         : 112567
ObjectType : tc
UnitId     : 00E0C5347154
Mac        : 00E0C5347154
Name       : DEV1417
ParentId   : 201
FirmwareId : 6
LastIp     : 192.168.11.123
MovedToBin : False

Id         : 3404
ObjectType : tc
UnitId     : 00E0C537A54E
Mac        : 00E0C537A54E
Name       : DEV0577
ParentId   : 203
FirmwareId : 6
LastIp     : 192.168.73.1
MovedToBin : False

Id         : 3430
ObjectType : tc
UnitId     : 00E0C5417B66
Mac        : 00E0C5417B66
Name       : DEV0006
ParentId   : 203
FirmwareId : 6
LastIp     : 192.168.85.11
MovedToBin : False

...

Id         : 4308
ObjectType : tc
UnitId     : 00E0C53FF551
Mac        : 00E0C53FF551
Name       : DEV7479
ParentId   : 216
FirmwareId : 20
LastIp     :
MovedToBin : False
```

### Example 3
Get information on all profiles below profile directory with the ID 908:

```powershell
$ProfileDirectoryColl = Get-UMSProfileDirectory -ComputerName 'igelrmserver' -WebSession $WebSession
$ProfileColl = Get-UMSProfile -ComputerName 'igelrmserver' -WebSession $WebSession
908 | Get-UMSDirectoryRecursive -DirectoryColl $ProfileDirectoryColl -ElementColl $ProfileColl

FirmwareId        : 39
IsMasterProfile   : False
OverridesSessions : False
Id                : 18902
Name              : 05|USBStorageHotplug:Disable
ParentId          : 11722
MovedToBin        : False
ObjectType        : profile

FirmwareId        : 39
IsMasterProfile   : False
OverridesSessions : False
Id                : 12047
Name              : 06|Password_DomainAutomaticLogin:Off|UDW
ParentId          : 11724
MovedToBin        : False
ObjectType        : profile

...

FirmwareId        : 39
IsMasterProfile   : False
OverridesSessions : False
Id                : 94461
Name              : 07|Update_Snapshots_Download_W10|UDW
ParentId          : 11726
MovedToBin        : False
ObjectType        : profile
```

## PARAMETERS

### -DirectoryColl
Collection of all Directories. Can be determined from Get-UMSDeviceDirectory or Get-UMSProfileDirectory.

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

### -ElementColl
Collection of all Elements. Can be determined from Get-UMSDevice or Get-UMSProfile.

```yaml
Type: Object
Parameter Sets: Element
Aliases:

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the starting device directory

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
