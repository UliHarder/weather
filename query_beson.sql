-- Download recent weather data for Benson

select
dt
, name
, metric
, cast(hourkey as int) hourkey
, concat(dt, ' ', lpad(cast(hourkey as int), 2, 0), ':30:00 UTC') date_time
, value
from
weather.weather_processed_t
${WHERE}
-- where dt >= '2021-07-23' and dt <= '2021-07-31'
AND  name LIKE '%BENSON%'
-- AND metric = 't'
ORDER BY metric, dt, cast(hourkey as int)
;

