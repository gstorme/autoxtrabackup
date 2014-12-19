autoxtrabackup
==============

Automatic MySQL scheduled backups using Percona innobackupex (xtrabackup).  
This script uses the innobackupex wrapper for xtrabackup from Percona, included in percona-xtrabackup.

Create full & incremental backups automatically, with configurable retention and compression, and optional e-mail output.

Requirements
------------
Supported MySQL distributions: MySQL, Percona Server, MariaDB  
Supported Linux distributions: Debian, Ubuntu, CentOS, RedHat  
Dependencies: percona-xtrabackup, download from http://www.percona.com/software/percona-xtrabackup

This script has been tested on Debian 7 (Wheezy) with Percona-server 5.6.  
This script has been tested on CentOS 6.4 with MariaDB-server-10.  

Installation
------------
Copy autoxtrabackup.config to /etc/default/autoxtrabackup and edit the settings  
This is not mandatory, but recommended. You can also set the settings in the script directly.  
Copy autoxtrabackup.sh to /usr/local/bin/autoxtrabackup  
Make it executable, and set a cronjob  

The script does not provide standard output. Check /tmp/backuplog  

Examples
---------
Create incremental backups each hour, and a full backup each 24 hours. Retention set to 1 week.  
  - Set "hoursBeforeFull" to 24  
  - Set "keepDays" to 7  
  - Add a cronjob "0 * * * * /usr/local/bin/autoxtrabackup"

Create a full backup on Sunday, take incremental backups all other days. Keep backups for 1 month.
  - Set "hoursBeforeFull" to 168
  - Set "keepDays" to 31
  - Create the first backup on Sunday at the desired time, let's take 23h for example
  - Add a cronjob "0 23 * * * /usr/local/bin/autoxtrabackup"

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
Use "./autoxtrabackup -h" for a quick reference on how to restore backups.

For more detailed information on how to restore a backup with innobackupex, visit http://www.percona.com/doc/percona-xtrabackup/2.2/innobackupex/innobackupex_script.html
