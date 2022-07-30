#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [System.IO.FileInfo] $DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Get-Schema {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context DacPac -Skip:( -Not $DacPacFile.Exists ) {
        Context Model {
            BeforeAll {
                $Model = Import-DacModel -Path $DacPacFile
            }

            It 'Returns all schemas of a model' {
                $Schemas = $Model | Get-DacSchema
                $Schemas | Should -Not -BeNullOrEmpty
                $Schemas.Count | Should -BeGreaterThan 3
            }

            It 'Returns all schemas of a model by name' {
                $Schema = $Model | Get-DacSchema -Name 'Application'
                $Schema | Should -Not -BeNullOrEmpty
                $Schema.Name | Should -Be '[Application]'
            }
        }
    }
}
