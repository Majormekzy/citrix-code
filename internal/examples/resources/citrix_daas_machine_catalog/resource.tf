resource "citrix_daas_machine_catalog" "example-azure-mtsession" {
	name                		= "example-azure-mtsession"
	description					= "Example multi-session catalog on Azure hypervisor"
	zone						= "<zone Id>"
	allocation_type				= "Random"
	session_support				= "MultiSession"
	is_power_managed			= true
	is_remote_pc 			  	= false
	provisioning_type 			= "MCS"
	provisioning_scheme			= 	{
		hypervisor = citrix_daas_azure_hypervisor.example-azure-hypervisor.id
		hypervisor_resource_pool = citrix_daas_hypervisor_resource_pool.example-azure-hypervisor-resource-pool.id
		identity_type      = "ActiveDirectory"
		machine_domain_identity = {
            domain                   = "<DomainFQDN>"
			domain_ou				 = "<DomainOU>"
            service_account          = "<Admin Username>"
            service_account_password = "<Admin Password>"
        }
		azure_machine_config = {
			storage_type = "Standard_LRS"
			use_managed_disks = true
            service_offering = "Standard_D2_v2"
            resource_group = "<Azure resource group name for image vhd>"
            storage_account = "<Azure storage account name for image vhd>"
            container = "<Azure storage container for image vhd>"
            master_image = "<Image vhd blob name>"
			writeback_cache = {
				wbc_disk_storage_type = "pd-standard"
				persist_wbc = true
				persist_os_disk = true
				persist_vm = true
				writeback_cache_disk_size_gb = 127
				storage_cost_saving = true
			}
        }
		network_mapping = {
            network_device = "0"
            network = "<Azure Subnet for machine>"
        }
		availability_zones = "1,2,..."
		number_of_total_machines = 	1
		machine_account_creation_rules ={
			naming_scheme =     "az-multi-##"
			naming_scheme_type ="Numeric"
		}
	}
}

resource "citrix_daas_machine_catalog" "example-gcp-mtsession" {
    name                        = "example-gcp-mtsession"
    description                 = "Example multi-session catalog on GCP hypervisor"
   	zone						= "<zone Id>"
	allocation_type				= "Random"
	session_support				= "MultiSession"
	is_power_managed			= true
	is_remote_pc 			  	= false
	provisioning_type 			= "MCS"
    provisioning_scheme         = {
		hypervisor = citrix_daas_gcp_hypervisor.example-gcp-hypervisor.id
		hypervisor_resource_pool = citrix_daas_hypervisor_resource_pool.example-gcp-hypervisor-resource-pool.id
		identity_type      = "ActiveDirectory"
		machine_domain_identity = {
            domain                   = "<DomainFQDN>"
			domain_ou				 = "<DomainOU>"
            service_account          = "<Admin Username>"
            service_account_password = "<Admin Password>"
        }
        gcp_machine_config = {
            
            machine_profile = "<Machine profile template VM name>"
            master_image = "<Image template VM name>"
            machine_snapshot = "<Image template VM snapshot name>"
			storage_type = "pd-standard"
			writeback_cache = {
				wbc_disk_storage_type = "pd-standard"
				persist_wbc = true
				persist_os_disk = true
				writeback_cache_disk_size_gb = 127
			}
        }
		availability_zones = "{project name}:{region}:{availability zone1},{project name}:{region}:{availability zone2},..."
        number_of_total_machines = 1
        machine_account_creation_rules = {
            naming_scheme = "gcp-multi-##"
            naming_scheme_type = "Numeric"
        }
    }
}

resource "citrix_daas_machine_catalog" "example-manual-power-managed-mtsession" {
	name                		= "example-manual-power-managed-mtsession"
	description					= "Example manual power managed multi-session catalog"
	zone						= "<zone Id>"
	allocation_type				= "Random"
	session_support				= "MultiSession"
	is_power_managed			= true
	is_remote_pc 			  	= false
	provisioning_type 			= "Manual"
	machine_accounts = [
        {
            hypervisor = citrix_daas_azure_hypervisor.example-azure-hypervisor.id
            machines = [
                {
                    region = "East US"
                    resource_group_name = "machine-resource-group-name"
                    machine_name = "Domain\\MachineName"
                }
            ]
        }
    ]
}

resource "citrix_daas_machine_catalog" "example-manual-non-power-managed-mtsession" {
	name                		= "example-manual-non-power-managed-mtsession"
	description					= "Example manual non power managed multi-session catalog"
	zone						= "<zone Id>"
	allocation_type				= "Random"
	session_support				= "MultiSession"
	is_power_managed			= false
	is_remote_pc 			  	= false
	provisioning_type 			= "Manual"
	machine_accounts = [
        {
            machines = [
                {
                    machine_name = "Domain\\MachineName1"
                },
				{
                    machine_name = "Domain\\MachineName2"
                }
            ]
        }
    ]
}

resource "citrix_daas_machine_catalog" "example-remote-pc" {
	name                		= "example-remote-pc-catalog"
	description					= "Example Remote PC catalog"
	zone						= "<zone Id>"
	allocation_type				= "Static"
	session_support				= "SingleSession"
	is_power_managed			= false
	is_remote_pc 			  	= true
	provisioning_type 			= "Manual"
	machine_accounts = [
        {
            machines = [
                {
                    machine_name = "Domain\\MachineName1"
                },
				{
                    machine_name = "Domain\\MachineName2"
                }
            ]
        }
    ]
	remote_pc_ous = [
        {
            include_subfolders = false
            ou_name = "OU=Example OU,DC=domain,DC=com"
        }
    ]
}