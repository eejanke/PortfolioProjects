--Create temporary table by combining the last 12 months through unions
Drop Table if Exists #yearly_tripdata
Create Table #yearly_tripdata
	(
	ride_id nvarchar(255),
	rideable_type nvarchar(255),
	started_at datetime,
	ended_at datetime,
	start_station_name nvarchar(255),
	start_station_id nvarchar(255),
	end_station_name nvarchar(255),
	end_station_id nvarchar(255),
	start_lat float,
	start_lng float,
	end_lat float,
	end_lng float,
	member_casual nvarchar(255),
	ride_length time(7),
	day_of_week float
	)

INSERT INTO #yearly_tripdata
	SELECT *
	FROM [Cyclistic Ride Share]..apr_22_tripdata

	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..aug_22_tripdata

	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..dec_22_tripdata

	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..feb_23_tripdata
	
	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..jan_23_tripdata
	
	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..july_22_tripdata
	
	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..june_22_tripdata
	
	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..mar_22_tripdata
	
	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..may_22_tripdata
	
	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..nov_22_tripdata
	
	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..oct_22_tripdata
	
	UNION

	SELECT *
	FROM [Cyclistic Ride Share]..sept_22_tripdata
	
--View temp table without duplicates
SELECT DISTINCT *
FROM #yearly_tripdata
ORDER BY ride_length DESC
--No duplicates are in the table

--Calculating ride length by finding the difference between the start of the ride and the end
SELECT *, DATEDIFF(SECOND, started_at, ended_at) as trip_time
INTO #yearly_triptime
FROM #yearly_tripdata
	

--Ride length by rider types
SELECT member_casual, 
	MIN((CAST(trip_time as float)/60)) as MIN, 
	MAX((CAST(trip_time as float)/60)) as MAX,
	AVG((CAST(trip_time AS float)/60)) as AVG
FROM #yearly_triptime
WHERE member_casual is not null
	AND (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
GROUP BY member_casual


--Total rides by members and casual riders by day of the week
SELECT day_of_week,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS Member,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS Casual
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
GROUP BY day_of_week
ORDER BY day_of_week

--Average rides by members and casual riders by day of week
SELECT DATEPART(WEEKDAY, started_at) as day,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END)/COUNT (distinct DATEPART(DAYOFYEAR, started_at)) AS Member_AVG,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END)/COUNT (distinct DATEPART(DAYOFYEAR, started_at)) AS Casual_AVG
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
GROUP BY DATEPART(WEEKDAY, started_at)
ORDER BY DATEPART(WEEKDAY, started_at)

--Total rides by members and casual riders by month
SELECT DATEPART(year, started_at) as year,
	DATEPART(month, started_at) AS ride_month,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS members,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
GROUP BY DATEPART(year, started_at),
	DATEPART(month, started_at)
ORDER BY DATEPART(year, started_at),
	DATEPART(month, started_at) ASC

--Average rides by members and casual riders by month
SELECT member_casual,
	count(member_casual)/12 as monthly_avg
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
GROUP BY member_casual


--Start station populatiry
SELECT TOP(10)
	start_station_name,
	start_station_id,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS members,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440 and
	start_station_name is not null and
	start_station_id is not null
GROUP BY start_station_name,
	start_station_id
ORDER BY casual DESC

--Start station populatiry with lat & lng
SELECT TOP(10)
	start_station_name,
	start_station_id,
	start_lat,
	start_lng,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS members,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440 and
	start_station_name is not null and
	start_station_id is not null
GROUP BY start_station_name,
	start_station_id,
	start_lat,
	start_lng
ORDER BY casual DESC

--End Station Popularity
SELECT TOP(10)
	end_station_name,
	end_station_id,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS members,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440 and
	end_station_name is not null and
	end_station_id is not null
GROUP BY end_station_name,
	end_station_id
ORDER BY casual DESC

--End Station Popularity with lat & lng
SELECT TOP(10)
	end_station_name,
	end_station_id,
	end_lat,
	end_lng,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS members,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440 and
	end_station_name is not null and
	end_station_id is not null
GROUP BY end_station_name,
	end_station_id,
	end_lat,
	end_lng
ORDER BY casual DESC


--Average trip time by month
SELECT DATEPART(year, started_at) AS year,
	DATEPART(month, started_at) AS month,
	member_casual,
	AVG((CAST(trip_time AS float)/60)) as AVG_trip_time
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
GROUP BY DATEPART(year, started_at), 
	DATEPART(month, started_at), 
	member_casual
ORDER BY DATEPART(year, started_at), 
	DATEPART(month, started_at) ASC

--Average trip time by weekday
SELECT day_of_week,
	member_casual,
	AVG((CAST(trip_time AS float)/60)) as AVG_trip_time
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
GROUP BY day_of_week, member_casual
ORDER BY day_of_week ASC

--Ride type by riders
SELECT rideable_type,
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS members,
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
GROUP BY rideable_type

--Average ride length by rideable type
SELECT rideable_type,
	member_casual,
	AVG((CAST(trip_time AS float)/60)) as AVG_trip_time
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
	and member_casual is not null
GROUP BY rideable_type,
	member_casual
ORDER BY rideable_type,
	member_casual

-- Average number of rides by hour
SELECT DATEPART(hour, started_at) as hour,
	member_casual,
	count(member_casual)/365 as rides
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
	and member_casual is not null
GROUP BY DATEPART(hour, started_at),
	member_casual
ORDER BY DATEPART(hour, started_at),
	member_casual


--Average ride length by hour
SELECT DATEPART(hour, started_at) as hour,
	member_casual,
	AVG((CAST(trip_time AS float)/60)) as AVG_trip_time
FROM #yearly_triptime
WHERE (CAST(trip_time as float)/60) > 0
	AND (CAST(trip_time as float)/60) < 1440
	and member_casual is not null
GROUP BY DATEPART(hour, started_at),
	member_casual
ORDER BY DATEPART(hour, started_at),
	member_casual
