--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 8 Code Examples
--------------------------------------------------------------

-- Listing 8-1: Creating and filling the 2014 Public Libraries Survey table

-- Create the 2014 Public Libraries Survey table with detailed columns
CREATE TABLE pls_fy2014_pupld14a (
    stabr varchar(2) NOT NULL, -- State abbreviation
    fscskey varchar(6) CONSTRAINT fscskey2014_key PRIMARY KEY, -- Unique library key
    libid varchar(20) NOT NULL, -- Library ID
    libname varchar(100) NOT NULL, -- Library name
    obereg varchar(2) NOT NULL, -- Office of Education region
    rstatus integer NOT NULL, -- Regional status
    statstru varchar(2) NOT NULL, -- Status structure
    statname varchar(2) NOT NULL, -- Status name
    stataddr varchar(2) NOT NULL, -- Status address
    longitud numeric(10,7) NOT NULL, -- Longitude
    latitude numeric(10,7) NOT NULL, -- Latitude
    fipsst varchar(2) NOT NULL, -- FIPS state code
    fipsco varchar(3) NOT NULL, -- FIPS county code
    address varchar(35) NOT NULL, -- Library address
    city varchar(20) NOT NULL, -- City
    zip varchar(5) NOT NULL, -- Zip code
    zip4 varchar(4) NOT NULL, -- Zip+4 code
    cnty varchar(20) NOT NULL, -- County
    phone varchar(10) NOT NULL, -- Phone number
    c_relatn varchar(2) NOT NULL, -- Central library relation
    c_legbas varchar(2) NOT NULL, -- Central library legal basis
    c_admin varchar(2) NOT NULL, -- Central library administration
    geocode varchar(3) NOT NULL, -- Geocode
    lsabound varchar(1) NOT NULL, -- LSA boundary
    startdat varchar(10), -- Start date
    enddate varchar(10), -- End date
    popu_lsa integer NOT NULL, -- Population served
    centlib integer NOT NULL, -- Number of central libraries
    branlib integer NOT NULL, -- Number of branch libraries
    bkmob integer NOT NULL, -- Number of bookmobiles
    master numeric(8,2) NOT NULL, -- Master librarian FTE
    libraria numeric(8,2) NOT NULL, -- Librarian FTE
    totstaff numeric(8,2) NOT NULL, -- Total staff FTE
    locgvt integer NOT NULL, -- Local government revenue
    stgvt integer NOT NULL, -- State government revenue
    fedgvt integer NOT NULL, -- Federal government revenue
    totincm integer NOT NULL, -- Total income
    salaries integer, -- Salaries
    benefit integer, -- Benefits
    staffexp integer, -- Staff expenditures
    prmatexp integer NOT NULL, -- Print material expenditures
    elmatexp integer NOT NULL, -- Electronic material expenditures
    totexpco integer NOT NULL, -- Total expenditures
    totopexp integer NOT NULL, -- Total operating expenditures
    lcap_rev integer NOT NULL, -- Local capital revenue
    scap_rev integer NOT NULL, -- State capital revenue
    fcap_rev integer NOT NULL, -- Federal capital revenue
    cap_rev integer NOT NULL, -- Total capital revenue
    capital integer NOT NULL, -- Capital expenditures
    bkvol integer NOT NULL, -- Book volumes
    ebook integer NOT NULL, -- E-books
    audio_ph integer NOT NULL, -- Physical audio
    audio_dl float NOT NULL, -- Downloadable audio
    video_ph integer NOT NULL, -- Physical video
    video_dl float NOT NULL, -- Downloadable video
    databases integer NOT NULL, -- Databases
    subscrip integer NOT NULL, -- Subscriptions
    hrs_open integer NOT NULL, -- Hours open
    visits integer NOT NULL, -- Visits
    referenc integer NOT NULL, -- Reference transactions
    regbor integer NOT NULL, -- Registered borrowers
    totcir integer NOT NULL, -- Total circulation
    kidcircl integer NOT NULL, -- Kids circulation
    elmatcir integer NOT NULL, -- Electronic material circulation
    loanto integer NOT NULL, -- Loans to other libraries
    loanfm integer NOT NULL, -- Loans from other libraries
    totpro integer NOT NULL, -- Total programs
    totatten integer NOT NULL, -- Total attendance
    gpterms integer NOT NULL, -- General public terminals
    pitusr integer NOT NULL, -- Public Internet terminal users
    wifisess integer NOT NULL, -- Wi-Fi sessions
    yr_sub integer NOT NULL -- Year submitted
);

