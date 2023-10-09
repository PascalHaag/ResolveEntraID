$param = @{
    Name = "User"
    NameProperty = "userPrincipalName"
    Query = "users/{0}"
}
Register-MeidIdentityProvider @param