[![CI](https://github.com/ethanbergstrom/Foil/actions/workflows/CI.yml/badge.svg)](https://github.com/ethanbergstrom/Foil/actions/workflows/CI.yml)

# Foil
Foil is a PowerShell Crescendo wrapper for Chocolatey

## Install Foil
```PowerShell
Install-Module Foil -Force
``` 

## Sample usages
### Search for a package
```PowerShell
Get-ChocoPackage -Name nodejs

Get-ChocoPackage -Name firefox -Exact
```

### Install a package
```PowerShell
Get-ChocoPackage nodejs -Exact -Verbose | Install-ChocoPackage

Install-ChocoPackage -Name 7zip -Verbose
```
### Get list of installed packages
```PowerShell
Get-ChocoPackage nodejs -LocalOnly -Verbose
```
### Uninstall a package
```PowerShell
Get-ChocoPackage keepass-plugin-winhello -LocalOnly -Verbose | Uninstall-ChocoPackage -Verbose -RemoveDependencies
```

### Manage package sources
```PowerShell
Register-ChocoSource privateRepo -Location 'https://somewhere/out/there/api/v2/'
Get-ChocoPackage nodejs -Verbose -Source privateRepo -Exact | Install-ChocoPackage
Unregister-ChocoSource privateRepo
```

Foil integrates with Choco.exe to manage and store source information

## Pass in package parameters
The Install-ChocoPackage cmdlet allows passing package parameters.

```powershell
Install-ChocoPackage sysinternals -AcceptLicense -ParamsGlobal -Params '/InstallDir:c:\windows\temp\sysinternals /QuickLaunchShortcut:false' -Verbose
```

## Known Issues
### Compatibility
Foil works with PowerShell for both FullCLR/'Desktop' (ex 5.1) and CoreCLR (ex: 7.0.1), though Chocolatey itself still requires FullCLR.

## Legal and Licensing
Foil is licensed under the [MIT license](./LICENSE.txt).