-- Create indexes on commonly queried columns to improve performance
CREATE INDEX libname2014_idx ON pls_fy2014_pupld14a (libname);
CREATE INDEX stabr2014_idx ON pls_fy2014_pupld14a (stabr);
CREATE INDEX city2014_idx ON pls_fy2014_pupld14a (city);
CREATE INDEX visits2014_idx ON pls_fy2014_pupld14a (visits);

-- Load data from a CSV file into the 2014 table
COPY pls_fy2014_pupld14a
FROM 'C:\YourDirectory\pls_fy2014_pupld14a.csv'
WITH (FORMAT CSV, HEADER);

-- Listing 8-2: Creating and filling the 2009 Public Libraries Survey table

-- Create the 2009 Public Libraries Survey table with detailed columns
CREATE TABLE pls_fy2009_pupld09a (
    stabr varchar(2) NOT NULL, -- State abbreviation
    fscskey varchar(6) CONSTRAINT fscskey2009_key PRIMARY KEY, -- Unique library key
    libid varchar(20) NOT NULL, -- Library ID
    libname varchar(100) NOT NULL, -- Library name
    address varchar(35) NOT NULL, -- Library address
    city varchar(20) NOT NULL, -- City
    zip varchar(5) NOT NULL, -- Zip code
    zip4 varchar(4) NOT NULL, -- Zip+4 code
    cnty varchar(20) NOT NULL, -- County
    phone varchar(10) NOT NULL, -- Phone number
    c_relatn varchar(2) NOT NULL, -- Central library relation
    c_legbas varchar(2) NOT NULL, -- Central library legal basis
    c_admin varchar(2) NOT NULL, -- Central library administration
    geocode varchar(3) NOT NULL, -- Geocode
    lsabound varchar(1) NOT NULL, -- LSA boundary
    startdat varchar(10), -- Start date
    enddate varchar(10), -- End date
    popu_lsa integer NOT NULL, -- Population served
    centlib integer NOT NULL, -- Number of central libraries
    branlib integer NOT NULL, -- Number of branch libraries
    bkmob integer NOT NULL, -- Number of bookmobiles
    master numeric(8,2) NOT NULL, -- Master librarian FTE
    libraria numeric(8,2) NOT NULL, -- Librarian FTE
    totstaff numeric(8,2) NOT NULL, -- Total staff FTE
    locgvt integer NOT NULL, -- Local government revenue
    stgvt integer NOT NULL, -- State government revenue
    fedgvt integer NOT NULL, -- Federal government revenue
    totincm integer NOT NULL, -- Total income
    salaries integer, -- Salaries
    benefit integer, -- Benefits
    staffexp integer, -- Staff expenditures
    prmatexp integer NOT NULL, -- Print material expenditures
    elmatexp integer NOT NULL, -- Electronic material expenditures
    totexpco integer NOT NULL, -- Total expenditures
    totopexp integer NOT NULL, -- Total operating expenditures
    lcap_rev integer NOT NULL, -- Local capital revenue
    scap_rev integer NOT NULL, -- State capital revenue
    fcap_rev integer NOT NULL, -- Federal capital revenue
    cap_rev integer NOT NULL, -- Total capital revenue
    capital integer NOT NULL, -- Capital expenditures
    bkvol integer NOT NULL, -- Book volumes
    ebook integer NOT NULL, -- E-books
    audio integer NOT NULL, -- Audio materials
    video integer NOT NULL, -- Video materials
    databases integer NOT NULL, -- Databases
    subscrip integer NOT NULL, -- Subscriptions
    hrs_open integer NOT NULL, -- Hours open
    visits integer NOT NULL, -- Visits
    referenc integer NOT NULL, -- Reference transactions
    regbor integer NOT NULL, -- Registered borrowers
    totcir integer NOT NULL, -- Total circulation
    kidcircl integer NOT NULL, -- Kids circulation
    loanto integer NOT NULL, -- Loans to other libraries
    loanfm integer NOT NULL, -- Loans from other libraries
    totpro integer NOT NULL, -- Total programs
    totatten integer NOT NULL, -- Total attendance
    gpterms integer NOT NULL, -- General public terminals
    pitusr integer NOT NULL, -- Public Internet terminal users
    yr_sub integer NOT NULL, -- Year submitted
    obereg varchar(2) NOT NULL, -- Office of Education region
    rstatus integer NOT NULL, -- Regional status
    statstru varchar(2) NOT NULL, -- Status structure
    statname varchar(2) NOT NULL, -- Status name
    stataddr varchar(2) NOT NULL, -- Status address
    longitud numeric(10,7) NOT NULL, -- Longitude
    latitude numeric(10,7) NOT NULL, -- Latitude
    fipsst varchar(2) NOT NULL, -- FIPS state code
    fipsco varchar(3) NOT NULL -- FIPS county code
);

