--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 11 Code Examples
--------------------------------------------------------------

-- Listing 11-1: Extracting components of a timestamp value using date_part()

-- The date_part function extracts subfields such as year, month, day, etc., from a timestamp.
SELECT
    date_part('year', '2019-12-01 18:37:12 EST'::timestamptz) AS "year", -- Extracts the year part of the timestamp
    date_part('month', '2019-12-01 18:37:12 EST'::timestamptz) AS "month", -- Extracts the month part of the timestamp
    date_part('day', '2019-12-01 18:37:12 EST'::timestamptz) AS "day", -- Extracts the day part of the timestamp
    date_part('hour', '2019-12-01 18:37:12 EST'::timestamptz) AS "hour", -- Extracts the hour part of the timestamp
    date_part('minute', '2019-12-01 18:37:12 EST'::timestamptz) AS "minute", -- Extracts the minute part of the timestamp
    date_part('seconds', '2019-12-01 18:37:12 EST'::timestamptz) AS "seconds", -- Extracts the seconds part of the timestamp
    date_part('timezone_hour', '2019-12-01 18:37:12 EST'::timestamptz) AS "tz", -- Extracts the timezone hour part of the timestamp
    date_part('week', '2019-12-01 18:37:12 EST'::timestamptz) AS "week", -- Extracts the week part of the timestamp
    date_part('quarter', '2019-12-01 18:37:12 EST'::timestamptz) AS "quarter", -- Extracts the quarter part of the timestamp
    date_part('epoch', '2019-12-01 18:37:12 EST'::timestamptz) AS "epoch"; -- Extracts the epoch part of the timestamp (seconds since 1970-01-01 00:00:00 UTC)

-- Bonus: Using the SQL-standard extract() for similar datetime parsing:

-- The extract function is SQL-standard and serves a similar purpose to date_part.
SELECT extract('year' from '2019-12-01 18:37:12 EST'::timestamptz) AS "year"; -- Extracts the year part of the timestamp

-- Listing 11-2: Three functions for making datetimes from components

-- make_date constructs a date from year, month, and day.
SELECT make_date(2018, 2, 22); -- Creates the date 2018-02-22

-- make_time constructs a time from hour, minute, and seconds.
SELECT make_time(18, 4, 30.3); -- Creates the time 18:04:30.3

-- make_timestamptz constructs a timestamp with time zone from year, month, day, hour, minute, seconds, and time zone.
SELECT make_timestamptz(2018, 2, 22, 18, 4, 30.3, 'Europe/Lisbon'); -- Creates the timestamp 2018-02-22 18:04:30.3 in the 'Europe/Lisbon' time zone

-- Bonus: Retrieving the current date and time

-- These functions return the current date and time in various formats.
SELECT
    current_date, -- Returns the current date
    current_time, -- Returns the current time
    current_timestamp, -- Returns the current date and time (timestamp with time zone)
    localtime, -- Returns the current time without time zone
    localtimestamp, -- Returns the current date and time without time zone
    now(); -- Alias for current_timestamp

-- Listing 11-3: Comparing current_timestamp and clock_timestamp() during row insert

-- current_timestamp returns the same value for all instances in a transaction,
-- while clock_timestamp() returns the actual current time, reflecting the clock's progress.

-- Create a table to store timestamps.
CREATE TABLE current_time_example (
    time_id bigserial, -- Automatically incremented ID
    current_timestamp_col timestamp with time zone, -- Column to store current_timestamp
    clock_timestamp_col timestamp with time zone -- Column to store clock_timestamp()
);

-- Insert 1000 rows, each with current_timestamp and clock_timestamp().
INSERT INTO current_time_example (current_timestamp_col, clock_timestamp_col)
    (SELECT current_timestamp, -- Gets the same timestamp for the entire transaction
            clock_timestamp() -- Gets the actual current time for each row
     FROM generate_series(1,1000)); -- Generates a series of numbers from 1 to 1000

-- Select all rows from the table.
SELECT * FROM current_time_example;

-- Time Zones

-- Listing 11-4: Showing your PostgreSQL server's default time zone

SHOW timezone; -- Displays the server's default time zone setting
-- Note: You can see all run-time defaults with SHOW ALL;

