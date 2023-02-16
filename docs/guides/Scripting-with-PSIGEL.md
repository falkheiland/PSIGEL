# Scripting with PSIGEL

## Table of contents

- [Installation](#installation)
- [Setup](#setup)
- [Configuration](#configuration)
- [Authentication](#authentication)
- [Creating a script](#creating-a-script)

## Installation

There are several ways to install PSIGEL:

### Powershell Gallery

```powershell
C:\> Install-Module -Name PSIGEL -Repository PSGallery
```

### Github Repository

#### Clone

Use your favorite Git client (e.g. git, Github Desktop etc.) to clone the PSIGEL repository via HTTPS `https://github.com/IGEL-Community/PSIGEL.git`

#### Release

Download and extract the latest [release](https://github.com/IGEL-Community/PSIGEL/releases).

## Setup

### Import the module

Powershell needs to import the PSIGEL module. This is done automatically if it resides within one of the Powershell Module Paths:

```powershell
C:\> [Environment]::GetEnvironmentVariable('PSModulePath') -split ';'
```

If you installed it by using the [PSGallery](#powershell-gallery) it will be located in one of the above paths. If it is not, you have to import the Module:

```powershell
C:\> Import-Module -FullyQualifiedName C:\Path\to\PSIGEL.psd1
```

## Configuration

If you want to script with PSIGEL, you will use parameters like `Computername` multiple times. To avoid unnecessary repetitions you can set Default Parameter Values (example):

```powershell
C:\> $PSDefaultParameterValues = @{
      '*-UMS*:Computername' = 'igelrmserver' # Name or IP address of the UMS server
      '*-UMS*:TCPPort'      = 9443 # set, if the TCP Port differs from the default port 8443
}
```

## Authentication

A cookie is needed for authentication with the REST API of the IMI. In PSIGEL this is done by creating a WebSession with the function `New-UMSAPICookie`. It then is provided to the functions with the parameter `WebSession`.

A simple way for an interactive, single time used script would be:

```powershell
C:\> $WebSession = New-UMSAPICookie -Credential (Get-Credential)
```

For the use in an unattended or repeated script you want to automatically add your credentials.

Within Windows you can store your credential in a secure way by using:

```powershell
C:\> Get-Credential | Export-Clixml -Path ('C:\Path\To\Your.cred')
```

**Warning:** This method does not create an encrypted file within Linux / MacOS.

You can now import the saved credential and create the WebSession:

```powershell
C:\> $WebSession = New-UMSAPICookie -Credential (Import-Clixml -Path 'C:\Path\To\Your.cred')
```

Finally we add the WebSession to the Default Parameter Values as well:

```powershell
C:\> $PSDefaultParameterValues.Add('*-UMS*:WebSession', $WebSession)
```

## Creating a script

First, lets get information on all used firmwares:

```powershell
C:\> $FirmwareColl = Get-UMSFirmware

C:\> $FirmwareColl

Id Product    Version    FirmwareType
-- -------    -------    ------------
 1 IGEL OS 11 11.3.100.1 LX
 2 IGEL OS 11 11.3.110.1 LX
```

Now lets find out which is the Id of the latest firmware:

```powershell
C:\> $LatestFirmwareId = ($FirmwareColl | Sort-Object -Property Version -Descending |
  Select-Object -First 1 ).Id

C:\> $LatestFirmwareId

2
```

Lets find out all online devices that are not on the latest firmware:

```powershell
C:\> $UpdateDeviceColl = Get-UMSDevice -Filter online |
  Where-Object { $_.Online -eq $false -and $_.FirmwareId -ne $LatestFirmwareId }
C:\> $UpdateDeviceColl

Id         : 505
ObjectType : tc
UnitId     : 0A0000000001
Mac        : 0A0000000001
Name       : BR-HR-001
ParentId   : 504
FirmwareId : 1
LastIp     :
MovedToBin : False
Online     : False

...

Id         : 572
ObjectType : tc
UnitId     : 0A0000000011
Mac        : 0A0000000011
Name       : L-DIS-011
ParentId   : 520
FirmwareId : 1
LastIp     :
MovedToBin : False
Online     : False
```

Using the pipeline we set the description "update" to those devices:

```powershell
C:\> $UpdateDeviceColl | Update-UMSDevice -Comment 'update'

Message : Update successful.
Id      : 505

...

Message : Update successful.
Id      : 572
```

Check for the comment on one of the devices:

```powershell
C:\> $UpdateDeviceColl | Get-UMSDevice -Filter details |
  Select-Object -Property Id, Name, Comment -First 1

Id      : 505
Name    : BR-HR-001
Comment : update
```

Since the **API does not support views and jobs** we get back to the UMS. We create a view for all devices that have the comment "update". then we create a new scheduled job "Update on Shutdown" for that view and execute it.

As last step we restart the selected devices to initiate the update and avoid being asked to confirm each restart:

```powershell
C:\> $UpdateDeviceColl | Restart-UMSDevice -Confirm:$False

Message  : Ok.
Id       : 505
ExecId   : ID-igelrmserver-40687-1583585133100-2-0
Mac      : 0A0000000001
ExecTime : 1583588208593
State    : SUCCESS

...

Message  : Ok.
Id       : 572
ExecId   : ID-igelrmserver-40687-1583585133100-8-0
Mac      : 0A0000000011
ExecTime : 1583588208904
State    : SUCCESS
```

After the reboot we remove the comment "update" from all devices that now have the latest firmware:

```powershell
C:\> Get-UMSDevice -Filter details | Where-Object {
    $_.Comment -eq 'update' -and $_.FirmwareId -eq $LatestFirmwareId
    } | Update-UMSDevice -Comment ''

Message : Update successful.
Id      : 505

...

Message : Update successful.
Id      : 572
```

At last we remove the WebSession Cookie:

```powershell
Remove-UMSAPICookie

D7588A4A667B3B76650245A8BF335036
```

If we create the view to begin with and schedule the execution of the job just after the execution of the script, then we have created a simple update workflow for our devices. Notice: we don't bother with a reboot here, but rather let the update process start, when the devices a shutdown by the user or per policy.

- The complete script (with removed unnecessary output) as follows:

```powershell
# set parameters
$CredPath = 'C:\Path\To\Your.cred'
$PSDefaultParameterValues = @{
  '*-UMS*:Computername' = 'igelrmserver'
}

#create a websession
$WebSession = New-UMSAPICookie -Credential (Import-Clixml -Path $CredPath)
$PSDefaultParameterValues.Add('*-UMS*:WebSession', $WebSession)

# get all firmwares
$FirmwareColl = Get-UMSFirmware

# get latest firmware
$LatestFirmwareId = ($FirmwareColl | Sort-Object -Property Version -Descending |
  Select-Object -First 1 ).Id

# remove a comment "update" from all devices with the latest firmware
$null = Get-UMSDevice -Filter details | Where-Object {
  $_.Comment -eq 'update' -and $_.FirmwareId -eq $LatestFirmwareId
} | Update-UMSDevice -Comment ''

# get all online devices that do not have the latest firmware
$UpdateDeviceColl = Get-UMSDevice -Filter online | Where-Object {
  $_.Online -eq $false -and $_.FirmwareId -ne $LatestFirmwareId
}

# set a comment "update" to all devices with not the latest firmware
$UpdateDeviceColl | Update-UMSDevice -Comment 'update'

# remove the used websession
$null = Remove-UMSAPICookie

<#
promptly after the execution of this script, a scheduled job "update on Shutdown"
on a view for all devices with the comment "update" should start in the UMS.
#>
```

Output:

```powershell
Message             Id
-------             --
Update successful. 505
..
Update successful. 572
```
