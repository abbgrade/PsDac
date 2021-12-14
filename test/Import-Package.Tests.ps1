#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Install-DacPackage' {

    BeforeDiscovery {
        [System.IO.FileInfo] $Script:DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsDac\bin\Debug\net5.0\publish\PsDac.psd1 -ErrorAction Stop
    }

    Context 'DacPac' -Skip:( -Not $Script:DacPacFile.Exists ) {

        It 'Imports the dacpac' {
            $Script:DacPac = Import-DacPackage $Script:DacPacFile
            $Script:DacPac | Should -Not -BeNullOrEmpty
        }

    }
}
