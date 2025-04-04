# Домашнее задание к занятию «Организация сети»

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

---
### Решение:   

[main.tf](https://github.com/JulieJool/ter-hw-01/blob/main/src/main.tf)      
[variables.tf](https://github.com/JulieJool/ter-hw-01/blob/main/src/variables.tf)      
[providers.tf](https://github.com/JulieJool/ter-hw-01/blob/main/src/providers.tf)      
[output.tf](https://github.com/JulieJool/ter-hw-01/blob/main/src/output.tf)      


![1](https://github.com/JulieJool/ter-hw-01/blob/main/img/1.png)      
 
![2](https://github.com/JulieJool/ter-hw-01/blob/main/img/2.png)       

Подлючение к vm из подсети public:     
![3](https://github.com/JulieJool/ter-hw-01/blob/main/img/3.png)       

Подлючение к vm из подсети private:    
![4](https://github.com/JulieJool/ter-hw-01/blob/main/img/4.png)       

При выполнении команды `curl ifconfig.me` на vm из подсети private выдается публичный ip nat-инстанса:    
![5](https://github.com/JulieJool/ter-hw-01/blob/main/img/5.png)       

При этом, обратим внимание на вывод команды `ip route show default` на vm из подсети private:    
![6](https://github.com/JulieJool/ter-hw-01/blob/main/img/6.png)          

и на vm из подсети public:      
![7](https://github.com/JulieJool/ter-hw-01/blob/main/img/7.png)      

- 192.168.20.1 — стандартный шлюз private-подсети в Yandex Cloud, 192.168.10.1 — стандартный шлюз public-подсети;     
- nat-инстанс (192.168.10.254) указан в Route Table как next-hop для трафика 0.0.0.0/0.

Yandex Cloud автоматически проксирует трафик через nat-инстанс. В этом выводе 192.168.10.254 не является шлюзом, потому что ***в Yandex Cloud подсети не видят шлюзы других подсетей напрямую.*** В Yandex Cloud шлюз подсети (192.168.20.1) и next-hop из Route Table (192.168.10.254) — это разные сущности, но система автоматически их связывает.      

Механизм работы:      
- Private-vm отправляет трафик на свой шлюз (192.168.20.1);     
- Yandex Cloud смотрит Route Table и перенаправляет трафик в NAT-инстанс;    
- nat-инстанс (192.168.10.254) делает MASQUERADE и выходит в интернет.     


---
### Задание 2. AWS* (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

1. Создать пустую VPC с подсетью 10.10.0.0/16.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 10.10.1.0/24.
 - Разрешить в этой subnet присвоение public IP по-умолчанию.
 - Создать Internet gateway.
 - Добавить в таблицу маршрутизации маршрут, направляющий весь исходящий трафик в Internet gateway.
 - Создать security group с разрешающими правилами на SSH и ICMP. Привязать эту security group на все, создаваемые в этом ДЗ, виртуалки.
 - Создать в этой подсети виртуалку и убедиться, что инстанс имеет публичный IP. Подключиться к ней, убедиться, что есть доступ к интернету.
 - Добавить NAT gateway в public subnet.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 10.10.2.0/24.
 - Создать отдельную таблицу маршрутизации и привязать её к private подсети.
 - Добавить Route, направляющий весь исходящий трафик private сети в NAT.
 - Создать виртуалку в приватной сети.
 - Подключиться к ней по SSH по приватному IP через виртуалку, созданную ранее в публичной подсети, и убедиться, что с виртуалки есть выход в интернет.

Resource Terraform:

1. [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc).
1. [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet).
1. [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway).

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
