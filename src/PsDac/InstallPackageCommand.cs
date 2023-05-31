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
        public string DatabaseName { get; set; }

        [Parameter()]
        public SwitchParameter UpgradeExisting { get; set; }

        #region deploy options

        [Parameter()]
        public ObjectType[] ExcludeObjectTypes
        {
            get { return DeployOptions.ExcludeObjectTypes; }
            set { DeployOptions.ExcludeObjectTypes = value; }
        }

        [Parameter()]
        public ObjectType[] DoNotDropObjectTypes
        {
            get { return DeployOptions.DoNotDropObjectTypes; }
            set { DeployOptions.DoNotDropObjectTypes = value; }
        }

        [Parameter()]
        public SwitchParameter BlockOnPossibleDataLoss
        {
            get { return DeployOptions.BlockOnPossibleDataLoss; }
            set { DeployOptions.BlockOnPossibleDataLoss = value; }
        }

        [Parameter()]
        public Hashtable Variables {
            set {
                foreach( var name in value.Keys )
                {
                    DeployOptions.SetVariable(name.ToString(), value[name].ToString());
                }
            }
        }

        #region Timeouts

        [Parameter()]
        public int CommandTimeout
        {
            get { return DeployOptions.CommandTimeout; }
            set { DeployOptions.CommandTimeout = value; }
        }

        [Parameter()]
        public int LongRunningCommandTimeout
        {
            get { return DeployOptions.LongRunningCommandTimeout; }
            set { DeployOptions.LongRunningCommandTimeout = value; }
        }

        [Parameter()]
        public int DatabaseLockTimeout
        {
            get { return DeployOptions.DatabaseLockTimeout; }
            set { DeployOptions.DatabaseLockTimeout = value; }
        }

        #endregion
        #region Drop not in source switches

        [Parameter()]
        public SwitchParameter DropConstraintsNotInSource
        {
            get { return DeployOptions.DropConstraintsNotInSource; }
            set { DeployOptions.DropConstraintsNotInSource = value; }
        }
            
        [Parameter()]
        public SwitchParameter DropDmlTriggersNotInSource
        {
            get { return DeployOptions.DropDmlTriggersNotInSource; }
            set { DeployOptions.DropDmlTriggersNotInSource = value; }
        }
            
        [Parameter()]
        public SwitchParameter DropExtendedPropertiesNotInSource
        {
            get { return DeployOptions.DropExtendedPropertiesNotInSource; }
            set { DeployOptions.DropExtendedPropertiesNotInSource = value; }
        }
            
        [Parameter()]
        public SwitchParameter DropIndexesNotInSource
        {
            get { return DeployOptions.DropIndexesNotInSource; }
            set { DeployOptions.DropIndexesNotInSource = value; }
        }
            
        [Parameter()]
        public SwitchParameter DropObjectsNotInSource
        {
            get { return DeployOptions.DropObjectsNotInSource; }
            set { DeployOptions.DropObjectsNotInSource = value; }
        }
            
        [Parameter()]
        public SwitchParameter DropPermissionsNotInSource
        {
            get { return DeployOptions.DropPermissionsNotInSource; }
            set { DeployOptions.DropPermissionsNotInSource = value; }
        }
            
        [Parameter()]
        public SwitchParameter DropRoleMembersNotInSource
        {
            get { return DeployOptions.DropRoleMembersNotInSource; }
            set { DeployOptions.DropRoleMembersNotInSource = value; }
        }
            
        [Parameter()]
        public SwitchParameter DropStatisticsNotInSource
        {
            get { return DeployOptions.DropStatisticsNotInSource; }
            set { DeployOptions.DropStatisticsNotInSource = value; }
        }

        #endregion
        #endregion

        private readonly DacDeployOptions DeployOptions = new();

        protected override void AsyncProcessRecord()
        {
            Service.Deploy(package: Package, targetDatabaseName: DatabaseName, upgradeExisting: UpgradeExisting.IsPresent, options: DeployOptions);
        }
    }
}
