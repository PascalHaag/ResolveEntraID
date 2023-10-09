function Clear-MeidIdentityCache {
    <#
    .SYNOPSIS
    Clears the Entra ID identiy cache.
    
    .DESCRIPTION
    Clears the Microsoft Entra ID identiy cache. The cache is used to cache the mapping between the ID and resolved name.
    
    .EXAMPLE
    PS C:\> Clear-MeidIdentityCache
    
    Clears the Entra ID identiy cache.
    #>
    [CmdletBinding()]
    param ()
    $script:IdNameMappingTable = @{}
}