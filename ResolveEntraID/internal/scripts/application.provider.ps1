$param = @{
	ProviderName = "Application"
    NameProperty = "displayName"
    QueryByName = "applications/{0}"
	QueryByGUID = "applications/{0}"
}
Register-REntraIdentityProvider @param