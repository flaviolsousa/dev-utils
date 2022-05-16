# jabba

## Readme

https://github.com/shyiko/jabba

## Util

```sh
jabba ls-remote
jabba ls-remote zulu@~1.8.60
jabba ls-remote "*@>=1.6.45 <1.9" --latest=minor

jabba install 1.15.0
jabba install adopt-openj9@1.8  
jabba install openjdk@1.10-0

jabba uninstall zulu@1.6.77

jabba ls

echo "1.8" > .jabbarc
jabba use

# set default java version
jabba alias default 1.8
```