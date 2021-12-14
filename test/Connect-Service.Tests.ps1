#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Connect-DacService' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsDac\bin\Debug\net5.0\publish\PsDac.psd1 -ErrorAction Stop
    }

    It 'Creates a service by datasource' {
        $service = Connect-DacService -DataSource '(LocalDb)\MSSQLLocalDB' -ErrorAction Stop
        $service | Should -Not -BeNullOrEmpty
    }

    It 'Creates a service by connection string' {
        $service = Connect-DacService -ConnectionString 'Server=(LocalDb)\MSSQLLocalDB' -ErrorAction Stop
        $service | Should -Not -BeNullOrEmpty
    }

}
