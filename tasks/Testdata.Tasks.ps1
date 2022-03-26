
[System.IO.DirectoryInfo] $SqlServerSamplesDirectory = "$PSScriptRoot\..\test\sql-server-samples"
[string] $WwiSsdtRelativePath = 'samples/databases/wide-world-importers/wwi-ssdt/wwi-ssdt'
[System.IO.DirectoryInfo] $WwiSsdtDirectory = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath
[System.IO.FileInfo] $WideWorldImportersProject = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath "WideWorldImporters.sqlproj"
[System.IO.FileInfo] $WideWorldImportersDacPac = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath "bin\Debug\WideWorldImporters.dacpac"

task Testdata.DacPac.WWI.Clean -If { $SqlServerSamplesDirectory.Exists } -Jobs {
    Remove-Item $SqlServerSamplesDirectory -Recurse -Force
}

task Testdata.DacPac.WWI.AddSolution -If { -Not $SqlServerSamplesDirectory.Exists } -Jobs {
    New-Item $SqlServerSamplesDirectory -ItemType Directory -ErrorAction Continue
}

task Testata.DacPac.WWI.InitSolution -If { -Not ( Test-Path "$SqlServerSamplesDirectory\.git" ) } -Jobs Testdata.DacPac.WWI.AddSolution, {
    Push-Location $SqlServerSamplesDirectory
    exec { git init }
    exec { git remote add origin -f https://github.com/microsoft/sql-server-samples.git }
    Pop-Location
}

task Testdata.DacPac.WWI.CheckoutSolution -If { -Not $WwiSsdtDirectory.Exists } -Jobs Testdata.DacPac.WWI.InitSolution, {
    Push-Location $SqlServerSamplesDirectory
    exec { git config core.sparseCheckout true }
    Set-Content .git/info/sparse-checkout $WwiSsdtRelativePath
    exec { git pull --depth=1 origin master --verbose }
    Pop-Location
}

task Testdata.DacPac.WWI.Create -If { -Not $WideWorldImportersDacPac.Exists } -Jobs Testdata.DacPac.WWI.CheckoutSolution, {
    # # can be enabled if dotnet core build is public and working
    # exec { dotnet build "$SqlServerSamplesDirectory\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\WideWorldImporters.sqlproj" /p:NetCoreBuild=true }

    Import-Module Invoke-MsBuild

    Invoke-MsBuild $WideWorldImportersProject

    assert ( Test-Path $WideWorldImportersDacPac )
}

task Testdata.Create -Jobs Testdata.DacPac.WWI.Create
