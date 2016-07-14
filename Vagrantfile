SSH_PORT_FILE = File.join(File.dirname(__FILE__), "ssh_port")

# see provision/base.sh
# emergency command > ssh 192.168.33.10 -p 25252 -i FULLPATH/.vagrant/machines/default/virtualbox/private_key -l ububtu
ssh_port = 22   #use 22 at first time
if File.exist?(SSH_PORT_FILE)
  ssh_port = File.read(SSH_PORT_FILE)
end
home_dir="/home/ubuntu"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_url = "ubuntu/xenial64" #https://atlas.hashicorp.com/ubuntu/boxes/xenial64/versions/20160707.0.0/providers/virtualbox.box"

  # config.vm.box = "ubuntu16/base" #Snapshot

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.ssh.guest_port = ssh_port

  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "forwarded_port", guest: ssh_port, host: 2222, id: "ssh"

  # Provider-specific configuration so you can fine-tune various
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    # http://qiita.com/hidekuro/items/385bcc4b9eb43945751d
    # http://vboxmania.net/content/vboxmanage-modifyvm%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89
    vb.memory = "1024"
    vb.cpus = 1
    vb.gui = true
    # http://d.hatena.ne.jp/ytoku/20160502/1462205664
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    vb.customize ["storagectl", :id, "--name", "SCSI Controller", "--hostiocache", "on"]
    # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # vb.customize ["modifyvm", :id,
    #   "--hwvirtex", "on",
    #   "--nestedpaging", "on",
    #   "--largepages", "on",
    #   "--ioapic", "on",
    #   "--pae", "on",
    #   "--paravirtprovider", "kvm",
    # ]

  end

  config.vm.synced_folder "provision/", home_dir + "/provision",type: "nfs" , nfs_udp: false
  config.vm.synced_folder "src/", home_dir + "/src", type: "nfs" , nfs_udp: false ,mount_options: ['actimeo=3']

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "base",           type:"shell",  privileged: false, path: "provision/base.sh"
  #config.vm.provision "security",       type:"shell",  privileged: false, path: "provision/security.sh"

  #docker
  # config.vm.synced_folder "docker/", home_dir + "/docker",type: "nfs"
  # config.vm.provision "docker",         type:"shell",  privileged: false, path: "provision/docker.sh"

  #node
  config.vm.provision "node",         type:"shell",  privileged: false, path: "provision/node.sh"

end

# re-create
# vagrant halt; vagrant destroy; rm -rf .vagrant/; rm ubuntu-xenial-16.04-cloudimg-console.log

# save as a box
# vagrant halt; vagrant package;  vagrant box add --force ubuntu16/base package.box
# vagrant box list
