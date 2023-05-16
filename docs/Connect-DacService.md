---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version: https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.dacservices
schema: 2.0.0
---

# Connect-DacService

## SYNOPSIS
Connects a database instance using DacServices.

## SYNTAX

### ConnectionString (Default)
```
Connect-DacService [-ConnectionString] <String> [-AccessToken <String>] [<CommonParameters>]
```

### Properties
```
Connect-DacService [-DataSource] <String> [-AccessToken <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a DacServices instance, that can be used by commands.
Unfortunately, the parameters are not checked while connecting, but while usage.

## EXAMPLES

### Example 1
```
PS C:\> Connect-DacService -DataSource '(LocalDb)\MSSQLLocalDB'
```

Creates a dac service for localdb.

## PARAMETERS

### -AccessToken
Specifies a token for authentication.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ConnectionString
Specifies the connection string to use.
The DataSource, Hostname or Instance must be specified as Server.

```yaml
Type: String
Parameter Sets: ConnectionString
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DataSource
Specifies the datasource or server name to connect to.

```yaml
Type: String
Parameter Sets: Properties
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

