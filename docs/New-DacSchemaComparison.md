---
external help file: PsDac.dll-Help.xml
Module Name: PsDac
online version: https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.dac.dacpackage
schema: 2.0.0
---

# New-DacSchemaComparison

## SYNOPSIS
Creates a Schema Comparison for two Dac Pacs

## SYNTAX

```
New-DacSchemaComparison -Source <TSqlModel> -Target <TSqlModel> [-ExcludedObjectTypes <ObjectType[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Provides a SchemComparison Object with schema diffs between the two provided Dac Pacs

## EXAMPLES

### Example 1
```powershell
PS C:\> New-DacSchemaComparison -DacPacPathSource ./WideWorldImporters.dacpac -DacPacPathTarget ./WideWorldImporters.dacpac
```

## PARAMETERS

### -ExcludedObjectTypes
Specifies the Object Types which should be ignored for the comparison

```yaml
Type: ObjectType[]
Parameter Sets: (All)
Aliases:
Accepted values: Aggregates, ApplicationRoles, Assemblies, AssemblyFiles, AsymmetricKeys, BrokerPriorities, Certificates, ColumnEncryptionKeys, ColumnMasterKeys, Contracts, DatabaseOptions, DatabaseRoles, DatabaseTriggers, Defaults, ExtendedProperties, ExternalDataSources, ExternalFileFormats, ExternalTables, Filegroups, Files, FileTables, FullTextCatalogs, FullTextStoplists, MessageTypes, PartitionFunctions, PartitionSchemes, Permissions, Queues, RemoteServiceBindings, RoleMembership, Rules, ScalarValuedFunctions, SearchPropertyLists, SecurityPolicies, Sequences, Services, Signatures, StoredProcedures, SymmetricKeys, Synonyms, Tables, TableValuedFunctions, UserDefinedDataTypes, UserDefinedTableTypes, ClrUserDefinedTypes, Users, Views, XmlSchemaCollections, Audits, Credentials, CryptographicProviders, DatabaseAuditSpecifications, DatabaseEncryptionKeys, DatabaseScopedCredentials, Endpoints, ErrorMessages, EventNotifications, EventSessions, LinkedServerLogins, LinkedServers, Logins, MasterKeys, Routes, ServerAuditSpecifications, ServerRoleMembership, ServerRoles, ServerTriggers, ExternalStreams, ExternalStreamingJobs, DatabaseWorkloadGroups, WorkloadClassifiers, ExternalLibraries, ExternalLanguages

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Source
Specifies the source TSqlModel for the comparison.

```yaml
Type: TSqlModel
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Target
Specifies the target TSqlModel for the comparison.

```yaml
Type: TSqlModel
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.IO.FileInfo

### Microsoft.SqlServer.Dac.ObjectType[]

## OUTPUTS

### System.Collections.Generic.List`1[[Microsoft.SqlServer.Dac.Compare.SchemaDifference, Microsoft.SqlServer.Dac.Extensions, Version=16.1.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a]]

## NOTES

## RELATED LINKS
