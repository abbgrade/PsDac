using System.Management.Automation;
using Microsoft.SqlServer.Dac.Model;

namespace PsDac
{
    [Cmdlet(VerbsCommon.Get, "Schema")]
    [OutputType(typeof(TSqlObject))]
    public class GetSchemaCommand : PSCmdlet
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

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        public DacQueryScopes Scope { get; set; } = DacQueryScopes.Default;

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            bool hasNameFilter = Name != null;
            if (hasNameFilter)
            {
                WriteVerbose($"Filter schemas on name '{Name}'");
            }

            var returned = false;

            foreach (var item in Model.GetObjects(Scope, ModelSchema.Schema))
            {
                if (!hasNameFilter || item.Name.ToString() == Name || item.Name.Parts[0].ToString() == Name)
                {

                    var result = new PSObject(item);
                    result.Properties.Add(new PSNoteProperty("Schema", item.Name.Parts[0]));
                    WriteObject(result);

                    returned = true;
                }
            }

            if (!returned && hasNameFilter)
                throw new System.InvalidOperationException($"Schema {Name} was not found.");

        }
    }
}
