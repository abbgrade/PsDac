using Microsoft.SqlServer.Dac;
using System;
using System.Management.Automation;

namespace PsDac
{
    public abstract class ClientCommand : PSCmdlet
    {

        [Parameter()]
        public DacServices Service { get; set; } = ConnectServiceCommand.Service;

        protected override void BeginProcessing()
        {
            BeginProcessing(serviceRequired: false);
        }

        protected void BeginProcessing(bool serviceRequired)
        {
            base.BeginProcessing();

            if (Service == null)
            {
                if (serviceRequired == true)
                    throw new PSArgumentNullException(nameof(Service), $"run Connect-DacService");
            }
            else
                Service.Message += Service_Message;
        }

        protected override void EndProcessing()
        {
            base.EndProcessing();

            if (Service != null)
                Service.Message -= Service_Message;
        }

        private void Service_Message(object sender, DacMessageEventArgs e)
        {
            switch (e.Message.MessageType)
            {
                case DacMessageType.Message:
                    ProcessServiceMessage(e);
                    break;
                case DacMessageType.Warning:
                    ProcessServiceWarning(e);
                    break;
                case DacMessageType.Error:
                    ProcessServiceError(e);
                    break;
                default:
                    throw new NotSupportedException($"{e.Message.MessageType} is not supported.");
            }
        }

        private void ProcessServiceError(DacMessageEventArgs e)
        {
            WriteError(new ErrorRecord(
                exception: new Exception($"{e.Message}"),
                errorId: e.Message.Number.ToString(),
                errorCategory: ErrorCategory.NotSpecified,
                targetObject: null
            ));
        }

        private void ProcessServiceWarning(DacMessageEventArgs e)
        {
            WriteWarning($"SQL{e.Message.Number}: {e.Message.Message}");
        }

        private void ProcessServiceMessage(DacMessageEventArgs e)
        {
            switch (e.Message.Number)
            {
                case 0:
                    WriteVerbose($"{e.Message.Message}");
                    break;
                default:
                    WriteVerbose($"SQL{e.Message.Number}: {e.Message.Message}");
                    break;
            }

        }
    }
}
