<#
.Synopsis
	Build script <https://github.com/nightroman/Invoke-Build>
#>

param(
	[ValidateSet('Debug', 'Release')]
	[string] $Configuration = 'Debug',

	[switch] $Force,

	[string] $NuGetApiKey = $env:nuget_apikey
)

. $PSScriptRoot\tasks\Build.Tasks.ps1

task Build -Jobs PsDac.Publish
task Clean -Jobs PsDac.Clean
task Install -Jobs PsDac.Install
task Uninstall -Jobs PsDac.Uninstall
task Publish -Jobs PsDac.Publish

# Synopsis: Default task.
task . Build
