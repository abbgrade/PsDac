#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [System.IO.FileInfo] $DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Get-Column {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context DacPac -Skip:( -Not $DacPacFile.Exists ) {
        Context Model {
            BeforeAll {
                $Model = Import-DacModel -Path $DacPacFile
            }
            Context 'Table' {
                BeforeAll {
                    $Table = $Model | Get-DacTable -Name '[Application].[Cities]'
                }

                It 'Returns all columns of a table via unnamed parameter' {
                    $Columns = $Table | Get-DacColumn
                    $Columns | Should -Not -BeNullOrEmpty
                    $Columns.Count | Should -BeGreaterThan 3
                }

                It 'Returns all columns of a table via named parameter' {
                    $Columns = Get-DacColumn -Object $Table
                    $Columns | Should -Not -BeNullOrEmpty
                    $Columns.Count | Should -BeGreaterThan 3
                }

                It 'Returns all columns of a table via aliased parameter' {
                    $Columns = Get-DacColumn -Table $Table
                    $Columns | Should -Not -BeNullOrEmpty
                    $Columns.Count | Should -BeGreaterThan 3
                }

                It 'Returns a column of a table by name' {
                    $Column = $Table | Get-DacColumn -Name '[Application].[Cities].[CityID]'
                    $Column | Should -Not -BeNullOrEmpty
                }
            }
            Context 'View' {
                BeforeAll {
                    $View = $Model | Get-DacView -Name '[Website].[Customers]'
                }

                It 'Returns all columns of a view via unnamed parameter' {
                    $Columns = $View | Get-DacColumn
                    $Columns | Should -Not -BeNullOrEmpty
                    $Columns.Count | Should -BeGreaterThan 3
                }

                It 'Returns all columns of a view via named parameter' {
                    $Columns = Get-DacColumn -Object $View
                    $Columns | Should -Not -BeNullOrEmpty
                    $Columns.Count | Should -BeGreaterThan 3
                }

                It 'Returns a column of a view by name' {
                    $Column = $View | Get-DacColumn -Name '[Website].[Customers].[CustomerID]'
                    $Column | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
