attribute :lb_port,     :kind_of => Integer
attribute :vm_port,     :kind_of => Integer

def initialize(*args)
  super
  @action = :create
end
