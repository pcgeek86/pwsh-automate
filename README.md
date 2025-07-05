# Automate Module

This module provides automation helpers for the Windows operating system.
It's built on top of the powerful [LibreAutomate](https://www.libreautomate.com/) .NET library.

## Installation

To install this module, run the following command:

```pwsh
Install-Module -Name Automate
```

## Usage

To save / persist window position:

```pwsh
Save-WindowPosition -ClassName mpv
```

To restore window position:

```pwsh
Restore-WindowPosition -ClassName mpv
```

To hide unwanted Windows Terminal windows that might pop up, you can use this command.

```pwsh
Get-Windows | ? { $PSItem.Name -and $PSItem.Name.EndsWith('mpv.com') } | % { $PSItem.SetStyle('MINIMIZE') } | Out-Null
```
