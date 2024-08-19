using System.Management.Automation;
using Microsoft.SqlServer.Dac.Model;

namespace PsDac
{
    [Cmdlet(VerbsCommon.Get, "Column")]
    [OutputType(typeof(TSqlObject))]
    public class GetColumnCommand : PSCmdlet
    {
        [Alias("Table")]
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public TSqlObject Object { get; set; }

        [Parameter(
            Position = 1,
            Mandatory = false)]
        [ValidateNotNullOrEmpty()]
        public string Name { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            if (Object.ObjectType.Name != "Table" && Object.ObjectType.Name != "View") {
                throw new System.ArgumentException("Invalid Table or View type", Object.ObjectType.Name);
            }

            bool hasNameFilter = Name != null;
            if ( hasNameFilter ) {
                WriteVerbose($"Filter columns on name '{Name}'");
            }

            var relationship = Object.ObjectType.Name == "Table" ? Microsoft.SqlServer.Dac.Model.Table.Columns : Microsoft.SqlServer.Dac.Model.View.Columns;

            foreach (var item in Object.GetReferencedRelationshipInstances(relationship, DacQueryScopes.Default)) {
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
