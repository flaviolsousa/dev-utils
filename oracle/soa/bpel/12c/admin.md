#### Use Oracle:

```sh
sudo su - oracle
```

#### Fix Permissions:

```sh
chown -R oracle.oracle /u01/middleware/domains/osb_domain
```

#### Admin Restart:

```sh
kill -9 [pid Admin_Server]
cd /u01/middleware/domains/osb_domain/bin
nohup ./startWebLogic.sh &
tail -2000f nohup.out
```

#### NodeManager Restart:

```sh
rm -rf /u01/middleware/oracle_common/common/nodemanager/nodemanager.process.lck
cd /u01/middleware/domains/osb_domain/bin
nohup ./startNodeManager.sh &
tail -2000f OSB_SRV0101.out
```

#### Fix STARTING:

```
rm -rf OSB_SRV0101
```
