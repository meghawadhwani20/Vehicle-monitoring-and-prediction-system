USE vehicle_data;
DROP TABLE IF EXISTS traffic_data;

CREATE TABLE traffic_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp DATETIME,
    latitude FLOAT,
    longitude FLOAT,
    location_name VARCHAR(255),  -- New Column for Location Name
    frc VARCHAR(10),
    currentSpeed INT,
    freeFlowSpeed INT,
    currentTravelTime INT,
    freeFlowTravelTime INT,
    speed_ratio FLOAT,
    delay_time INT,
    date DATE,
    time TIME
);
SELECT * FROM traffic_data;

UPDATE traffic_data
SET location_name = CASE 
    -- 1. Taj Mahal
    WHEN latitude BETWEEN 27.17 AND 27.18 AND longitude BETWEEN 78.00 AND 78.01 THEN 'Taj Mahal, India'

    -- 2. Agra Fort
    WHEN latitude BETWEEN 27.18 AND 27.19 AND longitude BETWEEN 78.01 AND 78.02 THEN 'Agra Fort, India'

    -- 3. India Gate
    WHEN latitude BETWEEN 28.61 AND 28.62 AND longitude BETWEEN 77.22 AND 77.23 THEN 'India Gate, Delhi, India'

    -- 4. Mumbai
    WHEN latitude BETWEEN 19.07 AND 19.08 AND longitude BETWEEN 72.87 AND 72.88 THEN 'Mumbai, India'

    -- 5. Bangalore
    WHEN latitude BETWEEN 12.97 AND 12.98 AND longitude BETWEEN 77.59 AND 77.60 THEN 'Bangalore, India'

    -- 6. Chennai
    WHEN latitude BETWEEN 13.08 AND 13.09 AND longitude BETWEEN 80.27 AND 80.28 THEN 'Chennai, India'

    -- 7. Kolkata
    WHEN latitude BETWEEN 22.57 AND 22.58 AND longitude BETWEEN 88.36 AND 88.37 THEN 'Kolkata, India'

    -- 8. Lucknow
    WHEN latitude BETWEEN 26.84 AND 26.85 AND longitude BETWEEN 80.94 AND 80.95 THEN 'Lucknow, India'

    -- 9. Bhopal
    WHEN latitude BETWEEN 23.25 AND 23.26 AND longitude BETWEEN 77.41 AND 77.42 THEN 'Bhopal, India'

    -- 10. Chandigarh
    WHEN latitude BETWEEN 30.73 AND 30.74 AND longitude BETWEEN 76.77 AND 76.78 THEN 'Chandigarh, India'

    -- For unknown locations, randomly assign one of the 10 cities
    ELSE CASE 
        WHEN MOD(id, 10) = 0 THEN 'Taj Mahal, India'
        WHEN MOD(id, 10) = 1 THEN 'Agra Fort, India'
        WHEN MOD(id, 10) = 2 THEN 'India Gate, Delhi, India'
        WHEN MOD(id, 10) = 3 THEN 'Mumbai, India'
        WHEN MOD(id, 10) = 4 THEN 'Bangalore, India'
        WHEN MOD(id, 10) = 5 THEN 'Chennai, India'
        WHEN MOD(id, 10) = 6 THEN 'Kolkata, India'
        WHEN MOD(id, 10) = 7 THEN 'Lucknow, India'
        WHEN MOD(id, 10) = 8 THEN 'Bhopal, India'
        WHEN MOD(id, 10) = 9 THEN 'Chandigarh, India'
    END
END;





-- Total records count:
SELECT COUNT(*) AS total_records FROM traffic_data;


-- Count of unique locations where vehicles are detected
SELECT COUNT(DISTINCT location_name) AS unique_locations FROM traffic_data;

-- Average speed of vehicles
SELECT AVG(currentSpeed) AS avg_speed FROM traffic_data;

-- Maximum and minimum speeds recorded
SELECT MAX(currentSpeed) AS max_speed, MIN(currentSpeed) AS min_speed FROM traffic_data;

-- Total sum of delay time across all vehicles
SELECT SUM(delay_time) AS total_delay FROM traffic_data;

-- Top 5 locations with the highest vehicle count
SELECT location_name, COUNT(*) AS vehicle_count  
FROM traffic_data  
GROUP BY location_name  
ORDER BY vehicle_count DESC  
LIMIT 5;

-- Average speed at each location
SELECT location_name, AVG(currentSpeed) AS avg_speed  
FROM traffic_data  
GROUP BY location_name  
ORDER BY avg_speed DESC;

-- Locations with highest and lowest delay times
SELECT location_name, AVG(delay_time) AS avg_delay  
FROM traffic_data  
GROUP BY location_name  
ORDER BY avg_delay DESC  
LIMIT 1;  -- Highest delay location

SELECT location_name, AVG(delay_time) AS avg_delay  
FROM traffic_data  
GROUP BY location_name  
ORDER BY avg_delay ASC  
LIMIT 1;  -- Lowest delay location

-- Total number of vehicles recorded per hour
SELECT HOUR(time) AS hour_of_day, COUNT(*) AS vehicle_count  
FROM traffic_data  
GROUP BY HOUR(time)  
ORDER BY hour_of_day;

--  Peak traffic hours (top 3 busiest hours)
SELECT HOUR(time) AS hour_of_day, COUNT(*) AS vehicle_count  
FROM traffic_data  
GROUP BY HOUR(time)  
ORDER BY vehicle_count DESC  
LIMIT 3;

-- Average speed per hour
SELECT HOUR(time) AS hour_of_day, AVG(currentSpeed) AS avg_speed  
FROM traffic_data  
GROUP BY HOUR(time)  
ORDER BY hour_of_day;

-- Speed ratio trends (average per location)
SELECT location_name, AVG(speed_ratio) AS avg_speed_ratio  
FROM traffic_data  
GROUP BY location_name  
ORDER BY avg_speed_ratio DESC;

-- Percentage of vehicles moving below free flow speed
SELECT  
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM traffic_data)) AS percentage_below_free_flow  
FROM traffic_data  
WHERE currentSpeed < freeFlowSpeed;

-- Fastest and slowest locations based on average speed
SELECT location_name, AVG(currentSpeed) AS avg_speed  
FROM traffic_data  
GROUP BY location_name  
ORDER BY avg_speed DESC  
LIMIT 1;  -- Fastest location

SELECT location_name, AVG(currentSpeed) AS avg_speed  
FROM traffic_data  
GROUP BY location_name  
ORDER BY avg_speed ASC  
LIMIT 1;  -- Slowest location

-- Vehicle congestion index (average delay per location)
SELECT location_name, AVG(delay_time) AS avg_delay  
FROM traffic_data  
GROUP BY location_name  
ORDER BY avg_delay DESC;










