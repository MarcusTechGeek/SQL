--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
--
-- Chapter 13 Code Examples
--------------------------------------------------------------

-- Commonly used string functions
-- Full list of functions available at:
-- https://www.postgresql.org/docs/current/static/functions-string.html

-- Case formatting functions examples
SELECT upper('Neal7');  -- Converts the string to uppercase
SELECT lower('Randy');  -- Converts the string to lowercase
SELECT initcap('at the end of the day');  -- Capitalizes the first letter of each word
SELECT initcap('Practical SQL');  -- Note initcap's behavior with acronyms (capitalizes 'SQL')

-- Character information functions examples
SELECT char_length(' Pat ');  -- Returns the number of characters, including spaces
SELECT length(' Pat ');  -- Synonym for char_length
SELECT position(', ' in 'Tan, Bella');  -- Finds the position of the substring ', '

-- Removing characters functions examples
SELECT trim('s' from 'socks');  -- Removes 's' from both ends of the string
SELECT trim(trailing 's' from 'socks');  -- Removes trailing 's' from the string
SELECT trim(' Pat ');  -- Removes leading and trailing spaces
SELECT char_length(trim(' Pat '));  -- Shows the length after trimming spaces
SELECT ltrim('socks', 's');  -- Removes leading 's' from the string
SELECT rtrim('socks', 's');  -- Removes trailing 's' from the string

-- Extracting and replacing characters functions examples
SELECT left('703-555-1212', 3);  -- Extracts the leftmost 3 characters
SELECT right('703-555-1212', 8);  -- Extracts the rightmost 8 characters
SELECT replace('bat', 'b', 'c');  -- Replaces 'b' with 'c'

-- Table 13-2: Regular Expression Matching Examples

-- Any character one or more times
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '.+');

-- One or two digits followed by a space and p.m.
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '\d{1,2} (?:a.m.|p.m.)');

-- One or more word characters at the start
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '^\w+');

-- One or more word characters followed by any character at the end.
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '\w+.$');

-- The words May or June
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from 'May|June');

-- Four digits
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '\d{4}');

-- May followed by a space, digit, comma, space, and four digits
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from 'May \d, \d{4}');

-- Turning Text to Data with Regular Expression Functions

-- Listing 13-2: Creating and loading the crime_reports table
-- Data source: https://sheriff.loudoun.gov/dailycrime

CREATE TABLE crime_reports (
    crime_id bigserial PRIMARY KEY,
    date_1 timestamp with time zone,
    date_2 timestamp with time zone,
    street varchar(250),
    city varchar(100),
    crime_type varchar(100),
    description text,
    case_number varchar(50),
    original_text text NOT NULL
);

-- Load data from a CSV file into the crime_reports table
COPY crime_reports (original_text)
FROM 'C:\YourDirectory\crime_reports.csv'
WITH (FORMAT CSV, HEADER OFF, QUOTE '"');

-- Select all original text entries from the crime_reports table
SELECT original_text FROM crime_reports;

-- Listing 13-3: Using regexp_match() to find the first date
SELECT crime_id,
       regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')  -- Finds the first date in the format mm/dd/yy
FROM crime_reports;

-- Listing 13-4: Using the regexp_matches() function with the 'g' flag
SELECT crime_id,
       regexp_matches(original_text, '\d{1,2}\/\d{1,2}\/\d{2}', 'g')  -- Finds all dates in the format mm/dd/yy
FROM crime_reports;

-- Listing 13-5: Using regexp_match() to find the second date
-- Note that the result includes an unwanted hyphen
SELECT crime_id,
       regexp_match(original_text, '-\d{1,2}\/\d{1,2}\/\d{1,2}')  -- Finds the second date preceded by a hyphen
FROM crime_reports;

-- Listing 13-6: Using a capture group to return only the date
-- Eliminates the hyphen
SELECT crime_id,
       regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})')  -- Captures and returns only the date, ignoring the hyphen
FROM crime_reports;

-- Listing 13-7: Matching case number, date, crime type, and city
SELECT
    regexp_match(original_text, '(?:C0|SO)[0-9]+') AS case_number,  -- Matches case numbers starting with C0 or SO
    regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,  -- Matches the first date
    regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,  -- Matches the crime type
    regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city  -- Matches the city name
FROM crime_reports;

-- Bonus: Get all parsed elements at once
SELECT crime_id,
       regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,  -- Matches the first date
       CASE WHEN EXISTS (SELECT regexp_matches(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})'))
            THEN regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})')
            ELSE NULL
            END AS date_2,  -- Matches the second date if it exists
       regexp_match(original_text, '\/\d{2}\n(\d{4})') AS hour_1,  -- Matches the first hour
       CASE WHEN EXISTS (SELECT regexp_matches(original_text, '\/\d{2}\n\d{4}-(\d{4})'))
            THEN regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})')
            ELSE NULL
            END AS hour_2,  -- Matches the second hour if it exists
       regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))') AS street,  -- Matches the street
       regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city,  -- Matches the city
       regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,  -- Matches the crime type
       regexp_match(original_text, ':\s(.+)(?:C0|SO)') AS description,  -- Matches the description
       regexp_match(original_text, '(?:C0|SO)[0-9]+') AS case_number  -- Matches the case number
FROM crime_reports;

-- Listing 13-8: Retrieving a value from within an array
SELECT
    crime_id,
    (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1] AS case_number  -- Retrieves the first element from the array returned by regexp_match
