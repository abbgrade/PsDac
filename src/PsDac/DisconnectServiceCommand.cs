using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommunications.Disconnect, "Service")]
    [OutputType(typeof(void))]
    public class DisconnectServiceCommand : ClientCommand
    {

        [Parameter( ValueFromPipeline = true )]
        public new DacServices Service { get; set; } = ConnectServiceCommand.Service;

        protected override void BeginProcessing()
        {
            BeginProcessing(serviceRequired: true);
        }

        protected override void AsyncProcessRecord()
        {
            if (ConnectServiceCommand.Service == Service)
                ConnectServiceCommand.Service = null;
        }
    }
}
