$param = @{
    Name = "Group"
    NameProperty = "displayName"
    Query = "groups/{0}"
}
Register-MeidIdentityProvider @param