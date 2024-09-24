$param = @{
    ProviderName = "Group"
    NameProperty = "displayName"
    QueryByName = "groups/{0}"
	QueryByGUID = "groups/{0}"
}
Register-REntraIdentityProvider @param