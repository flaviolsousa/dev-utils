# Processador de Pedido

## Install
[Oracle SOA Suite 12.2.1 QuickStart Download](http://www.oracle.com/technetwork/middleware/soasuite/downloads/soasuite1221-quickstartdownload-3050431.html)

#### Set $ORACLE_HOME:

Linux mint:

```bash
sudo xed ~/.bashrc
```
add:
```
export ORACLE_HOME=$HOME/Oracle/Oracle12c/osb
```

#### Create domain:


```bash
cd $ORACLE_HOME/oracle_common/common/bin

export QS_TEMPLATES="$ORACLE_HOME/soa/common/templates/wls/oracle.soa_template.jar, $ORACLE_HOME/osb/common/templates/wls/oracle.osb_template.jar"

./qs_config.sh

```

Adicionar o servidor como `JBpelStandaloneWebLogicServer` no ApplicationServers do JDEV

**Windows Configuration:**

Add on `setDomainEnv.cmd`

```bash
set JAVA_OPTIONS=%JAVA_OPTIONS% -Dfile.encoding=utf8
```

#### Criar MSDs
**localGtwDefinitions:**

> Resources > New SOA-MDS Connection > File Based MDS > MDS Root Folder: **%PATH%/GTW_DEFINITIONS**

**oramds:**

> Resources > New SOA-MDS Connection > File Based MDS > MDS Root Folder: **$ORACLE_NOME/user_projects/domains/base_domain/store/gmds/mds-soa/soa-infra**

**Linux Require:**

Add on begin of file `$ORACLE_HOME/Oracle12c/osb/jdeveloper/jdev/bin/jdev.sh`:

```bash
export MDS_PATH=$HOME/Documents/git/GTW_DEFINITIONS
```
