function Resolve-REntraIdentity {
	<#
    .SYNOPSIS
    Resolve Entra ID identity.
    
    .DESCRIPTION
    Resolve Microsoft Entra ID identity.
    This function will resolve an ID to a user defined property.
    Requires an active connection to Azure with MiniGraph.
    
    .PARAMETER Id
    ID(s) that should be resolved by the function.
    
    .PARAMETER Provider
    Provider(s) that should be used to resolve the ID(s).
    
    .PARAMETER NoCache
    Option that no Cache will be created. ID(s) with the mapping property will not be cached.
    
    .PARAMETER NameOnly
    Option that only show the resolved name.
    
    .EXAMPLE
    PS C:\> Resolve-MeidIdentity -ID "xyz" -Provider UserUPN

    Will resolve the ID "xyz" with defined property in the provider "UserUPN".
    The written output is ID, Name (Property), Provider and the result will be written in the cache.
    
    .EXAMPLE
    PS C:\> Resolve-MeidIdentity -ID "xyz","abc" -Provider UserUPN,Group

    Will resolve the IDs "xyz" and "abc" with defined property in the providers "UserUPN" and "Group".
    The written output is ID, Name (Property), Provider and the result will be written in the cache.

    .EXAMPLE
    PS C:\> Resolve-MeidIdentity -ID "xyz","abc" -Provider UserUPN,Group -NoCache

    Will resolve the IDs "xyz" and "abc" with defined property in the providers "UserUPN" and "Group".
    The written output is ID, Name (Property), Provider and the result will NOT be written in the cache.

    .EXAMPLE
    PS C:\> Resolve-MeidIdentity -ID "xyz","abc" -Provider UserUPN,Group -NoCache -NameOnly

    Will resolve the IDs "xyz" and "abc" with defined property in the providers "UserUPN" and "Group".
    The written output is only Name (Property) and the result will NOT be written in the cache.
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

		[ValidateSet("Name", "ID")]
		[string]
		$ResultType = "Name",

		[switch]
		$NoCache
	)
	process {
		switch ($ResultType) {
			"Name" { ConvertTo-REntraName } 
			"ID" { ConvertTo-REntraGUID }
		}
	}
}