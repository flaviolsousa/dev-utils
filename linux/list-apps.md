# ListApps

## Summary

- wine
- [Flameshot](#shutter)
- [onedrive-d](#onedrive-d)
- [build-essential](#build-essential)

---

### Flameshot

**Install**

```sh
sudo apt install flameshot
```

Corner Shortcuts

```
/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=flameshot org.flameshot.Flameshot gui
```

---

### PulseAudio Volume Control

**Install**

```sh
sudo apt install pavucontrol
```

**Turn On**

```sh
pactl load-module module-loopback latency_msec=1
```

**Turn Off**

```sh
pactl unload-module module-loopback
```

---

### onedrive-d

**Install**

```
sudo apt install python-pip
pip install --upgrade pip

wget https://github.com/xybu/onedrive-d-old/archive/future.zip -O onedrive-d.zip
./install.sh --reinstall
sudo onedrive-pref
```

**Start**

```
onedrive-d start
```

**/home/{user}/.onedrive/ignore_v2.ini**

```
Anexos
Aplicativos
Arquivos
Documentos
Janaina
Midia
Musica
Organizar
VazamentoLorenzetti
Vídeos
```

---

### build-essential

**Install**

```
sudo apt-get install build-essential
```

### fonts

```
sudo apt install fonts-firacode
```
