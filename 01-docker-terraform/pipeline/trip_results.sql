-- For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a trip_distance of less than or equal to 1 mile?
SELECT count(1)
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2025-11-01' and lpep_pickup_datetime < '2025-12-01'
AND trip_distance <= 1;


-- Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles
SELECT lpep_pickup_datetime::DATE, max(trip_distance) as total
FROM public.green_taxi_data
WHERE trip_distance < 100
GROUP BY lpep_pickup_datetime
ORDER BY total DESC;

-- Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?
SELECT "Zone", sum(total_amount) as amount
FROM public.green_taxi_data as gd left join public.taxi_zone_lookup as tz
ON gd."PULocationID" = tz."LocationID"
WHERE lpep_pickup_datetime::date = '2025-11-18'
GROUP BY "Zone"
order by amount DESC;


-- For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?
SELECT dropoff."Zone", tip_amount
FROM public.green_taxi_data as gd left join public.taxi_zone_lookup as pickup
ON gd."PULocationID" = pickup."LocationID"
left join public.taxi_zone_lookup as dropoff
ON gd."DOLocationID" = dropoff."LocationID"
WHERE EXTRACT(YEAR FROM lpep_pickup_datetime) = '2025'
AND EXTRACT(MONTH FROM lpep_pickup_datetime) = '11'
AND pickup."Zone" = 'East Harlem North'
ORDER BY tip_amount DESC
;

