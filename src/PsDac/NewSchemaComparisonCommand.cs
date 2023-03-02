using System.Management.Automation;
using Microsoft.SqlServer.Dac.Compare;
using System.Collections.Generic;
using System.IO;
using Microsoft.SqlServer.Dac;
using System.Linq;
using Microsoft.SqlServer.Dac.Model;

namespace PsDac
{
    [Cmdlet(VerbsCommon.New, "SchemaComparison")]
    [OutputType(typeof(List<SchemaDifference>))]
    public class NewSchemaComparisonCommand : PSCmdlet
    {
        const string PARAMETERSET_STANDARD = "Standard";
        const string PARAMETERSET_EXTENDED = "Extended";

        [Parameter(
            ParameterSetName = PARAMETERSET_STANDARD,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            ParameterSetName = PARAMETERSET_EXTENDED,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public TSqlModel Source { get; set; }

        [Parameter(
            ParameterSetName = PARAMETERSET_STANDARD,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            ParameterSetName = PARAMETERSET_EXTENDED,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public TSqlModel Target { get; set; }

        [Parameter(
            ParameterSetName = PARAMETERSET_EXTENDED,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
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

            switch (ParameterSetName)
            {
                case PARAMETERSET_EXTENDED:
                    WriteVerbose("Use comparison with custom options.");
                    foreach(ObjectType t in ExcludedObjectTypes)
                    {
                        excludedObjectTypes = excludedObjectTypes.Append(t).ToArray();
                    }
                    comparison.Options.ExcludeObjectTypes = excludedObjectTypes;
                    break;
            }

            var result = comparison.Compare();

            File.Delete(sourcePath);
            File.Delete(targetPath);

            WriteObject(result.Differences);

        }
    }
}
