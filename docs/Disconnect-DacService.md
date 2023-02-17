---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version: https://abbgrade.github.io/PsDac/Disconnect-DacService.html
schema: 2.0.0
---

# Disconnect-DacService

## SYNOPSIS
Closes the connection to a database server.

## SYNTAX

```
Disconnect-DacService [-Service <DacServices>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```
PS C:\> Connect-DacService -DataSource '(LocalDb)\MSSQLLocalDB'
PS C:\> Disconnect-DacService
```

Closes an open connection to localdb.

## PARAMETERS

### -Service
Specifies the service to disconnect.
Default is the latest connected service.

```yaml
Type: DacServices
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[DacServices](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.dacservices)

