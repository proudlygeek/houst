require 'rspec'

class Houst

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

describe 'Houst' do

  let(:houst) { Houst.new }

  context "Core Class" do
    it 'should give a list of available commands' do
      houst.help.should ==
'Usage: houst [action] [optional parameter]
	list: 	lists all hosts
	add: 	adds a new host
	rm: 	removes an host
	help: 	displays this dialog

Additional help can be obtained by using
	houst help [command]
'
    end

    it 'should add a new host' do
      host = { :from => "http://www.example.com", :to => "127.0.0.1" }
      houst.add(host)
      houst.hosts.should == { host[:from] => host[:to] }
    end

    it 'should remove an existing host' do
      houst.hosts =  { "http://www.example.com" => "127.0.0.1" }

      houst.rm("http://www.example.com")
      houst.hosts.should_not include("http://www.example.com")
    end
  end
end
