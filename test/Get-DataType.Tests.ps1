#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-DacDataType' {

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
