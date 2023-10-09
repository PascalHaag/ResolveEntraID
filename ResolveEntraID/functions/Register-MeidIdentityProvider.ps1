function Register-MeidIdentityProvider {
    <#
    .SYNOPSIS
    Register Entra ID identity provider.
    
    .DESCRIPTION
    Register Microsoft Entra ID identity provider.
    
    .PARAMETER Name
    Name(s) of the Entra ID identity provider.
    
    .PARAMETER NameProperty
    Property(s) to search for. E.g.: userPrincipalName
    
    .PARAMETER Query
    Graph endpoint url. E.g.: users
    
    .EXAMPLE
    PS C:\> Register-MeidIdentityProvider -Name "UserUPN" -NameProperty "userPrincipalName" -Query "users"

    Will register a provider with name "UserUPN", the property to search for "userPrincipalName" with the query "users/{0}".
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]
        $Name,

        [Parameter(Mandatory)]
        [string[]]
        $NameProperty,

        [Parameter(Mandatory)]
        [string[]]
        $Query
    )
    process {
        $queries = foreach ($item in $Query){
            if($item -match "\{0\}"){ $item; continue}
            $item.TrimEnd("/").Replace("{","{{").Replace("}","}}"), "{0}" -join "/"
        } 
        foreach ($entry in $Name) {
            $script:IdentityProvider[$entry] = [PSCustomObject]@{
                Name         = $entry
                NameProperty = $NameProperty
                Query        = $queries
            }
        }
    }
}