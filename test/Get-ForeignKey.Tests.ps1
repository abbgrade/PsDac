#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-DacForeignKey' {

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

            It 'Returns all foreign keys of a model' {
                $keys = $Script:Model | Get-DacForeignKey
                $keys | Should -Not -BeNullOrEmpty
                $keys.Count | Should -BeGreaterThan 5
            }

            It 'Returns all foreign keys of a model by name' {
                $key = $Script:Model | Get-DacForeignKey -Name '[Application].[FK_Application_Cities_Application_People]'
                $key | Should -Not -BeNullOrEmpty
                $key.Name | Should -Be '[Application].[FK_Application_Cities_Application_People]'
                $key.ObjectType.Name | Should -Be 'ForeignKeyConstraint'

                $parent = $key.GetParent()
                $parent.Name | Should -Be '[Application].[Cities]'

                $referenced = $key.GetReferenced()

                $sourceTable, $targetTable = $referenced | Where-Object { $_.ObjectType.Name -eq 'Table' }

                $sourceTable.Name | Should -Be '[Application].[Cities]'
                $targetTable.Name | Should -Be '[Application].[People]'

                $sourceColumn, $targetColumn = $referenced | Where-Object { $_.ObjectType.Name -eq 'Column' }

                $sourceColumn.Name | Should -Be '[Application].[Cities].[LastEditedBy]'
                $targetColumn.Name | Should -Be '[Application].[People].[PersonID]'
            }
        }
    }
}
