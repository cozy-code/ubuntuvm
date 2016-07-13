LOGFILE = File.join(File.dirname(__FILE__), "ubuntu-xenial-16.04-cloudimg-console.log")

# see provision/base.sh
# emergency command > ssh 192.168.33.10 -p 25252 -i FULLPATH/.vagrant/machines/default/virtualbox/private_key -l ububtu
ssh_port = 22   #use 22 at first time
if File.exist?(LOGFILE)
  ssh_port = 25252
end
home_dir="/home/ubuntu"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_url = "ubuntu/xenial64" #https://atlas.hashicorp.com/ubuntu/boxes/xenial64/versions/20160707.0.0/providers/virtualbox.box"

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
    vb.gui = true
    vb.customize ["storagectl", :id, "--name", "SCSI Controller", "--hostiocache", "on"]
    vb.customize [
      "modifyvm", :id,
      "--hwvirtex", "on",
      "--nestedpaging", "on",
      "--largepages", "on",
      "--ioapic", "on",
      "--pae", "on",
      "--paravirtprovider", "kvm",
    ]
  end

  config.vm.synced_folder "provision/", home_dir + "/provision",type: "nfs"
  config.vm.synced_folder "src/", home_dir + "/src", type: "nfs" , mount_options: ['actimeo=3']

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "base",           type:"shell",  privileged: false, path: "provision/base.sh"

  #docker
  # config.vm.synced_folder "docker/", home_dir + "/docker",type: "nfs"
  # config.vm.provision "docker",         type:"shell",  privileged: false, path: "provision/docker.sh"

  #node
  config.vm.provision "node",         type:"shell",  privileged: false, path: "provision/node.sh"

end
