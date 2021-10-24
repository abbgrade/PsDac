---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version: https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.dacpackage
schema: 2.0.0
---

# Install-DacPackage

## SYNOPSIS
Installs the package content to a database.

## SYNTAX

```
Install-DacPackage [-Package] <DacPackage> [-Service <DacServices>] -DatabaseName <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Connect-DacService -DataSource '(LocalDb)\MSSQLLocalDB'
PS C:\> Install-DacPackage ./myDb.dacpac -DatabaseName myDb
```

Installs the content of myDb.dacpac into database myDb on localdb and creates the database, if required.

## PARAMETERS

### -DatabaseName
Specifies the database to install the package into.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Package
Specifies the package to install into the database.

```yaml
Type: DacPackage
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Service
Specifies the server to install the package to. Default is the latest connected service.

```yaml
Type: DacServices
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.SqlServer.Dac.DacPackage

### System.String

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[DacPackage](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.dacpackage)
[DacServices](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.dacservices)