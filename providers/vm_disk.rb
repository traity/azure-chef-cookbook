def whyrun_supported?
  true
end

action :create do
  device  = "/dev/#{new_resource.device}"
  vm_name = node['azure']['vm_name']

  if device_mounted?(device)
    Chef::Log.warn("Disk already created and mounted #{new_resource.device}")
  else
    Azure::VM.disk_attach_new(size: new_resource.size,
                              vm_name: vm_name)


    ruby_block "wait_#{new_resource.name}" do
      retries 5
      block do
        sleep 2
        Chef::Log.info("Checking #{device} was attached. Wait and retry if not")
        raise "Device #{device} couldn't be attahed" unless ::File.exist?(device)
      end
    end

    system("mkfs.ext4 -F #{device}")

    mount_disk(device, new_resource.mount_point)
    node.set['azure']['disk'][new_resource.device] = { ok: true }
    node.save
  end
end

def device_mounted?(device)
  system("grep -q '^#{device} .*$' /proc/mounts")
end

def mount_disk(device, mount_point)
  directory mount_point do
    owner "root"
    group "root"
    mode 0755
    action    :create
    recursive true
    not_if "test -d #{mount_point}"
  end
  system("mount #{device} #{mount_point}")
end
