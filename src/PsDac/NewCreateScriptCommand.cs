using Microsoft.SqlServer.Dac;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommon.New, "CreateScript")]
    [OutputType(typeof(DacPackage))]
    public class NewCreateScriptCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public DacPackage Package { get; set; }

        [Parameter(
            Position = 1,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string DatabaseName { get; set; }

        [Parameter()]
        public SwitchParameter CreateNewDatabase { get; set; }

        [Parameter()]
        public SwitchParameter IncludeTransactionalScripts { get; set; }

        [Parameter()]
        public SwitchParameter CommentOutSetVarDeclarations { get; set; }

    protected override void ProcessRecord()
        {
            base.ProcessRecord();

            var options = new DacDeployOptions
            {
                CreateNewDatabase = CreateNewDatabase.IsPresent,
                ScriptDatabaseOptions = false,
                ScriptDatabaseCollation = false,
                ScriptDatabaseCompatibility = false,
                CommentOutSetVarDeclarations = CommentOutSetVarDeclarations.IsPresent,
                IncludeTransactionalScripts = IncludeTransactionalScripts.IsPresent
            };

            WriteObject(DacServices.GenerateCreateScript(package: Package, targetDatabaseName: DatabaseName, options: options));
        }
    }
}
