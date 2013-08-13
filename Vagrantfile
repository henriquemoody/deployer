Vagrant::Config.run do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.boot_mode = :headless

  config.vm.define :deploy1 do |deploy1|
    deploy1.vm.host_name = "deploy1"
    deploy1.vm.network :hostonly, "192.168.100.101"
  end

  config.vm.define :deploy2 do |deploy2|
    deploy2.vm.host_name = "deploy2"
    deploy2.vm.network :hostonly, "192.168.100.102"
  end

end
