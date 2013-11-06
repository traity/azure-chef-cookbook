Description
===========
  This cookbook provides libraries, resources and providers to configure and manage Windows Azure components.
  This is a very limited and work in progress version. 
  
  Currently supported resources:

  * VM Disks (`vm_disk`)
  * VM Endpoints (`vm_endpoint`)


Requirements
============
  This cookbook has been tested only with Chef 11.6.0 and is specific for Ubuntu. Cross platform recipes are expected in next versions


Windows Azure credentials
=========================
  In order to manage Windows Azure components, authentication credentials need to be available to the node. 
  The default recipe will install the Azure Cross-Platform Command-Line Interface and most commands require a Windows Azure subscription.

  A data bag called 'azure' with a 'publishsettings' item is required. This item should contain a Windows Azure subscription id,
  a Windows Azure subscription name and the Windows Azure subscription certificate
  
      ➜  bundle exec knife data bag show azure publishsettings --secret-file .chef/data_bag_key -F json
      {
        "id": "publishsettings",
        "subscription_id": "<AZURE_SUBSCRIPTION_ID>",
        "subscription_name": "<AZURE_SUBSCRIPTION_NAME>",
        "subscription_certificate": "<AZURE_SUBSCRIPTION_CERTIFICATE>"
      }

  **Note:** To obtain the certificate run the command `azure account download` in your local machine. More info at <http://www.windowsazure.com/en-us/manage/install-and-configure-cli/>


Recipes
=======

default.rb
----------
The default recipe install the Windows Azure CLI and its dependencies


Resources and Providers
=======================

vm_disk.rb
----------
Manage VM disks

Actions:

  * `create`

Attribute parameters:

  * `size` - size of the new disk(in GB)
  * `device` - device where the new disk will be attached (in next versions it will be set automatically)
  * `mount_point` - directory where the attached device will be mounted

Example:

    azure_vm_disk "mongodb::disk::data" do
      size 900 
      device "sdc"
      mount_point node['mongodb']['dbpath']
    end


vm_endpoint.rb
--------------

Manage VM endpoints

Actions:
  
  * `create`
  * `delete`

Attribute parameters:

  * `lb_port` - private port
  * `vm_port` - public port

Example:

    azure_vm_endpoint "mongodb::endpoint::replicaset" do
      lb_port 27017
      vm_port 27017
    end

