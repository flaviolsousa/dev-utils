## Resize disk

#### Linux

```
vboxmanage modifyhd Win7MT-disk1.vdi --resize 15000
```

#### Windows:

Right click on Computer > Manager > Disk Manager > Extend volume

## Rebuild kernel modules:

```sh
sudo /sbin/vboxconfig
```

## Grant access to the virtual box:

```
sudo groupadd vboxusers
sudo usermod -a -G vboxusers
```

## Install

```sh

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

### Linux Mint 19 ###

echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bionic contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

sudo apt-get update

### Check for last version

sudo apt-get install -y virtualbox-6.1
```

## Bug sudo vboxreload => modprobe: FATAL: Module vboxnetadp not found in directory ...

```sh
sudo vboxreload
mhwd-kernel -li
# Currently running: 6.1.12-1-MANJARO (linux61)    ##### 61 #####
yay -S linux61-virtualbox-host-modules             ##### Must fix de kernel version
sudo vboxreload
```
