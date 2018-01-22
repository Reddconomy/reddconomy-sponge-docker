#!/bin/bash
source /reddconomy_updater.sh

# FIX PERMISSIONS
chown java:java /minecraft -Rf


while true;
do
    if [ "`checkForReddconomyUpdate`" == "true" ];
    then
        echo "Restart & update"
        supervisorctl restart minecraft
    fi
    sleep 2m
done