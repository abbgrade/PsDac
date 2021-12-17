Describe 'Get-DacTable' {

    BeforeDiscovery {
        [System.IO.FileInfo] $Script:DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsDac\bin\Debug\net5.0\publish\PsDac.psd1 -ErrorAction Stop
    }

    Context 'DacPac' -Skip:( -Not $Script:DacPacFile.Exists ) {
        Context 'Model' {
            BeforeAll {
                $Script:Model = Import-DacModel -Path $Script:DacPacFile
            }

            It 'Returns all tables' {
                $tables = $Script:Model | Get-DacTable
                $tables | Should -Not -BeNullOrEmpty
                $tables.Count | Should -BeGreaterThan 5
            }

            It 'Returns a table by name' {
                $table = $Script:Model | Get-DacTable -Name '[Application].[Cities]'
                $table | Should -Not -BeNullOrEmpty
            }
        }
    }
}
