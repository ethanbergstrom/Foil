$BaseOriginalName = 'choco'

$BaseOriginalCommandElements = @(
    '--limit-output',
    '--yes'
)

$BaseParameters = @()

$BaseOutputHandlers = @{
    ParameterSetName = 'Default'
    Handler = {
        param ( $output )
    }
}

$Commands = @(
    @{
        Noun = 'ChocoSource'
        OriginalCommandElements = @('source')
        Verbs = @(
            @{
                Verb = 'Get'
                OutputHandlers = @{
                    ParameterSetName = 'Default'
                    Handler = {
                        param ($output)
                        if ($output) {
                            $output | ForEach-Object {
                                $sourceData = $_ -split '\|'
                                [pscustomobject]@{
                                    Name = $sourceData[0]
                                    Location = $sourceData[1]
                                    Disabled = $sourceData[2]
                                    UserName = $sourceData[3]
                                    Certificate = $sourceData[4]
                                    Priority = $sourceData[5]
                                    'Bypass Proxy' = $sourceData[6]
                                    'Allow Self Service' = $sourceData[7]
                                    'Visibile to Admins Only' = $sourceData[8]
                                }
                            }
                        }
                    }
                }
            },
            @{
                Verb = 'Register'
                OriginalCommandElements = @('add')
                Parameters = @(
                    @{
                        Name = 'Name'
                        ParameterType = 'string'
                        Description = 'Source Name'
                        OriginalName = '--name='
                        NoGap = $true
                        Mandatory = $true
                    },
                    @{
                        Name = 'Location'
                        OriginalName = '--source='
                        NoGap = $true
                        ParameterType = 'string'
                        Description = 'Source Location'
                        Mandatory = $true
                    }
                )
            },
            @{
                Verb = 'Unregister'
                OriginalCommandElements = @('remove')
                Parameters = @(
                    @{
                        Name = 'Name'
                        ParameterType = 'string'
                        Description = 'Source Name'
                        OriginalName = '--name='
                        NoGap = $true
                        Mandatory = $true
                    }
                )
            }
        )
    },
    @{
        Noun = 'ChocoPackage'
        Parameters = @(
            @{
                Name = 'Name'
                ParameterType = 'string'
                Description = 'Package Name'
            },
            @{
                Name = 'Version'
                OriginalName = '--version='
                ParameterType = 'string'
                Description = 'Package version'
                NoGap = $true
            }
        )
        OutputHandlers = @{
            ParameterSetName = 'Default'
            Handler = {
                param ($output)
                if ($output) {
                    $failures = ($output -match 'fail')
                    if ($failures) {
                        Write-Error ($output -join "`r`n")
                    } else {
                        $packageRegex = "^(?<name>[\S]+)[\|\s]v(?<version>[\S]+)"
                        $packageReportRegex="^[0-9]*(\s*)(packages installed)"
                        $output | ForEach-Object {
                            if (($_ -match $packageRegex) -and ($_ -notmatch $packageReportRegex) -and ($_ -notmatch 'already installed') -and $Matches.name -and $Matches.version) {
                                [pscustomobject]@{
                                    Name = $Matches.name
                                    Version = $Matches.version
                                }
                            }
                        }
                    }
                }
            }
        }
        Verbs = @(
            @{
                Verb = 'Install'
                OriginalCommandElements = @('install','--no-progress')
                Parameters = @(
                    @{
                        Name = 'ParamsGlobal'
                        OriginalName = '--params-global'
                        ParameterType = 'switch'
                        Description = 'Apply package parameters to dependencies'
                    },
                    @{
                        Name = 'Parameters'
                        OriginalName = '--parameters'
                        ParameterType = 'string'
                        Description = 'Parameters to pass to the package'
                    },
                    @{
                        Name = 'ArgsGlobal'
                        OriginalName = '--args-global'
                        ParameterType = 'switch'
                        Description = 'Apply package arguments to dependencies'
                    },
                    @{
                        Name = 'InstallArguments'
                        OriginalName = '--install-arguments'
                        ParameterType = 'string'
                        Description = 'Parameters to pass to the package'
                    },
                    @{
                        Name = 'Source'
                        OriginalName = '--source='
                        ParameterType = 'string'
                        Description = 'Package Source'
                        NoGap = $true
                    },
                    @{
                        Name = 'Force'
                        OriginalName = '--force'
                        ParameterType = 'switch'
                        Description = 'Force the operation'
                    }
                )
            },
            @{
                Verb = 'Get'
                OriginalCommandElements = @('search')
                Parameters = @(
                    @{
                        Name = 'AllVersions'
                        OriginalName = '--all-versions'
                        ParameterType = 'switch'
                        Description = 'All Versions'
                    },
                    @{
                        Name = 'LocalOnly'
                        OriginalName = '--local-only'
                        ParameterType = 'switch'
                        Description = 'Local Packages Only'
                    },
                    @{
                        Name = 'Exact'
                        OriginalName = '--exact'
                        ParameterType = 'switch'
                        Description = 'Search by exact package name'
                    },
                    @{
                        Name = 'Source'
                        OriginalName = '--source='
                        ParameterType = 'string'
                        Description = 'Package Source'
                        NoGap = $true
                    }
                )
                OutputHandlers = @{
                    ParameterSetName = 'Default'
                    Handler = {
                        param ( $output )
                        $output | ForEach-Object {
                            $Name,$version = $_ -split '\|'
                            if ( -not [string]::IsNullOrEmpty($name)) {
                                [pscustomobject]@{
                                    Name = $Name
                                    Version = $version
                                }
                            }
                        }
                    }
                }
            },
            @{
                Verb = 'Uninstall'
                OriginalCommandElements = @('uninstall','--remove-dependencies')
                Parameters = @(
                    @{
                        Name = 'Force'
                        OriginalName = '--force'
                        ParameterType = 'switch'
                        Description = 'Force the operation'
                    }
                )
            }
        )
    }
)
