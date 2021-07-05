https://redisdesktop.com/

Install(Mint):
http://docs.redisdesktop.com/en/latest/install/#build-from-source

```sh
cd src/
./configure
source /opt/qt59/bin/qt59-env.sh && qmake && make && sudo make install
cd /usr/share/redis-desktop-manager/bin
sudo mv qt.conf qt.backup
```

Execute (Mint):

```sh
source /opt/qt59/bin/qt59-env.sh && /usr/share/redis-desktop-manager/bin/./rdm
```
