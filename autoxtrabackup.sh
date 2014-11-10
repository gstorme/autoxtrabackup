#!/bin/bash
# MySQL backup script
# https://github.com/gregorystorme/autoxtrabackup
# Copyright (c) 2014 Gregory Storme
# Version: 0.2

if [ -f /etc/default/autoxtrabackup ] ; then
        . /etc/default/autoxtrabackup
else

backupDir=/var/backups/mysql
hoursBeforeFull=48
mysqlUser=dbuser
mysqlPwd=password
compression=true
keepDays=7
sendEmail=never
emailAddress=
fi

#####
# No editing should be required below this line
#####

dateNow=`date +%Y-%m-%d_%H-%M-%S`
dateNowUnix=`date +%s`
backupLog=/tmp/backuplog
delDay=`date -d "-$keepDays days" +%Y-%m-%d`
if [ -f "$backupDir"/latest_full ]; then
        lastFull=`cat "$backupDir"/latest_full`
fi

# Check if you set a correct retention
if [ $(($keepDays * 24)) -le $hoursBeforeFull ]; then
        echo "ERROR: You have set hoursBeforeFull to $hoursBeforeFull and keepDays to $keepDays, this will delete all your backups... Change this"
        exit 1
fi

# If you enabled sendEmail, check if you also set a recipient
if [[ -z $emailAddress ]] && [[ $sendEmail == onerror ]]; then
        echo "Error, you have enabled sendEmail but you have not configured any recipient"
        exit 1
elif [[ -z $emailAddress ]] && [[ $sendEmail == always ]]; then
        echo "Error, you have enabled sendEmail but you have not configured any recipient"
        exit 1
fi

# If compression is enabled, pass it on to the backup command
if [[ $compression == true ]]; then
        compress="--compress"
        compressThreads="--compress-threads=$compressThreads"
else
        compress=
        compressThreads=
fi

# Check for an existing full backup
if [ ! -f "$backupDir"/latest_full ]; then
        #echo "Latest full backup information not found... taking a first full backup now"
        echo $dateNowUnix > "$backupDir"/latest_full
        lastFull=`cat "$backupDir"/latest_full`
        /usr/bin/innobackupex --user=$mysqlUser --password=$mysqlPwd --no-timestamp $compress $compressThreads --rsync "$backupDir"/"$dateNow"_full > $backupLog 2>&1
else
        # Calculate the time since the last full backup
        difference=$((($dateNowUnix - $lastFull) / 60 / 60))

        # Check if we must take a full or incremental backup
        if [ $difference -lt $hoursBeforeFull ]; then
                #echo "It's been $difference hours since last full, doing an incremental backup"
                lastFullDir=`date -d@"$lastFull" '+%Y-%m-%d_%H-%M-%S'`
                /usr/bin/innobackupex --user=$mysqlUser --password=$mysqlPwd --no-timestamp $compress $compressThreads --rsync --incremental --incremental-basedir="$backupDir"/"$lastFullDir"_full "$backupDir"/"$dateNow"_incr > $backupLog 2>&1
        else
                #echo "It's been $difference hours since last full backup, time for a new full backup"
                echo $dateNowUnix > "$backupDir"/latest_full
                /usr/bin/innobackupex --user=$mysqlUser --password=$mysqlPwd --no-timestamp $compress $compressThreads --rsync "$backupDir"/"$dateNow"_full > $backupLog 2>&1
        fi
fi

# Check if the backup succeeded or failed, and e-mail the logfile, if enabled
if grep -q "completed OK" $backupLog; then
        #echo "Backup completed OK"
        if [[ $sendEmail == always ]]; then
                cat $backupLog | mail -s "AutoXtraBackup log" $emailAddress
        fi
else
        #echo "Backup FAILED"
        if [[ $sendEmail == always ]] || [[ $sendEmail == onerror ]]; then
                cat $backupLog | mail -s "AutoXtraBackup log" $emailAddress
        fi
        exit 1
fi

# Delete backups older than retention date
rm -rf $backupDir/$delDay*

# Delete incremental backups with full backup base directory that was deleted
for i in `find "$backupDir"/*incr -type f -iname xtrabackup_info 2>/dev/null |  xargs grep $delDay | awk '{print $10}' | cut -d '=' -f2`; do rm -rf $i; done

exit 0
