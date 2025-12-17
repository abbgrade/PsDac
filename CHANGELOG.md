# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.8.0] - 2025-12-11

### Changed

- Updated System.Management.Automation and PowerShellVersion to 7.4.
- Updated TargetFramework to net8.0.
- Updated Microsoft.SqlServer.DacFx to 170.2.70.
- Updated Microsoft.Data.SqlClient to 5.2.3.
- Updated Azure.Identity to 1.13.0.

## [1.7.0] - 2024-08-13

### Changed

- Added support for views to `Get-DacColumn` command.
- Updated Microsoft.SqlServer.DacFx to 162.1.167.
- Updated System.Management.Automation to 7.2.16 and PowerShell 7.2.16.

### Added

- Added `Install-Package` parameter for IgnoreWithNocheckOnCheckConstraints, IgnoreWithNocheckOnForeignKeys and ScriptNewConstraintValidation.

## [1.6.0] - 2023-08-24

### Changed

- Added verbose output to import dacpac and install dacpac.

## [1.5.0] - 2023-05-31

### Changed

- The access token in the `Connect-Service` command cannot be within the connection string but is an optional parameter.
- Connecting to a azure sql server without a access token, will aquire a new token.

### Added

- Added deploy options to `Install-Package`.

## [1.3.0] - 2023-03-14

### Added

- Added UpdateExisting switch to install command.
- Added `Export-DacModel` command.
- Added database option to import model or package from.
- Added `New-SchemaComparison` command.

### Changed

- Updated powershell version.

### Fixed

- Exception when write powershell output in thread.

## [1.2.0] - 2022-07-30

### Added

- Pipeline input for Disconnect-Service.

## [1.1.0] - 2022-07-30

### Added

- Default parameter set ConnectionString for Connect-Service.

## [1.0.0] - 2022-05-12

### Added

- Added `Connect-DacService` command.
- Added `Disconnect-DacService` command.
- Added `Install-DacPackage` command.
- Added output to all commands.
- Added documentation.

### Changed

- Changed type of the Name property in `Get-DacDataType` output from SqlDataType to string.

### Fixed

- `Get-DacDataType` works for user defined types and CLI types.

## [0.2.0] - 2021-10-15

### Added

- Added variable handling to `New-DacCreateScript` command.
- Added `Get-DacTableValuedFunction` command.

<!-- markdownlint-configure-file {"MD024": { "siblings_only": true } } -->
