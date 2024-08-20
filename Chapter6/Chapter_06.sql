--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 6 Code Examples
--------------------------------------------------------------

-- Listing 6-1: Creating the departments and employees tables

-- Create the 'departments' table with primary key and unique constraints
CREATE TABLE departments (
    dept_id bigserial, -- Auto-incrementing department ID
    dept varchar(100), -- Department name
    city varchar(100), -- City where the department is located
    CONSTRAINT dept_key PRIMARY KEY (dept_id), -- Primary key on dept_id
    CONSTRAINT dept_city_unique UNIQUE (dept, city) -- Unique constraint on dept and city combination
);

-- Create the 'employees' table with foreign key and unique constraints
CREATE TABLE employees (
    emp_id bigserial, -- Auto-incrementing employee ID
    first_name varchar(100), -- Employee's first name
    last_name varchar(100), -- Employee's last name
    salary integer, -- Employee's salary
    dept_id integer REFERENCES departments (dept_id), -- Foreign key referencing dept_id in departments
    CONSTRAINT emp_key PRIMARY KEY (emp_id), -- Primary key on emp_id
    CONSTRAINT emp_dept_unique UNIQUE (emp_id, dept_id) -- Unique constraint on emp_id and dept_id combination
);

-- Insert records into the 'departments' table
INSERT INTO departments (dept, city)
VALUES
    ('Tax', 'Atlanta'),
    ('IT', 'Boston');

-- Insert records into the 'employees' table
INSERT INTO employees (first_name, last_name, salary, dept_id)
VALUES
    ('Nancy', 'Jones', 62500, 1),
    ('Lee', 'Smith', 59300, 1),
    ('Soo', 'Nguyen', 83000, 2),
    ('Janet', 'King', 95000, 2);

-- Listing 6-2: Joining the employees and departments tables

-- Join 'employees' and 'departments' tables on dept_id and select all columns
SELECT *
FROM employees JOIN departments
ON employees.dept_id = departments.dept_id;

-- Listing 6-3: Creating two tables to explore JOIN types

-- Create the 'schools_left' table with primary key
CREATE TABLE schools_left (
    id integer CONSTRAINT left_id_key PRIMARY KEY, -- Primary key on id
    left_school varchar(30) -- Name of the school
);

-- Create the 'schools_right' table with primary key
CREATE TABLE schools_right (
    id integer CONSTRAINT right_id_key PRIMARY KEY, -- Primary key on id
    right_school varchar(30) -- Name of the school
);

-- Insert records into the 'schools_left' table
INSERT INTO schools_left (id, left_school) VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (5, 'Washington Middle School'),
    (6, 'Jefferson High School');

-- Insert records into the 'schools_right' table
INSERT INTO schools_right (id, right_school) VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (3, 'Morrison Elementary'),
    (4, 'Chase Magnet Academy'),
    (6, 'Jefferson High School');

-- Listing 6-4: Using JOIN

-- Perform an inner join on 'schools_left' and 'schools_right' tables on id and select all columns
SELECT *
FROM schools_left JOIN schools_right
ON schools_left.id = schools_right.id;

-- Bonus: Also can be specified as INNER JOIN

-- Perform an explicit INNER JOIN on 'schools_left' and 'schools_right' tables on id and select all columns
SELECT *
FROM schools_left INNER JOIN schools_right
ON schools_left.id = schools_right.id;

-- Listing 6-5: Using LEFT JOIN

-- Perform a LEFT JOIN on 'schools_left' and 'schools_right' tables on id and select all columns
SELECT *
FROM schools_left LEFT JOIN schools_right
ON schools_left.id = schools_right.id;

-- Listing 6-6: Using RIGHT JOIN

-- Perform a RIGHT JOIN on 'schools_left' and 'schools_right' tables on id and select all columns
SELECT *
FROM schools_left RIGHT JOIN schools_right
ON schools_left.id = schools_right.id;

-- Listing 6-7: Using FULL OUTER JOIN

-- Perform a FULL OUTER JOIN on 'schools_left' and 'schools_right' tables on id and select all columns
SELECT *
FROM schools_left FULL OUTER JOIN schools_right
ON schools_left.id = schools_right.id;

