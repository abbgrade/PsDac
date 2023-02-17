using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommon.Get, "Model")]
    [OutputType(typeof(TSqlModel))]
    public class GetModelCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true
        )]
        [ValidateNotNullOrEmpty()]
        public DacPackage Package { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            throw new PSNotSupportedException("Accessing the model from a loaded Package is not supported by DacFx.");
        }
    }
}
