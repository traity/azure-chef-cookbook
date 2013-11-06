actions :create, :attach, :detach

attribute :size,        :kind_of => Integer
attribute :device,      :kind_of => String
attribute :mount_point, :kind_of => String

def initialize(*args)
  super
  @action = :create
end
