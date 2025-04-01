resource "yandex_vpc_network" "vpc_netology" {
  name        = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.subnet_a_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc_netology.id
  v4_cidr_blocks = var.v4_cidr_blocks_a
}

resource "yandex_vpc_subnet" "private" {
  name           = var.subnet_b_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc_netology.id
  v4_cidr_blocks = var.v4_cidr_blocks_b
  route_table_id = yandex_vpc_route_table.route_table.id
}

resource "yandex_compute_instance" "nat_instance" {
  name        = var.nat_instance_name
  platform_id = var.platform_id
  zone        = var.default_zone

  resources {
    cores  = var.nat_instance_cores
    memory = var.nat_instance_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
      size     = var.nat_instance_disk_size
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = var.nat_instance_ip_address
    nat        = var.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_path)}"
  }

}  

resource "yandex_vpc_route_table" "route_table" {
  network_id = yandex_vpc_network.vpc_netology.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_instance_ip_address
  }
}

resource "yandex_compute_instance" "public_vm" {
  name            = var.public_vm_name
  platform_id     = var.public_vm_platform
  resources {
    cores         = var.public_vm_core
    memory        = var.public_vm_memory
    core_fraction = var.public_vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.public_vm_image_id
      size     = var.public_vm_disk_size
    }
  }

  scheduling_policy {
    preemptible = var.scheduling_policy
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_path)}"
  }

}

resource "yandex_compute_instance" "private_vm" {
  name            = var.private_vm_name
  platform_id     = var.private_vm_platform

  resources {
    cores         = var.private_vm_core
    memory        = var.private_vm_memory
    core_fraction = var.private_vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.private_vm_image_id
      size     = var.private_vm_disk_size
    }
  }

  scheduling_policy {
    preemptible = var.scheduling_policy
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }
  
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_path)}"
  }

}
