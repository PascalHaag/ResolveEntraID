$param = @{
    Name = "Application"
    NameProperty = "displayName"
    Query = "applications/{0}"
}
Register-MeidIdentityProvider @param