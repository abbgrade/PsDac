#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }, @{ ModuleName='PsSqlClient'; ModuleVersion='1.2.0' }, @{ ModuleName='PsSmo'; ModuleVersion='0.4.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.2.0' }

Describe 'Install-DacPackage' {
    BeforeDiscovery {
        [System.IO.FileInfo] $Script:TestDbDacPacFile = "$PsScriptRoot\testdb\bin\Debug\testdb.dacpac"
        [System.IO.FileInfo] $Script:WwiDacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"

        if ( -Not $Script:TestDbDacPacFile.Exists ) {
            Write-Warning "Skip tests with testdb.dacpac requirement."
        }

        if ( -Not $Script:WwiDacPacFile.Exists ) {
            Write-Warning "Skip tests with WideWorldImporters.dacpac requirement."
        }
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context 'Server' {

        BeforeAll {
            $Script:TestServer = New-SqlTestInstance
            $Script:SqlConnection = Connect-TSqlInstance -ConnectionString $Script:TestServer.ConnectionString
        }

        AfterAll {
            $Script:TestServer | Remove-SqlTestInstance
        }

        Context 'DacService' {

            BeforeAll {
                $Script:DacService = Connect-DacService -ConnectionString $Script:TestServer.ConnectionString -ErrorAction Stop
            }

            AfterAll {
                if ( $Script:DacService ) {
                    Disconnect-DacService
                }
            }

            Context 'Database' {

                BeforeEach {
                    [string] $Script:DatabaseName = ( [string](New-Guid) ).Substring(0, 8)
                }

                AfterEach {
                    Invoke-TSqlCommand "DROP DATABASE [$Script:DatabaseName];"
                }

                Context 'testdb DacPac' -Skip:( -Not $Script:TestDbDacPacFile.Exists ) {

                    BeforeAll {
                        $Script:DacPac = Import-DacPackage $Script:TestDbDacPacFile
                    }

                    It 'Creates database objects of a dacpac' {
                        Install-DacPackage $Script:DacPac -DatabaseName $Script:DatabaseName

                        Invoke-TSqlCommand "USE [$Script:DatabaseName]" -Connection $Script:SqlConnection
                        $Script:SmoConnection = Connect-SmoInstance -Connection $Script:SqlConnection

                        Get-SmoTable -Name MyTable | Should -Not -BeNullOrEmpty

                        Disconnect-SmoInstance -Instance $Script:SmoConnection
                    }
                }

                Context 'wwi DacPac' -Skip:( -Not $Script:WwiDacPacFile.Exists ) {

                    BeforeAll {
                        $Script:DacPac = Import-DacPackage -Path $Script:WwiDacPacFile
                    }

                    It 'Creates database objects of a dacpac' {
                        Install-DacPackage $Script:DacPac -DatabaseName $Script:DatabaseName #-ExcludeObjectTypes Logins, Files, Filegroups -Verbose

                        Invoke-TSqlCommand "USE [$Script:DatabaseName]" -Connection $Script:SqlConnection
                        $Script:SmoConnection = Connect-SmoInstance -Connection $Script:SqlConnection

                        Get-SmoTable -Name MyTable | Should -Not -BeNullOrEmpty

                        Disconnect-SmoInstance -Instance $Script:SmoConnection
                    }
                }
            }
        }
    }
}
