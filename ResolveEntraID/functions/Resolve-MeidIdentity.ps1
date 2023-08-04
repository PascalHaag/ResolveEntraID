function Resolve-MeidIdentity {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id,

        [Parameter(Mandatory)]
        [string[]]
        $Provider,

        [switch]
        $NoCache,

        [switch]
        $NameOnly
    )
    begin {
        function Write-Result {
            [CmdletBinding()]
            param (
                [string]
                $Id,

                [string]
                $Provider,

                [string]
                $Value,

                [switch]
                $NameOnly,

                [switch]
                $NoCache
            )
            $result = [PSCustomObject]@{
                ID = $Id
                Name = $Value
                Provider = $Provider
            }
            if ($NameOnly) { $Value }
            else { $result }
            if(-not $NoCache) { $script:IdNameMappingTable[$Id] = $result}
        }
    }
    process {
        foreach ($entry in $Id) {
            if ($entry -notmatch '^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$') {
                $entry
                continue
            }
            if ($script:IdNameMappingTable[$entry] -and -not $NoCache) {
                Write-Result -Id $entry -Value $script:IdNameMappingTable[$entry].Name -NoCache -Provider $script:IdNameMappingTable[$entry].Provider
                continue
            }
            foreach ($providerName in $Provider){
                
            }
        }
    }
    end {
    
    }
}