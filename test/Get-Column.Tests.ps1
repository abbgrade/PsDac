Describe 'Get-DacColumn' {
    Context 'Table' {
        BeforeAll {
            $Script:Table = Get-DacTable
        }

        It 'works' {
            $Script:Table | Get-DacColumn
        }
    }
}
