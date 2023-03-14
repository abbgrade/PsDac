#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.2.0' }

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
        It 'Imports the model from a DacPac by position' {
            $Model = Import-DacModel $DacPacFile
            $Model | Should -Not -BeNullOrEmpty
        }
    }


    Context Server {

        BeforeAll {
            $TestServer = New-SqlTestInstance
            $SqlConnection = Connect-TSqlInstance -ConnectionString $TestServer.ConnectionString
        }

        AfterAll {
            $TestServer | Remove-SqlTestInstance
        }

        Context DacService {

            BeforeAll {
                $DacService = $TestServer | Connect-DacService -ErrorAction Stop
            }

            AfterAll {
                if ( $DacService ) {
                    Disconnect-DacService
                }
            }

            Context Database {
                BeforeAll {
                    $Database = New-SqlTestDatabase -Instance $TestServer -InstanceConnection $SqlConnection
                }

                AfterAll {
                    $Database | Remove-SqlTestDatabase
                }

                It 'Extracts from the database' {
                    $Model = Import-DacModel -DatabaseName $Database.Name -ErrorAction Stop
                    $Model | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
