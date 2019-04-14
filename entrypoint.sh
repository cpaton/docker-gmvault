#!/bin/bash

# Make sure the home directory exists
if [ ! -d /data/home ]
then
    mkdir /data/home
fi
chmod u=rw,g=r,o= /data/home

# Create the gmvault user with the expected user id
if [ "$(id -g gmvault)" != "$GMVAULT_GID" ]
then
  echo "changing gmvault group id to $GMVAULT_GID"
  groupmod -o -g "$GMVAULT_GID" gmvault
fi

# Create the gmvault group with the expected group id
if [ "$(id -u gmvault)" != "$GMVAULT_UID" ]
then
  echo "changing gmvault user id to $GMVAULT_UID"
  usermod -o -u "$GMVAULT_UID" gmvault
fi
id gmvault

echo "Date: `date`."

chown -R gmvault:gmvault /data
chown -R gmvault:gmvault /data/home

# Set up crontab.
echo "" > $CRONTAB
echo "${GMVAULT_FULL_SYNC_SCHEDULE} '/app/BackupGmail.sh' 'full'" >> $CRONTAB
echo "${GMVAULT_QUICK_SYNC_SCHEDULE} '/app/BackupGmail.sh' 'quick'" >> $CRONTAB

OAUTH_TOKEN="/data/home/.gmvault/${GMVAULT_EMAIL_ADDRESS}.oauth2"
if [ -f $OAUTH_TOKEN ]
then
    /app/BackupGmail.sh quick
    if [ $? != 0 ]
    then
      echo "Initial backup failed"
      exit 1
    fi

    echo "Using scheduled tasks"
    crond -f
fi

echo "#############################"
echo "#   OAUTH SETUP REQUIRED!   #"
echo "#############################"
echo ""
echo "No Gmail OAuth token found at $OAUTH_TOKEN."
echo "Please set it up with the following instructions:"
echo "  1/ Attach a terminal to your container."
echo "  2/ Run this command:"
echo "     su --command 'gmvault check --renew-oauth2-tok --db-dir /data $GMVAULT_EMAIL_ADDRESS' gmvault"
echo "  3/ Go to the URL indicated, and copy the token back."
echo "  4/ Once the synchronization process starts, restart the container."
echo ""
echo "Note /data/home/.gmvault/gmvault_defaults.conf may need to be changed"
echo "gmvault_client_id and gmvault_client_secret need to be setup according the Google app settings"
echo "https://console.developers.google.com/apis/credentials?project=gmvault-cp"

/bin/bash
