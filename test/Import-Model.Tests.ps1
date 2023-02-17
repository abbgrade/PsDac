#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [System.IO.FileInfo] $DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Import-Model {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context DacPac -Skip:( -Not $DacPacFile.Exists ) {
        It 'Imports the model from a DacPac' {
            $Model = Import-DacModel -Path $DacPacFile
            $Model | Should -Not -BeNullOrEmpty
        }
    }
}
