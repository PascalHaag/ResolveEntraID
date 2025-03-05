function Clear-REntraIdentityCache {
	<#
    .SYNOPSIS
    Clear Entra ID identiy cache.

    .DESCRIPTION
	Clear Microsoft Entra ID identiy cache.
	This function will clear the cache of the identity.

    .PARAMETER Provider
	Provider(s) that should be used to clear the cache.

    .EXAMPLE
	PS C:\> Clear-REntraIdentityCache

	Will clear all cached identities.

	.EXAMPLE
	PS C:\> Clear-REntraIdentityCache -Provider "User"

	Will clear the cached identities for the provider "User".

	.EXAMPLE
	PS C:\> Clear-REntraIdentityCache -Provider "User","Group"

	Will clear the cached identities for the providers "User" and "Group".
	#>
	[CmdletBinding()]
	param (
		[string[]]
		$Provider
	)
	if (-not $Provider) {
		$script:IdNameMappingTable = @{}
		$script:NameIdMappingTable = @{}
	}
	else {
		foreach ($providerName in $Provider) {
			$script:IdNameMappingTable.Remove($providerName)
			$script:NameIdMappingTable.Remove($providerName)
		}
	}
}