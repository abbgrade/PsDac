using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsLifecycle.Install, "Package")]
    [OutputType(typeof(void))]
    public class InstallPackageCommand : ClientCommand
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true
        )]
        [ValidateNotNullOrEmpty()]
        public DacPackage Package { get; set; }

        [Parameter(
            Mandatory = true,
            ValueFromPipelineByPropertyName = true
        )]
        public string DatabaseName { get; set; }

        [Parameter()]
        public ObjectType[] ExcludeObjectTypes { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            var options = new DacDeployOptions();
            options.ExcludeObjectTypes = ExcludeObjectTypes;
            Service.Deploy(package: Package, targetDatabaseName: DatabaseName, options: options);
        }
    }
}
