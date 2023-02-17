using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System.IO;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsData.Export, "Model")]
    public class ExportModelCommand : PSCmdlet
    {
        [Parameter(
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public TSqlModel Model { get; set; }

        [Parameter(
            Mandatory = true
        )]
        [ValidateNotNullOrEmpty()]
        public FileInfo Path { get; set; }


        protected override void ProcessRecord()
        {
            base.ProcessRecord();
            DacPackageExtensions.BuildPackage(
                packageFilePath: Path.FullName,
                model: Model,
                packageMetadata: new PackageMetadata()
            );
        }
    }
}
