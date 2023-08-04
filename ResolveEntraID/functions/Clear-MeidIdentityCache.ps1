function Clear-MeidIdentityCache {
    [CmdletBinding()]
    param ()
    $script:IdNameMappingTable = @{}
}