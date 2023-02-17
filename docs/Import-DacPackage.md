---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version:
schema: 2.0.0
---

# Import-DacPackage

## SYNOPSIS
Imports the package from a dacpac or a database.

## SYNTAX

### File
```
Import-DacPackage [-Path] <FileInfo> [-Access <FileAccess>] [-Service <DacServices>] [<CommonParameters>]
```

### Database
```
Import-DacPackage [-DatabaseName <String>] -ApplicationName <String> -ApplicationVersion <Version>
 [-Service <DacServices>] [<CommonParameters>]
```

## DESCRIPTION
Imports a DacPackage from a DacPac file or a database. If it loaded from a database, a connection must be established before.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Access
Specifies if the file is opened for read or write access.

```yaml
Type: FileAccess
Parameter Sets: File
Aliases:
Accepted values: Read, Write, ReadWrite

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies the path to the dacpac to load the package from.

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

### -ApplicationName
Identifier for the DAC application.

```yaml
Type: String
Parameter Sets: Database
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationVersion
Version of the DAC application.

```yaml
Type: Version
Parameter Sets: Database
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Name of the source database.

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

### -Service
Specifies the server to extract the package from. Default is the latest connected service.

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

### Microsoft.SqlServer.Dac.DacPackage

## NOTES

## RELATED LINKS

[DacPackage](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.dacpackage)
