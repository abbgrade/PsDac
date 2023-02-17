using System.Management.Automation;
using Microsoft.SqlServer.Dac.Compare;
using System.Collections.Generic;
using System.IO;
using Microsoft.SqlServer.Dac;
using System.Linq;

namespace PsDac
{
    [Cmdlet(VerbsCommon.New, "SchemaComparison")]
    [OutputType(typeof(List<SchemaDifference>))]
    public class NewSchemaComparisonCommand : PSCmdlet
    {
        const string PARAMETERSET_STANDARD = "StandardDacComparison";
        const string PARAMETERSET_EXTENDED = "ExtendedComparison";

        [Parameter(
            ParameterSetName = PARAMETERSET_STANDARD,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            ParameterSetName = PARAMETERSET_EXTENDED,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public FileInfo DacPacPathSource { get; set; }

        [Parameter(
            ParameterSetName = PARAMETERSET_STANDARD,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            ParameterSetName = PARAMETERSET_EXTENDED,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public FileInfo DacPacPathTarget { get; set; }

        [Parameter(
            ParameterSetName = PARAMETERSET_EXTENDED,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        public ObjectType[] ExcludedObjectTypes { get; set; }


        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            var source = new SchemaCompareDacpacEndpoint(DacPacPathSource.FullName);
            var target = new SchemaCompareDacpacEndpoint(DacPacPathTarget.FullName);

            var comparison = new SchemaComparison(source, target);

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

            WriteObject(result.Differences);

        }
    }
}
