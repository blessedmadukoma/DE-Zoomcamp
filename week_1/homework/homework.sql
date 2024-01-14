SELECT
	*
FROM
	taxi_zone_data
-- 	green_trip_data
LIMIT 100;

-- SELECT COUNT(*)
-- FROM green_trip_data
-- WHERE
--     DATE_PART('MONTH', lpep_pickup_datetime) = 1
--     AND DATE_PART('DAY', lpep_pickup_datetime) = 15;

-- Which was the day with the largest trip distance? (Choose one)
-- SELECT
-- 	lpep_pickup_datetime, lpep_dropoff_datetime, trip_distance
-- FROM
-- 	green_trip_data
-- GROUP BY trip_distance
-- LIMIT 5;

-- SELECT COUNT(*)
-- FROM green_trip_data
-- WHERE
--     TO_CHAR(lpep_pickup_datetime, 'MM') = '01'
--     AND TO_CHAR(lpep_pickup_datetime, 'DD') = '15';

-- SELECT
--     DATE_TRUNC('day', CAST(lpep_pickup_datetime AS timestamp)) AS trip_day,
--     SUM(trip_distance) AS total_trip_distance
-- FROM
--     green_trip_data
-- GROUP BY
--     trip_day
-- ORDER BY
--     total_trip_distance DESC
-- -- LIMIT 1;

-- Question 5. The number of passengers
-- In 2019-01-01 how many trips had 2 and 3 passengers? (Choose one)
-- SELECT
--     DATE_TRUNC('day', CAST(lpep_pickup_datetime AS timestamp)) AS trip_day,
--     COUNT(DISTINCT CASE WHEN passenger_count = 2 THEN index END) AS total_distinct_trips_with_2_passengers,
--     COUNT(DISTINCT CASE WHEN passenger_count = 3 THEN index END) AS total_distinct_trips_with_3_passengers
-- FROM
--     green_trip_data
-- WHERE
--     DATE_TRUNC('day', CAST(lpep_pickup_datetime AS timestamp)) = '2019-01-01 00:00:00'
-- GROUP BY
--     trip_day
-- LIMIT 1;


-- Question 6. Largest tip
-- For the passengers picked up in the Astoria Zone 
-- 	which was the drop off zone that had the largest tip? 
-- 	We want the name of the zone, not the id. (Choose one)

SELECT
-- 	tzd."LocationID" as TZD_LocationID,
-- 	tzd."Zone" as TZD_Zone,
-- 	tzd."service_zone" as TZD_Service_Zone
*
from taxi_zone_data as tzd
inner join green_trip_data as gtd
ON tzd."LocationID" = gtd."PULocationID"
where gtd."tip_amount" > 0 AND tzd."Zone" = 'Astoria'
-- where gtd."tip_amount" > 0
ORDER BY gtd."tip_amount" DESC
LIMIT 10;

SELECT
    gtd."PULocationID" AS pickup_location_id,
    tzd1."Zone" AS pickup_zone,
    gtd."DOLocationID" AS dropoff_location_id,
    tzd2."Zone" AS dropoff_zone,
    MAX(gtd."tip_amount") AS max_tip_amount
FROM
    green_trip_data gtd
JOIN
    taxi_zone_data tzd1 ON gtd."PULocationID" = tzd1."LocationID"
JOIN
    taxi_zone_data tzd2 ON gtd."DOLocationID" = tzd2."LocationID"
WHERE
    tzd1."Zone" = 'Astoria'
GROUP BY
    gtd."PULocationID", tzd1."Zone", gtd."DOLocationID", tzd2."Zone"
ORDER BY
    max_tip_amount DESC
LIMIT 1;

