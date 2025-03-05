$param = @{
	ProviderName = "Group"
	NameProperty = "displayName"
	IdProperty   = "id"
	QueryByName  = "groups?`$filter=displayName eq '{0}'"
	QueryByGUID  = "groups/{0}"
}
Register-REntraIdentityProvider @param