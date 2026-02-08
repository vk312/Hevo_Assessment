**Hevo Technical Assessment**

This repository contains the dbt project developed as part of the Hevo Technical Assessment.
The objective is to build an end-to-end data pipeline: PostgreSQL (Docker-based) → Hevo (Logical Replication) → Snowflake → dbt analytics mart

**Architecture Overview**
PostgreSQL Local(Docker, Logical Replication)
              |            
Hevo Data Pipeline Cloud(Logical Replication Mode)
             |               
Snowflake Data Warehouse Cloud
              |                
dbt Transformations (Customers Mart)

**1.Project Overview**
This dbt project:
•	Transforms raw source tables into a Customer 360 analytics mart
•	Computes customer-level metrics such as:
•	First order date
•	Most recent order date
•	Number of orders
•	Customer Lifetime Value (LTV)
•	Applies data quality tests using dbt core and ‘dbt_utils’

**2.Project Structure**
hevo_dbt/
├── models/
│ ├── mart/
│ │ └── customers.sql
│ └── schema.yml
│ └── sources.yml
├── dbt_project.yml
├── packages.yml
├── README.md
└── .gitignore

**3.Prerequisites**
•	Python 3.9+
•	dbt Core (v1.11+)
•	dbt Snowflake adapter
•	Access to a Snowflake account
•	Access to Hevo Data Account
•	Access to GitHub 
•	Database knowledge (SQL)
•	Self-hosted instance of PostgreSQL (PgSQL) Database 
•	Networking knowledge for connecting to your local database from the Hevo cloud 
•	Docker Knowledge

**Steps**
1.Create PostgreSQL Container inside Docker, as required by the assessment.
2.Create Tables & Load CSV Data 
     Three raw tables are created in PostgreSQL: raw_customers ,raw_orders , raw_payments
      CSV files are loaded into these  via pgAdmin.
3. Enable Logical Replication
        Logical replication is enabled by:
        Setting wal_level = logical
        Creating a replication-enabled user
        Allowing replication connections
    This enables Hevo to ingest data using Logical Replication mode, as required.
4. Hevo Data Pipeline Setup
    Hevo Source Configuration
    Source: PostgreSQL (Docker-based)
    Ingestion Mode:  Logical Replication
    Fill out the configuration Details and test the connection
    No credentials or connection details are stored in this repository.
5. Hevo Destination Configuration
    Destination: Snowflake
    Fill out the configuration Details and test the connection


**Snowflake Setup**

•	Snowflake trial account created

•	Database and warehouse configured

•	Hevo successfully loads raw tables:

  raw_customers , raw_orders , raw_payments

3.**Configuration & Security**
No credentials, secrets, or access keys are stored in this repository.
Snowflake connection details must be configured outside the project, using following approaches:
profiles.yml 
Create the file at : ~/.dbt/profiles.yml
Example structure (DO NOT COMMIT):
default:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <account>
      user: <user>
      password: <password>
      role: <role>
      database: <database name>
      warehouse: <warehouse>
      schema:  <schema name >
      threads: 1

**Install Dependencies**
From the project root directory:
dbt deps

** Build the Project**
Run the customers model:
dbt run --select customers
This creates the customers table in the Snowflake MART schema.

**Run Tests**
Execute all data quality tests:
dbt test
The project includes:
•	not_null tests
•	unique tests
•	Business rule validation for customer lifetime value

**Notes**
•	Column quoting is enabled for Snowflake compatibility
•	Transformations follow dbt best practices
•	Sensitive configuration is intentionally excluded from the repository

Author
Prepared as part of the Hevo Data Technical Assessment

