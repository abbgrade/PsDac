#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Connect-DacService' {

    BeforeDiscovery {
        $Script:PsSqlTestServer = Import-Module PsSqlTestServer -PassThru -ErrorAction Continue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context 'Test Database' -Skip:( -Not $Script:PsSqlTestServer ) {

        BeforeAll {
            $Script:TestServer = New-SqlServer
        }

        AfterAll {
            $Script:TestServer | Remove-SqlServer
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
