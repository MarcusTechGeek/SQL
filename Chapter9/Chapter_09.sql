--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 9 Code Examples
--------------------------------------------------------------

-- Listing 9-1: Importing the FSIS Meat, Poultry, and Egg Inspection Directory
-- Source: https://catalog.data.gov/dataset/meat-poultry-and-egg-inspection-directory-by-establishment-name

-- Create the meat_poultry_egg_inspect table with appropriate columns and constraints
CREATE TABLE meat_poultry_egg_inspect (
    est_number varchar(50) CONSTRAINT est_number_key PRIMARY KEY, -- Establishment number
    company varchar(100), -- Company name
    street varchar(100), -- Street address
    city varchar(30), -- City
    st varchar(2), -- State abbreviation
    zip varchar(5), -- Zip code
    phone varchar(14), -- Phone number
    grant_date date, -- Grant date
    activities text, -- Activities
    dbas text -- Doing business as
);

-- Load data from a CSV file into the meat_poultry_egg_inspect table
COPY meat_poultry_egg_inspect
FROM 'C:\YourDirectory\MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- Create an index on the company column to improve query performance
CREATE INDEX company_idx ON meat_poultry_egg_inspect (company);

-- Count the number of rows imported
SELECT count(*) FROM meat_poultry_egg_inspect;

-- Listing 9-2: Finding multiple companies at the same address
-- Group by company, street, city, and state to find multiple companies at the same address
SELECT company,
       street,
       city,
       st,
       count(*) AS address_count
FROM meat_poultry_egg_inspect
GROUP BY company, street, city, st
HAVING count(*) > 1
ORDER BY company, street, city, st;

-- Listing 9-3: Grouping and counting states
-- Group by state and count the number of establishments in each state
SELECT st, 
       count(*) AS st_count
FROM meat_poultry_egg_inspect
GROUP BY st
ORDER BY st;

-- Listing 9-4: Using IS NULL to find missing values in the st column
-- Find rows where the state abbreviation (st) is missing
SELECT est_number,
       company,
       city,
       st,
       zip
FROM meat_poultry_egg_inspect
WHERE st IS NULL;

-- Listing 9-5: Using GROUP BY and count() to find inconsistent company names
-- Group by company and count the number of occurrences of each company name
SELECT company,
       count(*) AS company_count
FROM meat_poultry_egg_inspect
GROUP BY company
ORDER BY company ASC;

-- Listing 9-6: Using length() and count() to test the zip column
-- Group by the length of the zip code and count the number of occurrences of each length
SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_inspect
GROUP BY length(zip)
ORDER BY length(zip) ASC;

-- Listing 9-7: Filtering with length() to find short zip values
-- Find states with zip codes shorter than 5 characters
SELECT st,
       count(*) AS st_count
FROM meat_poultry_egg_inspect
WHERE length(zip) < 5
GROUP BY st
ORDER BY st ASC;

-- Listing 9-8: Backing up a table
-- Create a backup of the meat_poultry_egg_inspect table
CREATE TABLE meat_poultry_egg_inspect_backup AS
SELECT * FROM meat_poultry_egg_inspect;

-- Check the number of records in the original and backup tables
SELECT 
    (SELECT count(*) FROM meat_poultry_egg_inspect) AS original,
    (SELECT count(*) FROM meat_poultry_egg_inspect_backup) AS backup;

-- Listing 9-9: Creating and filling the st_copy column with ALTER TABLE and UPDATE
-- Add a new column st_copy to the meat_poultry_egg_inspect table
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN st_copy varchar(2);

-- Copy the values from the st column to the st_copy column
UPDATE meat_poultry_egg_inspect
SET st_copy = st;

-- Listing 9-10: Checking values in the st and st_copy columns
-- Select and compare the values in the st and st_copy columns
SELECT st,
       st_copy
FROM meat_poultry_egg_inspect
ORDER BY st;

-- Listing 9-11: Updating the st column for three establishments
-- Update the state (st) for specific establishments
UPDATE meat_poultry_egg_inspect
SET st = 'MN'
WHERE est_number = 'V18677A';

UPDATE meat_poultry_egg_inspect
SET st = 'AL'
WHERE est_number = 'M45319+P45319';

UPDATE meat_poultry_egg_inspect
SET st = 'WI'
WHERE est_number = 'M263A+P263A+V263A';

-- Listing 9-12: Restoring original st column values
-- Restore original state values from the st_copy column
UPDATE meat_poultry_egg_inspect
SET st = st_copy;

-- Restore original state values from the backup table
UPDATE meat_poultry_egg_inspect original
SET st = backup.st
FROM meat_poultry_egg_inspect_backup backup
WHERE original.est_number = backup.est_number; 

