$param = @{
	ProviderName = "User"
	NameProperty = "userPrincipalName", "mail"
	IdProperty   = "id"
	QueryByName  = "users?`$filter=userPrincipalName eq '{0}' or mail eq '{0}'", "users?`$filter=Name eq '{0}'"
	QueryByGUID  = "users/{0}"
}
Register-REntraIdentityProvider @param