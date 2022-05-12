#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Install-DacPackage' {

    BeforeDiscovery {
        [System.IO.FileInfo] $Global:DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context 'DacPac' -Skip:( -Not $Global:DacPacFile.Exists ) {

        It 'Imports the dacpac' {
            $Script:DacPac = Import-DacPackage $Global:DacPacFile
            $Script:DacPac | Should -Not -BeNullOrEmpty
        }

    }
}
