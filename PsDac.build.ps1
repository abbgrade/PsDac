<#
.Synopsis
	Build script <https://github.com/nightroman/Invoke-Build>

.Example
    # Add doc templates for new command.
    # BE CAREFUL! Existing documents will be overwritten and must be discarded using git.
    Invoke-Build PsDac.Doc.Init -Force

#>

param(
	[ValidateSet('Debug', 'Release')]
	[string] $Configuration = 'Debug',

	[switch] $Force,

	[string] $NuGetApiKey = $env:nuget_apikey
)

. $PSScriptRoot\tasks\Build.Tasks.ps1
. $PSScriptRoot\tasks\Testdata.Tasks.ps1

task Build -Jobs PsDac.Build
task Clean -Jobs PsDac.Clean
task Doc -Jobs PsDac.Doc
task Install -Jobs PsDac.Install
task Publish -Jobs PsDac.Publish
task Uninstall -Jobs PsDac.Uninstall

# Synopsis: Default task.
task . Build
