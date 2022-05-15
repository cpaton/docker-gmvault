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