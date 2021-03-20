$BaseOriginalName = 'choco'

$BaseOriginalCommandElements = @(
    '--limit-output',
    '--yes'
)

$BaseParameters = @()

$BaseOutputHandlers = @{
    ParameterSetName = 'Default'
    Handler = {
        param ( $output ) $output
    }
}

$Commands = @(
    @{
        Noun = 'ChocoSource'
        OriginalCommandElements = @('source')
        Parameters = @(
            @{
                Name = 'Name'
                ParameterType = 'string'
                Description = 'Source Name'
                OriginalName = '--name='
                NoGap = $true
            }
        )
        Verbs = @(
            @{
                Verb = 'Get'
                OutputHandlers = @{
                    ParameterSetName = 'Default'
                    Handler = {
                        param ( $output )
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
            },
            @{
                Verb = 'Add'
                OriginalCommandElements = @('add')
                Parameters = @(
                    @{
                        Name = 'Source'
                        OriginalName = '--source='
                        NoGap = $true
                        ParameterType = 'string'
                        Description = 'Source Location'
                    }
                )
            },
            @{
                Verb = 'Remove'
                OriginalCommandElements = @('remove')
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
            },
            @{
                Name = 'Source'
                OriginalName = '--source='
                ParameterType = 'string'
                Description = 'Package Source'
                NoGap = $true
            },
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
                Name = 'Force'
                OriginalName = '--force'
                ParameterType = 'switch'
                Description = 'Force the operation'
            }
        )
        OutputHandlers = @{
            ParameterSetName = 'Default'
            Handler = {
                param ( $output )
                $output | ForEach-Object {
                    $name,$version = $_ -split '\|'
                    [pscustomobject]@{
                        Name = $name
                        Version = $version
                    }
                }
            }
        }
        Verbs = @(
            @{
                Verb = 'Install'
                OriginalCommandElements = @('install','--no-progress')
            },
            @{
                Verb = 'Get'
                OriginalCommandElements = @('search')
            },
            @{
                Verb = 'Uninstall'
                OriginalCommandElements = @('uninstall','--remove-dependencies')
            }
        )
    }
)