-- Create indexes on commonly queried columns to improve performance
CREATE INDEX libname2009_idx ON pls_fy2009_pupld09a (libname);
CREATE INDEX stabr2009_idx ON pls_fy2009_pupld09a (stabr);
CREATE INDEX city2009_idx ON pls_fy2009_pupld09a (city);
CREATE INDEX visits2009_idx ON pls_fy2009_pupld09a (visits);

-- Load data from a CSV file into the 2009 table
COPY pls_fy2009_pupld09a
FROM 'C:\YourDirectory\pls_fy2009_pupld09a.csv'
WITH (FORMAT CSV, HEADER);

-- Listing 8-3: Using count() for table row counts

-- Count the number of rows in the 2014 table
SELECT count(*)
FROM pls_fy2014_pupld14a;

-- Count the number of rows in the 2009 table
SELECT count(*)
FROM pls_fy2009_pupld09a;

-- Listing 8-4: Using count() for the number of values in a column

-- Count the number of non-null values in the salaries column of the 2014 table
SELECT count(salaries)
FROM pls_fy2014_pupld14a;

-- Listing 8-5: Using count() for the number of distinct values in a column

-- Count the total number of library names in the 2014 table (including duplicates)
SELECT count(libname)
FROM pls_fy2014_pupld14a;

-- Count the number of distinct library names in the 2014 table
SELECT count(DISTINCT libname)
FROM pls_fy2014_pupld14a;

-- Bonus: find duplicate libnames
-- Find and count duplicate library names
SELECT libname, count(libname)
FROM pls_fy2014_pupld14a
GROUP BY libname
ORDER BY count(libname) DESC;

-- Bonus: see location of every Oxford Public Library
-- Find the city and state abbreviation for every Oxford Public Library
SELECT libname, city, stabr
FROM pls_fy2014_pupld14a
WHERE libname = 'OXFORD PUBLIC LIBRARY';

-- Listing 8-6: Finding the most and fewest visits using max() and min()
-- Find the maximum and minimum number of visits among all libraries in 2014
SELECT max(visits), min(visits)
FROM pls_fy2014_pupld14a;

-- Listing 8-7: Using GROUP BY on the stabr column

-- There are 56 unique state abbreviations in 2014.
SELECT stabr
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY stabr;

-- Bonus: there are 55 unique state abbreviations in 2009.
SELECT stabr
FROM pls_fy2009_pupld09a
GROUP BY stabr
ORDER BY stabr;

-- Listing 8-8: Using GROUP BY on the city and stabr columns

-- Group by city and state abbreviation, then order by city and state abbreviation
SELECT city, stabr
FROM pls_fy2014_pupld14a
GROUP BY city, stabr
ORDER BY city, stabr;

-- Bonus: We can count some of the combos
-- Group by city and state abbreviation, count the number of libraries in each group
SELECT city, stabr, count(*)
FROM pls_fy2014_pupld14a
GROUP BY city, stabr
ORDER BY count(*) DESC;

-- Listing 8-9: GROUP BY with count() on the stabr column

-- Group by state abbreviation and count the number of libraries in each state, ordered by count
SELECT stabr, count(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY count(*) DESC;

-- Listing 8-10: GROUP BY with count() on the stabr and stataddr columns

-- Group by state abbreviation and status address, count the number of libraries in each group
SELECT stabr, stataddr, count(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr, stataddr
ORDER BY stabr ASC, count(*) DESC;

-- Listing 8-11: Using the sum() aggregate function to total visits to libraries in 2014 and 2009

-- 2014
-- Sum the total number of visits in 2014, excluding negative values
SELECT sum(visits) AS visits_2014
FROM pls_fy2014_pupld14a
WHERE visits >= 0;

-- 2009
-- Sum the total number of visits in 2009, excluding negative values
SELECT sum(visits) AS visits_2009
FROM pls_fy2009_pupld09a
WHERE visits >= 0;

-- Listing 8-12: Using sum() to total visits on joined 2014 and 2009 library tables

-- Sum the total number of visits in 2014 and 2009 for libraries that exist in both years
SELECT sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0;

-- Listing 8-13: Using GROUP BY to track percent change in library visits by state

-- Calculate the percentage change in visits from 2009 to 2014 by state
SELECT pls14.stabr,
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.stabr
ORDER BY pct_change DESC;

-- Listing 8-14: Using HAVING to filter the results of an aggregate query

-- Calculate the percentage change in visits for states with more than 50 million visits in 2014
SELECT pls14.stabr,
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.stabr
HAVING sum(pls14.visits) > 50000000
ORDER BY pct_change DESC;
