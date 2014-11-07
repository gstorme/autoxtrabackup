autoxtrabackup
==============

Automatic MySQL backups using Percona innobackupex (xtrabackup).  
This script uses the innobackupex wrapper for xtrabackup from Percona.  
It will create full and incremental backups, according to a configurable schedule.  
Incremental backups are only applicable to XtraDB & InnoDB tables.  
Incremental backups of MyISAM tables are not possible, these will be full backups each time.  
You can set a retention, how long you want to keep the backups.  
Backup compression is enabled by default, but can be disabled.  

Requirements
------------
Percona-toolkit, download from http://www.percona.com/software/percona-toolkit
This script has been tested on Debian 7 (Wheezy) with percona-toolkit 2.2.11

Installation
------------
Copy autoxtrabackup.config to /etc/default/autoxtrabackup and edit the settings  
  This is not mandatory, but recommended. You can also set the settings in the script.  
Copy autoxtrabackup to /usr/local/bin/autoxtrabackup  
Make it executable, and set a cronjob  
