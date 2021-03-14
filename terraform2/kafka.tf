
resource "yandex_compute_instance" "kafka" {
  name        = "kafka"
  zone        = "ru-central1-a"
  hostname    = "kafka"
  platform_id = "standard-v2"

  resources {
    cores  = 2
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.internal-a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.privat_key_path)
  }
  
  # remote-exec will wait for ssh up and running, after that local-exec will come into play
  # XXX By default requires SSH agent to be running
  provisioner "remote-exec" {
    inline = ["# Connected!"]
    connection {
      host = self.network_interface.0.nat_ip_address
      user = "ubuntu"
    }
  }

  provisioner "local-exec" {
    working_dir = var.ansible_workdir
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    command = "ansible-playbook -u ubuntu -i '${self.network_interface.0.nat_ip_address},' --private-key ${var.privat_key_path} kafka.yml "
  }
}
