requires Configuration

[System.Version] $global:PsDacVersion = New-Object System.Version (
	Import-PowerShellDataFile $PSScriptRoot\..\src\PsDac\PsDac.psd1
).ModuleVersion
[System.IO.FileInfo] $global:PsDacStage = "$PSScriptRoot\..\src\PsDac\bin\$Configuration\net5.0\publish"
[System.IO.FileInfo] $global:PsDacManifest = "$global:PsDacStage\PsDac.psd1"
[System.IO.DirectoryInfo] $global:PsDacInstallDirectory = Join-Path $env:PSModulePath.Split(';')[0] 'PsDac' $global:PsDacVersion

task PsDac.Build -If { -Not $global:PsDacManifest.Exists -Or $Force } -Jobs {
	exec { dotnet publish $PSScriptRoot\..\src\PsDac -c $Configuration }
}

task PsDac.Import -Jobs PsDac.Build, {
    Import-Module $global:PsDacManifest.FullName
}

task PsDac.Clean {
	remove $PSScriptRoot\..\src\PsDac\bin, $PSScriptRoot\..\src\PsDac\obj
}

task PsDac.Uninstall -If { $global:PsDacInstallDirectory.Exists } -Jobs {
	Remove-Item -Recurse -Force $global:PsDacInstallDirectory.FullName
}

task PsDac.Install -If { -Not $global:PsDacInstallDirectory.Exists -Or $Force } -Jobs PsDac.Build, {
	Get-ChildItem $global:PsDacStage | Copy-Item -Destination $global:PsDacInstallDirectory.FullName -Recurse -Force
}

# Synopsis: Publish the module to PSGallery.
task PsDac.Publish -Jobs PsDac.Install, {

	assert ( $Configuration -eq 'Release' )

	Publish-Module -Name PsDac -NuGetApiKey $NuGetApiKey
}