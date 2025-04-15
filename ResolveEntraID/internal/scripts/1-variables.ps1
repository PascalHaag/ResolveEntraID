# ID for Name mapping
$script:IdNameMappingTable = @{}

# Name for ID mapping
$script:NameIdMappingTable = @{}

# Identity Provider
$script:IdentityProvider = @{}

# Service (Left: Label, Right: EntraAuth Service)
$script:_services = @{
	ResolveEntraGraph = 'GraphBeta'
}
$script:_serviceSelector = New-EntraServiceSelector -DefaultServices $script:_services