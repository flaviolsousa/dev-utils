# WsImport

```sh
echo "
Need java 1.8
So use jabba
https://github.com/shyiko/jabba

======

"

jabba use adopt-openj9@1.8.0-252

wsimport -keep -verbose -Xdebug -Xnocompile src/main/resources/model/service.wsdl -d src/main/java
```