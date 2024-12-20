#! /bin/bash
# Backup storage directory
backupfolder=/var/backups
# MySQL user
user='root'
# MySQL password
password='<DB PASSWORD>'
# Number of days to store the backup 
keep_day=14
sqlfile=$backupfolder/openmrs-$(date +%d-%m-%Y_%H-%M-%S).sql
zipfile=$backupfolder/openmrs-$(date +%d-%m-%Y_%H-%M-%S).zip
# Create a backup 
sudo mysqldump -u $user -p$password -e --single-transaction -q openmrs > $sqlfile
if [ $? == 0 ]; then
  echo 'Sql dump created' 
else
  echo 'mysqldump return non-zero code' 
  exit
fi
# Compress backup 
zip $zipfile $sqlfile
if [ $? == 0 ]; then
  echo 'The backup was successfully compressed' 
else
  echo 'Error compressing backup' 
  exit
fi
rm $sqlfile
echo $zipfile 
# Delete old backups 
find $backupfolder -mtime +$keep_day -delete       