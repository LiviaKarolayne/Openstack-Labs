# 😾 OpenStack 2024.1 Installation (Caracal)

This lab documents the installation of OpenStack 2024.1 using **Kolla Ansible** in an **All-in-One** environment.

## 🖥️ Environment Used

The lab was executed on a virtual machine with the following configuration:

- **Operating System:** Ubuntu Server 24.04 (clean install)
- **CPU:** 8 vCPUs
- **RAM:** 16 GB
- **Disk:** 40 GB
- **Access:** User with `sudo` privileges
- **Network:**

  - `enp0s3` – External interface via DHCP (public NAT network)
  - `enp0s8` – Management interface with static IP (internal Bridge network)

## ⚙️ Installation Steps

### 1. Updates and Dependencies

```bash
sudo apt update && sudo apt upgrade -y

sudo apt install -y git python3-dev libffi-dev gcc libssl-dev python3-venv
```

### 2. Network Configuration

#### 2.1 Define the Netplan file

```bash
cat <<EOF > /etc/netplan/<netpan-file>
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      addresses:
        - 192.168.0.6/24
      gateway4: 192.168.0.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
EOF
```

#### 2.2 Apply the network settings

```bash
sudo netplan try

sudo netplan apply
```

### 3. Kolla Ansible Installation

#### 3.1 Create Python virtual environment

```bash
sudo apt install python3-venv

python3 -m venv venv

source venv/bin/activate

pip install -U pip
```

#### 3.2 Install Ansible and Kolla Ansible

```bash
pip install 'ansible-core>=2.15,<2.16.99'

pip install git+https://opendev.org/openstack/kolla-ansible@stable/2024.1
```

### 4. Environment Preparation

#### 4.1 Create directories and copy config files

```bash
sudo mkdir -p /etc/kolla
sudo chown $USER:$USER /etc/kolla

cp -r venv/share/kolla-ansible/etc_examples/kolla/* /etc/kolla

cp venv/share/kolla-ansible/ansible/inventory/all-in-one /etc/kolla
```

### 5. globals.yml Configuration

The following settings were applied to the `/etc/kolla/globals.yml` file:

```yaml
workaround_ansible_issue_8743: yes
kolla_base_distro: 'ubuntu'
openstack_release: '2024.1'
kolla_internal_vip_address: '192.168.0.6'
network_interface: 'enp0s8'
neutron_external_interface: 'enp0s3'
neutron_plugin_agent: 'ovn'
enable_openstack_core: 'yes'
enable_glance: '{{ enable_openstack_core | bool }}'
enable_haproxy: 'no'
enable_keystone: '{{ enable_openstack_core | bool }}'
enable_mariadb: 'yes'
enable_memcached: 'yes'
enable_neutron: '{{ enable_openstack_core | bool }}'
enable_nova: '{{ enable_openstack_core | bool }}'
enable_rabbitmq: "{{ 'yes' if om_rpc_transport == 'rabbit' or om_notify_transport == 'rabbit' else 'no' }}"
enable_cinder: 'no'
enable_cinder_backup: 'no'
enable_fluentd: 'no'
enable_horizon: '{{ enable_openstack_core | bool }}'
nova_compute_virt_type: 'qemu'
nova_console: 'novnc'
```

### 6. OpenStack Deployment

```bash
cd /etc/kolla

kolla-ansible install-deps
kolla-genpwd

kolla-ansible -i ./all-in-one bootstrap-servers

kolla-ansible -i ./all-in-one prechecks

kolla-ansible -i ./all-in-one deploy
```

## ✅ Installation Test

After deployment, follow these steps to validate the environment:

### 1. Check Running Containers

Ensure all Kolla containers are running correctly:

```bash
sudo docker ps
```

Look for essential containers such as Keystone, Glance, Nova, Neutron, Horizon, and RabbitMQ:

![Containers do Openstack](../img/caracal_containers.png)

### 2. Access the Horizon Interface

In your browser, go to the address configured as `kolla_internal_vip_address` (192.168.0.6):

![Openstack Horizon](../img/o7k_horizon.png)

### 📚 References

- [Kolla Ansible Quickstart 2024.1](https://docs.openstack.org/kolla-ansible/2024.1/user/quickstart.html)
- [Official OpenStack Documentation](https://docs.openstack.org/2024.1/index.html)
