#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [System.IO.FileInfo] $DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Get-ForeignKey {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context DacPac -Skip:( -Not $DacPacFile.Exists ) {
        Context Model {
            BeforeAll {
                $Model = Import-DacModel -Path $DacPacFile
            }

            It 'Returns all foreign keys of a model' {
                $Keys = $Model | Get-DacForeignKey
                $Keys | Should -Not -BeNullOrEmpty
                $Keys.Count | Should -BeGreaterThan 5
            }

            It 'Returns all foreign keys of a model by name' {
                $Key = $Model | Get-DacForeignKey -Name '[Application].[FK_Application_Cities_Application_People]'
                $Key | Should -Not -BeNullOrEmpty
                $Key.Name | Should -Be '[Application].[FK_Application_Cities_Application_People]'
                $Key.ObjectType.Name | Should -Be 'ForeignKeyConstraint'

                $Parent = $Key.GetParent()
                $Parent.Name | Should -Be '[Application].[Cities]'

                $Referenced = $Key.GetReferenced()

                $SourceTable, $TargetTable = $Referenced | Where-Object { $_.ObjectType.Name -eq 'Table' }

                $SourceTable.Name | Should -Be '[Application].[Cities]'
                $TargetTable.Name | Should -Be '[Application].[People]'

                $SourceColumn, $TargetColumn = $Referenced | Where-Object { $_.ObjectType.Name -eq 'Column' }

                $SourceColumn.Name | Should -Be '[Application].[Cities].[LastEditedBy]'
                $TargetColumn.Name | Should -Be '[Application].[People].[PersonID]'
            }
        }
    }
}
