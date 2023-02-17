---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version: https://abbgrade.github.io/PsDac/New-DacCreateScript.html
schema: 2.0.0
---

# New-DacCreateScript

## SYNOPSIS
Generates a script to create a database from a package.

## SYNTAX

```
New-DacCreateScript [-Package] <DacPackage> [-DatabaseName <String>] [-CreateNewDatabase]
 [-IncludeTransactionalScripts] [-CommentOutSetVarDeclarations] [-Variables <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -CommentOutSetVarDeclarations
{{ Fill CommentOutSetVarDeclarations Description }}

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

### -CreateNewDatabase
{{ Fill CreateNewDatabase Description }}

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

### -DatabaseName
{{ Fill DatabaseName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeTransactionalScripts
{{ Fill IncludeTransactionalScripts Description }}

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

### -Package
{{ Fill Package Description }}

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

### -Variables
{{ Fill Variables Description }}

```yaml
Type: Hashtable
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
## OUTPUTS

### System.String
## NOTES

## RELATED LINKS

[DacPackage](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.dacpackage)

