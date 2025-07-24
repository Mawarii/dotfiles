# pp Formsflow Docker Config

## Caddy Instructionss

If you want to use the caddy configuration you have to create the external docker volume first.

This is done by executing the following command:

```bash
docker volume create caddy_data
docker network create caddy_proxy
```

Changed:
- main-domain
- postgres PW webapi
- postgres PW