FROM crime_reports;

-- Listing 13-9: Updating the crime_reports date_1 column
UPDATE crime_reports
SET datestyle = 'ISO, MDY';  -- Sets the datestyle to ISO format with MDY order

UPDATE crime_reports
SET date_1 = 
(
    (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]  -- Matches the date
        || ' ' ||
    (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1]  -- Matches the hour
        ||' US/Eastern'
)::timestamptz;  -- Converts the concatenated string to a timestamp with time zone

SELECT crime_id,
       date_1,
       original_text
FROM crime_reports;

-- Listing 13-10: Updating all crime_reports columns
UPDATE crime_reports
SET date_1 = 
    (
      (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
          || ' ' ||
      (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
          ||' US/Eastern'
    )::timestamptz,
             
    date_2 = 
    CASE 
    -- If there is no second date but there is a second hour
        WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NULL)
                     AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
        THEN 
          ((regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
              || ' ' ||
          (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
              ||' US/Eastern'
          )::timestamptz 
    -- If there is both a second date and second hour
        WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NOT NULL)
              AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
        THEN 
          ((regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})'))[1]
              || ' ' ||
          (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
              ||' US/Eastern'
          )::timestamptz 
    -- If neither of those conditions exist, provide a NULL
        ELSE NULL 
    END,
    street = (regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1],  -- Matches the street
    city = (regexp_match(original_text,
                           '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n'))[1],  -- Matches the city
    crime_type = (regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):'))[1],  -- Matches the crime type
    description = (regexp_match(original_text, ':\s(.+)(?:C0|SO)'))[1],  -- Matches the description
    case_number = (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1];  -- Matches the case number

-- Listing 13-11: Viewing selected crime data
SELECT date_1,
       street,
       city,
       crime_type
FROM crime_reports;

-- Listing 13-12: Using regular expressions in a WHERE clause

-- Select counties with names containing 'lade' or 'lare'
SELECT geo_name
FROM us_counties_2010
WHERE geo_name ~* '(.+lade.+|.+lare.+)'
ORDER BY geo_name;

-- Select counties with names containing 'ash' but not starting with 'Wash'
SELECT geo_name
FROM us_counties_2010
WHERE geo_name ~* '.+ash.+' AND geo_name !~ 'Wash.+'
ORDER BY geo_name;

-- Listing 13-13: Regular expression functions to replace and split

-- Replace the year in the date string
SELECT regexp_replace('05/12/2018', '\d{4}', '2017');

-- Split the string into a table by commas
SELECT regexp_split_to_table('Four,score,and,seven,years,ago', ',');

-- Split the string into an array by spaces
SELECT regexp_split_to_array('Phil Mike Tony Steve', ' ');

-- Listing 13-14: Finding an array length
SELECT array_length(regexp_split_to_array('Phil Mike Tony Steve', ' '), 1);

-- FULL TEXT SEARCH

-- Full-text search operators:
-- & (AND)
-- | (OR)
-- ! (NOT)

-- Listing 13-15: Converting text to tsvector data
SELECT to_tsvector('I am walking across the sitting room to sit with you.');

-- Listing 13-16: Converting search terms to tsquery data
SELECT to_tsquery('walking & sitting');

-- Listing 13-17: Querying a tsvector type with a tsquery
SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('walking & sitting');

SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('walking & running');

-- Listing 13-18: Creating and filling the president_speeches table

-- Sources:
-- https://archive.org/details/State-of-the-Union-Addresses-1945-2006
-- http://www.presidency.ucsb.edu/ws/index.php
-- https://www.eisenhower.archives.gov/all_about_ike/speeches.html

CREATE TABLE president_speeches (
    sotu_id serial PRIMARY KEY,
    president varchar(100) NOT NULL,
    title varchar(250) NOT NULL,
    speech_date date NOT NULL,
    speech_text text NOT NULL,
    search_speech_text tsvector
);

-- Load data from a CSV file into the president_speeches table
COPY president_speeches (president, title, speech_date, speech_text)
FROM 'C:\YourDirectory\sotu-1946-1977.csv'
WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@');

-- Select all entries from the president_speeches table
SELECT * FROM president_speeches;

-- Listing 13-19: Converting speeches to tsvector in the search_speech_text column
UPDATE president_speeches
SET search_speech_text = to_tsvector('english', speech_text);

-- Listing 13-20: Creating a GIN index for text search
CREATE INDEX search_idx ON president_speeches USING gin(search_speech_text);

-- Listing 13-21: Finding speeches containing the word "Vietnam"
SELECT president, speech_date
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('Vietnam')
ORDER BY speech_date;

-- Listing 13-22: Displaying search results with ts_headline()
SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('Vietnam'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('Vietnam');

-- Listing 13-23: Finding speeches with the word "transportation" but not "roads"
SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('transportation & !roads'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('transportation & !roads');

-- Listing 13-24: Find speeches where "defense" follows "military"
SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('military <-> defense'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('military <-> defense');

-- Bonus: Example with a distance of 2
SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('military <2> defense'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=2')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('military <2> defense');

-- Listing 13-25: Scoring relevance with ts_rank()
SELECT president,
       speech_date,
       ts_rank(search_speech_text, to_tsquery('war & security & threat & enemy')) AS score
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5;

-- Listing 13-26: Normalizing ts_rank() by speech length
SELECT president,
       speech_date,
       ts_rank(search_speech_text, to_tsquery('war & security & threat & enemy'), 2)::numeric AS score
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5;
