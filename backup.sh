#!/bin/bash

################ Variables #####################################################
user="karanravat60@gmail.com"
DATE="$(date +%d_%m_%Y))"
DBName="myrdsuser"
DBPassword="myrdspassword"
DBUser="myrdsinstance"
Backup_Location="/home/ubuntu/Backup"
Message1="Backup Completed for the Server"
Message2="Backup Failed for the check"
ENDPOINT="awsrds"

################# Dump of the database ##################################################

cd "$Backup_Location"
mkdir "$DATE"
mysqldump -h "$ENDPOINT" -u "$DBUser" -p"$DBPassword" "$DBName" > "$Backup_Location/$DATE/database-$DATE.sql"
zip database-$DATE.sql.zip database-$DATE.sql
aws s3 cp  database-$DATE.sql s3://discus-upload 

if [ $? -eq 0 ]; then
    echo "$Message1"
else
    echo "$Message2"
fi

############################################### IN CRONTAB iT WILL LOOK LIKE THIS IN IST TIME #######################

# 0 23 * * * sh /home/ubuntu/scripts/backup.sh >> /home/ubuntu/logs/backup.log

############################################### We also can setup on limit of 15 or 20 backups in Linux ######

# find /home/ubuntu/Backup -type d -mtime 15 -exec rm -r {} \;
