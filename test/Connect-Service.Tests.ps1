#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Connect-DacService' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsDac\bin\Debug\net5.0\publish\PsDac.psd1 -ErrorAction Stop
        Import-Module PsSqlTestServer -ErrorAction Stop
    }

    Context 'Test Database' {

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
