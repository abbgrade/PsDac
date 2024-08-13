using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using System.Collections;
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
        [ValidateNotNullOrEmpty()]
        public string DatabaseName { get; set; }

        [Parameter()]
        public SwitchParameter UpgradeExisting { get; set; }

        #region deploy options

        [Parameter()]
        public ObjectType[] ExcludeObjectTypes
        {
            set { DeployOptions.ExcludeObjectTypes = value; }
        }

        [Parameter()]
        public ObjectType[] DoNotDropObjectTypes
        {
            set { DeployOptions.DoNotDropObjectTypes = value; }
        }

        [Parameter()]
        public SwitchParameter AcceptPossibleDataLoss
        {
            set { DeployOptions.BlockOnPossibleDataLoss = !value.IsPresent; }
        }

        [Parameter()]
        public Hashtable Variables
        {
            set
            {
                if (value != null)
                    foreach (var name in value.Keys)
                        DeployOptions.SetVariable(name.ToString(), value[name].ToString());
            }
        }

        [Parameter()]
        public SwitchParameter IgnoreWithNocheckOnForeignKeys
        {
            set { DeployOptions.IgnoreWithNocheckOnForeignKeys = value.IsPresent;  }
        }

        [Parameter()]
        public SwitchParameter IgnoreWithNocheckOnCheckConstraints
        {
            set { DeployOptions.IgnoreWithNocheckOnCheckConstraints  = value.IsPresent;  }
        }

        #region Timeouts

        [Parameter()]
        public int CommandTimeout
        {
            set { DeployOptions.CommandTimeout = value; }
        }

        [Parameter()]
        public int LongRunningCommandTimeout
        {
            set { DeployOptions.LongRunningCommandTimeout = value; }
        }

        [Parameter()]
        public int DatabaseLockTimeout
        {
            set { DeployOptions.DatabaseLockTimeout = value; }
        }

        #endregion
        #region Drop not in source switches

        [Parameter()]
        public SwitchParameter DropConstraintsNotInSource
        {
            set { DeployOptions.DropConstraintsNotInSource = value; }
        }

        [Parameter()]
        public SwitchParameter DropDmlTriggersNotInSource
        {
            set { DeployOptions.DropDmlTriggersNotInSource = value; }
        }

        [Parameter()]
        public SwitchParameter DropExtendedPropertiesNotInSource
        {
            set { DeployOptions.DropExtendedPropertiesNotInSource = value; }
        }

        [Parameter()]
        public SwitchParameter DropIndexesNotInSource
        {
            set { DeployOptions.DropIndexesNotInSource = value; }
        }

        [Parameter()]
        public SwitchParameter DropObjectsNotInSource
        {
            set { DeployOptions.DropObjectsNotInSource = value; }
        }

        [Parameter()]
        public SwitchParameter DropPermissionsNotInSource
        {
            set { DeployOptions.DropPermissionsNotInSource = value; }
        }

        [Parameter()]
        public SwitchParameter DropRoleMembersNotInSource
        {
            set { DeployOptions.DropRoleMembersNotInSource = value; }
        }

        [Parameter()]
        public SwitchParameter DropStatisticsNotInSource
        {
            set { DeployOptions.DropStatisticsNotInSource = value; }
        }

        #endregion
        #endregion

        private readonly DacDeployOptions DeployOptions = new();

        protected override void BeginProcessing()
        {
            BeginProcessing(serviceRequired: true);
        }

        protected override void AsyncProcessRecord()
        {
            WriteVerbose($"Install dacpac '{Package.Name}' v{Package.Version} to [{DatabaseName}]");
            Service.Deploy(package: Package, targetDatabaseName: DatabaseName, upgradeExisting: UpgradeExisting.IsPresent, options: DeployOptions);
        }
    }
}
