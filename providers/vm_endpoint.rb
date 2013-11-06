def whyrun_supported?
  true
end

action :create do
  lb_port = new_resource.lb_port
  vm_port = new_resource.vm_port
  vm_name = node['azure']['vm_name']

  if node['azure']['endpoint'][lb_port.to_s]
    Chef::Log.debug("Port #{lb_port} already forwared to #{node['azure']['endpoint'][lb_port]}")
  else
    Azure::VM.endpoint_create(vm_name: vm_name,
                              lb_port: lb_port,
                              vm_port: vm_port)

    node.set['azure']['endpoint'][new_resource.lb_port] = new_resource.vm_port
    node.save
  end
end

action :delete do
  vm_name = node['azure']['vm_name']
  vm_port = new_resource.vm_port

  Azure::VM.endpoint_delete(vm_name: vm_name,
                            vm_port: vm_port)

  node['azure']['endpoint'].delete(new_resource.vm_port)
  node.save
end
