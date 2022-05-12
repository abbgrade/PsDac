#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [System.IO.FileInfo] $TestDbDacPacFile = "$PsScriptRoot\testdb\bin\Debug\testdb.dacpac",
    [System.IO.FileInfo] $WwiDacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe 'Get-DacDataType' {

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
        Context 'Model' {

            BeforeAll {
                $Script:Model = Import-DacModel -Path $TestDbDacPacFile
            }

            Context 'Table' {
                BeforeAll {
                    $Script:Table = $Script:Model | Get-DacTable -Name '[dbo].[MyTable]'
                }

                Context 'geography Column' {
                    BeforeAll {
                        $Script:Column = $Script:Table | Get-DacColumn -Name '[dbo].[MyTable].[Location]'
                    }

                    It 'Returns column info' {
                        $type = $Script:Column | Get-DacDataType
                        $type | Should -Not -BeNullOrEmpty
                        $type.Name | Should -Be 'geography'
                        $type.Length | Should -Be 0
                        $type.Precision | Should -Be 0
                        $type.Scale | Should -Be 0
                        $type.IsNullable | Should -Be $true
                        $type.IsMax | Should -Be $false
                    }
                }
            }
        }
    }

    Context 'wwi DacPac' -Skip:( -Not $WwiDacPacFile.Exists ) {
        Context 'Model' {
            BeforeAll {
                $Script:Model = Import-DacModel -Path $WwiDacPacFile
            }

            Context 'Table' {
                BeforeAll {
                    $Script:Table = $Script:Model | Get-DacTable -Name '[Purchasing].[PurchaseOrderLines]'
                }

                Context 'INT Column' {
                    BeforeAll {
                        $Script:Column = $Script:Table | Get-DacColumn -Name '[Purchasing].[PurchaseOrderLines].[PurchaseOrderLineID]'
                    }

                    It 'Returns column info' {
                        $type = $Script:Column | Get-DacDataType
                        $type | Should -Not -BeNullOrEmpty
                        $type.Name | Should -Be 'int'
                        $type.Length | Should -Be 0
                        $type.Precision | Should -Be 0
                        $type.Scale | Should -Be 0
                        $type.IsNullable | Should -Be $false
                        $type.IsMax | Should -Be $false
                    }
                }

                Context 'VARCHAR Column' {
                    BeforeAll {
                        $Script:Column = $Script:Table | Get-DacColumn -Name '[Purchasing].[PurchaseOrderLines].[Description]'
                    }

                    It 'Returns column info' {
                        $type = $Script:Column | Get-DacDataType
                        $type | Should -Not -BeNullOrEmpty
                        $type.Name | Should -Be 'NVarChar'
                        $type.Length | Should -Be 100
                        $type.Precision | Should -Be 0
                        $type.Scale | Should -Be 0
                        $type.IsNullable | Should -Not -BeNullOrEmpty
                        $type.IsMax | Should -Not -BeNullOrEmpty
                        $type.Collation | Should -Be $null
                    }
                }

                Context 'DECIMAL Column' {
                    BeforeAll {
                        $Script:Column = $Script:Table | Get-DacColumn -Name '[Purchasing].[PurchaseOrderLines].[ExpectedUnitPricePerOuter]'
                    }

                    It 'Returns column info' {
                        $type = $Script:Column | Get-DacDataType
                        $type | Should -Not -BeNullOrEmpty
                        $type.Name | Should -Be 'Decimal'
                        $type.Length | Should -Be 0
                        $type.Precision | Should -Be 18
                        $type.Scale | Should -Be 2
                        $type.IsNullable | Should -Not -BeNullOrEmpty
                        $type.IsMax | Should -Not -BeNullOrEmpty
                        $type.Collation | Should -Be $null
                    }
                }
            }
        }
    }
}
