. $PSScriptRoot/PsSqlTestTasks/SqlServerSamples.Tasks.ps1
. $PSScriptRoot/PsSqlTestTasks/SqlServerTestProject.Tasks.ps1
. $PSScriptRoot/PsSqlTestTasks/testdb.Tasks.ps1

task Testdata.Create -Jobs PsSqlTestTasks.TestDb.DacPac.Create
