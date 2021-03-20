. .\src\chocoCommands.ps1

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
        New-CrescendoCommand -Verb $_.Verb -Noun $Noun | %{
            $_.OriginalName = $BaseOriginalName
            $_.OriginalCommandElements = ($NounOriginalCommandElements + $VerbOriginalCommandElements + $BaseOriginalCommandElements)
            $_.Description = 'PowerShell Crescendo wrapper for Chocolatey'
            $_.Parameters = ($NounParameters + $VerbParameters + $BaseParameters)
            $_.OutputHandlers = ($VerbOutputHandlers ?? $NounOutputHandlers) ?? $BaseOutputHandlers
            $_
        } | ConvertTo-Json | Out-File $tempJson
        $tempJsonArray += $tempJson
    }
}

Export-CrescendoModule -ConfigurationFile $tempJsonArray -ModuleName .\Foil.psm1 -Force
