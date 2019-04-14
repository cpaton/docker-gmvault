# Synology

```
docker container run --name gmvault --restart always --env GMVAULT_EMAIL_ADDRESS=XXX --mount type=bind,src=/volume1/Data/Backup/gmail,dst=/data --mount type=bind,src=/volume1/Data/Management/Log,dst=/log capaton/gmvault
```

# Local Testing

```
docker container run --interactive --name gmvault --rm --env GMVAULT_EMAIL_ADDRESS=XXX --mount type=bind,src=/c/_cp/Temp/gmvault,dst=/data --mount type=bind,src=/c/_cp/Temp/log,dst=/log capaton/gmvault
```