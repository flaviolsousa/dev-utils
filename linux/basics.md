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
