--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 17 Code Examples
--------------------------------------------------------------

-- VACUUM

-- Listing 17-1: Creating a table to test vacuuming
-- This creates a new table named `vacuum_test` with a single column `integer_column` 
-- of the type integer. This table will be used to demonstrate how the VACUUM 
-- command works in PostgreSQL.
CREATE TABLE vacuum_test (
    integer_column integer
);

-- Listing 17-2: Determining the size of vacuum_test
-- This query determines the total size of the `vacuum_test` table, including its 
-- associated indexes, using the `pg_total_relation_size` function. 
-- The result is then formatted into a human-readable size (e.g., KB, MB).
SELECT pg_size_pretty(
           pg_total_relation_size('vacuum_test')
       );

-- Optional: Determine database size   
-- This query returns the total size of the current database (`analysis`) 
-- using the `pg_database_size` function and formats the result to be human-readable.
SELECT pg_size_pretty(
           pg_database_size('analysis')
       );

-- Listing 17-3: Inserting 500,000 rows into vacuum_test
-- This query inserts 500,000 rows into the `vacuum_test` table by using the 
-- `generate_series` function, which generates a series of numbers from 1 to 500,000.
INSERT INTO vacuum_test
SELECT * FROM generate_series(1,500000);

-- Test its size again
-- This checks the size of just the table itself (excluding indexes) using 
-- `pg_table_size` and formats the result for readability. This helps observe 
-- how much space the data is occupying.
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 17-4: Updating all rows in vacuum_test
-- This query updates every row in the `vacuum_test` table by adding 1 to the 
-- existing value in `integer_column`. This operation will increase the table's 
-- size due to the way PostgreSQL handles updates (creating new row versions).
UPDATE vacuum_test
SET integer_column = integer_column + 1;

-- Test its size again (35 MB)
-- After the update, this query checks the table size again to see how it has 
-- grown. The size increase can occur because old row versions (now obsolete) 
-- are not immediately removed, leading to additional disk usage.
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 17-5: Viewing autovacuum statistics for vacuum_test
-- This query fetches and displays statistics related to vacuum operations 
-- for the `vacuum_test` table from `pg_stat_all_tables`. It shows the last 
-- manual vacuum, last autovacuum, and the number of times each has occurred.
SELECT relname,
       last_vacuum,
       last_autovacuum,
       vacuum_count,
       autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- To see all columns available
-- This command retrieves all the available columns for `vacuum_test` 
-- from `pg_stat_all_tables`. It provides more detailed statistics, 
-- useful for understanding how PostgreSQL manages table maintenance.
SELECT *
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- Listing 17-6: Running VACUUM manually
-- The VACUUM command is used to clean up dead tuples (obsolete rows) in the table. 
-- These dead tuples are left behind after updates and deletes. Running VACUUM 
-- allows PostgreSQL to reclaim space and improve query performance.
VACUUM vacuum_test;

-- This command vacuums the entire database, not just the specified table.
VACUUM; 

-- The VERBOSE option provides additional details about what VACUUM is doing 
-- while it runs, which can be useful for troubleshooting or understanding its process.
VACUUM VERBOSE; 

-- Listing 17-7: Using VACUUM FULL to reclaim disk space
-- VACUUM FULL performs a more aggressive cleaning by rewriting the entire table, 
-- effectively removing all dead tuples and compacting the data. This process 
-- can reclaim more disk space but requires an exclusive lock on the table.
VACUUM FULL vacuum_test;

-- Test its size again
-- After running VACUUM FULL, this command checks the table size again to observe 
-- how much disk space was reclaimed by the operation.
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );
       
-- SETTINGS

-- Listing 17-8: Showing the location of postgresql.conf
-- This query shows the file path of the `postgresql.conf` file, which is the 
-- main configuration file for PostgreSQL. This file controls many aspects of 
-- database behavior, including autovacuum settings, logging, and memory usage.
SHOW config_file;

-- Listing 17-10: Show the location of the data directory
-- This query displays the file path to the data directory, where PostgreSQL 
-- stores all database files, including table data, indexes, and configuration files.
SHOW data_directory;

-- reload settings
-- These commands (for Mac/Linux and Windows) reload the PostgreSQL configuration 
-- files without restarting the server. Reloading is necessary after changes to 
-- certain configuration settings in `postgresql.conf`.
-- Mac and Linux: 
--   pg_ctl reload -D '/path/to/data/directory/'
-- Windows: 
--   pg_ctl reload -D "C:\path\to\data\directory\"

-- BACKUP AND RESTORE

-- Listing 17-11: Backing up the analysis database with pg_dump
-- This command uses `pg_dump` to create a backup of the `analysis` database. 
-- The `-d` option specifies the database name, `-U` specifies the username, 
-- and `-Fc` tells `pg_dump` to use the custom format, which allows for more 
-- flexible restoration options. The output is redirected to a file named `analysis_backup.sql`.
pg_dump -d analysis -U [user_name] -Fc > analysis_backup.sql

-- Back up just a table
-- This command backs up a single table named `train_rides` from the `analysis` 
-- database. The `-t` option specifies the table to back up. The backup is saved 
-- to a file named `train_backup.sql`.
pg_dump -t 'train_rides' -d analysis -U [user_name] -Fc > train_backup.sql 

-- Listing 17-12: Restoring the analysis database with pg_restore
-- This command restores the `analysis` database from a backup created with `pg_dump`. 
-- The `-C` option tells `pg_restore` to create the database before restoring it. 
-- The `-d postgres` option specifies that the database connection should be made to 
-- the `postgres` database (usually the default database). The backup is restored from 
-- the `analysis_backup_custom.sql` file.
pg_restore -C -d postgres -U postgres analysis_backup_custom.sql
