function Get-REntraIdentityCache {
    <#
    .SYNOPSIS
    Get the Entra ID identiy cache.
    
    .DESCRIPTION
    Get the Microsoft Entra ID identiy cache. The cache is used to cache the mapping between the ID and resolved name.

    .PARAMETER Provider
    Name(s) of provider
    
    .EXAMPLE
    PS C:\> Get-MeidIdentityCache
    
    Get the Entra ID identiy cache.

    .EXAMPLE
    PS C:\> Get-MeidIdentityCache -Provider "UserUPN", "Group"
    
    Get the Entra ID identiy cache of Providers "UserUPN", "Group".
    #>
    [CmdletBinding()]
    param (
        [string[]]
        $Provider
    )
    if (-not $Provider) {
        $script:IdNameMappingTable
    }
    else {
        foreach ($providerName in $Provider){
            $script:IdNameMappingTable[$providerName]
        }
    }
}