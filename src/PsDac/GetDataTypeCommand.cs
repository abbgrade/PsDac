using Microsoft.SqlServer.Dac.Model;
using System;
using System.Data;
using System.Linq;
using System.Management.Automation;

namespace PsDac
{
    [Cmdlet(VerbsCommon.Get, "DataType")]
    [OutputType(typeof(ColumnInfo))]
    public class GetDataTypeCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty()]
        public TSqlObject Column { get; set; }

        class ColumnInfo
        {
            public ObjectIdentifier Identifier { get; set; }
            public String Name { get {
                if ( Identifier.Parts.Count == 1 ) {
                    return Identifier.Parts[0];
                }
                if ( Identifier.Parts.Count == 2 && Identifier.Parts[0] == "sys" ) {
                    return Identifier.Parts[1];
                }
                return Identifier.ToString();
            } }
            // public SqlDataType Name { get; set; }
            public int Length { get; set; }
            public int Precision { get; set; }
            public int Scale { get; set; }
            public bool IsNullable { get; set; }
            public bool IsMax { get; set; }
            public string Collation { get; set; }
            public TSqlObject _detail { get; set; }

        }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            if (Column.ObjectType.Name != "Column") {
                throw new ArgumentException("Invalid Column type", Column.ObjectType.Name);
            }

            var type = Column.GetReferenced(Microsoft.SqlServer.Dac.Model.Column.DataType, DacQueryScopes.All).Single();

            WriteVerbose($"Found {type.Name}({type.ObjectType}) on column {Column.Name}({Column.ObjectType})");

            var dataType = new ColumnInfo
            {
                Identifier = type.Name,
                // Name = type.GetProperty<SqlDataType>(DataType.SqlDataType),
                Length = Column.GetProperty<int>(Microsoft.SqlServer.Dac.Model.Column.Length),
                Precision = Column.GetProperty<int>(Microsoft.SqlServer.Dac.Model.Column.Precision ),
                Scale = Column.GetProperty<int>(Microsoft.SqlServer.Dac.Model.Column.Scale),
                IsNullable = Column.GetProperty<bool>(Microsoft.SqlServer.Dac.Model.Column.Nullable),
                IsMax = Column.GetProperty<bool>(Microsoft.SqlServer.Dac.Model.Column.IsMax ),
                Collation = Column.GetProperty<string>(Microsoft.SqlServer.Dac.Model.Column.Collation ),
                _detail = type
            };

            WriteObject(dataType);

        }
    }
}
