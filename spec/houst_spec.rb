require 'rspec'
require 'houst/core'

class Symlinker

  def initialize
    @config_folder = "#{File.expand_path("~")}/.houst"
  end

  def create_config_folder
    Dir.mkdir @config_folder unless File.exists? @config_folder
  end
end

describe 'Houst' do

  let(:houst) { Houst::Core.new }

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

  context "Symlinker Class" do
    let(:symlinker) { Symlinker.new }

    it "should create a config folder into the current user's home" do
      File.should_receive(:expand_path).exactly(1).times.and_return("/home/johndoe")
      Dir.should_receive(:mkdir).with("/home/johndoe/.houst").exactly(1).times
      symlinker.create_config_folder
    end
  end

end
