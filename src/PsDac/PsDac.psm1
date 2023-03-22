$LoadedAssemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()

@(
    "$PSScriptRoot/Azure.Core.dll",
    "$PSScriptRoot/Azure.Identity.dll",
    "$PSScriptRoot/Microsoft.Identity.Client.dll",
    "$PSScriptRoot/Microsoft.SqlServer.Server.dll",
    "$PSScriptRoot/runtimes/win/lib/netcoreapp3.1/Microsoft.Data.SqlClient.dll"
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
            if ($RequiredAssemblyPath.Name -eq "Microsoft.Data.SqlClient.dll")
            { 
                $SNIPath = switch ($Env:PROCESSOR_ARCHITECTURE) 
                {
                    "AMD64" {"$PSScriptRoot\runtimes\win-x64\native\Microsoft.Data.SqlClient.SNI.dll"}     
                    "X86" {"$PSScriptRoot\runtimes\win-x86\native\Microsoft.Data.SqlClient.SNI.dll"}
                    "Arm" {"$PSScriptRoot\runtimes\win-arm\native\Microsoft.Data.SqlClient.SNI.dll"}              
                }
                Copy-Item $SNIPath -Destination "$PSScriptRoot\runtimes\win\lib\netcoreapp3.1\" -Force
            }
            Add-Type -Path $RequiredAssemblyPath
        }
        catch [System.IO.FileLoadException] {
            Write-Error "$( $_.Exception ) while adding assembly '$( $RequiredAssemblyPath.Name )'"
        }
    }
}

