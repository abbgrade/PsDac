using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System.IO;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsData.Export, "Package")]
    public class ExportPackageCommand : PSCmdlet
    {
        [Parameter(
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public DacPackage Package { get; set; }

        [Parameter(
            Mandatory = true
        )]
        [ValidateNotNullOrEmpty()]
        public FileInfo Path { get; set; }


        protected override void ProcessRecord()
        {
            base.ProcessRecord();
            throw new PSNotSupportedException("Accessing the model from a loaded Package is not supported by DacFx.");
            //DacPackageExtensions.BuildPackage(
            //    packageFilePath: Path.FullName,
            //    model: null,
            //    packageMetadata: null
            //);
        }
    }
}
