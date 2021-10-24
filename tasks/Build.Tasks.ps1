requires Configuration

[System.Version] $global:PsDacVersion = New-Object System.Version (
	Import-PowerShellDataFile $PSScriptRoot\..\src\PsDac\PsDac.psd1
).ModuleVersion
[System.IO.FileInfo] $global:PsDacStage = "$PSScriptRoot\..\src\PsDac\bin\$Configuration\net5.0\publish"
[System.IO.FileInfo] $global:PsDacManifest = "$global:PsDacStage\PsDac.psd1"
[System.IO.DirectoryInfo] $global:PsDacDoc = "$PSScriptRoot\..\docs"
[System.IO.DirectoryInfo] $global:PsDacInstallDirectory = Join-Path $env:PSModulePath.Split(';')[0] 'PsDac' $global:PsDacVersion

task PsDac.Build.Dll -Jobs {
    exec { dotnet publish $PSScriptRoot\..\src\PsDac -c $Configuration }
}

task PsDac.Import -Jobs PsDac.Build.Dll, {
    Import-Module $global:PsDacManifest.FullName
}

task PsDac.Doc.Init -If { -Not $global:PsDacDoc.Exists } -Jobs PsDac.Import, {
    New-MarkdownHelp -Module PsDac -OutputFolder $global:PsDacDoc -ErrorAction Stop
}

task PsDac.Doc -Jobs PsDac.Doc.Init, PsDac.Import, {
    Update-MarkdownHelp -Path $global:PsDacDoc
}

task PsDac.Build.Help -Jobs PsDac.Doc, {
    New-ExternalHelp -Path $global:PsDacDoc -OutputPath $global:PsDacStage\en-US\
}

task PsDac.Build -If { -Not $global:PsDacManifest.Exists -Or $Force } -Jobs PsDac.Build.Dll, PsDac.Build.Help

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
