# Using Bluetooth Headset (enable HFP profile)

## 1. Install ofono:

```sh
sudo apt install ofono ofono-phonesim
sudo usermod -aG bluetooth pulse
```

## 2. Config pulseaudio to use ofono:

2.1. Goto file `/etc/pulse/default.pa` find the line:

```
load-module module-bluetooth-discover
```

and change it to:

```
load-module module-bluetooth-discover headset=ofono
```

2.2. Goto file `/etc/dbus-1/system.d/ofono.conf` and add before `</busconfig>`:

```xml
  <policy user="pulse">
    <allow send_destination="org.ofono"/>
  </policy>
```

2.3. Configure phonesim. Goto file `/etc/ofono/phonesim.conf` and add:

```
[phonesim]
Driver=phonesim
Address=127.0.0.1
Port=12345
```

2.4. :

```
cd ${YOUR_APPS_DIRECTORY}

git clone git://git.kernel.org/pub/scm/network/ofono/ofono.git
cd ofono/test
./list-modems
```

---

# Now you can test:

```
ofono-phonesim -p 12345 /usr/share/phonesim/default.xml &
./enable-modem
./online-modem
```

---

# REFERENCES:

- https://zambrovski.medium.com/using-bluetooth-headset-on-ubuntu-790ce6eecc2
- https://github.com/foxylion-playground/ubuntu-bluetooth-hsp-hfp
- http://alisabzevari.github.io/2020/05/17/2020-05-17-galaxy-earbuds-ubuntu/
- https://zoomadmin.com/HowToInstall/UbuntuPackage/ofono-phonesim-autostart
