#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-DacTable' {

    BeforeDiscovery {
        [System.IO.FileInfo] $Global:DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context 'DacPac' -Skip:( -Not $Global:DacPacFile.Exists ) {
        Context 'Model' {
            BeforeAll {
                $Script:Model = Import-DacModel -Path $Global:DacPacFile
            }

            It 'Returns all tables of a model' {
                $tables = $Script:Model | Get-DacTable
                $tables | Should -Not -BeNullOrEmpty
                $tables.Count | Should -BeGreaterThan 5
            }

            It 'Returns a table of a model by name' {
                $table = $Script:Model | Get-DacTable -Name '[Application].[Cities]'
                $table | Should -Not -BeNullOrEmpty
            }
        }
    }
}
