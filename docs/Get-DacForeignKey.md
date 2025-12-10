---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version: https://abbgrade.github.io/PsDac/Get-DacForeignKey.html
schema: 2.0.0
---

# Get-DacForeignKey

## SYNOPSIS
Returns the foreign keys of a model.

## SYNTAX

```
Get-DacForeignKey [-Model] <TSqlModel> [[-Name] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Provides a foreign key object to access it's definition.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Model
Specifies the model to get the foreign keys from.

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
Specifies a filter on the key name.

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

### Microsoft.SqlServer.Dac.Model.TSqlModel
## OUTPUTS

### Microsoft.SqlServer.Dac.Model.TSqlObject
## NOTES

## RELATED LINKS

[TSqlObject](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.model.tsqlobject)

[TSqlModel](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.model.tsqlmodel)

