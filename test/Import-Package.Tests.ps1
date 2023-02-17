#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.2.0' }

param (
    [System.IO.FileInfo] $DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Install-Package {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context DacPac -Skip:( -Not $DacPacFile.Exists ) {

        It 'Imports the dacpac' {
            $DacPac = Import-DacPackage $DacPacFile
            $DacPac | Should -Not -BeNullOrEmpty
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
                    $DacPac = Import-DacPackage -DatabaseName $Database.Name -ApplicationName Test -ApplicationVersion '0.0.1' -ErrorAction Stop
                    $DacPac | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
