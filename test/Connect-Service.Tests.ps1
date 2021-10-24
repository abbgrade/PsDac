BeforeDiscovery {
    $Script:PsDacModule = Import-Module $PSScriptRoot\..\src\PsDac\bin\Debug\net5.0\publish\PsDac.psd1 -PassThru -ErrorAction Continue
}

Describe 'Connect-DacService' -Skip:( -Not $Script:PsDacModule ) {

    It 'Creates a service by datasource' {
        Connect-DacService -DataSource '(LocalDb)\MSSQLLocalDB' -ErrorAction Stop
    }

    It 'Creates a service by connection string' {
        Connect-DacService -ConnectionString 'Server=(LocalDb)\MSSQLLocalDB' -ErrorAction Stop
    }

}
