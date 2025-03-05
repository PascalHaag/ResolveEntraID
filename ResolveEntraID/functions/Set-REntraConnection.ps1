function Set-REntraConnection {
	<#
	.SYNOPSIS
	Set the default service for ResolveEntraID.

	.DESCRIPTION
	Set the default service for for ResolveEntraID.

	.PARAMETER Name
	The name of the service. Default is "ResolveEntraGraph".

	.EXAMPLE
	PS C:\> Set-REntraConnection -Name "ResolveEntraGraph"

	Will set the default service for Invoke-EntraRequest to "ResolveEntraGraph"
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[PSFValidateSet(TabCompletion = "ResolveEntraID.EntraService")]
		[PsfArgumentCompleter("ResolveEntraID.EntraService")]
		[string]
		$Name
	)
	process {
		$Script:PSDefaultParameterValues["Invoke-EntraRequest:Service"] = $Name
	}
}