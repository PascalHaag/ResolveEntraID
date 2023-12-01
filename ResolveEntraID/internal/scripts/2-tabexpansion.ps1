Register-PSFTeppScriptblock -Name ResolveEntraID.Provider -ScriptBlock {
    foreach ($provider in Get-MeidIdentityProvider){
        @{
            Text = $provider.Name
            ToolTip = "{0} --> Property: {1}" -f $provider.Name, ($provider.NameProperty -join ", ")
        }
    }
}