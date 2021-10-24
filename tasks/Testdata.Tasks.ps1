[System.IO.FileInfo] $Script:TestdataBackup = "$PSScriptRoot\..\test\WideWorldImporters-Full.bak"

task Testdata.Download -If { -Not ( $Script:TestdataBackup.Exists ) } -Jobs {
    Invoke-WebRequest `
        -Uri https://github.com/microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak `
        -OutFile $Script:TestdataBackup
}

task Testdata.ConnectDatabase -Jobs {
    Import-Module PsSqlClient
    Connect-TSqlInstance -DataSource '(LocalDb)\MSSQLLocalDB'
}

task Testdata.Restore -Jobs Testdata.Download, Testdata.ConnectDatabase, {

}

task Testdata.DacPac.InitSolution -Jobs {
    Remove-Item $PSScriptRoot\..\test\sql-server-samples -Recurse -Force
}

task Testdata.DacPac.CheckoutSolution -Jobs Testdata.DacPac.InitSolution, {
    $testdata = New-Item $PSScriptRoot\..\test\sql-server-samples -ItemType Directory
    Push-Location $testdata
    git init
    git remote add origin -f https://github.com/microsoft/sql-server-samples.git
    git config core.sparseCheckout true
    Set-Content .git/info/sparse-checkout samples/databases/wide-world-importers/wwi-ssdt/wwi-ssdt
    git pull --depth=1 origin master
    Pop-Location
}

task Testdata.DacPac.Create -Jobs {
    # # can be enabled if dotnet core build is public and working
    # exec { dotnet build "$PsScriptRoot\..\test\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\WideWorldImporters.sqlproj" /p:NetCoreBuild=true }

    Install-Module Invoke-MsBuild
    Import-Module Invoke-MsBuild
    Invoke-MsBuild "$PsScriptRoot\..\test\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\WideWorldImporters.sqlproj"

    assert ( Test-Path "$PsScriptRoot\..\test\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac" )
}

task Testdata.Create -Jobs Testdata.DacPac.Create
