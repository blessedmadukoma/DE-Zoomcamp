-- SQL Homework section

-- Question 3: Count records
-- How many taxi trips were totally made on September 18th 2019?

-- Tip: started and finished on 2019-09-18.

-- Remember that lpep_pickup_datetime and lpep_dropoff_datetime columns are in the format timestamp (date and hour+min+sec) and not in date.

SELECT COUNT(*)
FROM hw_green_trip_data
WHERE
    CAST(lpep_pickup_datetime AS DATE) = '2019-09-18'
    AND CAST(lpep_dropoff_datetime AS DATE) = '2019-09-18';

-- OR

SELECT COUNT(*)
FROM hw_green_trip_data
WHERE DATE(lpep_pickup_datetime) = '2019-09-18' AND DATE(lpep_dropoff_datetime) = '2019-09-18';

-- Question 4: Which was the day with the largest trip distance? (Choose one)

SELECT
    DATE_TRUNC('day', lpep_pickup_datetime) AS pickup_day,
    SUM(trip_distance) AS total_trip_distance
FROM
    hw_green_trip_data
GROUP BY
    pickup_day
ORDER BY
    total_trip_distance DESC
LIMIT 1;

-- Question 5: Three biggest pick up Boroughs
-- Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown

-- Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?
-- - "Brooklyn" "Manhattan" "Queens" [Answer]
-- - "Bronx" "Brooklyn" "Manhattan"
-- - "Bronx" "Manhattan" "Queens"
-- - "Brooklyn" "Queens" "Staten Island"

SELECT
    tzd."Borough",
    SUM(gtd.total_amount) AS total_amount_sum
FROM
    hw_green_trip_data gtd
JOIN
    hw_taxi_zone_data tzd ON gtd."PULocationID" = tzd."LocationID"
WHERE
    -- gtd.lpep_pickup_datetime >= '2019-09-18'
    -- AND gtd.lpep_pickup_datetime < '2019-09-19'
    DATE(gtd.lpep_pickup_datetime) >= '2019-09-18'
    AND DATE(gtd.lpep_pickup_datetime) < '2019-09-19'
GROUP BY
    tzd."Borough"
HAVING
    SUM(gtd.total_amount) > 50000
ORDER BY
    total_amount_sum DESC
LIMIT 3;

-- Question 6. Largest tip
-- For the passengers picked up in the Astoria Zone 
-- 	which was the drop off zone that had the largest tip? 
-- 	We want the name of the zone, not the id. (Choose one)

SELECT
    gtd."PULocationID" AS pickup_location_id,
    tzd1."Zone" AS pickup_zone,
    gtd."DOLocationID" AS dropoff_location_id,
    tzd2."Zone" AS dropoff_zone,
    MAX(gtd."tip_amount") AS max_tip_amount
FROM
    hw_green_trip_data gtd
JOIN
    hw_taxi_zone_data tzd1 ON gtd."PULocationID" = tzd1."LocationID"
JOIN
    taxi_zone_data tzd2 ON gtd."DOLocationID" = tzd2."LocationID"
WHERE
    tzd1."Zone" = 'Astoria'
GROUP BY
    gtd."PULocationID", tzd1."Zone", gtd."DOLocationID", tzd2."Zone"
ORDER BY
    max_tip_amount DESC
LIMIT 1;


-- Zoomcamp 2022 Question 5. The number of passengers
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
