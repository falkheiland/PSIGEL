# PSIGEL

[![GitHub last commit][github-commit-badge]][github-psigel]
[![GitHub release (latest by date)][github-release-badge]][github-psigel]
[![PowerShell Gallery Version][psgallery-v-badge]][powershell-gallery]
[![PS Gallery][psgallery-dl-badge]][powershell-gallery]
[![GitHub stars][github-start-badge]][github-psigel]
[![IGEL-Community Slack][slack-badge]][slack-igelcommunity]

![Logo](/docs/media/PSIGEL_1280_320.png)

## Table of contents

- [PSIGEL](#psigel)
  - [Table of contents](#table-of-contents)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Quickstart](#quickstart)
    - [Installation](#installation)
    - [Basic usage](#basic-usage)
  - [Documentation](#documentation)
  - [Maintainer](#maintainer)
  - [License](#license)

## Overview

**PSIGEL** is a powershell module that makes use of the REST API provided by the [**IGEL**](https://www.igel.com) Management Interface (IMI).

via [IGEL Knowledgebase](https://kb.igel.com/igelimi-v3/en/imi-manual-2723216.html) :
> IGEL Management Interface (IMI) enables you to connect UMS to systems management tools. It is a programming interface that can create and delete thin clients, move them between directories, reboot them and much more. Its implementation as a REST API makes IMI agnostic of hardware platforms, operating systems and programming languages, thus ensuring maximum interoperability.

## Prerequisites

| OS      | min. PS Version (Edition) |
| ------- | ------------------------- |
| Windows | 5.1 (Desktop)\*           |
| Windows | 7 (Core)\*                |
| Linux   | 7 (Core)\*                |
| MacOS   | 7 (Core)                  |

\* tested

## Quickstart

### Installation

If you have the [PowerShellGet](https://github.com/powershell/powershellget) module installed you can enter the following command:

```powershell
C:\> Install-Module -Name PSIGEL
```

Alternatively you can download a ZIP file of the latest version from our [Releases](https://github.com/IGEL-Community/PSIGEL/releases) page.

### Basic usage

Import Module:

```powershell
C:\> Import-Module -Name PSIGEL
```

Create a WebSession

```powershell
C:\> $WebSession = New-UMSAPICookie -Computername igelrmserver -Credential (Get-Credential)
```

Call a Function - e.g. get status information from the UMS server:

```powershell
C:\> Get-UMSStatus -Computername igelrmserver -WebSession $WebSession

RmGuiServerVersion : 6.3.130
BuildNumber        : 44584
ActiveMqVersion    : 5.7.0
DerbyVersion       : 10.12.1.1
ServerUuid         : f30fb3a2-37d4-4cbb-b884-4f5061d3260e
Server             : igelrmserver:8443
```

Remove WebSession:

```powershell
C:\> $null = Remove-UMSAPICookie -Computername igelrmserver -WebSession $WebSession
```

## Documentation

- [Scripting with PSIGEL](/Docs/Guides/Scripting-with-PSIGEL.md)
  - [Installation](/Docs/Guides/Scripting-with-PSIGEL.md#installation)
  - [Setup](/Docs/Guides/Scripting-with-PSIGEL.md#setup)
  - [Configuration](/Docs/Guides/Scripting-with-PSIGEL.md#configuration)
  - [Authentication](/Docs/Guides/Scripting-with-PSIGEL.md#authentication)
  - [Creating a script](/Docs/Guides/Scripting-with-PSIGEL.md#creating-a-script)
- Functions
  - [Get-UMSDevice](/docs/reference/en-US/Get-UMSDevice.md)
  - [Get-UMSDeviceAssignment](/docs/reference/en-US/Get-UMSDeviceAssignment.md)
  - [Get-UMSDeviceDirectory](/docs/reference/en-US/Get-UMSDeviceDirectory.md)
  - [Get-UMSDeviceDirectoryAssignment](/docs/reference/en-US/Get-UMSDeviceDirectoryAssignment.md)
  - [Get-UMSDirectoryRecursive](/docs/reference/en-US/Get-UMSDirectoryRecursive.md)
  - [Get-UMSFirmware](/docs/reference/en-US/Get-UMSFirmware.md)
  - [Get-UMSProfile](/docs/reference/en-US/Get-UMSProfile.md)
  - [Get-UMSProfileAssignment](/docs/reference/en-US/Get-UMSProfileAssignment.md)
  - [Get-UMSProfileDirectory](/docs/reference/en-US/Get-UMSProfileDirectory.md)
  - [Get-UMSStatus](/docs/reference/en-US/Get-UMSStatus.md)
  - [Move-UMSDevice](/docs/reference/en-US/Move-UMSDevice.md)
  - [Move-UMSDeviceDirectory](/docs/reference/en-US/Move-UMSDeviceDirectory.md)
  - [Move-UMSProfile](/docs/reference/en-US/Move-UMSProfile.md)
  - [Move-UMSProfileDirectory](/docs/reference/en-US/Move-UMSProfileDirectory.md)
  - [New-UMSAPICookie](/docs/reference/en-US/New-UMSAPICookie.md)
  - [New-UMSDevice](/docs/reference/en-US/New-UMSDevice.md)
  - [New-UMSDeviceDirectory](/docs/reference/en-US/New-UMSDeviceDirectory.md)
  - [New-UMSProfileAssignment](/docs/reference/en-US/New-UMSProfileAssignment.md)
  - [New-UMSProfileDirectory](/docs/reference/en-US/New-UMSProfileDirectory.md)
  - [Remove-UMSAPICookie](/docs/reference/en-US/Remove-UMSAPICookie.md)
  - [Remove-UMSDevice](/docs/reference/en-US/Remove-UMSDevice.md)
  - [Remove-UMSDeviceDirectory](/docs/reference/en-US/Remove-UMSDeviceDirectory.md)
  - [Remove-UMSProfile](/docs/reference/en-US/Remove-UMSProfile.md)
  - [Remove-UMSProfileAssignment](/docs/reference/en-US/Remove-UMSProfileAssignment.md)
  - [Remove-UMSProfileDirectory](/docs/reference/en-US/Remove-UMSProfileDirectory.md)
  - [Reset-UMSDevice](/docs/reference/en-US/Reset-UMSDevice.md)
  - [Restart-UMSDevice](/docs/reference/en-US/Restart-UMSDevice.md)
  - [Send-UMSDeviceSetting](/docs/reference/en-US/Send-UMSDeviceSetting.md)
  - [Start-UMSDevice](/docs/reference/en-US/Start-UMSDevice.md)
  - [Stop-UMSDevice](/docs/reference/en-US/Stop-UMSDevice.md)
  - [Update-UMSDevice](/docs/reference/en-US/Update-UMSDevice.md)
  - [Update-UMSDeviceDirectory](/docs/reference/en-US/Update-UMSDeviceDirectory.md)
  - [Update-UMSProfile](/docs/reference/en-US/Update-UMSProfile.md)
  - [Update-UMSProfileDirectory](/docs/reference/en-US/Update-UMSProfileDirectory.md)
- Other sources
  - [Presentation on IGEL Community Youtube Channel](https://www.youtube.com/watch?v=JbBUVjOyhrQ&t=3652s)
  - [igelexperts.com](https://www.igelexperts.com/category/igel/psigel/)
- [Changelog](CHANGELOG.md)

## Maintainer

- Falk Heiland
[![https://github.com/falkheiland][github-fh-badge]][github-fh]
[![http://twitter.com/falkheiland][twitter-fh-badge]][twitter-fh]

## License

This project is [licensed under the MIT License](LICENSE).

[![MIT licensed][mit-badge]][mit-license]

[psgallery-dl-badge]: https://img.shields.io/powershellgallery/dt/PSIGEL.svg?logo=powershell
[powershell-gallery]: https://www.powershellgallery.com/packages/PSIGEL/
[mit-badge]: https://img.shields.io/github/license/IGEL-Community/PSIGEL?logo=github
[mit-license]: LICENSE
[github-commit-badge]: https://img.shields.io/github/last-commit/IGEL-Community/PSIGEL?logo=github
[github-psigel]: https://github.com/IGEL-Community/PSIGEL
[github-release-badge]: https://img.shields.io/github/release/IGEL-Community/PSIGEL/all.svg?logo=github
[psgallery-v-badge]: https://img.shields.io/powershellgallery/v/PSIGEL?include_prereleases&logo=powershell
[github-start-badge]: https://img.shields.io/github/stars/IGEL-Community/PSIGEL?logo=github
[slack-badge]: https://img.shields.io/badge/chat-IGEL%20Community-brightgreen?logo=slack
[slack-igelcommunity]: https://igelcommunity.slack.com/
[github-fh-badge]: https://img.shields.io/badge/Github-falkheiland-green?logo=github
[github-fh]: https://github.com/falkheiland
[twitter-fh-badge]: https://img.shields.io/badge/Twitter-falkheiland-blue?logo=twitter
[twitter-fh]: https://twitter.com/falkheiland
