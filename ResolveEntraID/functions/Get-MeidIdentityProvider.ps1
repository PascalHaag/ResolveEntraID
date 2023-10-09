function Get-MeidIdentityProvider {
    <#
    .SYNOPSIS
    Get registered Entra ID identity provider.
    
    .DESCRIPTION
    Get by the user registered Microsoft Entra ID identity provider.
    
    .PARAMETER Name
    Can be used to filter for Name of the registered Entra ID identity provider.
    
    .EXAMPLE
    PS C:\> Get-MeidIdentityProvider

    Get all registered Microsoft Entra ID identity provider.
    
    .EXAMPLE
    PS C:\> Get-MeidIdentityProvider -Name "*User*"

    Get registered Microsoft Entra ID identity provider where name like "*User*".
    #>
    [CmdletBinding()]
    param (
        [PSFArgumentCompleter("ResolveEntraID.Provider")]
        [string]
        $Name = '*'
    )
    process {
        $script:IdentityProvider.Values | Where-Object Name -like $Name
    }
}