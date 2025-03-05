function Get-REntraIdentityProvider {
	<#
    .SYNOPSIS
    Get Entra ID identity provider.

    .DESCRIPTION
	Get Microsoft Entra ID identity provider.
	This function will get all registered providers.

    .PARAMETER ProviderName
	Name(s) of the Entra ID identity provider.

	.EXAMPLE
	PS C:\> Get-REntraIdentityProvider

	Will get all providers.

	.EXAMPLE
	PS C:\> Get-REntraIdentityProvider -ProviderName "*"

	Will get all providers.

	.EXAMPLE
	PS C:\> Get-REntraIdentityProvider -ProviderName "User"

	Will get the provider with name "User".

	.EXAMPLE
	PS C:\> Get-REntraIdentityProvider -ProviderName "User*"

	Will get all providers with name starting with "User".

	.EXAMPLE
	PS C:\> Get-REntraIdentityProvider -ProviderName "*User"

	Will get all providers with name ending with "User".

	.EXAMPLE
	PS C:\> Get-REntraIdentityProvider -ProviderName "*User*"

	Will get all providers with name containing "User".
    #>
	[CmdletBinding()]
	param (
		[PSFArgumentCompleter("ResolveEntraID.Provider")]
		[string]
		$ProviderName = '*'
	)
	process {
		$script:IdentityProvider.Values | Where-Object Name -Like $ProviderName
	}
}