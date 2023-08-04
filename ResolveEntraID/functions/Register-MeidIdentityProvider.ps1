function Register-MeidIdentityProvider {
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