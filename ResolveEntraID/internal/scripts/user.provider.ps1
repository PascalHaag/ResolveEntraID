$param = @{
    ProviderName = "User"
    NameProperty = "userPrincipalName"
    QueryByName = "users/{0}"
	QueryByGUID = "users/{0}"
}
Register-REntraIdentityProvider @param