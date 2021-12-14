using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommunications.Connect, "Service")]
    [OutputType(typeof(DacServices))]
    public class ConnectServiceCommand : PSCmdlet
    {
        [Parameter(
            ParameterSetName = "ConnectionString",
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string ConnectionString { get; set; }

        [Parameter(
            ParameterSetName = "DataSource",
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string DataSource { get; set; }

        internal static DacServices Service { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            switch (ParameterSetName)
            {
                case "ConnectionString":
                    WriteVerbose("Connect using connection string.");
                    break;

                case "DataSource":
                    WriteVerbose("Connect using datasource.");
                    ConnectionString = $"Server=\"{ DataSource }\"";
                    break;
            }

            try
            {
                Service = new DacServices(connectionString: ConnectionString);
            }
            catch (Exception ex)
            {
                WriteError(new ErrorRecord(
                    exception: ex,
                    errorId: ex.GetType().Name,
                    errorCategory: ErrorCategory.OpenError,
                    targetObject: null
                ));
            }

            Service.Message += Service_Message;

            WriteObject(Service);
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
                errorCategory: ErrorCategory.OpenError,
                targetObject: null
            ));
        }

        private void ProcessServiceWarning(DacMessageEventArgs e)
        {
            WriteWarning($"SQL{e.Message.Number}: {e.Message.Message}");
        }

        private void ProcessServiceMessage(DacMessageEventArgs e)
        {
            switch(e.Message.Number)
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
