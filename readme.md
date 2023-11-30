# ResolveEntraID

# PSGetInternal

Welcome to the module toolkit designed to resolve IDs in Entra ID to needed properties.
If you want to export the name of users, groups, applications or all other things in Entra ID, but you have only the IDs of these?
Just use this module, it will help you to resolve the IDs to properties that YOU want!  

## Installing

To use this module directly, you need to install it from the PowerShell Gallery:

```powershell
Install-Module ResolveEntraID -Scope CurrentUser
```

## Register Identity Provider

```powershell
#  Register a provider with name "UserUPN", the property to search for "userPrincipalName" with the query "users".
Register-MeidIdentityProvider -Name "UserUPN" -NameProperty "userPrincipalName" -Query "users"
```

## Unregister Identity Provider

```powershell
# Unregister a provider with name "UserUPN" and clear cache of the "UserUPN" provider.
Unregister-MeidIdentityProvider -Name "UserUPN"
```

## Get Identity Provider

```powershell
# Get all registered Microsoft Entra ID identity provider.
Get-MeidIdentityProvider
```
```powershell
# Get registered Microsoft Entra ID identity provider where name like "*User*".
Get-MeidIdentityProvider -Name "*User*"
```

## Resolve Identity

```powershell
# Will resolve the IDs "xyz" and "abc" with defined property in the providers "UserUPN" and "Group".
# The written output is ID, Name (Property), Provider and the result will be written in the cache.
Resolve-MeidIdentity -ID "xyz","abc" -Provider UserUPN,Group
```

## Clear Identity Cache

```powershell
# Clears the Entra ID identiy cache.
Clear-MeidIdentityCache
```
```powershell
# Clears the Entra ID identiy cache of provider "UserUPN".
Clear-MeidIdentityCache -ProviderName "UserUPN"
```

## Registered Provider by default

| Name        | Property          | Query        |
| ----------- | ----------------- | ------------ |
| User        | userPrinciaplName | users        |
| Group       | displayName       | groups       |
| Application | displayName       | applications |