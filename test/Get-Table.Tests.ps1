#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [System.IO.FileInfo] $DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Get-Table {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context DacPac -Skip:( -Not $DacPacFile.Exists ) {
        Context Model {
            BeforeAll {
                $Model = Import-DacModel -Path $DacPacFile
            }

            It 'Returns all tables of a model' {
                $Tables = $Model | Get-DacTable
                $Tables | Should -Not -BeNullOrEmpty
                $Tables.Count | Should -BeGreaterThan 5
            }

            It 'Returns a table of a model by name' {
                $Table = $Model | Get-DacTable -Name '[Application].[Cities]'
                $Table | Should -Not -BeNullOrEmpty
            }
        }
    }
}
