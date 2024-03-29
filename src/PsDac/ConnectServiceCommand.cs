using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System;
using System.Management.Automation;
using Microsoft.Data.SqlClient;

namespace PsDac
{
    [Cmdlet(VerbsCommunications.Connect, "Service", DefaultParameterSetName = PARAMETERSET_CONNECTION_STRING)]
    [OutputType(typeof(DacServices))]
    public class ConnectServiceCommand : PSCmdlet
    {
        #region ParameterSets
        const string PARAMETERSET_CONNECTION_STRING = "ConnectionString";
        const string PARAMETERSET_PROPERTIES = "Properties";
        #endregion

        private SqlConnectionStringBuilder connectionStringBuilder = new ();

        #region Parameters

        [Parameter(
            ParameterSetName = PARAMETERSET_CONNECTION_STRING,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string ConnectionString
        {
            get
            {
                return connectionStringBuilder.ConnectionString;
            }
            set
            {
                connectionStringBuilder.ConnectionString = value;
            }
        }

        [Parameter(
            ParameterSetName = PARAMETERSET_PROPERTIES,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string DataSource
        {
            get
            {
                return connectionStringBuilder.DataSource;
            }
            set
            {
                connectionStringBuilder.DataSource = value;
            }
        }

        [Parameter(
            ParameterSetName = PARAMETERSET_PROPERTIES,
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            ParameterSetName = PARAMETERSET_CONNECTION_STRING,
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

        #endregion

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            try
            {
                IUniversalAuthProvider authProvider = null;

                // if access token is present in connection string, use IUniversalAuthProvider and remove the access token from the connection string.
                if (AccessToken != null)
                {
                    authProvider = new PreparedAccessTokenAuthProvider(AccessToken);
                    AccessToken = null;
                }

                // if the server seems to be an azure sql server, use the azure token provider.
                else if (DataSource.EndsWith("database.windows.net"))
                {
                    WriteVerbose("Connect to Azure SQL Server.");
                    authProvider = new AzureAuthProvider("https://database.windows.net");
                }

                // else use defaults.
                else
                {
                    WriteVerbose("Connect to Microsoft SQL Server.");
                }

                // if present, use an auth provider.
                if (authProvider != null)
                {
                    WriteVerbose("Authenticate with token.");
                    Service = new DacServices(connectionString: ConnectionString, authProvider: authProvider);
                }

                // else use defaults.
                else
                {
                    WriteVerbose("Authenticate without token.");
                    Service = new DacServices(connectionString: ConnectionString);
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
