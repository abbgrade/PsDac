---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version:
schema: 2.0.0
---

# Connect-DacService

## SYNOPSIS
Connects a database instance using DacServices.

## SYNTAX

### ConnectionString
```
Connect-DacService [-ConnectionString] <String> [<CommonParameters>]
```

### DataSource
```
Connect-DacService [-DataSource] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Connect-DacService -DataSource '(LocalDb)\MSSQLLocalDB'
```

Creates a dac service for localdb.

## PARAMETERS

### -ConnectionString
Specifies the connection string to use.

```yaml
Type: String
Parameter Sets: ConnectionString
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -DataSource
Specifies the datasource aka. server name to connect to.

```yaml
Type: String
Parameter Sets: DataSource
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### Microsoft.SqlServer.Dac.DacServices

## NOTES

## RELATED LINKS

[DacServices](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.dacservices)
