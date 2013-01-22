require "houst/utils"

module Houst
  class Symlinker
    include Utils

    def initialize
      @original_hosts = "/etc/hosts"
      @config_folder = "#{File.expand_path("~")}/.houst"
      @hosts_file = "#{@config_folder}/hosts"
    end

    def create_config_folder
      Dir.mkdir @config_folder unless File.exists? @config_folder
    end

    def touch_hosts_file
      FileUtils.cp "#{@hosts_file}.orig", @hosts_file
    end

    def sync_hosts(hosts)
      File.open(@hosts_file, 'w').write(format(hosts))
    end

    def backup_original_hosts
      FileUtils.cp @original_hosts, "#{@config_folder}/hosts.orig"
    end

    def symlink_hosts
      FileUtils.ln_s @hosts_file, @original_hosts, :force => true
    end

  end
end
