using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommunications.Connect, "Service")]
    [OutputType(typeof(DacPackage))]
    public class ConnectServiceCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string ConnectionString { get; private set; }

        internal static DacServices Service { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            Service = new DacServices(connectionString: ConnectionString);
        }
    }
}
