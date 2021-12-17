#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-DacSchema' {

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

            It 'Returns all schemas of a model' {
                $schemas = $Script:Model | Get-DacSchema
                $schemas | Should -Not -BeNullOrEmpty
                $schemas.Count | Should -BeGreaterThan 3
            }

            It 'Returns all schemas of a model by name' {
                $schema = $Script:Model | Get-DacSchema -Name 'Application'
                $schema | Should -Not -BeNullOrEmpty
                $schema.Name | Should -Be '[Application]'
            }
        }
    }
}
