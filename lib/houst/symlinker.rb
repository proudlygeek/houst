module Houst
  class Symlinker

    def initialize
      @config_folder = "#{File.expand_path("~")}/.houst"
      @hosts_file = "#{@config_folder}/hosts"
    end

    def create_config_folder
      Dir.mkdir @config_folder unless File.exists? @config_folder
    end

    def touch_hosts_file
      File.open(@hosts_file, "w") {} unless File.exists? @hosts_file
    end

    def sync_hosts(hosts)
      buffer = []

      hosts.each do |from, to|
       buffer << "#{from}	#{to}\n"
      end

      File.open(@hosts_file, 'w').write(buffer.join)
    end
  end
end
