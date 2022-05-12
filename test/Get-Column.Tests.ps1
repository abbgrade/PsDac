#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-DacColumn' {

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
            Context 'Table' {
                BeforeAll {
                    $Script:Table = $Script:Model | Get-DacTable -Name '[Application].[Cities]'
                }

                It 'Returns all columns of a table' {
                    $columns = $Script:Table | Get-DacColumn
                    $columns | Should -Not -BeNullOrEmpty
                    $columns.Count | Should -BeGreaterThan 3
                }

                It 'Returns a column of a table by name' {
                    $column = $Script:Table | Get-DacColumn -Name '[Application].[Cities].[CityID]'
                    $column | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
