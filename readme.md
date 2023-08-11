# Teddy Retailers Ingestion Demo
- Teddy Retailers operates both online and brick and mortar stores where it sells commonly used household products.
- Teddy Retailers is planning to perform and in-depht analysis of activity in both it's online and physical stores. 

## Data
The relevant data has been exported as flat CSV files as follows:
* Local Server: Four separate CSV files with identical structure contain the data from the online store.
    - These files can be found in this repository in the ./data directory.
* Google Cloud Storage: Two csv files have been extracted from the transactional system. These file contain the information about customers visits.
    - These files can be found in google cloud storage at the following URLs.
        - https://storage.googleapis.com/clearscape_analytics_demo_data/DEMO_TVUG_TPT_NOS/visits.csv
        - https://storage.googleapis.com/clearscape_analytics_demo_data/DEMO_TVUG_TPT_NOS/visit_products.csv

## Business Requirements 
Data from both physical and online stores shall be ingested into Teddy's Teradata Vantage Database in the most efficient manner following the following requirements.
* Online store 
    - All data from the Online Store shall be ingested. 
    - The data from each of the local files shall be ingested into the same table.
* Physical Stores
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

### Loading Data Stored Locally:

### Loading Data Stored Locally:
* For loading the data that is stored locally, we are going to use Teradata Parallel Transporter (TPT). TPT is a powerful data-loading tool that is client-based, thus very efficient for loading data from a local server. It also allows parallelization, which can make the process more efficient.
* TPT is highly configurable and robust, so it is worth taking a look at its full documentation and reference guide for advanced use cases. [TPT Documentation can be found on Teradata's website.](https://docs.teradata.com/r/k_KCYzsgJJ_t2du~c~wK_Q/OkTPh7PBa4ICuyi45jJsgQ)
* TPT operations are based on highly configurable operators that allow the parallelization of Reading Operations (Producer Operators), Writing Operations (Consumer Operators), Loading, and Filtering Operations (Filter Operators). The TPT package comes with preconfigured operators for loading data, writing to files, etc. You can find those under the `./templates` directory located inside the directory where TPT was installed.
* TPT jobs are configured through TPT scripts. In our case, the `tpt-jobs` folder contains the script that defines our corresponding job.
* It is a best practice to define environment variables used by our TPT jobs in a `jobvars.txt` file.
  - The environment variables define things such as the parameters of our database connections.
  - For example, the host, user, and password of our ClearScape Analytics Environment in our case.
  - The configuration of our inputs, like the location of the files that will be ingested, their format, delimiters, etc.
  - The tables that we will be using to load the data and record logs.
* Our TPT job script is integrated with the following elements.
  - A description.
  - The schema of the files that are being loaded.
  - Data Definition commands to create the tables that will be used.
  - The file reading operation.
  - The loading operation.
* To run the TPT job, we execute the following command from the terminal. Due to the relative paths, it is necessary to be located inside the directory that contains the job definition file:
```
tbuild -f ingest_teddy.tpt -v jobvars.txt -j file_load
```
* In this command, `-f` stands for the job definition file, `-v` for the file that contains the environment variables of the job, and `-j` for the job.
* It is possible to add several instances of an operator as follows, where `n` stands for the number of instances of the operator:
  - `TO OPERATOR ($LOAD)[n]`
  - `$FILE_READER(TEDDY_SCHEMA)[n]`
* The addition of several instances allows for the parallelization of the operations.
* The alternative file ingest_teddy_full.tpt is included as a reference of a TPT job that doesn't leverage included templates.

### Loading Data Stored in the Cloud:
* For loading data from cloud object storage, we will use Native Object Storage (NOS). NOS is optimized for ingesting object storage data in the cloud.
* NOS allows executing SQL statements against object storage sources.
* The files in the `nos-scripts` folder contain scripts to bring the data from Google Cloud Storage fulfilling the business requirements.
  - The `ingest_visits` script performs an inner join of the physical storage visits data with the online store data on the `customer_id`. This fulfills the requirement of retrieving data from the physical store that corresponds to customers who bought online.
  - The `ingest_visit_products` script ingests the `visit_products` data, also performing an inner join with the already ingested visits data. This is also to fulfill the business requirement of retrieving data from the physical store that corresponds to customers who bought online.
