using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System.Linq;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommon.Set, "Package")]
    [OutputType(typeof(DacPackage))]
    public class SetPackageCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public DacPackage Package { get; set; }

        [Parameter(
            Position = 1,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public TSqlModel Model { get; set; }

        public string Name { get; set; }
        public string Description { get; set; }
        public string Version { get; set; }

        [Parameter()]
        public int[] IgnoreCode { get; set; } = new int[] { };

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            if (Name == null)
                Name = Package.Name;

            if (Description == null)
                Description = Package.Description;

            if (Version == null)
                Version = Package.Version.ToString();

            foreach(var message in Model.Validate())
            {
                if (!IgnoreCode.Contains(message.Number))
                    WriteWarning(message.ToString());
            }

            Package.UpdateModel(newModel: Model, packageMetadata: new PackageMetadata {
                Name = Name,
                Description = Description,
                Version = Version
            });
        }
    }
}
