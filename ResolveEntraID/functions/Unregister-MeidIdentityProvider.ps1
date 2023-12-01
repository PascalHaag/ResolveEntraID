function Unregister-MeidIdentityProvider {
    <#
    .SYNOPSIS
    Unregister Entra ID identity provider.
    
    .DESCRIPTION
    Unregister Microsoft Entra ID identity provider.
    
    .PARAMETER ProviderName
    Name of the provider that should be unregistered.
    
    .EXAMPLE
    PS C:\> Unregister-MeidIdentityProvider -Name "UserUPN"

    Will unregister a provider with name "UserUPN".

    .EXAMPLE
    PS C:\> Unregister-MeidIdentityProvider -Name "UserUPN", "Groups"

    Will unregister a provider with name "UserUPN" and "Groups".
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [PSFArgumentCompleter("ResolveEntraID.Provider")]
        [PSFValidateSet(TabCompletion = "ResolveEntraID.Provider")]
        [string[]]
        $ProviderName
    )
    process {
        foreach ($entry in $ProviderName ){
            Clear-MeidIdentityCache -Provider $entry
            $script:IdentityProvider.Remove($entry)
        }
    }
}