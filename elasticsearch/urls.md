# Util

## Threads

```
https://${host}/_cat/thread_pool/search?v&h=node_name,name,active,rejected,completed
```

## Health

```
https://${host}/_cat/health?v

```

## Disks

```
https://${host}/_cat/allocation?v

```

## Clear Cache

```sh
curl --location --request POST 'https://${host}/*/_cache/clear'
```
