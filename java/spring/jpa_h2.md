#DB-H2

## Dependency

Add on `pom.xml`

```xml
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>runtime</scope>
</dependency>
```

## Access H2 Console:

Add on `application.properties`

```properties
spring.h2.console.enabled=true
```

Load: http://localhost:8080/h2-console/

| Label        | value              |
| ------------ | ------------------ |
| Driver Class | org.h2.Driver      |
| JDBC URL     | jdbc:h2:mem:testdb |
| User Name    | sa                 |
| Password     |                    |
