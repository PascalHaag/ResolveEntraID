function Clear-MeidIdentityCache {
    <#
    .SYNOPSIS
    Clears the Entra ID identiy cache.
    
    .DESCRIPTION
    Clears the Microsoft Entra ID identiy cache. The cache is used to cache the mapping between the ID and resolved name.

    .PARAMETER Provider
    Name(s) of provider, where the cache should be cleared.
    
    .EXAMPLE
    PS C:\> Clear-MeidIdentityCache
    
    Clears the Entra ID identiy cache.

    .EXAMPLE
    PS C:\> Clear-MeidIdentityCache -Provider "UserUPN", "Group"
    
    Clears the Entra ID identiy cache of Providers "UserUPN", "Group".
    #>
    [CmdletBinding()]
    param (
        [string[]]
        $Provider
    )
    if (-not $Provider) {
        $script:IdNameMappingTable = @{}
    }
    else {
        foreach ($providerName in $Provider){
            $script:IdNameMappingTable.Remove($providerName)
        }
    }
}