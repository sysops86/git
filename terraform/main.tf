variable "one_endpoint" {}
variable "one_username" {}
variable "one_password" {}
variable "one_flow_endpoint" {}
 
terraform {
  required_providers {
    opennebula = {
      source = "OpenNebula/opennebula"
      version = "0.4.3"
    }
  }
}

data "opennebula_template" "alseImage" {
    name = "ALSE 1.7.1 MG 6.5.0" # Значение было получено на предыдущих шагах, его надо изменить
}
 
data "opennebula_virtual_network" "astra-all3124" {
   name = "astra-all3124" # Значение было получено на предыдущих шагах, его надо изменить
}
 
locals {
    # Диск шаблона не заполняется в атрибуте disk, вместо этого он остаётся в шаблоне template
    template_first_disk_name = regex("IMAGE=\"([^\\\"]+)", regex("DISK=\\[([^\\]]+)", data.opennebula_template.alseImage.template)[0])[0]
}
 
# Обход ограничения в работе провайдера: диск шаблона не заполняется в атрибуте disk, вместо этого он остаётся в шаблоне template откуда мы его и забираем
data "opennebula_image" "alseImageFromTemplate" {
  name = local.template_first_disk_name
}
 
resource "opennebula_virtual_machine" "demo" {
    name        = "tftestak"  # Значение должно быть уникальным в рамках системы, его необходимо поменять
    description = "this is a test VM astra consulting" # Можно поменять либо удалить, оно будет этображаться в специальном теге DESCRIPTION
    cpu         = 1 # Изменить по необходимости: Доля от физического ядра, на которую может расчитывать ВМ, принимает значение в диапазоне 0 < x <= 1
    vcpu        = 2 # Изменить по необходимости: Количество виртуальных процессоров
    memory      = 2048 # Изменить по необходимости: размер оперативной памяти для ВМ в байтах
    group       = "astra-consulting" # Значение было получено на предыдущих шагах, его надо изменить
    permissions = "744" # Изменить по необходимости Права на создаваемую ВМ в UNIX формате, где права 1 - Администрирование ВМ(обычные пользователи не могут его применять), 2 - Права на управление ВМ, 4 - Право на использование ВМ.
    template_id = data.opennebula_template.alseImage.id
 
    disk {
        # Диск шаблона не заполняется в атрибуте disk, вместо этого он остаётся в шаблоне template
        image_id =  data.opennebula_image.alseImageFromTemplate.id
        size     = 18000 # Изменить по необходимости: Размер жесткого диска в мегабайтах
        driver   = "qcow2" # Изменять не требуется. Формат хранения используемый хостом виртуализации для диска, может быть qcow2 и raw
    }
 
    sched_ds_requirements = "NAME=ceph_system_ssd" # Значение было получено на предыдущих шагах, его можно изменить 
 
    nic {
        model           = "virtio" # Используемый драйвер сетевой карты, следует использовать другой только в случае если нет никакой возможности использовать паравиртуализированные драйвера.
        network_id      = data.opennebula_virtual_network.astra160.id
        security_groups = [] # Изменить по необходимости, но для базовых случаев изменять не нужно, доступные группы безопасности можно посмотреть в пользовательском интерфейсе Сеть — Группы безопасности
    }
}
