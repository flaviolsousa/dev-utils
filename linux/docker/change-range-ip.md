Create file: /etc/docker/daemon.json

```json
{
  "bip": "192.178.1.5/24",
  "fixed-cidr": "192.178.1.5/25"
}
```

Execute:

```shell
sudo service docker restart
```

_Maybe a restart will be necessary_
