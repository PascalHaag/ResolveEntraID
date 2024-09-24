function Register-REntraIdentityProvider {
	<#
    .SYNOPSIS
    Register Entra ID identity provider.
    
    .DESCRIPTION
    Register Microsoft Entra ID identity provider.
    
    .PARAMETER ProviderName
    Name(s) of the Entra ID identity provider.
    
    .PARAMETER NameProperty
    Property(s) to search for. E.g.: userPrincipalName
    
    .PARAMETER Query
    Graph endpoint url. E.g.: users
    
    .EXAMPLE
    PS C:\> Register-MeidIdentityProvider -ProviderName "UserUPN" -NameProperty "userPrincipalName" -Query "users"

    Will register a provider with name "UserUPN", the property to search for "userPrincipalName" with the query "users/{0}".
    
    .NOTES
    General notes
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
				QueryByName  = $queriesName
				QueryByGUID  = $queriesGUID
				PSTypeName   = "ResolveEntraID.Provider"
			}
		}
	}
}