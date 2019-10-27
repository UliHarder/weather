-- import that works after August 2015
USE weather;

ADD JAR hdfs:///code/json-serde-1.3.9-SNAPSHOT-jar-with-dependencies.jar;

ADD JAR hdfs:///code/brickhouse-0.7.1-SNAPSHOT.jar;
CREATE TEMPORARY FUNCTION json_split AS 'brickhouse.udf.json.JsonSplitUDF';
CREATE TEMPORARY FUNCTION json_map AS 'brickhouse.udf.json.JsonMapUDF';
CREATE TEMPORARY FUNCTION to_json AS 'brickhouse.udf.json.ToJsonUDF';
DROP TABLE weather_t;
CREATE TABLE weather_t
AS
SELECT thislocation.i
, thislocation.name
, thislocation.lat
, thislocation.lon
, thislocation.country
, thislocation.continent
, thislocation.elevation
--, thisperiod
, thisperiod.value day
--, to_json(thisperiod.rep)
--, thisperiod.rep
--, thisrep
, thisrep.offset / 60 hourkey
, metric
, value
--, thislocation.period
--, thislocation
FROM  weather_raw_t
LATERAL VIEW EXPLODE(siterep.dv.location) loc AS thislocation
LATERAL VIEW EXPLODE(thislocation.period) per AS thisperiod
LATERAL VIEW EXPLODE(thisperiod.rep) rep AS thisrep
LATERAL VIEW EXPLODE(JSON_MAP(TO_JSON(thisrep),'string,string')) x AS metric, value
WHERE metric != 'offset'
;


