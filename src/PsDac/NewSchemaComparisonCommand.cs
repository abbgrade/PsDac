using System.Management.Automation;
using Microsoft.SqlServer.Dac.Compare;
using System;
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
        const string StandardComparisonParameterSetName = "StandardDacComparison";
        const string ExtendedComparisonParameterSetName = "ExtendedComparison";

        [Parameter(
            ParameterSetName = StandardComparisonParameterSetName,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            ParameterSetName = ExtendedComparisonParameterSetName,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public FileInfo DacPacPathSource { get; set; }

        [Parameter(
            ParameterSetName = StandardComparisonParameterSetName,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            ParameterSetName = ExtendedComparisonParameterSetName,
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)] 
        [ValidateNotNullOrEmpty()]
        public FileInfo DacPacPathTarget { get; set; }

        [Parameter(
            ParameterSetName = ExtendedComparisonParameterSetName,
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
                case "ExtendedComparison":
                    WriteVerbose("use comparison with custom options.");
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
