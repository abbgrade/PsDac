#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [System.IO.FileInfo] $DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Get-DacModel -Tag NotImplemented {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context 'Model' -Skip:( -Not $DacPacFile.Exists ) {
        BeforeAll {
            Write-Verbose $DacPacFile -Verbose
            $DacPac = Import-DacModel -Path $DacPacFile -Verbose
        }

        It 'Returns the model of a package' {
            $model = $DacPac | Get-DacModel
            $model | Should -Not -BeNullOrEmpty
        }
    }
}
