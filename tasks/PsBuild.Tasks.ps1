
if ( -Not $PsBuildTaskBranch ) {
    $PsBuildTaskBranch = 'main'
}

#region InvokeBuild

task UpdateBuildTasks {
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/DotNet/Build.Tasks.ps1" `
        -OutFile "$PSScriptRoot\Build.Tasks.ps1"
}

#endregion
#region GitHub Actions

task UpdateValidationWorkflow {
    [System.IO.FileInfo] $file = "$PSScriptRoot/../.github/workflows/build-validation.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/build-validation-matrix.yml" `
        -OutFile $file
}

task UpdatePagesWorkflow {
    [System.IO.FileInfo] $file = "$PSScriptRoot/../.github/workflows/build-pages.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/build-pages.yml" `
        -OutFile $file
}

task UpdatePreReleaseWorkflow {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\workflows\pre-release.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/pre-release-windows.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

task UpdateReleaseWorkflow {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\workflows\release.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/release-windows.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

task UpdateReleaseHotfixWorkflow {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\workflows\release-hotfix.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/GitHub/release-hotfix-windows.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

task UpdateWorkflows -Jobs UpdateValidationWorkflow, UpdatePagesWorkflow, UpdatePreReleaseWorkflow, UpdateReleaseWorkflow, UpdateReleaseHotfixWorkflow

#endregion
#region GitHub Pages

task UpdateIndexPage {
    New-Item -Type Directory "$PSScriptRoot\..\docs" -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/docs/index.md" `
        -OutFile "$PSScriptRoot\..\docs\index.md"
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/_config.yml" `
        -OutFile "$PSScriptRoot\..\_config.yml"
}

#endregion
#region GitHub Dependabot

task UpdateDependabotConfig {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.github\dependabot.yml"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/dependabot/dependabot.yml" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

#endregion
#region VsCode

task UpdateVsCodeTasks {
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.vscode\tasks.json"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/VsCode/tasks.json" `
        -OutFile $file
}

task UpdateVsCodeLaunch {
    requires ModuleName
    [System.IO.FileInfo] $file = "$PSScriptRoot\..\.vscode\launch.json"
    New-Item -Type Directory $file.Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/VsCode/launch.json" |
    ForEach-Object { $_ -replace 'MyModuleName', $ModuleName } |
    Out-File $file -NoNewline
}

#endregion
#region PsBuildTasks

task UpdatePsBuildTasksTasks {
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/abbgrade/PsBuildTasks/$PsBuildTaskBranch/tasks/Dotnet-Matrix.Tasks.ps1" `
        -OutFile "$PSScriptRoot\PsBuild.Tasks.ps1"
}

#endregion

task UpdatePsBuildTasks -Jobs UpdateBuildTasks, UpdateWorkflows, UpdateIndexPage, UpdateDependabotConfig, UpdateVsCodeTasks, UpdateVsCodeLaunch, UpdatePsBuildTasksTasks
