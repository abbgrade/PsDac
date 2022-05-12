---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version:
schema: 2.0.0
---

# Get-DacColumn

## SYNOPSIS
Returns columns of a table.

## SYNTAX

```
Get-DacColumn [-Table] <TSqlObject> [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Provides a column object to access it's definition.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-DacModel -Path ./WideWorldImporters.dacpac | Get-DacTable -Name '[Application].[Cities]' | Get-DacColumn -Name '[Application].[Cities].[CityID]'

Schema      Name                            ObjectType
------      ----                            ----------
Application [Application].[Cities].[CityID] Microsoft.SqlServer.Dac.Model.ModelTypeClass
```

## PARAMETERS

### -Name
Specifies a filter on the column name.

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

### -Table
Specifies the table to get the columns from. The ObjectType must be Table.

```yaml
Type: TSqlObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.SqlServer.Dac.Model.TSqlObject

## OUTPUTS

### Microsoft.SqlServer.Dac.Model.TSqlObject

ObjectType will be Column.

## NOTES

## RELATED LINKS

[TSqlObject](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.model.tsqlobject)
