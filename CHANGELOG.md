# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2023-01-21
#### Added
* Futureproofing support for Chocolatey v2.0.0 and higher
* Ability to search remote packages with `Find-ChocoPackage` via `choco search`
#### Changed
* Switched `Get-ChocoPackage` from using `choco search` to `choco list` to distinguish their changed meaning in Chocolatey v2.0.0 and higher
#### Deprecated
* When used with Chocolatey v1.0.0 and higher, `Get-ChocoPackage -LocalOnly` is deprecated, as `-LocalOnly` will become redundant in Chocolatey v2.0.0 and higher
* When used with Chocolatey v1.0.0 and higher, `Get-ChocoPackage -Source` is deprecated, as `Get-PackageSource` only looks at installed packages beginning with Chocolatey v2.0.0 and higher. Please move search functions to `Find-ChocoPackage` instead. 

## [0.2.1] - 2023-01-21
#### Fixed
* No longer emits 'Environment' packages of version 'var' when installing a package that updates environment variables

## [0.2.0] - 2022-09-28
#### Added
* Support for finding and installing prelease packages

## [0.1.0] - 2021-09-24
#### Changed
* Including dependent packages during package uninstalling must now be explicitly requested

## [0.0.8] - 2021-09-24
#### Added
* Support for empty package parameters and install arguments

## [0.0.7] - 2021-07-11
#### Added
* Specific Cmdlet descriptions in Get-Help documentation

## [0.0.6] - 2021-07-04
#### Fixed
* Package failure regex that only captured install failures now captures uninstalls failures as well

## [0.0.5] - 2021-06-16
#### Changed
* Switched CI/CD from AppVeyor to GitHub Actions

## [0.0.4] - 2021-06-16
#### Fixed
* False positives in error handling during package installation for packages that emitted output including the string 'fail'

## [0.0.3] - 2021-03-28
#### Changed
* To mirror broader PowerShell Crescendo support, restrict module to run at a minimum of PowerShell 5.1
  * https://devblogs.microsoft.com/powershell/native-commands-in-powershell-a-new-approach/

## [0.0.2] - 2021-03-27
#### Fixed
* Cmdlets can now properly chain in a pipeline

## [0.0.1] - 2021-03-27
Initial release
