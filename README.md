autoxtrabackup
==============

Automatic MySQL backups using Percona innobackupex (xtrabackup).  
This script uses the innobackupex wrapper for xtrabackup from Percona.  

Create full & incremental backups automatically, with configurable retention and compression.

Requirements
------------
Percona-toolkit, download from http://www.percona.com/software/percona-toolkit  
This script has been tested on Debian 7 (Wheezy) with percona-toolkit 2.2.11  
It should work on any MySQL distribution, but it has been tested only on Percona Server 5.6.

Installation
------------
Copy autoxtrabackup.config to /etc/default/autoxtrabackup and edit the settings  
  This is not mandatory, but recommended. You can also set the settings in the script.  
Copy autoxtrabackup to /usr/local/bin/autoxtrabackup  
Make it executable, and set a cronjob  

Remarks
-------
Incremental backups are only applicable to XtraDB & InnoDB tables.  
Incremental backups of MyISAM tables are not possible, these will be full backups each time.  
You can set a retention, how long you want to keep the backups.  
