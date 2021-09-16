using System.Management.Automation;
using Microsoft.SqlServer.Dac.Model;

namespace PsDac
{
    [Cmdlet(VerbsCommon.Get, "Column")]
    [OutputType(typeof(TSqlObject))]
    public class GetColumnCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public TSqlObject Table { get; set; }

        [Parameter(
            Position = 1,
            Mandatory = false)]
        [ValidateNotNullOrEmpty()]
        public string Name { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            if (Table.ObjectType.Name != "Table") {
                throw new System.ArgumentException("Invalid Table type", Table.ObjectType.Name);
            }

            bool hasNameFilter = Name != null;
            if ( hasNameFilter ) {
                WriteVerbose($"Filter columns on name '{Name}'");
            }

            foreach (var item in Table.GetReferencedRelationshipInstances(Microsoft.SqlServer.Dac.Model.Table.Columns, DacQueryScopes.Default)) {
                if ( ( !hasNameFilter || item.ObjectName.ToString() == Name ))
                {
                    var result = new PSObject(item.Object);
                    result.Properties.Add(new PSNoteProperty("Schema", item.ObjectName.Parts[0]));
                    WriteObject(result);
                }
            }

        }
    }
}
