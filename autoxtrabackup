#!/bin/bash
# MySQL backup script
# Version 0.1 - https://github.com/gregorystorme/autoxtrabackup
# Copyright (c) 2014 Gregory Storme


if [ -f /etc/default/autoxtrabackup ] ; then
        . /etc/default/autoxtrabackup
else

backupDir=/var/backups/mysql
hoursBeforeFull=12
mysqlUser=dbuser
mysqlPwd=password
compression=yes
keepDays=7
fi

#####
# No editing should be required below this line
#####

dateNow=`date +%Y-%m-%d_%H-%M-%S`
dateNowUnix=`date +%s`
backupLog=/tmp/backuplog
delDay=`date -d "-$keepDays days" +%Y-%m-%d`

if [ $(($keepDays * 24)) -le $hoursBeforeFull ]; then
        echo "ERROR: You have set hoursBeforeFull to $hoursBeforeFull and keepDays to $keepDays, this will delete all your backups... Change this"
        exit 1
else
        :
fi

if [[ $compression == yes ]]; then
 compress="--compress"
else
 compress=
fi

if [ -f "$backupDir"/latest_full ]; then
 echo "Latest full backup information found... continuing"
 lastFull=`cat "$backupDir"/latest_full`
else
 echo "Latest full backup information not found... taking a first full backup now"
 echo $dateNowUnix > "$backupDir"/latest_full
 /usr/bin/innobackupex --user=$mysqlUser --password=$mysqlPwd --no-timestamp $compress --rsync "$backupDir"/"$dateNow"_full > $backupLog 2>&1
  if grep -q "completed OK" $backupLog; then
   echo "Full backup completed OK!"
   exit 0
  else
   echo "Full backup FAILED"
   exit 1
  fi
fi

difference=$((($dateNowUnix - $lastFull) / 60 / 60))

if [ $difference -lt $hoursBeforeFull ]; then
 echo "It's been $difference hours since last full, doing an incremental backup"
 lastFullDir=`date -d@"$lastFull" '+%Y-%m-%d_%H-%M-%S'`
 /usr/bin/innobackupex --user=$mysqlUser --password=$mysqlPwd --no-timestamp $compress --rsync --incremental --incremental-basedir="$backupDir"/"$lastFullDir"_full "$backupDir"/"$dateNow"_incr > $backupLog 2>&1
else
 echo "It's been $difference hours since last full backup, time for a new full backup"
 echo $dateNowUnix > "$backupDir"/latest_full
 /usr/bin/innobackupex --user=$mysqlUser --password=$mysqlPwd --no-timestamp $compress --rsync "$backupDir"/"$dateNow"_full > $backupLog 2>&1
fi

if grep -q "completed OK" $backupLog; then
 if grep -q "incremental" $backupLog; then
         echo "Incremental backup completed OK!"
 else
  echo "Full backup completed OK!"
 fi
else
        echo "Backup FAILED"
        exit 1
fi

# Delete backups older than retention date
rm -rf $backupDir/$delDay*

# Delete incremental backups with full backup base directory that was deleted
for i in `find "$backupDir"/*incr -type f -iname xtrabackup_info |  xargs grep $delDay | awk '{print $10}' | cut -d '=' -f2`; do rm -rf $i; done

exit 0
