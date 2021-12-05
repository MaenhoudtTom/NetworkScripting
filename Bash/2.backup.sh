#!/bin/bash

# Crontab command to schedule script
#00 17 * * 7 ./backup.sh
#crontab -e

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]
then
        # Stopping the script
        echo "This script must be run as root"
        exit 1
fi


# Check for parameter
if [ -z "$1" ]
then
        # Stopping the script
        echo "No path specified, falling back to default"
        backupTargetFolder="/home/tom/"
else
	backupTargetFolder=$1
	echo "A backup will be made from this folder: $backupTargetFolder"
fi

# Check if target folder exists
echo "Checking if the target folder exists...."
if [ -d $backupTargetFolder ]
then
	echo "Folder found."
else
	echo "Target folder not found, are you sure the folder exists?"
	exit 3
fi

# Create folder for backups if not present
echo "Creating backup folder...."
if [ -d "/backups" ]
then
	echo "Folder already created"
else
	mkdir /backups
	echo "Created backup folder"
fi

# Currunt time to add to file name
now=$(date +"%d_%m_%y")
echo $now

# File that contains backup
backup="/backups/backup-$now.tar.gz"

# Create backup for target folder
echo "Backing up target folder..."
echo "Source $backupTargetFolder"
echo "Destination $backup"
tar -zcvf $backup $backupTargetFolder
echo "Done"

# Creating MySQL database backup
echo "Backing up MySQL database..."

DBbackup="/backups/DBbackup-$now.tar.gz"
DBHost="localhost"
DBPort="3306"
DBUser=""
DBPwd=""
DBName=""

mysqldump -h $DBHost -P $DBPort -u $DBUser -p $DBPwd $DBName | gzip > $DBbackup

if [ $? -eq 0 ]
then
	echo "Database backup completed successfully"
else
	echo "An error occured during backup"
	exit 4
fi
