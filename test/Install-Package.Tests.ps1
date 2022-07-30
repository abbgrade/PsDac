#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }, @{ ModuleName='PsSqlClient'; ModuleVersion='1.2.0' }, @{ ModuleName='PsSmo'; ModuleVersion='0.4.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.2.0' }

param (
    [System.IO.FileInfo] $TestDbDacPacFile = "$PsScriptRoot\testdb\bin\Debug\testdb.dacpac",
    [System.IO.FileInfo] $WwiDacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
)

Describe Install-Package {

    BeforeDiscovery {
        if ( -Not $TestDbDacPacFile.Exists ) {
            Write-Warning "Skip tests with testdb.dacpac requirement."
        }

        if ( -Not $WwiDacPacFile.Exists ) {
            Write-Warning "Skip tests with WideWorldImporters.dacpac requirement."
        }
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
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

                BeforeEach {
                    [string] $DatabaseName = ( [string](New-Guid) ).Substring(0, 8)
                }

                AfterEach {
                    Invoke-TSqlCommand "DROP DATABASE [$DatabaseName];"
                }

                Context 'testdb DacPac' -Skip:( -Not $TestDbDacPacFile.Exists ) {

                    BeforeAll {
                        $DacPac = Import-DacPackage -Path $TestDbDacPacFile.FullName
                    }

                    It 'Creates database objects of a dacpac' {
                        Install-DacPackage $DacPac -DatabaseName $DatabaseName

                        Invoke-TSqlCommand "USE [$DatabaseName]" -Connection $SqlConnection
                        $SmoConnection = Connect-SmoInstance -Connection $SqlConnection

                        Get-SmoTable -Name MyTable | Should -Not -BeNullOrEmpty

                        Disconnect-SmoInstance -Instance $SmoConnection
                    }
                }

                Context 'wwi DacPac' -Skip:( -Not $WwiDacPacFile.Exists ) {

                    BeforeAll {
                        $DacPac = Import-DacPackage -Path $WwiDacPacFile.FullName
                    }

                    It 'Creates database objects of a dacpac' {
                        Install-DacPackage $DacPac -DatabaseName $DatabaseName #-ExcludeObjectTypes Logins, Files, Filegroups -Verbose

                        Invoke-TSqlCommand "USE [$DatabaseName]" -Connection $SqlConnection
                        $SmoConnection = Connect-SmoInstance -Connection $SqlConnection

                        Get-SmoTable -Name MyTable | Should -Not -BeNullOrEmpty

                        Disconnect-SmoInstance -Instance $SmoConnection
                    }
                }
            }
        }
    }
}
