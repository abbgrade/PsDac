#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Install-DacPackage' {
    BeforeDiscovery {
        $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction Continue
        $Script:PsSmo = Import-Module PsSmo -MinimumVersion 0.6.0 -PassThru -ErrorAction Continue
        $Script:PsSqlTestServer = Import-Module PsSqlTestServer -MinimumVersion 0.2.1 -PassThru -ErrorAction Continue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsDac\bin\Debug\net5.0\publish\PsDac.psd1 -ErrorAction Stop
    }

    Context 'Server' -Skip:( -Not ( $Script:PsSqlTestServer -And $Script:PsSqlClient -And $Script:PsSmo ) ) {

        BeforeAll {
            $Script:TestServer = New-SqlServer
            $Script:SqlConnection = Connect-TSqlInstance -ConnectionString $Script:TestServer.ConnectionString
        }

        AfterAll {
            $Script:TestServer | Remove-SqlServer
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

                BeforeDiscovery {
                    [System.IO.FileInfo] $Script:TestDbDacPacFile = "$PsScriptRoot\testdb\bin\Debug\testdb.dacpac"
                    [System.IO.FileInfo] $Script:WwiDacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
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

                Context 'wwi DacPac' -Skip:( $true -Or -Not $Script:WwiDacPacFile.Exists ) {

                    BeforeAll {
                        $Script:DacPac = Import-DacPackage $Script:WwiDacPacFile
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
