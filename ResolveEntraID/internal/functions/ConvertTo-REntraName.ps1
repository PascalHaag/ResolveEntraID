function ConvertTo-REntraName {
	<#
    .SYNOPSIS
	Convert a GUID to a user defined property.

	.DESCRIPTION
	Convert a GUID to a user defined property. If the GUID is already a user defined property, it will be returned as is.

	.PARAMETER Identity
	The GUID to convert to a user defined property.

	.PARAMETER Provider
	The provider to use for the conversion.

	.PARAMETER NoCache
	Option that no Cache will be created. ID(s) with the mapping property will not be cached.

	.EXAMPLE
	PS C:\> ConvertTo-REntraName -Identity "<GUID>" -Provider UserUPN

	Will convert the GUID "<GUID>" to a user defined property using the provider "UserUPN".

	.EXAMPLE
	PS C:\> ConvertTo-REntraName -Identity "<GUID>" -Provider UserUPN -NoCache

	Will convert the GUID "<GUID>" to a user defined property using the provider "UserUPN" and not cache the result.

	.EXAMPLE
	PS C:\> "<GUID>" | ConvertTo-REntraName -Provider UserUPN

	Will convert the GUID "<GUID>" to a user defined property using the provider "UserUPN".

	.EXAMPLE
	PS C:\> ConvertTo-REntraName -Identity "<GUID>" -Provider UserUPN -NameOnly

	Will convert the GUID "<GUID>" to a user defined property using the provider "UserUPN" and only return the user defined property.
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
		$NameOnly
	)
	begin {
		function Write-Result {
			<#
            .SYNOPSIS
            Write the result

            .DESCRIPTION
            Write the result in several variants:
            ID, Name (resolved Property), Provider

            or with NameOnly
            Name

            The function will also write the result in the cache (IdNameMappingTable), if NoCache isn't set.
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
				$NameOnly,

				[switch]
				$NoCache
			)
			$result = [PSCustomObject]@{
				ID       = $Id
				Name     = $Name
				Provider = $Provider
			}
			if ($NameOnly) { $Name }
			else { $result }

			if ($NoCache) { return }

			if (-not $script:IdNameMappingTable[$Provider]) {
				$script:IdNameMappingTable[$Provider] = @{}
			}
			$script:IdNameMappingTable[$Provider][$Id] = $result
		}
	}
	process {
		:main foreach ($entry in $Identity) {
			if ($entry -notmatch '^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$') {
				$entry
				continue
			}
			foreach ($providerName in $Provider) {
				if ($NoCache) { break }
				if ($script:IdNameMappingTable[$providerName].$entry) {
					Write-Result -Id $entry -Name $script:IdNameMappingTable[$providerName].$entry.Name -NoCache -Provider $providerName -NameOnly:$NameOnly
					continue main
				}
			}
			#region iterate over providers
			:providers foreach ($providerName in $Provider) {
				$providerObject = $script:IdentityProvider[$providerName]
				if (-not $providerObject) {
					Write-PSFMessage -Level Error -Message "Could not find identity provider {0}. Please register or check the spelling of the provider. Known providers: {1}" -StringValues $providerName, ((Get-REntraIdentityProvider).Name -join ", ") -Target $providerName
					continue
				}

				foreach ($queryPath in $providerObject.QueryByGuid) {
					try {
						$graphResponse = Invoke-EntraRequest -Path ($queryPath -f $entry) -ErrorAction Stop
					}
					catch {
						if ($_.ErrorDetails.Message -match '"code":\s*"Request_ResourceNotFound"') {
							Write-PSFMessage -Level InternalComment -Message "ID {0} could not found as {1}." -StringValues $entry, $providerName -Target $entry -Tag $providerName -ErrorRecord $_ -OverrideExceptionMessage
							continue
						}
						Write-PSFMessage -Level Error -Message "Error resolving {0}." -StringValues $entry -ErrorRecord $_ -Target $entry -Tag $providerName, "fail" -EnableException $true -PSCmdlet $PSCmdlet
						continue
					}
					if ($graphResponse) { break }
				}
				if (-not $graphResponse ) { continue providers }

				foreach ($propertyName in $providerObject.NameProperty) {
					$resolvedName = $graphResponse.$propertyName
					if ($resolvedName) { break }
				}
				if (-not $resolvedName) {
					$resolvedName = $entry
					Write-PSFMessage -Level SomewhatVerbose -Message "{0} of type {1} could be found but failed to resolve the {2}." -StringValues $entry, $providerName, ($providerObject.NameProperty -join ", ") -Target $entry -Tag $providerName
				}
				Write-Result -Id $entry -Name $resolvedName -Provider $providerName -NameOnly:$NameOnly -NoCache:$NoCache
				continue main
			}
			#endregion iterate over providers
			Write-Result -Id $entry -Name $entry -Provider "Unknown" -NameOnly:$NameOnly -NoCache
		}
	}
	end {

	}
}
