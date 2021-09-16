@{
    RootModule = 'PsDac.dll'
    ModuleVersion = '0.1.0'
    GUID = 'f69d5927-d9ef-48c9-b88c-fb2c5158d62c'
    DefaultCommandPrefix = 'Dac'
    Author = 'Steffen Kampmann'
    Copyright = '(c) 2021 Steffen Kampmann. Alle Rechte vorbehalten.'
    Description = 'PsDac connects DacFx and PowerShell. It gives you PowerShell Cmdlets with the power of Microsoft.SqlServer.DacFx.'
    PowerShellVersion = '7.0'

    CmdletsToExport = @(
        'Get-Column',
        'Get-DataType',
        'Get-ForeignKey',
        'Get-Object',
        'Get-PartitionFunction',
        'Get-PartitionScheme',
        'Get-Procedure',
        'Get-Role',
        'Get-ScalarFunction',
        'Get-Schema',
        'Get-Table',
        'Get-View',
        'Import-Model',
        'Import-Package',
        'New-CreateScript',
        'Remove-Schema',
        'Set-Package',
        'Test-Model'
    )

    PrivateData = @{

        PSData = @{
            Category = 'Databases'
            Tags = @('dacfx', 'dacpac', 'sqlserver')
            LicenseUri = 'https://github.com/abbgrade/PsDac/blob/main/LICENSE'
            ProjectUri = 'https://github.com/abbgrade/PsDac'
            IsPrerelease = 'True'
        }
    }
}