using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommunications.Connect, "Service", DefaultParameterSetName = ConnectionStringParameterSetName)]
    [OutputType(typeof(DacServices))]
    public class ConnectServiceCommand : PSCmdlet
    {
        const string ConnectionStringParameterSetName = "ConnectionString";
        const string DataSourceParameterSetName = "DataSource";
        const string AccessTokenParameterSetName = "AccessToken";

        [Parameter(
            ParameterSetName = AccessTokenParameterSetName,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            ParameterSetName = ConnectionStringParameterSetName,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string ConnectionString { get; set; }

        [Parameter(
            ParameterSetName = AccessTokenParameterSetName,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string AccessToken { get; set; }

        [Parameter(
            ParameterSetName = DataSourceParameterSetName,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string DataSource { get; set; }

        internal static DacServices Service { get; set; }

        public record class AcessTokenProvider(string Token) : IUniversalAuthProvider
        {
            public string GetValidAccessToken() => Token;
        }

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
                case "AccessToken":
                    WriteVerbose("Connect using connection string with access token.");
                    break;
            }

            try
            {
                switch (ParameterSetName)
                {
                    case "ConnectionString":
                    case "DataSource":
                        Service = new DacServices(connectionString: ConnectionString);
                        break;

                    case "AccessToken":
                        Service = new DacServices(connectionString: ConnectionString, new AcessTokenProvider(AccessToken));
                        break;
                }
               
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

            WriteObject(Service);
        }
    }
}
