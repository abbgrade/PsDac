using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System;
using System.Management.Automation;
using System.Data.Common;

namespace PsDac
{
    [Cmdlet(VerbsCommunications.Connect, "Service", DefaultParameterSetName = ConnectionStringParameterSetName)]
    [OutputType(typeof(DacServices))]
    public class ConnectServiceCommand : PSCmdlet
    {
        const string ConnectionStringParameterSetName = "ConnectionString";
        const string DataSourceParameterSetName = "DataSource";

        [Parameter(
            ParameterSetName = ConnectionStringParameterSetName,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string ConnectionString { get; set; }

        [Parameter(
            ParameterSetName = DataSourceParameterSetName,
            Position = 0,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public string DataSource { get; set; }

        [Parameter(           
            Position = 0,
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]

        internal static DacServices Service { get; set; }

        public record class AcessTokenProvider(string Token) : IUniversalAuthProvider
        {
            public string GetValidAccessToken() => Token;
        }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            try
            {
                DbConnectionStringBuilder dbConnectionStringBuilder = new DbConnectionStringBuilder();

                switch (ParameterSetName)
                {
                    case "ConnectionString":
                        WriteVerbose("Connect using connection string.");
                        //if access token is present in connection string, use IUniversalAuthProvider and remove the access token from the connection string
                        dbConnectionStringBuilder.ConnectionString = ConnectionString;
                        if (dbConnectionStringBuilder.ContainsKey("access token")) {
                            var accessToken = dbConnectionStringBuilder["access token"].ToString();
                            dbConnectionStringBuilder.Remove("access token");
                            Service = new DacServices(connectionString: dbConnectionStringBuilder.ConnectionString, new AcessTokenProvider(accessToken));
                        }
                        else {
                            WriteVerbose("ohne access token");
                            Service = new DacServices(connectionString: dbConnectionStringBuilder.ConnectionString);
                        }
                        break;

                    case "DataSource":
                            WriteVerbose("Connect using datasource."); 
                            dbConnectionStringBuilder.Add("data source", DataSource);                
                            Service = new DacServices(connectionString: dbConnectionStringBuilder.ConnectionString);
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
