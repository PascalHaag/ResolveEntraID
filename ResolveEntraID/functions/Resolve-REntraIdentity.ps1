function Resolve-REntraIdentity {
	<#
    .SYNOPSIS
    Resolve Entra ID identity.

    .DESCRIPTION
    Resolve Microsoft Entra ID identity.
    This function will resolve an ID to a property or resolve a property to a ID.
    Requires an active connection to Azure with EntraAuth.
	Default service for EntraAuth is "ResolveEntraGraph".

    .PARAMETER Identity
    ID(s) that should be resolved by the function.

    .PARAMETER Provider
    Provider(s) that should be used to resolve the ID(s).

	.PARAMETER ResultType
	Option to define the result type. Default is "Name".

    .PARAMETER NoCache
    Option that no Cache will be created. ID(s) with the mapping property will not be cached.

    .PARAMETER NameOnly
    Option that only show the resolved name.

    .EXAMPLE
    PS C:\> Resolve-REntraIdentity -Identity "<ID>" -Provider UserUPN -ResultType Name

    Will resolve the ID "<ID>" with defined property in the provider "UserUPN".
    The written output is ID, Name (Property), Provider and the result will be written in the cache.

	.EXAMPLE
	PS C:\> Resolve-REntraIdentity -Identity "<Property>" -Provider UserUPN -ResultType ID

	Will resolve the Name (Property) "<Property>" with defined property in the provider "UserUPN".
	The written output is ID, Name (Property), Provider and the result will be written in the cache.

    .EXAMPLE
    PS C:\> Resolve-REntraIdentity -Identity "<ID>","<ID2>" -Provider UserUPN,Group

    Will resolve the IDs "<ID>" and "<ID2>" with defined property in the providers "UserUPN" and "Group".
    The written output is ID, Name (Property), Provider and the result will be written in the cache.

    .EXAMPLE
    PS C:\> Resolve-REntraIdentity -Identity "<ID>","<ID2>" -Provider UserUPN,Group -NoCache

    Will resolve the IDs "<ID>" and "<ID2>" with defined property in the providers "UserUPN" and "Group".
    The written output is ID, Name (Property), Provider and the result will NOT be written in the cache.

    .EXAMPLE
    PS C:\> Resolve-REntraIdentity -Identity "<ID>","<ID2>" -Provider UserUPN,Group -NoCache -NameOnly

    Will resolve the IDs "<ID>" and "<ID2>" with defined property in the providers "UserUPN" and "Group".
    The written output is only Name (Property) and the result will NOT be written in the cache.

	.EXAMPLE
	 PS C:\> Resolve-REntraIdentity -Identity "<Property>","<Property2>" -Provider UserUPN,Group -NoCache -ResultType ID -IdOnly

    Will resolve the Name (Property) "<Property>" and "<Property2>" with defined property in the providers "UserUPN" and "Group".
    The written output is only the ID and the result will NOT be written in the cache.

	.EXAMPLE
	PS C:\> "<ID>" | Resolve-REntraIdentity -Provider UserUPN

	Will resolve the ID "<ID>" with defined property in the provider "UserUPN".
	The written output is ID, Name (Property), Provider and the result will be written in the cache.
    #>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', ('Provider','NoCache', 'NameOnly') , Justification = 'Provider, NoCache and NameOnly are used in the function, in a steppable pipeline and should not be suppressed.')]
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

		[ValidateSet("Name", "ID")]
		[string]
		$ResultType = "Name",

		[switch]
		$NoCache,

		[Alias("IdOnly")]
		[switch]
		$NameOnly,

		[hashtable]
        $ServiceMap = @{}
	)
	begin {
		$services = $script:_serviceSelector.GetServiceMap($ServiceMap)
		Assert-EntraConnection -Cmdlet $PSCmdLet -Service $services.ResolveEntraGraph
		# GetSteppablePipeline is used to create a portable pipeline, that allows pausing and resuming the enclosed command as needed.
		# Effectively this means, the wrapped command will only be run once, no matter the numbers of input ids.
		# This significantly improves performance.
		$command = switch ($ResultType) {
			"Name" { { ConvertTo-REntraName -Provider $Provider -NoCache:$NoCache -NameOnly:$NameOnly -ServiceMap $services -WarningAction $WarningPreference}.GetSteppablePipeline() }
			"ID" { { ConvertTo-REntraGUID -Provider $Provider -NoCache:$NoCache -IdOnly:$NameOnly -ServiceMap $services -WarningAction $WarningPreference}.GetSteppablePipeline() }
		}
		$command.begin($true)
	}
	process {
		foreach ($entry in $Identity) { $command.Process($entry) }
	}
	end {
		$command.End()
	}
}