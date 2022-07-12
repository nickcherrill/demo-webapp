[CmdletBinding()]
param (
	[Parameter(Mandatory = $true)]
	[string]
	$mainTemplatePath
)

$ErrorActionPreference = 'Stop'

try {
	Write-Output "[Info] Installing Bicep CLI"
	az bicep install
}
catch {
	Write-Output "[Error] Bicep CLI failed to install"
	Write-Output "[Error] $($_.Exception.Message) for $($_.Exception.ItemName)"
}

try {
	Write-Output "[Info] $mainTemplatePath Bicep files building to ARM Templates.."
	C:\Users\VssAdministrator\.azure\bin\bicep.exe build $mainTemplatePath
	Write-Output "[Info] Templates converted to ARM successfully"
}
catch {
	Write-Output "[Error] Bicep build failed"
	Write-Output "[Error] $($_.Exception.Message) for $($_.Exception.ItemName)"
}
