function Register-REntraIdentityProvider {
	<#
    .SYNOPSIS
    Register Entra ID identity provider.

    .DESCRIPTION
    Register Microsoft Entra ID identity provider.
	This function will register a provider with the defined properties.
	Per default the provider are "User", "Group" and "Application" for more information, check the examples of this function.

    .PARAMETER ProviderName
    Name(s) of the Entra ID identity provider.

    .PARAMETER NameProperty
    Property(s) to search for. E.g.: userPrincipalName

    .PARAMETER IDProperty
	Property(s) to return. E.g.: id

	.PARAMETER QueryByName
	Query(s) to search for the property. E.g.: users?`$filter=userPrincipalName eq '{0}'

	.PARAMETER QueryByGUID
	Query(s) to search for the GUID. E.g.: users/{0}

	.EXAMPLE
	PS C:\> Register-REntraIdentityProvider -ProviderName "User" -NameProperty "userPrincipalName", "mail" -IDProperty "id" -QueryByName "users?`$filter=userPrincipalName eq '{0}' or mail eq '{0}'", "users?`$filter=Name eq '{0}'" -QueryByGUID "users/{0}"

	Will register a provider with name "User", the property to search for "userPrincipalName" and "mail" with the query to get the GUID "users?`$filter=userPrincipalName eq '{0}' or mail eq '{0}'" or "users?`$filter=Name eq '{0}'" or to get the userPrincipalName "users/{0}".

    .EXAMPLE
	PS C:\> Register-REntraIdentityProvider -ProviderName "Group" -NameProperty "displayName" -IDProperty "id" -QueryByName "groups?`$filter=displayName eq '{0}'" -QueryByGUID "groups/{0}"

	Will register a provider with name "Group", the property to search for "displayName" with the query to get the GUID "groups?`$filter=displayName eq '{0}'" or to get the displayName "groups/{0}".

	.EXAMPLE
	PS C:\> Register-REntraIdentityProvider -ProviderName "Application" -NameProperty "displayName" -IDProperty "appId", "id" -QueryByName "applications?`$filter=displayName eq '{0}'", "servicePrincipals?`$filter=displayName eq '{0}'" -QueryByGUID "applications/{0}", "servicePrincipals(appId='{0}')", "servicePrincipals/{0}"

	Will register a provider with name "Application", the property to search for "displayName" with the query to get the GUID "applications?`$filter=displayName eq '{0}'" or to get the displayName "applications/{0}".
	Will register a provider with name "Application", the property to search for "displayName" with the query to get the GUID "servicePrincipals?`$filter=displayName eq '{0}'" or to get the displayName "servicePrincipals(appId='{0}')".
	Will register a provider with name "Application", the property to search for "displayName" with the query to get the GUID "servicePrincipals?`$filter=displayName eq '{0}'" or to get the displayName "servicePrincipals/{0}".
    #>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string[]]
		$ProviderName,

		[Parameter(Mandatory)]
		[string[]]
		$NameProperty,

		[Parameter(Mandatory)]
		[string[]]
		$IDProperty,

		[Parameter(Mandatory)]
		[string[]]
		$QueryByName,

		[Parameter(Mandatory)]
		[string[]]
		$QueryByGUID
	)
	process {
		$queriesName = foreach ($item in $QueryByName) {
			if ($item -match "\{0\}") { $item; continue }
			$item.TrimEnd("/").Replace("{", "{{").Replace("}", "}}"), "{0}" -join "/"
		}
		$queriesGUID = foreach ($item in $QueryByGUID) {
			if ($item -match "\{0\}") { $item; continue }
			$item.TrimEnd("/").Replace("{", "{{").Replace("}", "}}"), "{0}" -join "/"
		}
		foreach ($entry in $ProviderName) {
			$script:IdentityProvider[$entry] = [PSCustomObject]@{
				Name         = $entry
				NameProperty = $NameProperty
				IDProperty   = $IDProperty
				QueryByName  = $queriesName
				QueryByGUID  = $queriesGUID
				PSTypeName   = "ResolveEntraID.Provider"
			}
		}
	}
}