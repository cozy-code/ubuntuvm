# see provision/base.sh
# emergency command > ssh 192.168.33.10 -p 25252 -i FULLPATH/.vagrant/machines/default/virtualbox/private_key -l ububtu
ssh_port = 25252
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
    vb.memory = "1024"
  end

  config.vm.synced_folder "provision/", home_dir + "/provision",type: "nfs"
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "base",           type:"shell",  privileged: false, path: "provision/base.sh"
  config.vm.provision "docker",         type:"shell",  privileged: false, path: "provision/docker.sh"

  #docker
  config.vm.synced_folder "docker/", home_dir + "/docker",type: "nfs"

end
