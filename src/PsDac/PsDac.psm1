$LoadedAssemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()

@(
    "$PSScriptRoot/Azure.Core.dll",
    "$PSScriptRoot/Azure.Identity.dll",
    "$PSScriptRoot/Microsoft.Identity.Client.dll",
    "$PSScriptRoot/Microsoft.SqlServer.Server.dll",
    "$PSScriptRoot/runtimes/win/lib/net6.0/Microsoft.Data.SqlClient.dll"
    ) | ForEach-Object {
        [System.IO.FileInfo] $RequiredAssemblyPath = $_
        If ( -not $RequiredAssemblyPath.Exists ) {
            Write-Error "Build issue: '$RequiredAssemblyPath' does not exist."
        }
        $LoadedAssembly = $LoadedAssemblies | Where-Object Location -Like "*$( $RequiredAssemblyPath.Name )"

        if ( $LoadedAssembly ) {
            if ( $LoadedAssembly.Location -ne $RequiredAssemblyPath.FullName ) {
                Write-Warning "Assembly '$( $LoadedAssembly.GetName() )' already loaded from '$( $LoadedAssembly.Location )'. Skip adding defined dll."
            }
        }
        else {
            try {
                # Microsoft.Data.SqlClient.dll expects Data.SqlClient.SNI.dll in the same directory - copy Data.SqlClient.SNI.dll before adding SqlClient
                if ( $RequiredAssemblyPath.Name -eq 'Microsoft.Data.SqlClient.dll' )
                {
                    $Runtime = switch ($Env:PROCESSOR_ARCHITECTURE)
                    {
                        AMD64 { 'win-x64' }
                        X86 { 'win-x86' }
                        Arm { 'win-arm' }
                    }
                    if ( $Runtime ) {
                        $NativeDllTargetDirectory = "$PSScriptRoot/runtimes/win/lib/net6.0"
                        if ( -Not ( Test-Path "$NativeDllTargetDirectory/Microsoft.Data.SqlClient.SNI.dll" ) ) {
                            Copy-Item "$PSScriptRoot/runtimes/$Runtime/native/Microsoft.Data.SqlClient.SNI.dll" -Destination $NativeDllTargetDirectory
                        }
                    }
                }

                Add-Type -Path $RequiredAssemblyPath
            }
            catch [System.IO.FileLoadException] {
                Write-Error "$( $_.Exception ) while adding assembly '$( $RequiredAssemblyPath.Name )'"
            }
        }
    }
