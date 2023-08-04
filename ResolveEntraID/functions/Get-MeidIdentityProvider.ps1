function Get-MeidIdentityProvider {
    [CmdletBinding()]
    param (
        [string]
        $Name = '*' 
    )
    process {
        $script:IdentityProvider.Values | Where-Object Name -like $Name
    }
}