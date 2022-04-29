### Login error

```
ctrl+alt+f1
```

### Finding largest file recursively in directory

```sh
du -a /usr/share/kibana/ | sort -n -r | head -n 20
```

### Size of folders

```sh
du -cks * | sort -rn | head
```

### Available disk

```sh
df -h /home
df -h /
```

### Remover message logs

```sh
sudo rm /var/log/messages-*
```

## Expurgo logs journalctl

```sh
sudo journalctl --vacuum-time=2d
```
