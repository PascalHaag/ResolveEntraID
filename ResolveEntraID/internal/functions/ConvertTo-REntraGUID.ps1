function ConvertFrom-REntraNameToGUID {
    <#
    .SYNOPSIS
    Resolve Entra ID identity.
    
    .DESCRIPTION
    Resolve Microsoft Entra ID identity.
    This function will resolve an ID to a user defined property.
    Requires an active connection to Azure with MiniGraph.
    
    .PARAMETER Id
    ID(s) that should be resolved by the function.
    
    .PARAMETER Provider
    Provider(s) that should be used to resolve the ID(s).
    
    .PARAMETER NoCache
    Option that no Cache will be created. ID(s) with the mapping property will not be cached.
    
    .PARAMETER NameOnly
    Option that only show the resolved name.
    
    .EXAMPLE
    PS C:\> Resolve-MeidIdentity -ID "xyz" -Provider UserUPN

    Will resolve the ID "xyz" with defined property in the provider "UserUPN".
    The written output is ID, Name (Property), Provider and the result will be written in the cache.
    
    .EXAMPLE
    PS C:\> Resolve-MeidIdentity -ID "xyz","abc" -Provider UserUPN,Group

    Will resolve the IDs "xyz" and "abc" with defined property in the providers "UserUPN" and "Group".
    The written output is ID, Name (Property), Provider and the result will be written in the cache.

    .EXAMPLE
    PS C:\> Resolve-MeidIdentity -ID "xyz","abc" -Provider UserUPN,Group -NoCache

    Will resolve the IDs "xyz" and "abc" with defined property in the providers "UserUPN" and "Group".
    The written output is ID, Name (Property), Provider and the result will NOT be written in the cache.

    .EXAMPLE
    PS C:\> Resolve-MeidIdentity -ID "xyz","abc" -Provider UserUPN,Group -NoCache -NameOnly

    Will resolve the IDs "xyz" and "abc" with defined property in the providers "UserUPN" and "Group".
    The written output is only Name (Property) and the result will NOT be written in the cache.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [AllowEmptyCollection()]
        [AllowNull()]
        [string[]]
        $IdentityName,

        [Parameter(Mandatory)]
        [PSFArgumentCompleter("ResolveEntraID.Provider")]
        [PSFValidateSet(TabCompletion = "ResolveEntraID.Provider")]
        [string[]]
        $Provider,

        [switch]
        $NoCache,

        [switch]
        $NameOnly
    )
    begin {
        function Write-Result {
            <#
            .SYNOPSIS
            Write the result
    
            .DESCRIPTION
            Write the result in several variants:
            ID, Name (resolved Property), Provider

            or with NameOnly
            Name

            The function will also write the result in the cache (IdNameMappingTable), if NoCache isn't set.
            #>
            [OutputType([string])]
            [CmdletBinding()]
            param (
                [string]
                $Id,

                [string]
                $Provider,

                [string]
                $Value,

				[ValidateSet("ID", "Name")]
                [string]
                $NameOnly,

                [switch]
                $NoCache
            )
            $result = [PSCustomObject]@{
                ID       = $Id
                Name     = $Value
                Provider = $Provider
            }
            if ($NameOnly) { $Value }
            else { $result }

            if ($NoCache) { return }

            if (-not $script:IdNameMappingTable[$Provider]) {
                $script:IdNameMappingTable[$Provider] = @{}
            }
            $script:IdNameMappingTable[$Provider][$Name] = $result
        }
    }
    process {
        :main foreach ($entry in $IdentityName) {
            foreach ($providerName in $Provider) {
                if ($NoCache) { break }
                if ($script:IdNameMappingTable[$providerName].$entry) {
                    Write-Result -Id $script:IdNameMappingTable[$providerName].$entry.ID -Name $entry -NoCache -Provider $providerName
                    continue main
                }
            }
            foreach ($providerName in $Provider) {
                $providerObject = $script:IdentityProvider[$providerName]
                if (-not $providerObject) {
                    Write-PSFMessage -Level Error -Message "Could not find identity provider {0}. Please register or check the spelling of the provider. Known providers: {1}" -StringValues $providerName, ((Get-MeidIdentityProvider).Name -join ", ") -Target $providerName
                    continue
                }
                try {
					foreach ($propertyName in $providerObject.NameProperty) {
						$graphResponse = MiniGraph\Invoke-GraphRequest -Query ($providerObject.QueryToGetGUID -f "?`$filter=$propertyName eq '$entry'") -ErrorAction Stop
						if (-not $graphResponse) { continue }
                        $resolvedName = $graphResponse.$propertyName
                        if (-not $resolvedName) { continue }
                        break
                    }
                    if (-not $resolvedName) {
                        $resolvedName = $entry
                        Write-PSFMessage -Level SomewhatVerbose -Message "{0} of type {1} could be found but failed to resolve the {2}." -StringValues $entry, $providerName, ($providerObject.NameProperty -join ", ") -Target $entry -Tag $providerName
                    }
                    Write-Result -Id $entry -Value $resolvedName -Provider $providerName -NameOnly:$NameOnly -NoCache:$NoCache
                    continue main
                }
                catch {
                    if ($_.ErrorDetails.Message -match '"code":\s*"Request_ResourceNotFound"') {
                        Write-PSFMessage -Level InternalComment -Message "ID {0} could not found as {1}." -StringValues $entry, $providerName -Target $entry -Tag $providerName -ErrorRecord $_ -OverrideExceptionMessage
                        continue
                    }
                    Write-PSFMessage -Level Error -Message "Error resolving {0}." -StringValues $entry -ErrorRecord $_ -Target $entry -Tag $providerName, "fail" -EnableException $true -PSCmdlet $PSCmdlet
                }
            }
            Write-Result -Id $entry -Value $entry -Provider "Unknown" -NameOnly:$NameOnly -NoCache
        }
    }
    end {
    
    }
}