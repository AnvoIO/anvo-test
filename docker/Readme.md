# Build Snapshot:

```
$ make build_snapshots

$ make create_snapshots

# wait until all snapshots are created with following logs:
$ docker logs qsnapshot
{
   "head_block_id" : "...",
   "head_block_num" : 16,
   "head_block_time" : "...",
   "snapshot_name" : "/app/snapshot-node/./logs/ANVO/data/snapshots/snapshot-....bin",
   "version" : 7
}

$ make copy_snapshots
```

# Build and run docker image:

```
$ make build
$ make start

CONTAINER ID   IMAGE               COMMAND             CREATED          STATUS                    PORTS                                       NAMES
70c42a58f632   anvo-test:latest    "./entrypoint.sh"   12 seconds ago   Up 11 seconds (healthy)   0.0.0.0:8888->8888/tcp, :::8888->8888/tcp   anvotest

```

# Interact with docker:

## Start docker
Note: SYSTEM_TOKEN_SYMBOL can be ANVO (additional chains can be added)
```
docker run --name anvotest --env SYSTEM_TOKEN_SYMBOL="ANVO" -d -p 8888:8888 ghcr.io/anvo-network/anvo-test:latest
```

## Time manipulation:
```
$ docker exec anvotest core-cli get info
{
  ...
  "head_block_time": "2026-03-16T02:02:47.000",
  ...
}

# manipulate time
docker exec anvotest /app/scripts/manipulate_time.sh "+15d"

$ docker exec anvotest core-cli get info
{
  ...
  "head_block_time": "2026-03-31T02:03:24.500",
  ...
}
```

# Testing key:
```
ENV ANVO_PUB_KEY=EOS5dUsCQCAyHVjnqr6BFqVEE7w8XksnkRtz22wd9eFrSq4NHoKEH
ENV ANVO_PRV_KEY=5JKxAqBoQuAYSh6YMcjxcougPpt1pi9L4PyJHwEQuZgYYgkWpjS
```

# Adding a new chain

1. Create `docker/scripts/deploy_system_contract_{chain}.sh`
2. Add contract artifacts to `docker/contracts/{chain}/`
3. Add snapshot directory `docker/node/logs/{CHAIN}/data/snapshots/`
4. Update `docker/create_snapshot.sh` with the new chain dispatch
5. Register the chain in `src/chain.ts`
