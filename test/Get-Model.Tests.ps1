#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-DacModel -Tag NotImplemented {

    BeforeDiscovery {
        [System.IO.FileInfo] $Script:DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context 'Model' -Skip:( -Not $Script:DacPacFile.Exists ) {
        BeforeAll {
            $Script:DacPac = Import-DacModel $Script:DacPacFile
        }

        It 'Returns the model of a package' {
            $model = $Script:DacPac | Get-DacModel
            $model | Should -Not -BeNullOrEmpty
        }
    }
}
