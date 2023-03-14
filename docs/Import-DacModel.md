---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version: https://abbgrade.github.io/PsDac/Import-DacModel.html
schema: 2.0.0
---

# Import-DacModel

## SYNOPSIS
Imports a model from a dacpac or a database.

## SYNTAX

### File
```
Import-DacModel [-Path] <FileInfo> [-ModelStorageType <DacSchemaModelStorageType>] [-LoadAsScriptBackedModel]
 [-Service <DacServices>] [<CommonParameters>]
```

### Database
```
Import-DacModel [-DatabaseName <String>] [-ModelStorageType <DacSchemaModelStorageType>]
 [-LoadAsScriptBackedModel] [-Service <DacServices>] [<CommonParameters>]
```

## DESCRIPTION
Provides a model object to access it's definition.

## EXAMPLES

### Example 1
```
PS C:\> Import-DacModel -Path ./WideWorldImporters.dacpac

Version           : Sql130
EngineVersion     : 13
IsScriptBacked    : False
DisplayServices   : Microsoft.SqlServer.Dac.Model.SqlDisplayServices
CollationComparer : Microsoft.SqlServer.Dac.Model.SqlModelCollationComparer
```

## PARAMETERS

### -DatabaseName
Name of the source database

```yaml
Type: String
Parameter Sets: Database
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoadAsScriptBackedModel
{{ Fill LoadAsScriptBackedModel Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
Parameter Sets: File
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Service
Specifies the server to extract the package from.
Default is the latest connected service.

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

### System.IO.FileInfo
## OUTPUTS

### Microsoft.SqlServer.Dac.Model.TSqlModel
## NOTES

## RELATED LINKS

[TSqlModel](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.model.tsqlmodel)

