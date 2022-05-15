# Synology

```
docker container run --name gmvault --restart always --env GMVAULT_EMAIL_ADDRESS=XXX --mount type=bind,src=/volume1/Data/Backup/gmail-backup/,dst=/data --mount type=bind,src=/volume1/Data/Management/Log,dst=/log capaton/gmvault
```

# Authentication

E-Mail account has 2FA enabled which prevents OAuth tokens from being used for sensitive scopes.  Instead need to use App Passwords.

```
docker container run --rm -it --mount type=bind,source=/volume1/Data/Backup/gmail-backup/,target=/data --entrypoint /bin/bash capaton/gmvault

groupmod -o -g "$GMVAULT_GID" gmvault
usermod -o -u "$GMVAULT_UID" gmvault
chown -R gmvault:gmvault /data

gmvault sync -t quick --store-passwd xxx@gmail.com
```

# Local Testing

```
docker container run --interactive --name gmvault --rm --env GMVAULT_EMAIL_ADDRESS=XXX --mount type=bind,src=/c/_cp/Temp/gmvault,dst=/data --mount type=bind,src=/c/_cp/Temp/log,dst=/log capaton/gmvault
```

docker container run --rm --env TZ=Europe/London --env GMVAULT_EMAIL_ADDRESS=xxx@gmail.com --env MVAULT_FULL_SYNC_SCHEDULE='30 1 * * 0' --env GMVAULT_QUICK_SYNC_SCHEDULE='30 1 * * 1-6' --env GMVAULT_UID=1024 --env GMVAULT_GID=101 --mount type=bind,source=/volume1/Data/Backup/gmail-backup,target=/data --mount type=bind,source=/volume1/Data/Management/Log,target=/log capaton/gmvault

jelfenthznyjyzaa

## https://github.com/guillaumeaubert/gmvault-docker