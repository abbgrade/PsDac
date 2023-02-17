---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version:
schema: 2.0.0
---

# Import-DacModel

## SYNOPSIS
Imports a model from a dacpac file.

## SYNTAX

```
Import-DacModel [-Path] <FileInfo> [-ModelStorageType <DacSchemaModelStorageType>] [-LoadAsScriptBackedModel]
 [<CommonParameters>]
```

## DESCRIPTION
Provides a model object to access it's definition.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-DacModel -Path ./WideWorldImporters.dacpac

Version           : Sql130
EngineVersion     : 13
IsScriptBacked    : False
DisplayServices   : Microsoft.SqlServer.Dac.Model.SqlDisplayServices
CollationComparer : Microsoft.SqlServer.Dac.Model.SqlModelCollationComparer
```

## PARAMETERS

### -LoadAsScriptBackedModel
{{ Fill LoadAsScriptBackedModel Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModelStorageType
{{ Fill ModelStorageType Description }}

```yaml
Type: DacSchemaModelStorageType
Parameter Sets: (All)
Aliases:
Accepted values: File, Memory

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies the path to the dacpac to load the model from.

```yaml
Type: FileInfo
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

### System.IO.FileInfo

## OUTPUTS

### Microsoft.SqlServer.Dac.Model.TSqlModel

## NOTES

## RELATED LINKS

[TSqlModel](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.model.tsqlmodel)
