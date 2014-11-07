autoxtrabackup
==============

Automatic MySQL backups using Percona innobackupex (xtrabackup).
This script uses the innobackupex wrapper for xtrabackup from Percona.

Requirements
------------
The backup tools from Percona.
Download the toolkit at http://www.percona.com/software/percona-toolkit
Currently this script has been tested on Debian 7 (Wheezy) with percona-toolkit 2.2.11

Installation
------------
Copy autoxtrabackup.config to /etc/default/autoxtrabackup and edit the settings
  This is not mandatory, but recommended. You can also set the settings in the script.
Copy autoxtrabackup to /usr/local/bin/autoxtrabackup
Make it executable, and set a cronjob
