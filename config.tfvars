vlans = [
  { interface = "bridge", name = "Office", vlan_id = 10 },
  { interface = "bridge", name = "ControlPlane", vlan_id = 20 }
]

ip_addresses = [
  { interface = "Office", address = "192.168.3.254/24"},
  { interface = "ControlPlane", address = "10.0.0.254/24" },
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
]