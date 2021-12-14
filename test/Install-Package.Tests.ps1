#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Install-DacPackage'{
    BeforeDiscovery {
        $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction Continue
        $Script:PsSmo = Import-Module PsSmo -MinimumVersion 0.6.0 -PassThru -ErrorAction Continue

        # [System.IO.FileInfo] $Script:DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
        [System.IO.FileInfo] $Script:DacPacFile = "$PsScriptRoot\testdb\bin\Debug\testdb.dacpac"
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsDac\bin\Debug\net5.0\publish\PsDac.psd1 -ErrorAction Stop
    }

    Context 'DacPac' -Skip:( -Not $Script:DacPacFile.Exists ) {

        BeforeAll {
            $Script:DacPac = Import-DacPackage $Script:DacPacFile
        }

        Context 'Server' -Skip:( -Not ( $Script:PsSqlClient -And $Script:PsSmo ) ) {

            BeforeAll {
                $Script:DataSource = '(LocalDb)\MSSQLLocalDB'
                $Script:SqlConnection = Connect-TSqlInstance -DataSource $Script:DataSource
            }

            Context 'DacService' {

                BeforeAll {
                    $Script:DacService = Connect-DacService -DataSource $Script:DataSource
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

                    It 'Creates database objects of a dacpac' {
                        Install-DacPackage $Script:DacPac -DatabaseName $Script:DatabaseName

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
