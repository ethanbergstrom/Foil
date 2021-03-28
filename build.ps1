. .\src\foil.ps1

$tempJsonArray = @()

$commands | ForEach-Object {
    $Noun = $_.Noun
    $NounOriginalCommandElements = $_.OriginalCommandElements ?? @()
    $NounParameters = $_.Parameters ?? @()
    $NounOutputHandlers = $_.OutputHandlers
    $_.Verbs | ForEach-Object {
        $VerbOriginalCommandElements = $_.OriginalCommandElements ?? @()
        $VerbParameters = $_.Parameters ?? @()
        $VerbOutputHandlers = $_.OutputHandlers
        $tempJson = New-TemporaryFile
        New-CrescendoCommand -Verb $_.Verb -Noun $Noun | ForEach-Object {
            $_.OriginalName = $BaseOriginalName
            # Order noun elements first, then verbs, then generic
            $_.OriginalCommandElements = ($NounOriginalCommandElements + $VerbOriginalCommandElements + $BaseOriginalCommandElements)
            $_.Description = 'PowerShell Crescendo wrapper for Chocolatey'
            # Order noun parameters first, then verbes, then generic
            $_.Parameters = ($NounParameters + $VerbParameters + $BaseParameters)
            # Prefer verb handlers first, then noun, then generic
            $_.OutputHandlers = ($VerbOutputHandlers ?? $NounOutputHandlers) ?? $BaseOutputHandlers
            $_
        } | ConvertTo-Json | Out-File $tempJson
        $tempJsonArray += $tempJson
    }
}

Export-CrescendoModule -ConfigurationFile $tempJsonArray -ModuleName .\src\Foil.psm1 -Force
