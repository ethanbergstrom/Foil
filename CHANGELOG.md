# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
