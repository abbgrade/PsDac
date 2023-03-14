using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System;
using System.Management.Automation;
using System.Data.Common;

namespace PsDac
{
    [Cmdlet(VerbsCommunications.Connect, "Service", DefaultParameterSetName = PARAMETERSET_CONNECTION_STRING)]
    [OutputType(typeof(DacServices))]
    public class ConnectServiceCommand : PSCmdlet
    {
        const string PARAMETERSET_CONNECTION_STRING = "ConnectionString";
        const string PARAMETERSET_PROPERTIES = "DataSource";

        [Parameter(
            ParameterSetName = PARAMETERSET_CONNECTION_STRING,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string ConnectionString { get; set; }

        [Parameter(
            ParameterSetName = PARAMETERSET_PROPERTIES,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string DataSource { get; set; }

        [Parameter(
            ParameterSetName = PARAMETERSET_PROPERTIES,
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string AccessToken { get; set; }

        [Parameter(           
            Position = 0,
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        internal static DacServices Service { get; set; }

        private record class AccessTokenProvider(string Token) : IUniversalAuthProvider
        {
            public string GetValidAccessToken() => Token;
        }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            try
            {
                switch (ParameterSetName)
                {
                    case "ConnectionString":
                        WriteVerbose("Connect using connection string.");
                        break;

                    case "DataSource":
                        WriteVerbose("Connect using properties.");
                        DbConnectionStringBuilder reverseConnectionStringBuilder = new();
                        reverseConnectionStringBuilder.Add("data source", DataSource);                
                        if (!string.IsNullOrEmpty(AccessToken))
                        {
                            reverseConnectionStringBuilder.Add("access token", AccessToken);
                        }
                        ConnectionString = reverseConnectionStringBuilder.ConnectionString;
                        break;
                }

                //if access token is present in connection string, use IUniversalAuthProvider and remove the access token from the connection string
                DbConnectionStringBuilder connectionStringBuilder = new();
                connectionStringBuilder.ConnectionString = ConnectionString;
                if (connectionStringBuilder.ContainsKey("access token"))
                {
                    var accessToken = connectionStringBuilder["access token"].ToString();
                    connectionStringBuilder.Remove("access token");
                    Service = new DacServices(connectionString: connectionStringBuilder.ConnectionString, new AccessTokenProvider(accessToken));
                }
                else
                {
                    Service = new DacServices(connectionString: connectionStringBuilder.ConnectionString);
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
