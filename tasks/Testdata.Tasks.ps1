
[System.IO.DirectoryInfo] $SqlServerSamplesDirectory = "$PSScriptRoot\..\test\sql-server-samples"
[string] $WwiSsdtRelativePath = 'samples/databases/wide-world-importers/wwi-ssdt/wwi-ssdt'
[System.IO.DirectoryInfo] $WwiSsdtDirectory = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath
[System.IO.FileInfo] $WideWorldImportersProject = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath "WideWorldImporters.sqlproj"
[System.IO.FileInfo] $WideWorldImportersDacPac = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath "bin\Debug\WideWorldImporters.dacpac"

task TestData.DacPac.WWI.Clean -If { $SqlServerSamplesDirectory.Exists } -Jobs {
    Remove-Item $SqlServerSamplesDirectory -Recurse -Force
}

task TestData.DacPac.WWI.AddSolution -If { -Not $SqlServerSamplesDirectory.Exists } -Jobs {
    New-Item $SqlServerSamplesDirectory -ItemType Directory -ErrorAction Continue
}

task TestData.DacPac.WWI.InitSolution -If { -Not ( Test-Path "$SqlServerSamplesDirectory\.git" ) } -Jobs TestData.DacPac.WWI.AddSolution, {
    Push-Location $SqlServerSamplesDirectory
    exec { git init }
    exec { git remote add origin -f https://github.com/microsoft/sql-server-samples.git }
    Pop-Location
}

task TestData.DacPac.WWI.CheckoutSolution -If { -Not $WwiSsdtDirectory.Exists } -Jobs TestData.DacPac.WWI.InitSolution, {
    Push-Location $SqlServerSamplesDirectory
    exec { git config core.sparseCheckout true }
    Set-Content .git/info/sparse-checkout $WwiSsdtRelativePath
    exec { git checkout master }
    Pop-Location
}

task TestData.DacPac.WWI.Create -If { -Not $WideWorldImportersDacPac.Exists } -Jobs TestData.DacPac.WWI.CheckoutSolution, {
    # # can be enabled if dotnet core build is public and working
    # exec { dotnet build "$SqlServerSamplesDirectory\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\WideWorldImporters.sqlproj" /p:NetCoreBuild=true }

    assert $WideWorldImportersProject
    Write-Verbose "WideWorldImportersProject: $WideWorldImportersProject"

    Invoke-MsBuild $WideWorldImportersProject

    assert ( Test-Path $WideWorldImportersDacPac )
}

task TestData.Create -Jobs TestData.DacPac.WWI.Create
