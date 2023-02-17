#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [System.IO.FileInfo] $TestDbDacPacFile = "$PsScriptRoot\sql-server-test-project\testdb\bin\Debug\testdb.dacpac",
    [System.IO.FileInfo] $WwiDacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Get-DataType {

    BeforeDiscovery {
        if ( -Not $TestDbDacPacFile.Exists ) {
            Write-Warning "Skip tests with testdb.dacpac requirement."
        }

        if ( -Not $WwiDacPacFile.Exists ) {
            Write-Warning "Skip tests with WideWorldImporters.dacpac requirement."
        }
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context 'testdb DacPac' -Skip:( -Not $TestDbDacPacFile.Exists ) {
        Context Model {

            BeforeAll {
                $Model = Import-DacModel -Path $TestDbDacPacFile
            }

            Context Table {
                BeforeAll {
                    $Table = $Model | Get-DacTable -Name '[dbo].[MyTable]'
                }

                Context 'geography Column' {
                    BeforeAll {
                        $Column = $Table | Get-DacColumn -Name '[dbo].[MyTable].[Location]'
                    }

                    It 'Returns column info' {
                        $Type = $Column | Get-DacDataType
                        $Type | Should -Not -BeNullOrEmpty
                        $Type.Name | Should -Be 'geography'
                        $Type.Length | Should -Be 0
                        $Type.Precision | Should -Be 0
                        $Type.Scale | Should -Be 0
                        $Type.IsNullable | Should -Be $true
                        $Type.IsMax | Should -Be $false
                    }
                }
            }
        }
    }

    Context 'wwi DacPac' -Skip:( -Not $WwiDacPacFile.Exists ) {
        Context Model {
            BeforeAll {
                $Model = Import-DacModel -Path $WwiDacPacFile
            }

            Context Table {
                BeforeAll {
                    $Table = $Model | Get-DacTable -Name '[Purchasing].[PurchaseOrderLines]'
                }

                Context 'INT Column' {
                    BeforeAll {
                        $Column = $Table | Get-DacColumn -Name '[Purchasing].[PurchaseOrderLines].[PurchaseOrderLineID]'
                    }

                    It 'Returns column info' {
                        $Type = $Column | Get-DacDataType
                        $Type | Should -Not -BeNullOrEmpty
                        $Type.Name | Should -Be 'int'
                        $Type.Length | Should -Be 0
                        $Type.Precision | Should -Be 0
                        $Type.Scale | Should -Be 0
                        $Type.IsNullable | Should -Be $false
                        $Type.IsMax | Should -Be $false
                    }
                }

                Context 'VARCHAR Column' {
                    BeforeAll {
                        $Column = $Table | Get-DacColumn -Name '[Purchasing].[PurchaseOrderLines].[Description]'
                    }

                    It 'Returns column info' {
                        $Type = $Column | Get-DacDataType
                        $Type | Should -Not -BeNullOrEmpty
                        $Type.Name | Should -Be 'NVarChar'
                        $Type.Length | Should -Be 100
                        $Type.Precision | Should -Be 0
                        $Type.Scale | Should -Be 0
                        $Type.IsNullable | Should -Not -BeNullOrEmpty
                        $Type.IsMax | Should -Not -BeNullOrEmpty
                        $Type.Collation | Should -Be $null
                    }
                }

                Context 'DECIMAL Column' {
                    BeforeAll {
                        $Column = $Table | Get-DacColumn -Name '[Purchasing].[PurchaseOrderLines].[ExpectedUnitPricePerOuter]'
                    }

                    It 'Returns column info' {
                        $Type = $Column | Get-DacDataType
                        $Type | Should -Not -BeNullOrEmpty
                        $Type.Name | Should -Be 'Decimal'
                        $Type.Length | Should -Be 0
                        $Type.Precision | Should -Be 18
                        $Type.Scale | Should -Be 2
                        $Type.IsNullable | Should -Not -BeNullOrEmpty
                        $Type.IsMax | Should -Not -BeNullOrEmpty
                        $Type.Collation | Should -Be $null
                    }
                }
            }
        }
    }
}
