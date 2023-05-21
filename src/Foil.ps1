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
# The general structure of this hashtable is to define noun-level attributes, which are -probably- common across all commands for the same noun, but still allow for customization at more specific verb-level defition for that noun.
# The following three command attributes have the following order of precedence:
# 	OriginalCommandElements will be MERGED in the order of Noun + Verb + Base
#		Example: Noun ChocoSource's element 'source', Verb Register's element 'add', and Base elements are merged to become 'choco source add --limit-output --yes'
# 	Parameters will be MERGED in the order of Noun + Verb + Base
#		Example: Noun ChocoPackage's parameters for package name and version and Verb Install's parameter specifying source information are merged to become '<packageName> --version=<packageVersion> --source=<packageSource>'.
#			These are then appended to the merged original command elements, to create 'choco install <packageName> --version=<packageVersion> --source=<packageSource> --limit-output --yes'
# 	OutputHandler sets will SUPERCEDE each other in the order of: Verb -beats-> Noun -beats-> Base. This allows reusability of PowerShell parsing code.
#		Example: Noun ChocoPackage has inline output handler PowerShell code with complex regex that works for both Install-ChocoPackage and Uninstall-ChocoPackage, but Get-ChocoPackage's native output uses simple vertical bar delimiters.
#		Example 2: The native commands for Register-ChocoSource and Unregister-ChocoSource don't return any output, and until Crescendo supports error handling by exit codes, a base required default output handler that doesn't do anything can be defined and reused in multiple places.
$Commands = @(
    @{
        Noun = 'ChocoSource'
        OriginalCommandElements = @('source')
        Verbs = @(
            @{
                Verb = 'Get'
                Description = 'Return Chocolatey package sources'
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
                Description = 'Register a new Chocolatey package source'
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
                Description = 'Unregister an existing Chocolatey package source'
                OriginalCommandElements = @('remove')
                Parameters = @(
                    @{
                        Name = 'Name'
                        ParameterType = 'string'
                        Description = 'Source Name'
                        OriginalName = '--name='
                        NoGap = $true
                        Mandatory = $true
                        ValueFromPipelineByPropertyName = $true
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
                ValueFromPipelineByPropertyName = $true
            },
            @{
                Name = 'Version'
                OriginalName = '--version='
                ParameterType = 'string'
                Description = 'Package version'
                NoGap = $true
                ValueFromPipelineByPropertyName = $true
            }
        )
        OutputHandlers = @{
            ParameterSetName = 'Default'
            Handler = {
                param ($output)
                if ($output) {
                    $failures = ($output -match 'Chocolatey .+ packages failed\.')
                    if ($failures) {
                        Write-Error ($output -join "`r`n")
                    } else {
                        $packageVersionRegex = "^(?<name>[\S]+)[\|\s]v(?<version>[\S]+)"
                        $packageNoVersionRegex = "(?<name>[\S]+) has been successfully"
                        $packageReportRegex = "^[0-9]*(\s*)(packages installed)"
                        $output | ForEach-Object {
                            # Output is provided in an array of strings, so we inspect each output string for package name (and optionally version) candidates
                            # Starting with Choco v2, package version information is no longer included during uninstall
                            # To maintain passivity with pre-v2 and consuming package provider modules, we match on multiple possible patterns, which can result in multiple matches for the same package
                            if ((($_ -cmatch $packageVersionRegex) -or ($_ -cmatch $packageNoVersionRegex)) -and $Matches.name -and ($_ -notmatch $packageReportRegex)) {
                                [pscustomobject]@{
                                    Name = $Matches.name
                                    Version = $Matches.version
                                }
                            }
                        } | Sort-Object Name, Version | Group-Object Name | ForEach-Object {
                            # If there are multiple matches for the same package, merge them together (including any pre-v2 uninstall version info) and return them
                            $packageCandidate = @{
                                Name = $_.Name
                            }

                            if ($_.Group.Version) {
                                $packageCandidate.Version = $_.Group.Version | Select-Object -Unique
                            }

                            [pscustomobject]$packageCandidate
                        }
                    }
                }
            }
        }
        Verbs = @(
            @{
                Verb = 'Install'
                Description = 'Install a new package with Chocolatey'
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
                        OriginalName = '--parameters='
                        ParameterType = 'string'
                        Description = 'Parameters to pass to the package'
                        NoGap = $true
                    },
                    @{
                        Name = 'ArgsGlobal'
                        OriginalName = '--args-global'
                        ParameterType = 'switch'
                        Description = 'Apply package arguments to dependencies'
                    },
                    @{
                        Name = 'InstallArguments'
                        OriginalName = '--install-arguments='
                        ParameterType = 'string'
                        Description = 'Parameters to pass to the package'
                        NoGap = $true
                    },
                    @{
                        Name = 'Source'
                        OriginalName = '--source='
                        ParameterType = 'string'
                        Description = 'Package Source'
                        NoGap = $true
                        ValueFromPipelineByPropertyName = $true
                    },
                    @{
                        Name = 'Force'
                        OriginalName = '--force'
                        ParameterType = 'switch'
                        Description = 'Force the operation'
                    },
                    @{
                        Name = 'PreRelease'
                        OriginalName = '--pre'
                        ParameterType = 'switch'
                        Description = 'Include prerelease packages'
                    }
                )
            },
            @{
                Verb = 'Get'
                Description = 'Get a list of installed or available Chocolatey packages'
                OriginalCommandElements = @('list')
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
                    },
                    @{
                        Name = 'PreRelease'
                        OriginalName = '--pre'
                        ParameterType = 'switch'
                        Description = 'Include prerelease packages'
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
                Verb = 'Find'
                Description = 'Finds a list of available Chocolatey packages'
                OriginalCommandElements = @('search')
                Parameters = @(
                    @{
                        Name = 'AllVersions'
                        OriginalName = '--all-versions'
                        ParameterType = 'switch'
                        Description = 'All Versions'
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
                    },
                    @{
                        Name = 'PreRelease'
                        OriginalName = '--pre'
                        ParameterType = 'switch'
                        Description = 'Include prerelease packages'
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
                Description = 'Uninstall an existing package with Chocolatey'
                OriginalCommandElements = @('uninstall')
                Parameters = @(
                    @{
                        Name = 'Force'
                        OriginalName = '--force'
                        ParameterType = 'switch'
                        Description = 'Force the operation'
                    }
                    @{
                        Name = 'RemoveDependencies'
                        OriginalName = '--remove-dependencies'
                        ParameterType = 'switch'
                        Description = 'Remove all dependant packages not depended on by another installed package'
                    }
                )
            }
        )
    }
)
