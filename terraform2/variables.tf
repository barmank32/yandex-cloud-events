variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable subnet_id {
  description = "Subnet"
}
variable service_account_key_file {
  description = "key.json"
}
variable privat_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

#  Variables
variable "ansible_workdir" {
  type = string
  description = "Path to Ansible workdir where provisioner tasks are located (i.e. ../ansible)"
}
