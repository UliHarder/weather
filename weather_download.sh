#!/bin/bash
# This scripts pulls all available weather observation from the MetOffice
# datapoint service
#Prepare the current date and time as part of the filename
DATE=`date +%Y-%m-%d-%H-%M`
# where the data lives
DATA=~/metoffice/data/
FILE=All-observation-UK
MINDATA=2

# bits for the URL

BASEURL=http://datapoint.metoffice.gov.uk/public/data/val/wxobs/all/
TYPE=json # this can be json or xml
WHAT="/all?res=hourly&key="
APIKEY=blah-blah-blah-blah

for type in json 
do
    thisurl=$BASEURL$type$WHAT$APIKEY
    thisfile=$DATA$FILE-$DATE.$type
    wget $thisurl -O $thisfile
done

bytes=`ls -Ash $thisfile`
newbytes=`ls -s $thisfile | awk '{ print $1 }' `
 if(( $newbytes < $MINDATA )); then
       twidge update  ".@uli Metoffice observations download failed. $bytes" 
 fi
exit
