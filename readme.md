# Teddy Retailers Ingestion Demo
- Teddy Retailers operates both online and brick and mortar stores where it sells commonly used household products.
- Teddy Retailers is planning to perform and in-depht analysis of activity in both it's online and physical stores. 

## Data
The relevant data has been exported as flat CSV files as follows:
- Local Server: Four separate CSV files with identical structure contain the data from the online store.
    - These files can be found in this repository in the ./data directory.
- Google Cloud Block Storage: Two csv files have been extracted from the transactional system. These file contain the information about customers visits.
    - These files can be found in google cloud storage at the following URLs.
        - https://storage.googleapis.com/clearscape_analytics_demo_data/DEMO_TVUG_TPT_NOS/visits.csv
        - https://storage.googleapis.com/clearscape_analytics_demo_data/DEMO_TVUG_TPT_NOS/visit_products.csv

## Business Requirements 
Data from both physical and online stores shall be ingested into Teddy's Teradata Vantage Database in the most efficient manner following the following requirements.
- Online store 
    - All data from the Online Store shall be ingested. 
    - The data from each of the local files shall be ingested into the same table.
- Physical Stores
    - Only the data corresponding to customers that also purchased online shall be ingested.
    - The data shall be ingested into two different tables conserving the schema currently reflected in the CSV files.

## Pre-Requsites
* Access to a Teradata Vantage Instance. You can provision one for free at [ClearScape Analytics Experience.](https://clearscape.teradata.com/sign-in?utm_source=github&utm_medium=readme&utm_campaign=TPT_NOS)
* Access to Teradata Parallel Transporter TPT at. You can download TPT at [Teradata Tools and Utilities TTU.](https://downloads.teradata.com/download/database/teradata-tools-and-utilities-13-10) 
* Your favorite database client.

## Steps
* Follow the steps of the installation wizard of Teradata Tools and Utilities.
* Follow the steps for creating a Teradata Vantage environment on ClearScape Analytics Experience.
    - While creating a Teradata Vantage environment take note of the hostname, database user, and password. You will need these parameters to create a connection in your favorite database client.
* In your favorite database client run the command for creating the database, this script can be found in the `create_db` folder of this repository.
```
CREATE DATABASE teddy_ingestion
AS PERMANENT = 110e6;
```