-- Listing 11-5: Showing time zone abbreviations and names

-- Retrieve all time zone abbreviations.
SELECT * FROM pg_timezone_abbrevs;

-- Retrieve all time zone names.
SELECT * FROM pg_timezone_names;

-- Filter to find time zone names starting with 'Europe'.
SELECT * FROM pg_timezone_names
WHERE name LIKE 'Europe%';

-- Listing 11-6: Setting the time zone for a client session

-- Set the time zone for the current session to 'US/Pacific'.
SET timezone TO 'US/Pacific';

-- Create a table to test time zone changes.
CREATE TABLE time_zone_test (
    test_date timestamp with time zone -- Column to store timestamps with time zone
);

-- Insert a timestamp into the table.
INSERT INTO time_zone_test VALUES ('2020-01-01 4:00');

-- Select the timestamp from the table.
SELECT test_date
FROM time_zone_test;

-- Change the time zone for the session to 'US/Eastern'.
SET timezone TO 'US/Eastern';

-- Select the timestamp again to see the effect of the time zone change.
SELECT test_date
FROM time_zone_test;

-- Select the timestamp with a specific time zone.
SELECT test_date AT TIME ZONE 'Asia/Seoul'
FROM time_zone_test;

-- Math with dates!

-- Calculate the difference between two dates.
SELECT '9/30/1929'::date - '9/27/1929'::date; -- Returns 3 days

-- Add an interval to a date.
SELECT '9/30/1929'::date + '5 years'::interval; -- Returns the date 5 years later

-- Taxi Rides

-- Listing 11-7: Creating a table and importing NYC yellow taxi data

-- Create a table to store NYC yellow taxi trip data.
CREATE TABLE nyc_yellow_taxi_trips_2016_06_01 (
    trip_id bigserial PRIMARY KEY, -- Automatically incremented ID
    vendor_id varchar(1) NOT NULL, -- Vendor ID
    tpep_pickup_datetime timestamp with time zone NOT NULL, -- Pickup date and time
    tpep_dropoff_datetime timestamp with time zone NOT NULL, -- Dropoff date and time
    passenger_count integer NOT NULL, -- Number of passengers
    trip_distance numeric(8,2) NOT NULL, -- Distance of the trip
    pickup_longitude numeric(18,15) NOT NULL, -- Longitude of pickup location
    pickup_latitude numeric(18,15) NOT NULL, -- Latitude of pickup location
    rate_code_id varchar(2) NOT NULL, -- Rate code ID
    store_and_fwd_flag varchar(1) NOT NULL, -- Store and forward flag
    dropoff_longitude numeric(18,15) NOT NULL, -- Longitude of dropoff location
    dropoff_latitude numeric(18,15) NOT NULL, -- Latitude of dropoff location
    payment_type varchar(1) NOT NULL, -- Payment type
    fare_amount numeric(9,2) NOT NULL, -- Fare amount
    extra numeric(9,2) NOT NULL, -- Extra charges
    mta_tax numeric(5,2) NOT NULL, -- MTA tax
    tip_amount numeric(9,2) NOT NULL, -- Tip amount
    tolls_amount numeric(9,2) NOT NULL, -- Tolls amount
    improvement_surcharge numeric(9,2) NOT NULL, -- Improvement surcharge
    total_amount numeric(9,2) NOT NULL -- Total amount
);

-- Import data from a CSV file into the table.
COPY nyc_yellow_taxi_trips_2016_06_01 (
    vendor_id,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    pickup_longitude,
    pickup_latitude,
    rate_code_id,
    store_and_fwd_flag,
    dropoff_longitude,
    dropoff_latitude,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount
   )
FROM 'C:\YourDirectory\yellow_tripdata_2016_06_01.csv' -- Path to the CSV file
WITH (FORMAT CSV, HEADER, DELIMITER ','); -- CSV format, includes header, comma as delimiter

-- Create an index on the pickup datetime column to improve query performance.
CREATE INDEX tpep_pickup_idx
ON nyc_yellow_taxi_trips_2016_06_01 (tpep_pickup_datetime);

-- Count the number of rows in the table.
SELECT count(*) FROM nyc_yellow_taxi_trips_2016_06_01;

