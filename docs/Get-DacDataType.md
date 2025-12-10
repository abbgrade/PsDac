---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version: https://abbgrade.github.io/PsDac/Get-DacDataType.html
schema: 2.0.0
---

# Get-DacDataType

## SYNOPSIS
Returns the data type of a column.

## SYNTAX

```
Get-DacDataType [-Column] <TSqlObject> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Provides the datatype and properties to a column.

## EXAMPLES

### Example 1
```
PS C:\> Import-DacModel -Path ./WideWorldImporters.dacpac | Get-DacTable -Name '[Application].[Cities]' | Get-DacColumn -Name '[Application].[Cities].[CityID]' | Get-DacDataType


Name       : Int
Length     : 0
Precision  : 0
Scale      : 0
IsNullable : False
IsMax      : False
Collation  :
_detail    : Microsoft.SqlServer.Dac.Model.TSqlObject
```

## PARAMETERS

### -Column
Specifies the column to get the data type from.
The ObjectType must be Column.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.SqlServer.Dac.Model.TSqlObject
## OUTPUTS

### PsDac.GetDataTypeCommand+ColumnInfo
## NOTES

## RELATED LINKS

[TSqlObject](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.model.tsqlobject)

[Column](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.model.column)

