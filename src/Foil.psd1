@{
	RootModule = 'Foil.psm1'
	ModuleVersion = '0.3.0'
	GUID = '38430603-9954-45fd-949a-5f79492ffaf7'
	Author = 'Ethan Bergstrom'
	Copyright = '2021-2023'
	Description = 'A PowerShell Crescendo wrapper for Chocolatey'
	# Crescendo modules aren't supported below PowerShell 5.1
	# https://devblogs.microsoft.com/powershell/announcing-powershell-crescendo-preview-1/
	PowerShellVersion = '5.1'
	PrivateData = @{
		PSData = @{
			# Tags applied to this module to indicate this is a PackageManagement Provider.
			Tags = @('Crescendo','Chocolatey','PSEdition_Desktop','PSEdition_Core','Windows','CrescendoBuilt')

			# A URL to the license for this module.
			LicenseUri = 'https://github.com/ethanbergstrom/foil/blob/master/LICENSE.txt'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/ethanbergstrom/Foil'
		}
	}
}