-- Listing 9-13: Creating and filling the company_standard column
-- Add a new column company_standard to the meat_poultry_egg_inspect table
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN company_standard varchar(100);

-- Copy the values from the company column to the company_standard column
UPDATE meat_poultry_egg_inspect
SET company_standard = company;

-- Listing 9-14: Use UPDATE to modify field values that match a string
-- Update the company_standard column for companies that start with 'Armour'
UPDATE meat_poultry_egg_inspect
SET company_standard = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%';

-- Select and display the updated company and company_standard values
SELECT company, company_standard
FROM meat_poultry_egg_inspect
WHERE company LIKE 'Armour%';

-- Listing 9-15: Creating and filling the zip_copy column
-- Add a new column zip_copy to the meat_poultry_egg_inspect table
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN zip_copy varchar(5);

-- Copy the values from the zip column to the zip_copy column
UPDATE meat_poultry_egg_inspect
SET zip_copy = zip;

-- Listing 9-16: Modify codes in the zip column missing two leading zeros
-- Add two leading zeros to zip codes that are 3 characters long in PR and VI
UPDATE meat_poultry_egg_inspect
SET zip = '00' || zip
WHERE st IN('PR','VI') AND length(zip) = 3;

-- Listing 9-17: Modify codes in the zip column missing one leading zero
-- Add one leading zero to zip codes that are 4 characters long in certain states
UPDATE meat_poultry_egg_inspect
SET zip = '0' || zip
WHERE st IN('CT','MA','ME','NH','NJ','RI','VT') AND length(zip) = 4;

-- Listing 9-18: Creating and filling a state_regions table
-- Create the state_regions table with state and region columns
CREATE TABLE state_regions (
    st varchar(2) CONSTRAINT st_key PRIMARY KEY, -- State abbreviation
    region varchar(20) NOT NULL -- Region name
);

-- Load data from a CSV file into the state_regions table
COPY state_regions
FROM 'C:\YourDirectory\state_regions.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- Listing 9-19: Adding and updating an inspection_date column
-- Add a new column inspection_date to the meat_poultry_egg_inspect table
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN inspection_date date;

-- Update the inspection_date column for establishments in the New England region
UPDATE meat_poultry_egg_inspect inspect
SET inspection_date = '2019-12-01'
WHERE EXISTS (SELECT state_regions.region
              FROM state_regions
              WHERE inspect.st = state_regions.st 
                    AND state_regions.region = 'New England');

-- Listing 9-20: Viewing updated inspection_date values
-- Select and group by state and inspection_date to view updated values
SELECT st, inspection_date
FROM meat_poultry_egg_inspect
GROUP BY st, inspection_date
ORDER BY st;

-- Listing 9-21: Delete rows matching an expression
-- Delete rows where the state abbreviation is PR or VI
DELETE FROM meat_poultry_egg_inspect
WHERE st IN('PR','VI');

-- Listing 9-22: Remove a column from a table using DROP
-- Drop the zip_copy column from the meat_poultry_egg_inspect table
ALTER TABLE meat_poultry_egg_inspect DROP COLUMN zip_copy;

-- Listing 9-23: Remove a table from a database using DROP
-- Drop the meat_poultry_egg_inspect_backup table
DROP TABLE meat_poultry_egg_inspect_backup;

-- Listing 9-24: Demonstrating a transaction block
-- Start a transaction and perform an update
START TRANSACTION;

UPDATE meat_poultry_egg_inspect
SET company = 'AGRO Merchants Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

-- View changes
SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- Revert changes
ROLLBACK;

-- See restored state
SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- Alternately, commit changes at the end
START TRANSACTION;

UPDATE meat_poultry_egg_inspect
SET company = 'AGRO Merchants Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

COMMIT;

-- Listing 9-25: Backing up a table while adding and filling a new column
-- Create a backup of the meat_poultry_egg_inspect table with an additional reviewed_date column
CREATE TABLE meat_poultry_egg_inspect_backup AS
SELECT *,
       '2018-02-07'::date AS reviewed_date
FROM meat_poultry_egg_inspect;

-- Listing 9-26: Swapping table names using ALTER TABLE
-- Rename the meat_poultry_egg_inspect table to meat_poultry_egg_inspect_temp
ALTER TABLE meat_poultry_egg_inspect RENAME TO meat_poultry_egg_inspect_temp;

-- Rename the backup table to meat_poultry_egg_inspect
ALTER TABLE meat_poultry_egg_inspect_backup RENAME TO meat_poultry_egg_inspect;

-- Rename the temporary table to meat_poultry_egg_inspect_backup
ALTER TABLE meat_poultry_egg_inspect_temp RENAME TO meat_poultry_egg_inspect_backup;
