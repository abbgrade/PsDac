using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Compare;
using Microsoft.SqlServer.Dac.Model;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommon.New, "SchemaComparison")]
    [OutputType(typeof(List<SchemaDifference>))]
    public class NewSchemaComparisonCommand : PSCmdlet
    {
        [Parameter(
            Mandatory = true,
            ValueFromPipelineByPropertyName = true
        )]
        [ValidateNotNullOrEmpty()]
        public TSqlModel Source { get; set; }

        [Parameter(
            Mandatory = true,
            ValueFromPipelineByPropertyName = true
        )]
        [ValidateNotNullOrEmpty()]
        public TSqlModel Target { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true
        )]
        public ObjectType[] ExcludedObjectTypes { get; set; }


        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            var sourcePath = Path.GetTempFileName();
            var targetPath = Path.GetTempFileName();
            DacPackageExtensions.BuildPackage(
                packageFilePath: sourcePath,
                model: Source,
                packageMetadata: new PackageMetadata()
            );
            DacPackageExtensions.BuildPackage(
                packageFilePath: targetPath,
                model: Target,
                packageMetadata: new PackageMetadata()
            );
            var comparison = new SchemaComparison(
                source: new SchemaCompareDacpacEndpoint(sourcePath),
                target: new SchemaCompareDacpacEndpoint(targetPath)
            );

            var excludedObjectTypes = comparison.Options.ExcludeObjectTypes;

            if (ExcludedObjectTypes != null && ExcludedObjectTypes.Length > 0)
            {
                WriteVerbose("Use comparison with excluded object types.");
                foreach(ObjectType t in ExcludedObjectTypes)
                {
                    excludedObjectTypes = excludedObjectTypes.Append(t).ToArray();
                }
                comparison.Options.ExcludeObjectTypes = excludedObjectTypes;
            }

            var result = comparison.Compare();

            File.Delete(sourcePath);
            File.Delete(targetPath);

            WriteObject(result.Differences);
        }
    }
}
