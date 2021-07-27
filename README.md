# weather

## Raw data ingest

The script `createTableWeatherRawPartioned.sql` creates a HIVE table
that can hold the JSON observations we have been downloading daily in
the last few years. We populate it with the script `addFile.sh` one at
a time. This would be faster by copying all files for one day in one
go. 

## First processing step

The scripts `createTableWeatherProcessed.sql` creates a table that
holds the observations as text rather JSON but keeps the partitioning by
download day. The ingest is done by `ingestRawWeather.sh`. 

## Final processing step

In the next step the data is kept in a table created by
`createTableWeatherPartitioned.sql` and the partitioning is done by
day of observation. To get the `INSERT OVERWRITE` right and avoid
deleting data we pick an observation day, write its partition and look
at the files downloaded two days before and afer. This is done in the script `ingestProcessedWeather.sh`.

## Regular downloads

The script `pipeline.sh` puts the data regularly into HDFS and HIVE.


## Links

Scripts for this webpage: https://uliharder.wordpress.com/r/1084-2/


http://pimaster:50070/
http://pimaster:8088/
https://pimaster:9090/

JSON SERDE
https://github.com/rcongiu/Hive-JSON-Serde


Attempt to get the time line server running
sudo apt-get install libjinput-java libjinput-java-doc libjinput-jni