-- Listing 11-8: Counting taxi trips by hour

-- Group the data by hour of the pickup time and count the number of trips in each hour.
SELECT
    date_part('hour', tpep_pickup_datetime) AS trip_hour, -- Extracts the hour part of the pickup time
    count(*) -- Counts the number of trips
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_hour -- Groups by the extracted hour
ORDER BY trip_hour; -- Orders the result by hour

-- Listing 11-9: Exporting taxi pickups per hour to a CSV file

-- Export the count of taxi trips per hour to a CSV file.
COPY
    (SELECT
        date_part('hour', tpep_pickup_datetime) AS trip_hour, -- Extracts the hour part of the pickup time
        count(*) -- Counts the number of trips
    FROM nyc_yellow_taxi_trips_2016_06_01
    GROUP BY trip_hour -- Groups by the extracted hour
    ORDER BY trip_hour -- Orders the result by hour
    )
TO 'C:\YourDirectory\hourly_pickups_2016_06_01.csv' -- Path to the output CSV file
WITH (FORMAT CSV, HEADER, DELIMITER ','); -- CSV format, includes header, comma as delimiter

-- Listing 11-10: Calculating median trip time by hour

-- Calculate the median trip time for each hour of the pickup time.
SELECT
    date_part('hour', tpep_pickup_datetime) AS trip_hour, -- Extracts the hour part of the pickup time
    percentile_cont(.5)
        WITHIN GROUP (ORDER BY
            tpep_dropoff_datetime - tpep_pickup_datetime) AS median_trip -- Calculates the median trip time
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_hour -- Groups by the extracted hour
ORDER BY trip_hour; -- Orders the result by hour

-- Listing 11-11: Creating a table to hold train trip data

-- Set the time zone for the session to 'US/Central'.
SET timezone TO 'US/Central';

-- Create a table to store train trip data.
CREATE TABLE train_rides (
    trip_id bigserial PRIMARY KEY, -- Automatically incremented ID
    segment varchar(50) NOT NULL, -- Trip segment description
    departure timestamp with time zone NOT NULL, -- Departure date and time
    arrival timestamp with time zone NOT NULL -- Arrival date and time
);

-- Insert sample train trip data into the table.
INSERT INTO train_rides (segment, departure, arrival)
VALUES
    ('Chicago to New York', '2017-11-13 21:30 CST', '2017-11-14 18:23 EST'),
    ('New York to New Orleans', '2017-11-15 14:15 EST', '2017-11-16 19:32 CST'),
    ('New Orleans to Los Angeles', '2017-11-17 13:45 CST', '2017-11-18 9:00 PST'),
    ('Los Angeles to San Francisco', '2017-11-19 10:10 PST', '2017-11-19 21:24 PST'),
    ('San Francisco to Denver', '2017-11-20 9:10 PST', '2017-11-21 18:38 MST'),
    ('Denver to Chicago', '2017-11-22 19:10 MST', '2017-11-23 14:50 CST');

-- Select all rows from the train_rides table.
SELECT * FROM train_rides;

-- Listing 11-12: Calculating the length of each trip segment

-- Calculate the duration of each trip segment.
SELECT segment,
       to_char(departure, 'YYYY-MM-DD HH12:MI a.m. TZ') AS departure, -- Formats the departure time
       arrival - departure AS segment_time -- Calculates the trip duration
FROM train_rides;

-- Listing 11-13: Calculating cumulative intervals using OVER

-- Calculate the cumulative duration of the trip segments.
SELECT segment,
       arrival - departure AS segment_time, -- Calculates the trip duration
       sum(arrival - departure) OVER (ORDER BY trip_id) AS cume_time -- Calculates the cumulative duration
FROM train_rides;

-- Listing 11-14: Better formatting for cumulative trip time

-- Better format for the cumulative trip time, converting to seconds.
SELECT segment,
       arrival - departure AS segment_time, -- Calculates the trip duration
       sum(date_part('epoch', (arrival - departure))) -- Sums the trip durations in seconds
           OVER (ORDER BY trip_id) * interval '1 second' AS cume_time -- Converts the sum to an interval
FROM train_rides;
