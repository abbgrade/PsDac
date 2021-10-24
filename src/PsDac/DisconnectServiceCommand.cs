using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommunications.Disconnect, "Service")]
    [OutputType(typeof(void))]
    public class DisconnectServiceCommand : PSCmdlet
    {

        [Parameter()]
        public DacServices Service { get; set; } = ConnectServiceCommand.Service;

        protected override void BeginProcessing()
        {
            base.BeginProcessing();

            if (Service == null)
                throw new PSArgumentNullException(nameof(Service), $"run Connect-DacService");
        }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            if (ConnectServiceCommand.Service == Service)
                ConnectServiceCommand.Service = null;
        }
    }
}
