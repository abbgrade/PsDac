---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version:
schema: 2.0.0
---

# Get-DacSchema

## SYNOPSIS
Gets the schemas of a model.

## SYNTAX

```
Get-DacSchema [-Model] <TSqlModel> [[-Name] <String>] [-Scope <DacQueryScopes>] [<CommonParameters>]
```

## DESCRIPTION
Provides a schema object to access it's definition.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-DacModel -Path ./WideWorldImporters.dacpac | Get-DacSchema -Name 'Application'
fwd-i-search: _
Schema      Name          ObjectType
------      ----          ----------
Application [Application] Microsoft.SqlServer.Dac.Model.ModelTypeClass
```

## PARAMETERS

### -Model
Specifies the model to get the schemas from.

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
Specifies a filter on the schema name.

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

### -Scope
Specifies a filter on the scope.

```yaml
Type: DacQueryScopes
Parameter Sets: (All)
Aliases:
Accepted values: None, UserDefined, BuiltIn, Default, SameDatabase, System, All

Required: False
Position: Named
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
