#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }, @{ ModuleName='PsSqlClient'; ModuleVersion='1.2.0' }, @{ ModuleName='PsSmo'; ModuleVersion='0.4.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.2.0' }, @{ ModuleName='PsSqlLocalDb'; ModuleVersion='0.4.0' }

Describe Connect-Service {

    BeforeAll {
        Import-Module $PSScriptRoot\..\publish\PsDac\PsDac.psd1 -ErrorAction Stop
    }

    Context TestDatabase {

        BeforeAll {
            $TestServer = New-SqlTestInstance -ErrorAction Stop
        }

        AfterAll {
            if ( $TestServer ) {
                $TestServer | Remove-SqlTestInstance
            }
        }

        It 'Creates a service by datasource' {
            $Service = Connect-DacService -DataSource $TestServer.DataSource -ErrorAction Stop
            $Service | Should -Not -BeNullOrEmpty
        }

        It 'Creates a service by connection string' {
            $Service = Connect-DacService -ConnectionString $TestServer.ConnectionString -ErrorAction Stop
            $Service | Should -Not -BeNullOrEmpty
        }

        It 'Creates a service by pipeline' {
            $Service = $TestServer | Connect-DacService -ErrorAction Stop
            $Service | Should -Not -BeNullOrEmpty
        }
    }

    Context AzureSqlServer -Tag AzureSql {

        BeforeAll {
            $TestServer = New-SqlTestAzureInstance -Subscription 'Visual Studio' -ErrorAction Stop
        }

        AfterAll {
            if ( $TestServer ) {
                $TestServer | Remove-SqlTestAzureInstance
            }
        }

        It 'Creates a service by datasource' {
            $Service = Connect-DacService -DataSource $TestServer.DataSource -ErrorAction Stop
            $Service | Should -Not -BeNullOrEmpty
        }

        It 'Creates a service by connection string' {
            $Service = Connect-DacService -ConnectionString $TestServer.ConnectionString -ErrorAction Stop
            $Service | Should -Not -BeNullOrEmpty
        }

        It 'Creates a service by pipeline' {
            $Service = $TestServer | Connect-DacService -ErrorAction Stop
            $Service | Should -Not -BeNullOrEmpty
        }

        Context AccessToken {

            BeforeAll {
                $TestServerWithToken = $TestServer.PsObject.Copy()
                $TestServerWithToken | Add-Member AccessToken ( Get-AzAccessToken -ResourceUrl https://database.windows.net ).Token
            }

            It 'Creates a service by datasource' {
                $Service = Connect-DacService -DataSource $TestServerWithToken.DataSource -AccessToken $TestServerWithToken.AccessToken -ErrorAction Stop
                $Service | Should -Not -BeNullOrEmpty
            }

            It 'Creates a service by connection string' {
                $Service = Connect-DacService -ConnectionString $TestServerWithToken.ConnectionString -AccessToken $TestServerWithToken.AccessToken -ErrorAction Stop
                $Service | Should -Not -BeNullOrEmpty
            }

            It 'Creates a service by pipeline' {
                $Service = $TestServerWithToken | Connect-DacService -ErrorAction Stop
                $Service | Should -Not -BeNullOrEmpty
            }
        }
    }
}
