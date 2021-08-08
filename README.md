# weather

I have been downloading for a number of year now obesrvation data from the [Metoffice datapoint service](https://www.metoffice.gov.uk/services/data/datapoint) in JSON format. After trying to decode the data with R and Python, I finally settled on using HIVE running on a [Hadoop cluster](https://uliharder.wordpress.com/r/1084-2/). Long term my plan is to explore using mySQL as the latest version also cope with JSON documents. Using trial and error I found that this [table definition](createTableWeatherRawPartioned.sql) interprets the data correctly.

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

## A plot of the latest data  

To keep an eye on the progress of the we plot the last 7 days of weather for Benson with the R script 
![The UK](R/benson.png?raw=true "The UK")

## Links

Scripts for this webpage: https://uliharder.wordpress.com/r/1084-2/


http://pimaster:50070/
http://pimaster:8088/
https://pimaster:9090/

JSON SERDE
https://github.com/rcongiu/Hive-JSON-Serde


Attempt to get the time line server running
sudo apt-get install libjinput-java libjinput-java-doc libjinput-jni
