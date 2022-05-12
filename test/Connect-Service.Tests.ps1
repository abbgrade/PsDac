#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }, @{ ModuleName='PsSqlClient'; ModuleVersion='1.2.0' }, @{ ModuleName='PsSmo'; ModuleVersion='0.4.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.2.0' }

Describe 'Connect-DacService' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context 'Test Database' {

        BeforeAll {
            $Script:TestServer = New-SqlTestInstance
        }

        AfterAll {
            if ( $Script:TestServer ) {
                $Script:TestServer | Remove-SqlTestInstance
            }
        }

        It 'Creates a service by datasource' {
            $service = Connect-DacService -DataSource $Script:TestServer.DataSource -ErrorAction Stop
            $service | Should -Not -BeNullOrEmpty
        }

        It 'Creates a service by connection string' {
            $service = Connect-DacService -ConnectionString $Script:TestServer.ConnectionString -ErrorAction Stop
            $service | Should -Not -BeNullOrEmpty
        }
    }
}
