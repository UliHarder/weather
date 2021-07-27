#!/bin/bash

# the directory we want to be in
ROOT=/home/uh/weather
DIR=$ROOT/weather

# where the data lives
DATA=$ROOT/observations/new/

# the file name
FILE=All-observation-UK

# go to working directory

echo "Going to $DIR"
cd $DIR

# record day and time

DATE=`date +%Y-%m-%d-%H-%M`
DT=`date +%Y-%m-%d`
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`


# get API key

source credentials.sh

echo $APIKEY

# download file from metoffice

echo "./getObservation.sh $DATE $DATA $FILE $APIKEY"


thisfile=`./getObservation.sh $DATE $DATA $FILE $APIKEY`

echo $thisfile




# copy file to HDFS
hdfsfile="/data/staging/weather/observation_raw/$YEAR/$MONTH/$DAY/$DT"

command="ALTER TABLE weather.observation_raw_t  ADD IF NOT EXISTS  PARTITION (year = $YEAR, month = '"$MONTH"', day = '"$DAY"', dt = '"$DT"') LOCATION '"$hdfsfile"';"

echo $command

hive -e "$command"

hdfs dfs -copyFromLocal $thisfile $hdfsfile

# add to raw partitioned table

hive --hivevar WHERE=" where dt = '"$DT"' " -f ingestRawWeather.sql 

# rerun the processed table
DATECMD=date
FORMAT="%Y-%m-%d"

now=`$DATECMD +$FORMAT -d "$DT - 3 day"`
nowL=$now
nowR=`$DATECMD +$FORMAT -d "$nowL + 3 day"`
echo "$now $nowL $nowR" 
left=`$DATECMD +$FORMAT -d "$nowL - 3 day"`
right=`$DATECMD +$FORMAT -d "$nowR + 3 day"`
where=" where dt >= '"$left"' and dt <= '"$right"' and substr(daykey, 1,10) >= '"$nowL"' and substr(daykey, 1,10) <= '"$nowR"' "
echo $left $now $right
echo $where

hive --hivevar WHERE="$where" -f ingestProcessedWeather.sql




# end


exit
