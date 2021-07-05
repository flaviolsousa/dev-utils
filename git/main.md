# Commands

## config proxy on git

```bash
set http_proxy=http://DOMAIN\USER:SENHA@http://PROXY_HOST:8080
set https_proxy=http://DOMAIN\USER:SENHA@http://PROXY_HOST:8080
```

## stage

```
git stash
git pull
git stash pop
```

## git submodule add

```bash
git submodule add ${GIT_URL_SSH} lib/commons

git submodule add ${GIT_URL_SSH} lib/test-api
```

## Clone with submodules

```bash
git clone ${GIT_URL_SSH} --recursive
cd GTW_LAMBDA_LOCATIONS
git checkout develop
git submodule init
git submodule update
git submodule foreach git checkout develop
git submodule foreach git fetch origin/remote/develop
echo foi!
```

## .sh Clone with submodules

```bash
REPO_GIT=$1
REPO_GIT=${REPO_GIT:-GTW_LAMBDA_LIB_COMMONS}

BRANCH_GIT=$2
BRANCH_GIT=${BRANCH_GIT:-develop}

echo
echo REPO_GIT ..... $REPO_GIT
echo BRANCH_GIT ... $BRANCH_GIT
echo

read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	git clone ${GIT_URL_SSH_PREFIX}/$REPO_GIT.git --recursive
	cd $REPO_GIT
	git submodule update --init --recursive
	git checkout $BRANCH_GIT
	git submodule init
	git submodule update
	git submodule foreach git checkout $BRANCH_GIT
fi
```

## Move the Branch cursor back

```sh
Remote:
git push -f origin 888c97db32bae7271d2b2c6dc7a0897911995037:ti

Local:
git reset --hard 888c97db32bae7271d2b2c6dc7a0897911995037
#         ^^^^^^
#         optional
```

