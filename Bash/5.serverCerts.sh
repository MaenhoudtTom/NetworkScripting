#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]
then
        # Stopping the script
        echo "This script must be run as root"
        exit 1
fi

# Find all .crt files and put it in crts.txt
find / -type f -name '*.crt' >> ./crts.txt

# Read file
certs="./crts.txt"
LINES=$(cat $certs)

# For every line in file
for cert in $certs
do
	# Get expiration date of cert
	DATE=$(openssl x509 -enddate -noout -in $cert)

	# Get month, day and year
    	DAY="$(echo "$DATE" | cut -b 14,15)"
    	MONTH="$(echo "$DATE" | cut -b 10,11,12)"
    	YEAR="$(echo "$DATE" | cut -b 26,27,28,29)"

	# Correct day error
    	DAYCORRECTION="$(echo "$DAY" | cut -b 1)"
    	if [[ "$DAYCORRECTION" == " " ]]; then
        	DAY="$(echo "$DAY" | cut -b 2)"
    	fi

    	NEWDATE="$DAY-${MONTH^^}-$YEAR"

	# Reformat dates
    	CERTIFICATEDATE=$(date -d "$NEWDATE" +"%s")
    	OUTDATEDDATE=$(date -d "$dt +14 day" +"%s")
    	CURRENTDATE=$(date +%s)

	# Check when cert expires and put in file if needed
    	if [ $CURRENTDATE -gt $CERTIFICATEDATE ] && [ $CERTIFICATEDATE -le $OUTDATEDDATE ]
       	then
        	echo "$LINE" >> ./certsToExpire.txt
    	fi
done

echo "You can find the certs that are almost expired in file certsToExpire.txt"

# Remove file
rm $certs
