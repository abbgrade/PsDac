---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version: https://abbgrade.github.io/PsDac/Get-DacTable.html
schema: 2.0.0
---

# Get-DacTable

## SYNOPSIS
Returns the tables of a model.

## SYNTAX

```
Get-DacTable [-Model] <TSqlModel> [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Provides a table object to access it's definition.

## EXAMPLES

### Example 1
```
PS C:\> Import-DacModel -Path ./WideWorldImporters.dacpac | Get-DacTable -Name '[Application].[Cities]'

Schema      Name                   ObjectType
------      ----                   ----------
Application [Application].[Cities] Microsoft.SqlServer.Dac.Model.ModelTypeClass
```

## PARAMETERS

### -Model
Specifies the model to get the tables from.

```yaml
Type: TSqlModel
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
Specifies a filter on the table name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.SqlServer.Dac.Model.TSqlModel
## OUTPUTS

### Microsoft.SqlServer.Dac.Model.TSqlObject
## NOTES

## RELATED LINKS

[TSqlObject](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.model.tsqlobject)

[TSqlModel](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.model.tsqlmodel)

