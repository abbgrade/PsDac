#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }, @{ ModuleName='PsSqlClient'; ModuleVersion='1.2.0' }, @{ ModuleName='PsSmo'; ModuleVersion='0.4.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.2.0' }

Describe Connect-Service {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context TestDatabase {

        BeforeAll {
            $TestServer = New-SqlTestInstance
        }

        AfterAll {
            if ( $TestServer ) {
                $TestServer | Remove-SqlTestInstance
            }
        }

        Context Connection {

            BeforeAll {
                $Service = $TestServer | Connect-DacService -ErrorAction Stop
            }

            It Disconnects {
                $Service | Disconnect-DacService -ErrorAction Stop
                {
                    $Service | Disconnect-DacService -ErrorAction Stop
                } | Should -Throw
            }
        }
    }
}
