#!/usr/bin/bash

##############################################################################################################################
# This shell script is use to insert the imsi data into the database.
# This script should be used for creating imsi data against the cos.
# Before running this script make sure that the databse configuration is already doone (addition of entry in the tnsnames.ora)
# Below are the env variable which user has to set before running this script.
# DB_USER : database username
# DB_PASSWORD : database password
# DB_SID : database SID
##############################################################################################################################


if [ -z "$1" ] 
then
	echo "DB_USER is mandatory argument."
	echo "Usage imsi_migartion.sh DB_USER DB_PASSWORD DB_SID"
	echo "Press enter to exit"
	read input
	exit;
fi

if [ -z "$2" ] 
then
	echo "DB_PASSWORD is mandatory argument."
	echo "Usage imsi_migartion.sh DB_USER DB_PASSWORD DB_SID"
	echo "Press enter to exit"
	read input
	exit;
fi

if [ -z "$3" ] 
then
	echo "DB_SID is mandatory argument."
	echo "Usage imsi_migartion.sh DB_USER DB_PASSWORD DB_SID"
	echo "Press enter to exit"
	read input
	exit;
fi

DB_USER=$1
DB_PASSWORD=$2
DB_SID=$3
file='imsi_data.csv'
echo "Starting the script."
echo "Creating temp data file per type."

while read -r line
do
        isRange=`echo $line | cut -d',' -f2`
        if [ $isRange == 'N' ]
        then
                echo $line | cut -d',' -f1,6,7,8 >>imsi_cos_entries.csv
		elif [ $isRange == 'Y' ]
		then
			echo $line ",0" | cut -d',' -f1,3,4,5,7,8,9 >>subscriber_cos_range.csv
        fi;
done<$file

echo "Running sql loader to load imsi data into the cos"
echo "SQLLDR CONTROL=imsi_cos_entries.csv, LOG=imsi_cos_entries.log, BAD=imsi_cos_entries.bad, DATA=imsi_cos_entries.csv USERID=$DB_USER@$DB_SID/$DB_PASSWORD, ERRORS=0, DISCARD=imsi_cos_entries.dsc,DISCARDMAX=0"
sqlldr CONTROL=imsi_cos_entries.ctl, LOG=imsi_cos_entries.log, BAD=imsi_cos_entries.bad, DATA=imsi_cos_entries.csv USERID=$DB_USER@$DB_SID/$DB_PASSWORD, ERRORS=0, DISCARD=imsi_cos_entries.dsc,DISCARDMAX=0

echo "Removing temp generated file"
rm imsi_cos_entries.csv
echo "Sql loader to load imsi data into the cos finished"


echo "Running sql loader to load range data into the cos"
echo "SQLLDR CONTROL=subscriber_cos_range.csv, LOG=subscriber_cos_range.log, BAD=subscriber_cos_range.bad, DATA=subscriber_cos_range.csv USERID=$DB_USER@$DB_SID/$DB_PASSWORD, ERRORS=0, DISCARD=subscriber_cos_range.dsc,DISCARDMAX=0"
sqlldr CONTROL=subscriber_cos_range.ctl, LOG=subscriber_cos_range.log, BAD=subscriber_cos_range.bad, DATA=subscriber_cos_range.csv USERID=$DB_USER@$DB_SID/$DB_PASSWORD, ERRORS=0, DISCARD=subscriber_cos_range.dsc,DISCARDMAX=0

echo "Removing temp generated file"
rm subscriber_cos_range.csv
echo "Sql loader to load imsi data into the cos finished"
