--Create a DB
-- Create a schema
/* Create table called US_accident_4 */	
DROP TABLE IF EXISTS US_Accident_4;
CREATE TABLE US_Accident_4(
count_of_Bump BIGINT,
Count_of_Crossing SMALLINT,
count_Traffic_Signal BIGINT,
Country VARCHAR(15),
County VARCHAR(50),
Crossing BOOLEAN,
Description VARCHAR(300),
End_Lat FLOAT,
End_Lng FLOAT,
End_Time VARCHAR(50),
Give_Way BOOLEAN,
ID VARCHAR(10) PRIMARY KEY NOT NULL,
Junction BOOLEAN,
Nautical_Twilight CHAR(26),
No_Exit BOOLEAN,
Number INT,
Railway BOOLEAN,
Roundabout BOOLEAN,
Severity VARCHAR,
Side CHAR(10),
Source CHAR(15),
Start_Time VARCHAR(30),
State VARCHAR(4),
Station BOOLEAN,
Stop BOOLEAN,
Street VARCHAR(80),
Sunrise_Sunset CHAR(6),
Temperature FLOAT,
Timezone VARCHAR(30),
Traffic_Calming BOOLEAN,
Traffic_Signal BOOLEAN,
Turning_Loop BOOLEAN,
Visibility FLOAT,
Weather_Condition VARCHAR(240),
Weather_Timestamp VARCHAR(40),
Wind_Direction VARCHAR,
Zipcode VARCHAR,
Count_of_accidents INTEGER,
count_of_county BIGINT,
Distance FLOAT,
Humidity INTEGER,
Number_of_Records INT,
Precipitation VARCHAR,
Pressure FLOAT,
Records BIGINT,
Start_Lat FLOAT,
Start_Lng FLOAT,
TMC BIGINT,
Wind_Chill FLOAT,
Wind_Speed FLOAT
);
-- Copied data into the Db
COPY US_Accident_4
FROM 'C:\Users\Public\US_Accident_4.csv' 
DELIMITER ',' 
CSV HEADER;


-- preview all table in the db

SELECT *
FROM US_Accident_1
ORDER BY Airport_Code
LIMIT 10;

SELECT *
FROM US_Accident_2
ORDER BY Airport_Code
LIMIT 10;

SELECT *
FROM US_Accident_3
ORDER BY Airport_Code
LIMIT 10;

SELECT *
FROM US_Accident_4
ORDER BY Count_of_accidents
LIMIT 10;

DROP TABLE IF EXISTS Total_US_Accident;

SELECT A1.airport_code, A1.ID, A1.Astronomical_Twilight,A1.County,A2.Count_of_accidents,A2.Civil_Twilight, A3.Severity,A3.City,A4.Weather_condition, A4.Start_Time INTO Total_US_Accident
FROM US_Accident_1 AS A1
FULL JOIN US_Accident_2 AS A2 ON A1.Id = A2.Id
FULL JOIN US_Accident_3 AS A3 ON A1.Id = A3.Id
FULL JOIN US_Accident_4 AS A4 ON A1.Id = A4.Id

--total COUNT of accidents that happened during the day?
SELECT*
FROM US_Accident_1
WHERE Civil_Twilight ='Day';


--Find the sum of accidents that occurred Tarrant County.
SELECT SUM(count_of_accidents::integer) AS sum_count_of_accidents, county
FROM Total_US_Accident
WHERE county = 'Tarrant'
GROUP BY county;

--total COUNT of accidents that happened during the day BY Count?
SELECT SUM(CAST(count_of_accidents AS integer)) AS sum_count_of_accidents, astronomical_twilight
FROM Total_US_Accident
WHERE astronomical_twilight = 'Day'
GROUP BY astronomical_twilight;

--total COUNT of accidents that happened during the day BY Count?
SELECT SUM(CAST(count_of_accidents AS integer)) AS sum_count_of_accidents, astronomical_twilight
FROM Total_US_Accident
WHERE astronomical_twilight = 'Night'
GROUP BY astronomical_twilight;

--Accident by weather condition and severity
SELECT SUM(count_of_accidents::integer) AS total_accidents, severity, weather_condition
FROM Total_US_Accident
WHERE severity > 1
  AND weather_condition = 'Mostly Cloudy'
GROUP BY severity,weather_condition;




--Total accident according to monthh of the year
SELECT EXTRACT(MONTH FROM TO_TIMESTAMP(start_time, 'MM-DD-YYYY HH24:MI')) AS month,
       COUNT(*) AS total_accidents
FROM Total_US_Accident
GROUP BY month
ORDER BY month;

-- Accident by CITY	
SELECT city, COUNT(*) AS total_accidents
FROM Total_US_Accident
GROUP BY city
ORDER BY total_accidents DESC;

--Total accident according to hour of the day
SELECT EXTRACT(HOUR FROM TO_TIMESTAMP(start_time, 'MM-DD-YYYY HH24:MI')) AS hour_of_day, COUNT(*) AS total_accidents
FROM Total_US_Accident
GROUP BY hour_of_day
ORDER BY hour_of_day;
