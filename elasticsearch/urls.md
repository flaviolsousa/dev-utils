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

```
POST /*/_cache/clear

GET /_cluster/pending_tasks

GET /_cat/allocation?v

GET /_cat/health?v
GET /_cluster/health?pretty

GET /_cat/master?v
GET /_cat/recovery?v
GET /_cat/recovery?v&h=i,s,t,ty,st,shost,thost,f,fp,b,bp

GET /_cat/repositories?v
GET /_cat/thread_pool
GET /_cat/thread_pool/generic?v

GET /_cat/shards?v
GET /_cat/shards?v&h=index,shard,prirep,state,unassigned,reason

GET /_snapshot/_status
GET /_nodes/hot_threads
GET /_tasks
GET /_cat/tasks
GET /_nodes/stats
GET /_nodes/stats/_all

// Without access on AWS
POST /_cluster/reroute?retry_failed=true
```

## Reference

### Tunning

- https://aws.amazon.com/blogs/big-data/best-practices-for-configuring-your-amazon-opensearch-service-domain/
- https://aws.amazon.com/blogs/big-data/get-started-with-amazon-opensearch-service-t-shirt-size-your-domain/
