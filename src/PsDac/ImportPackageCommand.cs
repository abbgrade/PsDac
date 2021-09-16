using Microsoft.SqlServer.Dac;
using System;
using System.IO;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsData.Import, "Package")]
    [OutputType(typeof(DacPackage))]
    public class ImportPackageCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public FileInfo Path { get; set; }

        [Parameter()]
        public FileAccess Access { get; set; } = FileAccess.Read;

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            if (!Path.Exists) {
                throw new ArgumentException( $"Path does not exist.", Path.FullName );
            }

            var package = DacPackage.Load(
                fileName: Path.FullName, 
                modelStorageType: DacSchemaModelStorageType.Memory,
                packageAccess: Access
            );

            WriteObject(package);
        }
    }
}
