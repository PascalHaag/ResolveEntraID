# ResolveEntraID

Welcome to the module toolkit designed to resolve GUIDs in Entra ID to needed properties or to resolve property to GUIDs.
If you want to export the name of users, groups, applications or all other things in Entra ID, but you have only the IDs of these?
Just use this module, it will help you to resolve the IDs to properties that YOU want!

## Installing

To use this module directly, you need to install it from the PowerShell Gallery:

```powershell
Install-Module ResolveEntraID -Scope CurrentUser
```

```powershell
Install-PSResorce ResolveEntraID -Scope CurrentUser
```

## Register Identity Provider

```powershell
#  Will register a provider with name "Group", the property to search for "displayName" with the query to get the GUID "groups?`$filter=displayName eq '{0}'" or to get the displayName "groups/{0}".
Register-REntraIdentityProvider -ProviderName "Group" -NameProperty "displayName" -IDProperty "id" -QueryByName "groups?`$filter=displayName eq '{0}'" -QueryByGUID "groups/{0}"
```

## Unregister Identity Provider

```powershell
# Unregister a provider with name "Group" and clear cache of the "Group" provider.
Unregister-REntraIdentityProvider -ProviderName "Group"
```

## Get Identity Provider

```powershell
# Get all providers.
Get-REntraIdentityProvider
```
```powershell
# Get all providers with name containing "User".
Get-REntraIdentityProvider -ProviderName "*User*"
```

## Resolve Identity

```powershell
# Will resolve the IDs "<ID>" and "<ID2>" with defined property in the providers "UserUPN" and "Group".
# The written output is ID, Name (Property), Provider and the result will be written in the cache.
Resolve-REntraIdentity -Identity "<ID>","<ID2>" -Provider UserUPN,Group
```

## Clear Identity Cache

```powershell
# Clears the Entra ID identiy cache.
Clear-REntraIdentityCache
```
```powershell
# Clears the cached identities for the providers "Group".
Clear-REntraIdentityCache -Provider "Group"
```

## Registered Provider by default

```powershell
# To see all queries of the single provider.

Get-REntraIdentityProvider
```

| ProviderName	| NameProperty 					| IdProperty 	|
| ------------- | ----------------------------- | ------------- |
| User        	| "userPrincipalName", "mail" 	| "id" 			|
| Group       	| displayName 					| "id" 			|
| Application 	| displayName 					| "appId", "id" |