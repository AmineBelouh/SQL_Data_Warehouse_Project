/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' and sets up three schemas: 'bronze', 'silver', and 'gold'. 
    It drops the database and schemas if they already exist.
	
WARNING:
    Dropping the database means all data in it will be permanently deleted. Proceed with caution and ensure you have proper backups.
*/

DROP DATABASE IF EXISTS DataWarehouse;
CREATE DATABASE DataWarehouse;

-- Connect to the database (done manually in client)

DROP SCHEMA IF EXISTS bronze;
CREATE SCHEMA bronze;

DROP SCHEMA IF EXISTS silver;
CREATE SCHEMA silver;

DROP SCHEMA IF EXISTS gold;
CREATE SCHEMA gold;
