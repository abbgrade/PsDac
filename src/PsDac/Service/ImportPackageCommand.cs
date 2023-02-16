using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System;
using System.IO;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsData.Import, "Package")]
    [OutputType(typeof(DacPackage))]
    public class ImportPackageCommand : ClientCommand
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

        [Parameter(
            Mandatory = true,
            ParameterSetName = PARAMETERSET_DATABASE
        )]
        public string ApplicationName { get; set; }

        [Parameter(
            Mandatory = true,
            ParameterSetName = PARAMETERSET_DATABASE
        )]
        public Version ApplicationVersion { get; set; }

        [Parameter()]
        public FileAccess Access { get; set; } = FileAccess.Read;

        protected override void BeginProcessing()
        {

            switch (ParameterSetName)
            {
                case PARAMETERSET_DATABASE:
                    base.BeginProcessing();
                    break;

                default:
                    base.BeginProcessing(serviceRequired:false);
                    break;
            }
        }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            DacPackage package = null;

            switch (ParameterSetName)
            {
                case PARAMETERSET_DATABASE:
                    using (MemoryStream packageStream = new MemoryStream()) {
                        Service.Extract(
                            packageStream: packageStream,
                            databaseName: DatabaseName,
                            applicationName: ApplicationName,
                            applicationVersion: ApplicationVersion
                        );
                        packageStream.Position = 0;
                        package = DacPackage.Load(
                            stream: packageStream,
                            modelStorageType: DacSchemaModelStorageType.Memory,
                        packageAccess: FileAccess.ReadWrite
                        );
                    }
                    break;
                case PARAMETERSET_FILE:

                    if (!Path.Exists)
                    {
                        throw new ArgumentException($"Path does not exist.", Path.FullName);
                    }

                    package = DacPackage.Load(
                        fileName: Path.FullName,
                        modelStorageType: DacSchemaModelStorageType.Memory,
                        packageAccess: Access
                    );
                    break;
                default:
                    throw new NotImplementedException($"ParameterSetName {ParameterSetName} is not implemented");
            }

            if (package != null)
                WriteObject(package);
        }
    }
}
