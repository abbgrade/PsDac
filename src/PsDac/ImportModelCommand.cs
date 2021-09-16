using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System;
using System.IO;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsData.Import, "Model")]
    [OutputType(typeof(TSqlModel))]
    public class ImportTSqlModelCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public FileInfo Path { get; set; }

        [Parameter()]
        public DacSchemaModelStorageType ModelStorageType { get; set; } = DacSchemaModelStorageType.Memory;

        [Parameter()]
        public SwitchParameter LoadAsScriptBackedModel { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            if (!Path.Exists) {
                throw new ArgumentException( $"Path does not exist.", Path.FullName );
            }

            var package = TSqlModel.LoadFromDacpac(fileName:Path.FullName, options: new ModelLoadOptions(modelStorageType: ModelStorageType, loadAsScriptBackedModel: LoadAsScriptBackedModel.IsPresent));

            WriteObject(package);
        }
    }
}
