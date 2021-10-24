
BeforeDiscovery {
    $Script:PsDacModule = Import-Module $PSScriptRoot\..\src\PsDac\bin\Debug\net5.0\publish\PsDac.psd1 -PassThru -ErrorAction Continue
    $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction Continue
}

Describe 'Install-DacPackage' -Skip:( -Not $Script:PsDacModule ) {

    BeforeDiscovery {
        [System.IO.FileInfo] $Script:DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
    }

    Context 'DacPac' -Skip:( -Not $Script:DacPacFile.Exists ) {

        BeforeAll {
            $Script:DacPac = Import-DacPackage $Script:DacPacFile
        }

        Context 'Server' -Skip:( -Not ( $Script:PsSqlClient ) ) {

            BeforeAll {
                $Script:SqlServerInstance = '(LocalDb)\MSSQLLocalDB'
                $Script:SqlServerConnection = Connect-TSqlInstance -DataSource $Script:SqlServerInstance
            }

            Context 'DacService' {

                BeforeAll {
                    $Script:DacService = Connect-DacService -DataSource $Script:SqlServerInstance
                }

                AfterAll {
                    if ( $Script:DacService ) {
                        Disconnect-DacService
                    }
                }

                Context 'Database' {

                    BeforeEach {
                        [string] $Script:DatabaseName = New-Guid
                    }

                    AfterEach {
                        Invoke-TSqlCommand "DROP DATABASE [$Script:DatabaseName]"
                    }

                    It 'Creates database objects of a dacpac' {
                        Install-DacPackage $Script:DacPac -DatabaseName $Script:DatabaseName
                    }
                }
            }
        }
    }
}
