module Azure

  class CommandError < StandardError; end

  def self.command(command)
    command = "azure #{command}"

    IO.popen("#{command} 2>&1") do |io|
      out = io.read
      io.close
      Chef::Log.debug("command #{command}")
      Chef::Log.debug(out)

      raise CommandError.new("error while running `#{command}`:\n #{out}") unless $?.to_i == 0
    end
  end

  module VM
    def self.disk_attach_new(options = {})
      Azure.command("vm disk attach-new #{options[:vm_name]} #{options[:size]} ")
    end

    def self.endpoint_create(options = {})
      Azure.command("vm endpoint create #{options[:vm_name]} #{options[:lb_port]} #{options[:vm_port]}")
    end

    def self.endpoint_delete(options = {})
      Azure.command("vm endpoint delete #{options[:vm_name]} #{options[:vm_port]}")
    end
  end
end
