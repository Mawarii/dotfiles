# FMTH Formsflow Docker Config

## Server Folder Structure

The folder structure on the server is based on instances. There is one main instance and four extra instances if needed.

Every instance has its own folder (and hard drive) placed at `/storage/<instance>`. Inside this folder is the configuration and data stored.

If you want to change anything edit the files inside the `FMTH Fowmsflow Docker config` folder.

Currently used:
- /storage/main-instance


## Caddy Instructions

If you want to use the caddy configuration you have to create the external docker volume first.

This is done by executing the following command:

```bash
docker volume create caddy_data
```
