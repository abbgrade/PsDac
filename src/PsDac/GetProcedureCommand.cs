using System.Management.Automation;
using Microsoft.SqlServer.Dac.Model;

namespace PsDac
{
    [Cmdlet(VerbsCommon.Get, "Procedure")]
    [OutputType(typeof(TSqlObject))]
    public class GetProcedureCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public TSqlModel Model { get; set; }

        [Parameter(
            Position = 1,
            Mandatory = false)]
        [ValidateNotNullOrEmpty()]
        public string Name { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            bool hasNameFilter = Name != null;
            if ( hasNameFilter ) {
                WriteVerbose($"Filter procedures on name '{Name}'");
            }

            foreach (var item in Model.GetObjects(DacQueryScopes.Default, ModelSchema.Procedure)) {
                if ( !hasNameFilter || item.Name.ToString() == Name )
                {
                    var result = new PSObject(item);
                    result.Properties.Add(new PSNoteProperty("Schema", item.Name.Parts[0]));
                    WriteObject(result);
                }
            }

        }
    }
}
