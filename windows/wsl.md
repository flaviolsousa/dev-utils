# Windows Subsystem Linux

## Cisco Config

https://gist.github.com/balmeida-nokia/122adf625c11c916902950e3255bd104
https://gist.github.com/machuu/7663aa653828d81efbc2aaad6e3b1431

```sh
Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match "Cisco AnyConnect"} | Set-NetIPInterface -InterfaceMetric 6000
(Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-DnsClientServerAddress).ServerAddresses
```

### /etc/wsl.conf

```sh
[network]
generateResolvConf = false
```

### cat /etc/resolv.conf

```sh
[network]
generateResolvConf = false
```
