using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System;
using System.IO;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsData.Import, "Model")]
    [OutputType(typeof(TSqlModel))]
    public class ImportTSqlModelCommand : ClientCommand
    {
        #region ParameterSets
        private const string PARAMETERSET_DATABASE = "Database";
        private const string PARAMETERSET_FILE = "File";
        #endregion

        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true,
            ParameterSetName = PARAMETERSET_FILE
        )]
        [ValidateNotNullOrEmpty()]
        public FileInfo Path { get; set; }

        [Parameter(
            ParameterSetName = PARAMETERSET_DATABASE
        )]
        public string DatabaseName { get; set; }

        [Parameter()]
        public DacSchemaModelStorageType ModelStorageType { get; set; } = DacSchemaModelStorageType.Memory;

        [Parameter()]
        public SwitchParameter LoadAsScriptBackedModel { get; set; }

        protected override void BeginProcessing()
        {

            switch (ParameterSetName)
            {
                case PARAMETERSET_DATABASE:
                    base.BeginProcessing();
                    break;

                default:
                    base.BeginProcessing(serviceRequired: false);
                    break;
            }
        }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            TSqlModel model = null;

            switch (ParameterSetName)
            {
                case PARAMETERSET_DATABASE:

                    string tempDacPacPath = System.IO.Path.GetTempFileName();
                    Service.Extract(
                        targetPath: tempDacPacPath,
                        databaseName: DatabaseName,
                        applicationName: "temp",
                        applicationVersion: new Version()
                    );

                    model = TSqlModel.LoadFromDacpac(fileName: tempDacPacPath, options: new ModelLoadOptions(modelStorageType: ModelStorageType, loadAsScriptBackedModel: LoadAsScriptBackedModel.IsPresent));
                    break;

                case PARAMETERSET_FILE:

                    if (!Path.Exists)
                    {
                        throw new ArgumentException($"Path does not exist.", Path.FullName);
                    }

                    model = TSqlModel.LoadFromDacpac(fileName:Path.FullName, options: new ModelLoadOptions(modelStorageType: ModelStorageType, loadAsScriptBackedModel: LoadAsScriptBackedModel.IsPresent));
                    break;

                default:
                    throw new NotImplementedException($"ParameterSetName {ParameterSetName} is not implemented");
            }

            if (model != null)
                WriteObject(model);
        }
    }
}
