requires Configuration
requires ModuleName

[System.IO.DirectoryInfo] $PublishDirectory = "$PSScriptRoot/../publish"
[System.IO.DirectoryInfo] $SourceDirectory = "$PSScriptRoot/../src"
[System.IO.DirectoryInfo] $DocumentationDirectory = "$PSScriptRoot/../docs"
[System.IO.DirectoryInfo] $ModulePublishDirectory = "$PublishDirectory/$ModuleName"
[System.IO.DirectoryInfo] $ModuleSourceDirectory = "$SourceDirectory/$ModuleName"
[System.IO.DirectoryInfo] $BinaryDirectory = "$ModuleSourceDirectory/bin"
[System.IO.DirectoryInfo] $ObjectDirectory = "$ModuleSourceDirectory/obj"

# Synopsis: Set the prerelease in the manifest based on the build number.
task SetPrerelease -If $BuildNumber {
	$Global:PreRelease = "alpha$( '{0:d4}' -f $BuildNumber )"
	Update-ModuleManifest -Path $Global:Manifest -Prerelease $Global:PreRelease
}

# Synopsis: Build the dll with the module commands.
task Build.Dll -Jobs {
	exec { dotnet publish $ModuleSourceDirectory -c $Configuration -o $ModulePublishDirectory }
	$Global:Manifest = Get-Item $ModulePublishDirectory/$ModuleName.psd1
}, SetPrerelease

# Synopsis: Import the module.
task Import -Jobs Build.Dll, {
    Import-Module $Global:Manifest
}

# Synopsis: Import platyPs.
task Import.platyPs -Jobs {
	Import-Module platyPs
}

# Synopsis: Initialize the documentation.
task Doc.Init -If { $DocumentationDirectory.Exists -eq $false -Or $ForceDocInit -eq $true } -Jobs Import, Import.platyPs, {
	New-Item $DocumentationDirectory -ItemType Directory -ErrorAction SilentlyContinue
    New-MarkdownHelp -Module $ModuleName -OutputFolder $DocumentationDirectory -Force:$ForceDocInit -ErrorAction Stop
}

# Synopsis: Update the markdown documentation.
task Doc.Update -Jobs Import, Import.platyPs, Doc.Init, {
    Update-MarkdownHelp -Path $DocumentationDirectory
}

# Synopsis: Build the XML help based on the markdown documentation.
task Build.Help -Jobs Import.platyPs, Doc.Update, {
    New-ExternalHelp -Path $DocumentationDirectory -OutputPath $ModulePublishDirectory\en-US\ -Force
}

# Synopsis: Build the module.
task Build -Job Build.Dll, Build.Help

# Synopsis: Remove all temporary files.
task Clean {
	remove $BinaryDirectory, $ObjectDirectory, $PublishDirectory
}

# Synopsis: Install the module.
task Install -Jobs Build, {
	$info = Import-PowerShellDataFile $Global:Manifest
	$version = ([System.Version] $info.ModuleVersion)
	$defaultModulePath = $env:PsModulePath -split ';' | Select-Object -First 1
	Write-Verbose "install $ModuleName $version to $defaultModulePath"
	$installPath = Join-Path $defaultModulePath $ModuleName $version.ToString()
	New-Item -Type Directory $installPath -Force | Out-Null
	Get-ChildItem $Global:Manifest.Directory | Copy-Item -Destination $installPath -Recurse -Force
}

# Synopsis: Publish the module to PSGallery.
task Publish -Jobs Clean, Build, {
	if ( -Not $Global:PreRelease ) {
		assert ( $Configuration -eq 'Release' )
		Update-ModuleManifest -Path $Global:Manifest -Prerelease ''
	}
	Publish-Module -Path $Global:Manifest.Directory -NuGetApiKey $NuGetApiKey -Force:$ForcePublish
}
