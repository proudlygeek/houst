require 'rspec'
require 'houst/core'
require 'houst/symlinker'

describe 'Houst' do

  context "Core Class" do
    let(:houst) { Houst::Core.new }

    it 'should give a list of available commands' do
      houst.help.should ==
      "Usage: houst [action] [optional parameter]
       	list: 	lists all hosts
       	add: 	adds a new host
       	rm: 	removes an host
       	help: 	displays this dialog

      Additional help can be obtained by using
      	houst help [command]
      ".gsub(/^ +/, '')
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
    let(:symlinker) { Houst::Symlinker.new }

    before :each do
      File.should_receive(:expand_path).exactly(1).times.and_return("/home/johndoe")
    end

    it 'should create a config folder into the current user\'s home' do
      Dir.should_receive(:mkdir).with("/home/johndoe/.houst").exactly(1).times
      symlinker.create_config_folder
    end

    it 'should backup the original hosts file into the config folder' do
      FileUtils.should_receive(:cp).with("/etc/hosts", "/home/johndoe/.houst/hosts.orig").exactly(1).times
      symlinker.backup_original_hosts
    end

    it 'should touch a new hosts file into the config folder with the contents of the backupped hosts file' do
      FileUtils.should_receive(:cp).with("/home/johndoe/.houst/hosts.orig", "/home/johndoe/.houst/hosts" ).exactly(1).times
      symlinker.touch_hosts_file
    end

    it 'should symlink the hosts file with /etc/hosts' do
      FileUtils.should_receive(:ln_s).with("/home/johndoe/.houst/hosts", "/etc/hosts", {:force => true}).exactly(1).times
      symlinker.symlink_hosts
    end

    it 'should sync host lines on the hosts file' do
      hosts = {
        '127.0.0.1'         => 'example.com',
        '192.168.10.1'      => 'foobar.com',
        'localhost'         => 'uselesshost.com'
      }

      expected_result = "
          127.0.0.1	example.com
          192.168.10.1	foobar.com
          localhost	uselesshost.com
      ".gsub(/^( |\n)+/, '')

      file_mock = mock()
      file_mock.should_receive(:write).with(expected_result)
      File.should_receive(:open).with("/home/johndoe/.houst/hosts", "w").exactly(1).times.and_return(file_mock)
      symlinker.sync_hosts(hosts)
    end

  end
end
