function ConvertTo-REntraGUID {
	<#
    .SYNOPSIS
	Convert a string to a GUID

	.DESCRIPTION
	Convert a string to a GUID. If the string is already a GUID, it will be returned as is.

	.PARAMETER Identity
	The string to convert to a GUID.

	.PARAMETER Provider
	The provider to use for the conversion.

	.PARAMETER NoCache
	Option that no Cache will be created. ID(s) with the mapping property will not be cached.

	.PARAMETER IdOnly
	Option that only show the resolved ID.

	.EXAMPLE
	PS C:\> ConvertTo-REntraGUID -Identity "<userPrincipalName>" -Provider UserUPN

	Will convert the string "<userPrincipalName>" to a GUID using the provider "UserUPN".

	.EXAMPLE
	PS C:\> ConvertTo-REntraGUID -Identity "<userPrincipalName>" -Provider UserUPN -NoCache

	Will convert the string "<userPrincipalName>" to a GUID using the provider "UserUPN" and not cache the result.

	.EXAMPLE
	PS C:\> ConvertTo-REntraGUID -Identity "<userPrincipalName>" -Provider UserUPN -IdOnly

	Will convert the string "<userPrincipalName>" to a GUID using the provider "UserUPN" and only return the GUID.

	.EXAMPLE
	PS C:\> "<userPrincipalName>" | ConvertTo-REntraGUID -Provider UserUPN

	Will convert the string "<userPrincipalName>" to a GUID using the provider "UserUPN".
    #>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[AllowEmptyCollection()]
		[AllowNull()]
		[string[]]
		$Identity,

		[Parameter(Mandatory)]
		[PSFArgumentCompleter("ResolveEntraID.Provider")]
		[PSFValidateSet(TabCompletion = "ResolveEntraID.Provider")]
		[string[]]
		$Provider,

		[switch]
		$NoCache,

		[switch]
		$IdOnly
	)
	begin {
		function Write-Result {
			<#
            .SYNOPSIS
            Write the result

            .DESCRIPTION
            Write the result in several variants:
            ID, Name (resolved Property), Provider

            or with IdOnly
            Name

            The function will also write the result in the cache (NameIDMappingTable), if NoCache isn't set.
            #>
			[OutputType([string])]
			[CmdletBinding()]
			param (
				[string]
				$Id,

				[string]
				$Provider,

				[string]
				$Name,

				[switch]
				$IdOnly,

				[switch]
				$NoCache
			)
			$result = [PSCustomObject]@{
				ID       = $Id
				Name     = $Name
				Provider = $Provider
			}
			if ($IdOnly) { $Id }
			else { $result }

			if ($NoCache) { return }

			if (-not $script:NameIdMappingTable[$Provider]) {
				$script:NameIdMappingTable[$Provider] = @{}
			}
			$script:NameIdMappingTable[$Provider][$Name] = $result
		}
	}
	process {
		:main foreach ($entry in $Identity) {
			if ($entry -match '^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$') {
				$entry
				continue
			}

			# Cache check for entry
			foreach ($providerName in $Provider) {
				if ($NoCache) { break }
				if ($script:NameIdMappingTable[$providerName].$entry) {
					Write-Result -Id $script:NameIdMappingTable[$providerName].$entry.ID -Name $entry -NoCache -Provider $providerName
					continue main
				}
			}
			# Resolve against Entra
			:providers foreach ($providerName in $Provider) {

				# Resolve provider to use
				$providerObject = $script:IdentityProvider[$providerName]
				if (-not $providerObject) {
					Write-PSFMessage -Level Error -Message "Could not find identity provider {0}. Please register or check the spelling of the provider. Known providers: {1}" -StringValues $providerObject.Name, ((Get-MeidIdentityProvider).Name -join ", ") -Target $providerObject.Name
					continue
				}

				# Resolve identities
				foreach ($queryPath in $providerObject.QueryByName) {
					try {
						$graphResponse = Invoke-EntraRequest -Path ($queryPath -f $entry) -ErrorAction Stop
					}
					catch {
						if ($_.ErrorDetails.Message -match '"code":\s*"Request_ResourceNotFound"') {
							Write-PSFMessage -Level InternalComment -Message "ID {0} could not found as {1}." -StringValues $entry, $providerObject.Name -Target $entry -Tag $providerObject.Name -ErrorRecord $_ -OverrideExceptionMessage
							continue
						}
						Write-PSFMessage -Level Error -Message "Error resolving {0}." -StringValues $entry -ErrorRecord $_ -Target $entry -Tag $providerObject.Name, "fail" -EnableException $true -PSCmdlet $PSCmdlet
						continue
					}
					if ($graphResponse) { break }
				}
				if (-not $graphResponse ) { continue providers }

				# Multi value handling of identities
				foreach ($propertyName in $providerObject.NameProperty) {
					$resolvedPrincipal = $graphResponse | Where-Object $propertyName -EQ $entry
					if ($resolvedPrincipal) { break }
				}
				if ($resolvedPrincipal.Count -gt 1) {
					Write-PSFMessage -Level Error -Message "Unable to uniquely identify {0} as {1}. Found {2} matches for property {3}." -StringValues $entry, $providerObject.Name, $resolvedPrincipal.Count, $propertyName
					continue providers
				}

				# Resolve identity to ID
				foreach ($propertyID in $providerObject.IDProperty) {
					$resolvedID = $resolvedPrincipal.$propertyID
					if (-not $resolvedID) { continue }
					break
				}
				if (-not $resolvedID) {
					$resolvedID = $entry
					Write-PSFMessage -Level SomewhatVerbose -Message "{0} of type {1} could be found but failed to resolve the {2}." -StringValues $entry, $providerObject.Name, ($providerObject.IdProperty -join ", ") -Target $entry -Tag $providerObject.Name
				}
				Write-Result -Id $resolvedID -Name $entry -Provider $providerObject.Name -IdOnly:$IdOnly -NoCache:$NoCache
				continue main
			}
			Write-Result -Id $entry -Name $entry -Provider "Unknown" -IdOnly:$IdOnly -NoCache
		}
	}
	end {

	}
}