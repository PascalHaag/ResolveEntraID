function Set-REntraConnection {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[PSFValidateSet(TabCompletion="ResolveEntraID.EntraService")]
		[PsfArgumentCompleter("ResolveEntraID.EntraService")]
		[string]
		$Name
	)
	process {
		$Script:PSDefaultParameterValues["Invoke-EntraRequest:Service"] = $Name
	}
}