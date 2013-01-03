require 'rspec'
require 'houst/core'

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
end
