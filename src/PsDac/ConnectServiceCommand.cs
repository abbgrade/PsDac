using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommunications.Connect, "Service", DefaultParameterSetName = "ConnectionString")]
    [OutputType(typeof(DacPackage))]
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
        }
    }
}
