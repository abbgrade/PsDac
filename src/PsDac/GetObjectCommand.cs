using System.Management.Automation;
using Microsoft.SqlServer.Dac.Model;

namespace PsDac
{
    [Cmdlet(VerbsCommon.Get, "Object")]
    [OutputType(typeof(TSqlObject))]
    public class GetObjectCommand : PSCmdlet
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
            if ( hasNameFilter ) {
                WriteVerbose($"Filter roles on name '{Name}'");
            }

            foreach (var item in Model.GetObjects(Scope)) {
                if ( !hasNameFilter || item.Name.ToString() == Name )
                {
                    WriteObject(item);
                }
            }

        }
    }
}