-- Listing 6-8: Using CROSS JOIN

-- Perform a CROSS JOIN on 'schools_left' and 'schools_right' tables and select all columns
SELECT *
FROM schools_left CROSS JOIN schools_right;

-- Listing 6-9: Filtering to show missing values with IS NULL

-- Perform a LEFT JOIN and filter results to show rows where the right table id is NULL
SELECT *
FROM schools_left LEFT JOIN schools_right
ON schools_left.id = schools_right.id
WHERE schools_right.id IS NULL;

-- Listing 6-10: Querying specific columns in a join

-- Perform a LEFT JOIN and select specific columns from 'schools_left' and 'schools_right' tables
SELECT schools_left.id,
       schools_left.left_school,
       schools_right.right_school
FROM schools_left LEFT JOIN schools_right
ON schools_left.id = schools_right.id;

-- Listing 6-11: Simplifying code with table aliases

-- Perform a LEFT JOIN using table aliases and select specific columns
SELECT lt.id,
       lt.left_school,
       rt.right_school
FROM schools_left AS lt LEFT JOIN schools_right AS rt
ON lt.id = rt.id;

-- Listing 6-12: Joining multiple tables

-- Create the 'schools_enrollment' table
CREATE TABLE schools_enrollment (
    id integer, -- ID of the school
    enrollment integer -- Enrollment number
);

-- Create the 'schools_grades' table
CREATE TABLE schools_grades (
    id integer, -- ID of the school
    grades varchar(10) -- Grades offered
);

-- Insert records into the 'schools_enrollment' table
INSERT INTO schools_enrollment (id, enrollment)
VALUES
    (1, 360),
    (2, 1001),
    (5, 450),
    (6, 927);

-- Insert records into the 'schools_grades' table
INSERT INTO schools_grades (id, grades)
VALUES
    (1, 'K-3'),
    (2, '9-12'),
    (5, '6-8'),
    (6, '9-12');

-- Perform multiple LEFT JOINs and select specific columns from all tables
SELECT lt.id, lt.left_school, en.enrollment, gr.grades
FROM schools_left AS lt LEFT JOIN schools_enrollment AS en
    ON lt.id = en.id
LEFT JOIN schools_grades AS gr
    ON lt.id = gr.id;

-- Listing 6-13: Performing math on joined Census tables
-- Decennial Census 2000. Full data dictionary at https://www.census.gov/prod/cen2000/doc/pl94-171.pdf
-- Note: Some non-number columns have been given more descriptive names

-- Create the 'us_counties_2000' table to store census data
CREATE TABLE us_counties_2000 (
    geo_name varchar(90),              -- County/state name
    state_us_abbreviation varchar(2),  -- State/U.S. abbreviation
    state_fips varchar(2),             -- State FIPS code
    county_fips varchar(3),            -- County code
    p0010001 integer,                  -- Total population
    p0010002 integer,                  -- Population of one race:
    p0010003 integer,                      -- White Alone
    p0010004 integer,                      -- Black or African American alone
    p0010005 integer,                      -- American Indian and Alaska Native alone
    p0010006 integer,                      -- Asian alone
    p0010007 integer,                      -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,                      -- Some Other Race alone
    p0010009 integer,                  -- Population of two or more races
    p0010010 integer,                  -- Population of two races
    p0020002 integer,                  -- Hispanic or Latino
    p0020003 integer                   -- Not Hispanic or Latino:
);

-- Copy data from a CSV file into the 'us_counties_2000' table
COPY us_counties_2000
FROM 'C:\YourDirectory\us_counties_2000.csv'
WITH (FORMAT CSV, HEADER);

-- Perform an INNER JOIN on 2010 and 2000 census tables, calculate population changes, and order by percentage change
SELECT c2010.geo_name,
       c2010.state_us_abbreviation AS state,
       c2010.p0010001 AS pop_2010,
       c2000.p0010001 AS pop_2000,
       c2010.p0010001 - c2000.p0010001 AS raw_change, -- Calculate raw population change
       round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
           / c2000.p0010001 * 100, 1 ) AS pct_change -- Calculate percentage population change
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips
   AND c2010.p0010001 <> c2000.p0010001
ORDER BY pct_change DESC;
