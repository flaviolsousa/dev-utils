# Run application with prefix (ignore version)

## Create a Script

> drawio-x86_64-17.4.2.AppImage

```sh
#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

cd $BASEDIR

APP_NAME=$(ls -t drawio* | head -1)

echo "$BASEDIR"/$APP_NAME

"$BASEDIR"/$APP_NAME &

read k

```
