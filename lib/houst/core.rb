module Houst
  class Core
    attr_accessor :hosts

    def initialize
      @commands = [
        { name: "list", description: "lists all hosts" },
        { name: "add",  description: "adds a new host" },
        { name: "rm",   description: "removes an host" },
        { name: "help", description: "displays this dialog" }
      ]
      @hosts = {}
    end

    #
    # Shows the command banner usage.
    #
    def help
      base = ["Usage: houst [action] [optional parameter]"]

      @commands.each do |command|
        base << "\t#{command[:name]}: \t#{command[:description]}"
      end

      base << "\nAdditional help can be obtained by using\n\thoust help [command]\n"

      base.join "\n"
    end

    #
    # Adds an host alias to /etc/hosts.
    #
    def add(params)
      from, to = params[:from], params[:to]
      hosts[from] = to
    end

    #
    # Deletes an host alias from /etc/hosts.
    #
    def rm(hostname)
      hosts.delete hostname
    end
  end
end
