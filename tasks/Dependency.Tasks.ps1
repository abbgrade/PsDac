task InstallBuildDependencies -Jobs {
    Install-Module platyPs -Scope CurrentUser -ErrorAction Stop -Verbose
}

task InstallTestDependencies -Jobs {
    Install-Module PsSqlLocalDb -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease
    Install-Module PsSqlTestServer -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease
}

task InstallReleaseDependencies -Jobs {}
