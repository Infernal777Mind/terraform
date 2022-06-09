terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  token     = "AQAAAAAgzGnHAATuweQ12eQQ3Ez8pL-PxYww7aE"
  cloud_id  = "b1gu6010f56t8p35j3kv"
  folder_id = "b1gmev5moakrt87230is"
  zone      = "ru-central1-a"
}
resource "yandex_compute_instance" "vm-1" {
  name = "node"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd800n45ob5uggkrooi8"
      size     = 15
    }
  }

  network_interface {
    subnet_id  = "e9bpen7ln9abjbcsud2l"
    nat        = true
    ip_address = "10.128.0.10"
  }

  metadata = {
    user-data = "${file("/home/terra/terraform/meta.txt")}"
  }
  provisioner "remote-exec" {
    inline = ["sudo apt install -y ansible"]
    connection {
      type        = "ssh"
      user        = "admin"
      port        = 22
      host        = self.network_interface[0].nat_ip_address
      private_key = file("/home/terra/.ssh/id_rsa")
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -u admin -i clickhouse.yml --list-hosts '${file("/home/terra/terraform/ansible_hosts")}' --private-key '${file("/home/terra/.ssh/id_rsa")}'"
  }
}
resource "yandex_compute_instance" "vm-2" {
  name = "data"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd800n45ob5uggkrooi8"
      size     = 15
    }
  }

  network_interface {
    subnet_id  = "e9bpen7ln9abjbcsud2l"
    nat        = true
    ip_address = "10.128.0.11"
  }

  metadata = {
    user-data = "${file("/home/terra/terraform/meta.txt")}"
  }
  provisioner "remote-exec" {
    inline = ["echo $PATH"]
    connection {
      type        = "ssh"
      user        = "admin"
      port        = 22
      host        = self.network_interface[0].nat_ip_address
      private_key = file("/home/terra/.ssh/id_rsa")
    }
  }
}
resource "yandex_compute_instance" "vm-3" {
  name = "datatwo"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd800n45ob5uggkrooi8"
      size     = 15
    }
  }

  network_interface {
    subnet_id  = "e9bpen7ln9abjbcsud2l"
    nat        = true
    ip_address = "10.128.0.12"
  }

  metadata = {
    user-data = "${file("/home/terra/terraform/meta.txt")}"
  }
  provisioner "remote-exec" {
    inline = ["echo $PATH"]
    connection {
      type        = "ssh"
      user        = "admin"
      port        = 22
      host        = self.network_interface[0].nat_ip_address
      private_key = file("/home/terra/.ssh/id_rsa")
    }
  }
}
