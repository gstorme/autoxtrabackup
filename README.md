autoxtrabackup
==============

Automatic MySQL scheduled backups using Percona innobackupex (xtrabackup).  
This script uses the innobackupex wrapper for xtrabackup from Percona, included in percona-xtrabackup.

Create full & incremental backups automatically, with configurable retention and compression, and optional e-mail output.

Requirements
------------
Percona-xtrabackup, download from http://www.percona.com/software/percona-toolkit  
This script has been tested on Debian 7 (Wheezy) with percona-xtrabackup 2.2.6  
It should work on any MySQL distribution, but it has been tested only on Percona Server 5.6.

Installation
------------
Copy autoxtrabackup.config to /etc/default/autoxtrabackup and edit the settings  
This is not mandatory, but recommended. You can also set the settings in the script directly.  
Copy autoxtrabackup to /usr/local/bin/autoxtrabackup  
Make it executable, and set a cronjob  

Examples
---------
Create incremental backups each hour, and a full backup each 24 hours. Retention set to 1 week.  
  - Set "hoursBeforeFull" to 24  
  - Set "keepDays" to 7  
  - Add a cronjob "0 * * * * /usr/local/bin/autoxtrabackup"

Don't create incremental backups. Create a full backup every day at 23h, retention set to 1 week.
  - Set "hoursBeforeFull" to 1
  - Set "keepDays" to 7
  - Add a cronjob "0 23 * * * /usr/local/bin/autoxtrabackup"

Remarks
-------
Incremental backups only apply to XtraDB & InnoDB tables.  
Incremental backups of MyISAM tables are not possible, a full backup of such tables will be created each time.  

Restoring
---------
For information on how to restore a backup with innobackupex, visit http://www.percona.com/doc/percona-xtrabackup/2.1/innobackupex/innobackupex_script.html
