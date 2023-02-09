$assemblyLoaded = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -like "*netcoreapp3.1\Microsoft.Data.SqlClient.dll"
if ([string]::IsNullOrEmpty($assemblyLoaded)) {
    Add-Type -AssemblyName $PSScriptRoot\runtimes\win\lib\netcoreapp3.1\Microsoft.Data.SqlClient.dll
}
