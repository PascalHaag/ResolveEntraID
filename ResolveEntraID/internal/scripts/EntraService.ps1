$param = @{
    Name          = 'ResolveEntraGraph'
    ServiceUrl    = 'https://graph.microsoft.com/beta'
    Resource      = 'https://graph.microsoft.com'
    DefaultScopes = @()
    HelpUrl       = 'https://developer.microsoft.com/en-us/graph/quick-start'
}
Register-EntraService @param

$Script:PSDefaultParameterValues["Invoke-EntraRequest:Service"] = "ResolveEntraGraph"