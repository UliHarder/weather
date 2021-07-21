select
dt
, name
, metric
, count(*) f
, round(avg(value),1) value
from
weather_processed_t
where name like '%BENSON%'
AND metric = 't'
group by dt, name, metric
order by dt desc;


select
dt
, name
, metric
, hourkey
, value
from
weather_processed_t
where name like '%BENSON%'
AND metric = 't'
AND dt in ('2021-04-24' , '2021-04-25')
;
