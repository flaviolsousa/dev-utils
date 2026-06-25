# Home Assistant

## Oracle VirtualBox

### Minimum Requirements

- CPU: 2 cores minimum, 4 cores recommended
- RAM: 2 GB minimum
- Disk: [VirtualBox (Intel chip) (.vdi)](https://www.home-assistant.io/installation/)

### Virtual Machine Settings

- Type: Linux
- SO: Others Linux
- Base Memory: 2024 MB or higher
- Enable EFI: enabled
- Network Adapter: Adapter 1 enabled, attached to Bridge Adapter
- Promiscuous Mode: Allow All (optional but can help network discovery)

### Access:

http://homeassistant.local:8123/

### Commands

```sh
ha host shutdown
ha network info

ip -4 addr show
nmcli device status
nmcli connection show
ip -br addr
ip route


# Para resolver o modo bridge no VirtualBox
ha network update enp0s3 --ipv4-method static --ipv4-address 192.168.0.200/24 --ipv4-gateway 192.168.0.1 --ipv4-nameserver 8.8.8.8

# Tentativa 2
ha network update enp0s3 --ipv4-method static --ipv4-address 192.168.0.200/24 --ipv4-gateway 192.168.0.1 --ipv4-nameserver 8.8.8.8 --ipv4-nameserver 1.1.1.1


```

## Git Bash + Virtual Box (auto type)

```sh
VBoxManage="/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"

# "$VBoxManage" list runningvms
#    "HomeAssistantOS" {8870bf17...}
# VM="$("$VBoxManage" list runningvms | sed -n 's/^"\(.*\)".*/\1/p' | head -n 1)"
VM="HomeAssistantOS"

echo "VM selecionada: $VM"

press_enter() {
  "$VBoxManage" controlvm "$VM" keyboardputscancode 1c 9c
  sleep 0.5
}

press_ctrl_c() {
  "$VBoxManage" controlvm "$VM" keyboardputscancode 1d 2e ae 9d
  sleep 1
}

send() {
  echo ">>> $1"
  "$VBoxManage" controlvm "$VM" keyboardputstring "$1"
  press_enter
  sleep 0.8
}

# Stop last command
press_ctrl_c

"$VBoxManage" controlvm "$VM" nic1 nat
"$VBoxManage" controlvm "$VM" setlinkstate1 on
"$VBoxManage" controlvm "$VM" natpf1 delete "haweb" 2>/dev/null || true
"$VBoxManage" controlvm "$VM" natpf1 "haweb,tcp,,8123,,8123"


send 'nmcli connection modify "Supervisor enp0s3" ipv4.method auto ipv4.gateway "" ipv4.addresses "" ipv4.dns "" ipv4.ignore-auto-dns no connection.autoconnect yes'
send 'nmcli connection down "Supervisor enp0s3"'
send 'nmcli connection up "Supervisor enp0s3"'
send 'ip -4 addr show enp0s3'
send 'ip route'
send 'ping -4 -n -W 2 -c 4 10.0.2.2; echo "nat-gateway rc=$?"'
send 'ping -4 -n -W 2 -c 4 1.1.1.1; echo "internet rc=$?"'
send 'sync'
send 'reboot'
```

### Solução 2 (worked 2024-06-24)

```sh
VBoxManage="/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"

# "$VBoxManage" list runningvms
#    "HomeAssistantOS" {8870bf17...}
# VM="$("$VBoxManage" list runningvms | sed -n 's/^"\(.*\)".*/\1/p' | head -n 1)"
VM="HomeAssistantOS"

echo "VM selecionada: $VM"

press_enter() {
  "$VBoxManage" controlvm "$VM" keyboardputscancode 1c 9c
  sleep 0.5
}

send() {
  echo ">>> $1"
  "$VBoxManage" controlvm "$VM" keyboardputstring "$1"
  press_enter
  sleep 0.8
}

# Configure Board 1 to NAT
"$VBoxManage" modifyvm "$VM" --nic1 nat

# Force VirtualBox NAT to use DNS Windows DNS Resolver
"$VBoxManage" modifyvm "$VM" --natdnshostresolver1 on

# Create redirection of port 8123
"$VBoxManage" modifyvm "$VM" --natpf1 delete "Home Assistant" 2>/dev/null || true
"$VBoxManage" modifyvm "$VM" --natpf1 "Home Assistant,tcp,,8123,,8123"


## REQUIRED: check the interface name
## ha network info
## e.g. enp0s3 or enp0s17


send 'network update enp0s17 --ipv4-method auto'
send 'network reload'
```
