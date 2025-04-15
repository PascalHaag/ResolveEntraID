Register-PSFTeppScriptblock -Name ResolveEntraID.Provider -ScriptBlock {
	foreach ($provider in Get-REntraIdentityProvider) {
		@{
			Text    = $provider.Name
			ToolTip = "{0} --> Property: {1}" -f $provider.Name, ($provider.NameProperty -join ", ")
		}
	}
} -Global

Register-PSFTeppScriptblock -Name ResolveEntraID.EntraService -ScriptBlock {
	foreach ($service in Get-EntraService) {
		@{
			Text    = $service.Name
			ToolTip = "{0} --> ServiceUrl: {1}" -f $service.Name, $service.ServiceUrl
		}
	}
} -Global