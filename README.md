## Kamal CLoud SQL proxy

## How to use it in Kamal environment


In the project, where you want to use this:

```sh
# add two mandatory environments
echo CLOUD_SQL_CREDENTIALS_BASE64=$(cat /path/to/your/credentials.json | base64) >> .env
echo INSTANCE_CONNECTION_NAME=<instance_connection_string> >> .env

# push envs to the servers
kamal env push
```


### Kamal settings

in `/config/deploy.yml` in the accessories section set: 

```yaml
accessories:
  cloud-sql-proxy:
    image: ghcr.io/tymbe-devops/kamal-cloud-sql-proxy:v1
    roles: 
      - web
    env:
      # Optionally you can set a port
      # clear:
        # PORT=5432
      secret:
        - CLOUD_SQL_CREDENTIALS_BASE64
        - INSTANCE_CONNECTION_NAME
    port: "127.0.0.1:5432:5432"
```
## How to connect from another container

If you want to use this SQL connection from another docker container on the same hosts, you have to use IP address provided by this command where `ty-devops-cloud-sql-proxy` is name of the sql-proxy 

```sh
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ty-devops-cloud-sql-proxy
```

---

### How to build this image for both platforms

```sh
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/tymbe-devops/kamal-cloud-sql-proxy:v1 --push .
```