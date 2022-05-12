using Microsoft.SqlServer.Dac;
using System.Management.Automation;
using System.Collections;

namespace PsDac
{
    [Cmdlet(VerbsCommon.New, "CreateScript")]
    [OutputType(typeof(string))]
    public class NewCreateScriptCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public DacPackage Package { get; set; }

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        public string DatabaseName { get; set; } = "master";

        [Parameter()]
        public SwitchParameter CreateNewDatabase { get; set; }

        [Parameter()]
        public SwitchParameter IncludeTransactionalScripts { get; set; }

        [Parameter()]
        public SwitchParameter CommentOutSetVarDeclarations { get; set; }

#if NEW
        [Parameter()]
        public SwitchParameter DoNotEvaluateSqlCmdVariables { get; set; }
#endif

        [Parameter()]
        public Hashtable Variables { get; set; } = new Hashtable();

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
                IncludeTransactionalScripts = IncludeTransactionalScripts.IsPresent,
#if NEW
                DoNotEvaluateSqlCmdVariables = DoNotEvaluateSqlCmdVariables.IsPresent
#endif
            };

            foreach (DictionaryEntry variable in Variables)
            {
#if NEW
                options.SetVariable(
                    variable.Key.ToString(),
                    variable.Value.ToString()
                );
#endif
                options.SqlCommandVariableValues.Add(key: variable.Key.ToString(), value: variable.Value.ToString());
            }

            WriteObject(DacServices.GenerateCreateScript(package: Package, targetDatabaseName: DatabaseName, options: options));
        }
    }
}
