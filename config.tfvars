vlans = [
  { interface = "bridge", name = "Office", vlan_id = 10 },
  { interface = "bridge", name = "ControlPlane", vlan_id = 20 },
  { interface = "bridge", name = "IaaS-NS", vlan_id = 30 },
  { interface = "bridge", name = "IaaS-EW", vlan_id = 40 },
  { interface = "bridge", name = "HPC", vlan_id = 50 },

]

ip_addresses = [
  { interface = "Office", address = "192.168.3.254/24"},
  { interface = "ControlPlane", address = "10.0.0.254/24" },
  { interface = "IaaS-NS", address = "10.0.1.254/24" },
  { interface = "IaaS-EW", address = "10.0.2.254/24" },
  { interface = "HPC", address = "10.0.3.254/24" },
]

ip_pools = [
  { name = "Office", ranges = ["192.168.3.1-192.168.3.253"] },
]

dhcp_server_networks = [
  { address = "192.168.3.0/24", gateway = "192.168.3.254", dns_server = ["192.168.3.254"]}
]

dhcp_servers = [
  { address_pool = "Office", interface = "Office", name = "Office" },
]

dns_records = [
  { name = "cp-pi4-0.phorge", address = "10.0.0.1", type = "A" },
  { name = "cp-pi4-1.phorge", address = "10.0.0.2", type = "A" },
  { name = "cp-pi4-2.phorge", address = "10.0.0.3", type = "A" },
  { name = "cp-api_server.phorge", address = "10.0.0.4", type = "A" },
  { name = "iaas0.phorge", address = "10.0.1.1", type = "A" },
  { name = "iaas1.phorge", address = "10.0.1.2", type = "A" },
  { name = "iaas2.phorge", address = "10.0.1.3", type = "A" },
  { name = "hpc-gpu.phorge", address = "10.0.3.1", type = "A" },
  { name = "hpc-npu.phorge", address = "10.0.3.2", type = "A" },
]

firewall_rules = [
  { chain = "input", action = "accept", in_interface_list = "!LAN", dst_port = "53", protocol = "tcp", place_before="5" , comment = "tofu;;; Allow TCP DNS from !LAN" },
  { chain = "input", action = "accept", in_interface_list = "!LAN", dst_port = "53", protocol = "udp", place_before="5" , comment = "tofu;;; Allow UDP DNS from !LAN" },
  { chain = "forward", action = "drop", in_interface_list = "!LAN", dst_address = "192.168.1.0/24", place_before="11", comment = "tofu;;; Drop overlay network"}
]

firewall_address_lists = [
  { list = "ControlPlane Nodes", address = "10.0.0.1-10.0.0.3" },
  { list = "ControlPlane LoadBalancer IPs", address = "10.0.0.10-10.0.0.20"},
  { list = "ControlPlane API Server", address = "10.0.0.4"},
  { list = "IaaS Nodes", address = "10.0.1.1-10.0.1.3" },
]

firewall_nat_rules = [
  { chain = "dstnat", action = "dst-nat", protocol = "tcp", dst_port = "80", to_addresses = "10.0.0.10", to_ports = "80", in_interface_list = "WAN", comment = "tofu;;; Redirect HTTP to ControlPlane LB Nginx" },
  { chain = "dstnat", action = "dst-nat", protocol = "tcp", dst_port = "443", to_addresses = "10.0.0.10", to_ports = "443", in_interface_list = "WAN", comment = "tofu;;; Redirect HTTPS to ControlPlane LB Nginx" },
  { chain = "dstnat", action = "dst-nat", protocol = "udp", dst_port = "9", to_addresses = "10.0.3.253", dst_address="10.0.3.0/24", comment = "tofu;;; Allow WoL from other networks to HPC" }, # Requires to manually create a static ARP entry such as: 10.0.3.253 -> ff:ff:ff:ff:ff:ff
]

interface_lists = [ 
  { name = "PCI"},
  # { name = "ControlPlane Nodes" },
  # { name = "IaaS NS" },
  # { name = "IaaS EW" },
  # { name = "HPC Nodes" },
]

interface_list_members = [
  { interface_list = "PCI", interface = "ControlPlane" },
  { interface_list = "PCI", interface = "IaaS-NS" },
  { interface_list = "PCI", interface = "IaaS-EW" },
  { interface_list = "PCI", interface = "HPC" },
]