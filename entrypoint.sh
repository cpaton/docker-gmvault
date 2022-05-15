#!/bin/bash

/app/setup.sh

# Set up crontab.
echo "" > $CRONTAB
echo "${GMVAULT_FULL_SYNC_SCHEDULE} '/app/BackupGmail.sh' 'full'" >> $CRONTAB
echo "${GMVAULT_QUICK_SYNC_SCHEDULE} '/app/BackupGmail.sh' 'quick'" >> $CRONTAB

ls -la /data/home/.gmvault

OAUTH_TOKEN="/data/home/.gmvault/${GMVAULT_EMAIL_ADDRESS}.oauth2"
STORED_PASSWORD="/data/home/.gmvault/${GMVAULT_EMAIL_ADDRESS}.passwd"
if [ -f $OAUTH_TOKEN ] || [ -f $STORED_PASSWORD ]
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
