$param = @{
	ProviderName = "Application"
	NameProperty = "displayName"
	IdProperty   = "appId", "id" 
	QueryByName  = "applications?`$filter=displayName eq '{0}'", "servicePrincipals?`$filter=displayName eq '{0}'"
	QueryByGUID  = "applications/{0}", "servicePrincipals(appId='{0}')", "servicePrincipals/{0}"
}
Register-REntraIdentityProvider @param