using System.Linq;
using System.Management.Automation;
using Microsoft.SqlServer.Dac.Model;

namespace PsDac
{
    [Cmdlet(VerbsDiagnostic.Test, "Model")]
    [OutputType(typeof(TSqlObject))]
    public class TestModelCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public TSqlModel Model { get; set; }

        [Parameter()]
        public int[] IgnoreCode { get; set; } = new int[] { };

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            foreach( var message in Model.Validate() )
            {
                if ( !IgnoreCode.Contains(message.Number))
                {
                    WriteObject(message);
                }
            }

        }
    }
}
