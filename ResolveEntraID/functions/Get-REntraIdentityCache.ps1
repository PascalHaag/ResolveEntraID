function Get-REntraIdentityCache {
	<#
    .SYNOPSIS
    Get Entra ID identiy cache.

    .DESCRIPTION
	Get Microsoft Entra ID identiy cache.
	This function will get all cached identities.

    .PARAMETER Provider
	Provider(s) that should be used to get the cache.

    .EXAMPLE
    PS C:\> Get-REntraIdentityCache

	Will get all cached identities.

	.EXAMPLE
	PS C:\> Get-REntraIdentityCache -Provider "User"

	Will get the cached identities for the provider "User".

	.EXAMPLE
	PS C:\> Get-REntraIdentityCache -Provider "User","Group"

	Will get the cached identities for the providers "User" and "Group".
    #>
	[OutputType([hashtable])]
	[CmdletBinding()]
	param (
		[string[]]
		$Provider
	)
	if (-not $Provider) {
		$script:IdNameMappingTable
		$script:NameIdMappingTable
	}
	else {
		foreach ($providerName in $Provider) {
			$script:IdNameMappingTable[$providerName]
			$script:NameIdMappingTable[$providerName]
		}
	}
}