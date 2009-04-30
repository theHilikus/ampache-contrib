#!/bin/bash
 
###############################################
# CHANGE THESE OPTIONS TO MATCH YOUR SYSTEM ! #
###############################################

cfgfile=/etc/ampache/ampache.cfg.php            # Ampache config file
ampachedir=/usr/share/ampache/www               # the directory Ampache is installed in
backupdir=~/ampache_backup                      # the directory to write the backup to

###############################################
#         END OF CONFIGURABLE OPTIONS         #
###############################################

ampacheDBserver=`grep "^database_hostname" $cfgfile | cut --delimiter="=" -f2 | cut --delimiter="\"" -f2`
ampacheDB=`grep "database_name" $cfgfile | cut --delimiter="=" -f2 | cut --delimiter="\"" -f2`
ampacheDBuser=`grep "database_username" $cfgfile | cut --delimiter="=" -f2 | cut --delimiter="\"" -f2`
ampacheDBpassword=`grep database_password $cfgfile | cut --delimiter="=" -f2 | cut --delimiter="\"" -f2`

mysqlopt="--host=$ampacheDBserver --user=$ampacheDBuser --password=$ampacheDBpassword"

timestamp=`date +%Y-%m-%d`
 
dbdump="$backupdir/ampache-$timestamp.sql.gz"
filedump="$backupdir/ampache-$timestamp.files.tgz"
 
date
echo "Ampache backup."
echo "Database: $ampacheDB"
echo "Login: $ampacheDBuser / $ampacheDBpassword"
echo "Directory: $ampachedir"
echo "Backup to: $backupdir"
echo
echo "creating database dump..."
mysqldump --default-character-set=utf8 $mysqlopt "$ampacheDB" | gzip > "$dbdump" || exit $?
 
echo "creating file archive of $ampachedir ..."
cd "$ampachedir"
tar --exclude .svn -zcf "$filedump" . || exit $?
 
echo "Done!"
echo "Backup files:"
ls -l $dbdump
ls -l $filedump
echo "******************************************"
echo
