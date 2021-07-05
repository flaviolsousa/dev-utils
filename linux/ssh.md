# ssh-copy-id

```sh
ssh-keygen

ssh-copy-id -i ~/.ssh/id_rsa.pub flavio.sousa@{{HOST_FTP}}

ssh flavio.sousa@{{HOST_FTP}}
```

# Shell to execute with a pem key

```sh
#! /bin/bash

echo "########### connecting to server and run commands in sequence ###########"
ssh -i ~/.ssh/ec2_instance.pem ubuntu@ip_address 'touch a.txt; touch b.txt; sudo systemctl status tomcat.service'
```
