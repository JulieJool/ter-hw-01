variable "cloud_id" {
  type        = string
  default     = "b1g9qhatvl2668hcgv5r"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gb7lk95d3ritbm7pen"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "vpc_name" {
  type        = string
  default     = "vpc-netology"
  description = "VPC network & subnet name"
}

variable "subnet_a_name" {
  type = string
  default = "public"
}

variable "subnet_b_name" {
  type = string
  default = "private"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "v4_cidr_blocks_a" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "v4_cidr_blocks_b" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "nat_instance_name" {
    type = string
    default = "nat-instance"
}

variable "platform_id" {
    type = string
    default = "standard-v1"
}

variable "nat_instance_cores" {
  type = number
  default = 2
}

variable "nat_instance_memory" {
  type = number
  default = 2
}

variable "nat_image_id" {
  type = string
  default = "fd80mrhj8fl2oe87o4e1"
}

variable "nat_instance_disk_size" {
  default = 10
}

variable "nat_instance_ip_address" {
  type = string
  default = "192.168.10.254"
}

variable "nat" {
  type        = bool
  default     = true
}

variable "public_vm_name" {
  type = string
  default = "public_vm"
}

variable "public_vm_platform" {
  type = string
  default = "standard-v1"
}

variable "public_vm_core" {
  type = number
  default = 4
}

variable "public_vm_memory" {
  type        = number
  default     = 4
}

variable "public_vm_core_fraction" {
  description = "guaranteed vCPU, for yandex cloud - 20, 50 or 100"
  type        = number
  default     = 20
}

variable "public_vm_disk_size" {
  type        = number
  default     = 20
}

variable "public_vm_image_id" {
  type        = string
  default     = "fd8pfd17g205ujpmpb0a"
}

variable "scheduling_policy" {
  type        = bool
  default     = true
}

variable "private_vm_name" {
  type        = string
  default     = "private-vm"
}

variable "private_vm_platform" {
  type        = string
  default     = "standard-v1"
}

variable "private_vm_core" {
  type        = number
  default     = 4
}

variable "private_vm_memory" {
  type        = number
  default     = 4
}

variable "private_vm_core_fraction" {
  description = "guaranteed vCPU, for yandex cloud - 20, 50 or 100"
  type        = number
  default     = 20
}

variable "private_vm_disk_size" {
  type        = number
  default     = 20
}

variable "private_vm_image_id" {
  type        = string
  default     = "fd8pfd17g205ujpmpb0a"
}

variable "ssh_key_path" {
  default = "~/.ssh/yandex_cloud_key.pub"
  description = "ssh-keygen -t ed25519"
}
