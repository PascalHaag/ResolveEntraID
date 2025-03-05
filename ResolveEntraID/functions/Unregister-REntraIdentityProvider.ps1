function Unregister-REntraIdentityProvider {
	<#
    .SYNOPSIS
    Unregister Entra ID identity provider.

    .DESCRIPTION
	Unregister Microsoft Entra ID identity provider.
	This function will unregister a provider.

    .PARAMETER ProviderName
	Name(s) of the Entra ID identity provider.

	.EXAMPLE
	PS C:\> Get-REntraIdentityProvider -ProviderName "*"

	Will unregister all providers.

	.EXAMPLE
    PS C:\> Unregister-REntraIdentityProvider -ProviderName "User"

	Will unregister the provider with name "User".

	.EXAMPLE
	PS C:\> Unregister-REntraIdentityProvider -ProviderName "User","Group"

	Will unregister the providers with name "User" and "Group".

	.EXAMPLE
	PS C:\> Get-REntraIdentityProvider -ProviderName "User*"

	Will unregister all providers with name starting with "User".

	.EXAMPLE
	PS C:\> "User" | Unregister-REntraIdentityProvider

	Will unregister the provider with name "User".
    #>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[PSFArgumentCompleter("ResolveEntraID.Provider")]
		[PSFValidateSet(TabCompletion = "ResolveEntraID.Provider")]
		[string[]]
		$ProviderName
	)
	process {
		foreach ($entry in $ProviderName ) {
			Clear-REntraIdentityCache -Provider $entry
			$script:IdentityProvider.Remove($entry)
		}
	}
}