#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.2.0' }

param (
    [System.IO.FileInfo] $DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Export-Model {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context DacPac -Skip:( -Not $DacPacFile.Exists ) {

        Context Model {
            BeforeAll {
                $Model = Import-DacModel -Path $DacPacFile
            }

            It 'Exports to dacpac' {
                $file = New-TemporaryFile
                Remove-Item $file
                Export-DacModel -Model $Model -Path $file
                $file | Should -Exist
            }
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

                Context Model {
                    BeforeAll {
                        $Model = Import-DacModel -DatabaseName $Database.Name -ErrorAction Stop
                    }

                    It 'Exports to dacpac' {
                        $file = New-TemporaryFile
                        Remove-Item $file
                        Export-DacModel -Model $Model -Path $file
                        $file | Should -Exist
                    }
                }
            }
        }
    }
}
