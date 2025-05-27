# A1 Migration Tool

<!-- CREAETED BY GAURAV KATVA -->
<!-- DATE: 28th March, 2025 -->
<!-- For contact: shubham.boora@airlinq.com -->

## Overview
This migration tool is designed to move data from legacy telecom systems to a new platform. The process involves several steps: validation of input data, transformation, and ingestion into the target system.


## Setting up virtual environment (IMPORTANT)
If in the root directory of the project you find the folder called `migration_env` then ignore this step. Else create the new environment for running the scripts,

```bash
# Create a virtual environment
python -m venv migration_env

# Activate it
# On Linux/Mac: (activate everytime before running the scripts)
source migration_env/bin/activate

# Then install the required packages (no need to install if already installed)
pip install -r requirements.txt
```

Here we are using `python` command if you have another version of python use that, such as `python3` or `python3.9` etc. 

After you activate the current env you dont need to use `python` or `pip3.8` command, you can ommit the version number and directly use `python` or `pip`.


## Prerequisites
- Python 3.8 (recommended)
- Oracle client installed
- MySQL client installed
- Access to source and target databases

## Installation

### Step 1: Extract the Package
Extract the provided code zip file to your preferred location on your system.

### Step 2: Configure Environment
Update the `.env` file in the `env` folder with your specific environment details.

Example `.env` file:
```
SYSTEM_CLIENT_PATH=/home/aqadmin/migration_scripts
DB_HOST=10.235.117.196
DB_USERNAME=aqadmin
DB_PASSWORD=Aqadmin@123
MIGRATION_DB_NAME=
AIRCONTROL_DB_HOST=192.168.1.122
AIRCONTROL_USERNAME=python_dev
AIRCONTROL_PASSWORD=Python@123
AIRCONTROL_DB_NAME=cmp_master_a1s4
ROUTER_DB_HOST=10.235.117.196
GOUP_THIRDPARTY_DB_NAME=cmp_maxis_interface_thirdparty_migration
GOUP_ROUTER_DB_NAME=goup_router
BSS_DB_HOST=10.223.72.33
BSS_DB_USERNAME=aqadmin
BSS_DB_PASSWORD=Aqadmin@123
BSS_DB_NAME=S3W2_myindian
BILLING_DB_HOST=10.221.86.66
BILLING_DB_USERNAME=aqadmin
BILLING_DB_PASSWORD=Aqadmin@123
BILLING_DB_NAME=S4P1billing
PRODUCT_CATALOGUE_DB_HOST=10.235.117.196
PRODUCT_CATALOGUE_DB_USERNAME=aqadmin
PRODUCT_CATALOGUE_DB_PASSWORD=Aqadmin@123
PRODUCT_CATALOGUE_DB_NAME=pc_db
AIRCONTROL_API_HOST_PORT=192.168.1.37:8030
OPCO_ACCOUNT_ID=2
OPCO_USERNAME=A1 Digital SIM management
OPCO_PASSWORD=Gtadmin@123
ACCOUNT_ID_OPCO_USER = 3
SOAP_API_HOST_PORT=192.168.1.89:8081
OCS_FILE_PATH=/home/aqadmin/migration_scripts
ORACLE_DB_HOST=10.235.117.196
ORACLE_DB_USERNAME=AQADMIN
ORACLE_DB_PASSWORD=Aqadmin123
ORACLE_DB_SID=XEPDB1
NOTIFICATION_CENTER_HOST=192.168.1.37:8030
X_USER_ID=AA
```

> **Important Note**: Keep `MIGRATION_DB_NAME=` empty (with no value). We are using a different approach with 4 separate migration databases instead of a single one.

> **Important Note**: After configuring the .env file, if the migration_env is not activated please activate it using the `source migration_env/bin/activate` and then install the dependecies using `pip install -r requirements.txt` If you have not setup the virtual environemnt please go to the [Setting up virtual environment (IMPORTANT)](#setting-up-virtual-environment-important)

## Setup Migration Databases
Navigate to the `src` folder within the extracted migration package and run following commands as per your requirements. Also verify that inside `db/ares/transformation` folder you have the list of latest DB configuration, it must be. There should be 4 files regarding that to create 4 helper migration DB for each job.

- validation
- transformation
- ingestion
- metadata

### Step 0: Rollback the previous data (if needed)
You see when we are working same data, already onboarded data can not be inserted one more time. So this rollback command will help to remove previous entries and after this script can be re-run.

> **Important Node**: Make sure to run the below rollback command after you have ran the script till transformation layer at least one time, including DB deploy script as the deploy has rollback stored procedures. If tranformation DB ec_success, bu_success tables are not having the data then rollback won't happen.

```bash
python rollback/ares_rollback.py all
```

### Step 1: Deploy Database Schemas

```bash
python dbdeploy/ares/deploy.py all
```

After you rollback make sure to restart the API server, sometime data got cached in the backend so might see some glitch. Restart of API server will solve this.

This will create four migration helper databases:
- validation
- transformation
- ingestion
- metadata

## ORACLE DB Input data validation reports
There was a special requirements that oracle DB should also have the information regarding the the error codes and error out records.

For that we created special functions to create those tables under ORACLE input DB. To do so run these commands. 

> **Important Node**: Make sure to run the below commands after you have ran the dbdeploy scripts and databases successfully created error_codes and failure tables, also verify that the tables and data created properly.

```bash
python validation/ares/validation_helper.py error_codes
```

```bash
python validation/ares/validation_helper.py rejection_tables
```


## Migration Process

### 1. Data Validation
Validate the input data files with:

> **Important Note**: For CSR helper, we have a file in the input that is also validated. If not present, please find the sample file [here](https://globetouch1-my.sharepoint.com/:x:/g/personal/shubham_boora_airlinq_com/ET9VGqOP4xdAku7Ezx4fV_EBCa0PmRTXPdGExC7L0PzSvA?e=M7sgW2). The PC team can share the latest file according to the latest data. The file should be under `data/custom/ares/input_data`. If not present, refer to the provided link.

> **Important Note**: You might face oracle related error while running the script, this is due to some path export issue on your server. If the issue occures just go to the end of this file, and run the given commands.

```bash
python validation/ares/file_validation_script/feed_file_validator.py validation
```

This step checks all input CSV files for data quality, column formats, and required fields.

### 2. Data Transformation
Transform the validated data with:

```bash
python transformation/ares/transformation_migration/migration_data_insertion.py ingestion
```

To transform the CSR data and create `csr_mapping_details` and `csr_mapping_master` will need to run the following command, by using following command,

```bash
python transformation/ares/transformation_migration/migration_data_insertion.py csr
```

For transforming trigger entity please use this command, 

```bash
python rule_trigger/ares_rule_trigger_transform.py notification
python rule_trigger/ares_rule_trigger_transform.py trigger
```

This step processes and converts the input data into the format required by the target system.

### 3. Data Ingestion
This is the final step where data is loaded into the target system, broken down by entity type:


#### For reconcilation report need to clear the loading summary DB
```bash
python ingestion/ares/aircontrol_onboarding/onboarding.py clear_loading_summary
```

#### Enterprise Customer (EC) Onboarding
```bash
python ingestion/ares/aircontrol_onboarding/onboarding.py ec
```

#### Business Unit (BU) Onboarding
```bash
python ingestion/ares/aircontrol_onboarding/onboarding.py bu
```

#### Cost Center (CC) Onboarding
```bash
python ingestion/ares/aircontrol_onboarding/onboarding.py cc
```

#### Role Access Configuration
```bash
python ingestion/ares/aircontrol_onboarding/onboarding.py role_access
```

#### User Onboarding
```bash
python ingestion/ares/aircontrol_onboarding/onboarding.py user
```

#### Report Subscriptions Creation
```bash
python ingestion/ares/aircontrol_onboarding/onboarding.py report_subscriptions
```

#### APN Creation
```bash
python ingestion/ares/aircontrol_onboarding/onboarding.py apn
```

#### CSR Journey

```bash
python ingestion/ares/csr_journey_migration/csr_jounery_api.py
```

#### Trigger & Notification Template
```bash
python rule_trigger/ares_trigger_ingestion.py template
python rule_trigger/ares_trigger_ingestion.py trigger
```

#### Sim Assets Migration
```bash
python ingestion/ares/asset_table_migration/migration_data_insertion.py asset
```


## Verifying the results
In the metadata db in mysql, you can see the data under
- validation_summary
- transformation_summary
- loading_summary

to see how much records of what entity have been proccessed.

## Common Issues and Troubleshooting

### Database Connection Issues
- Verify the credentials in your `.env` file
- Ensure the database servers are accessible from your machine
- Check firewall settings if you're unable to connect

### Python Environment Problems
- Make sure Python 3.8 is in your PATH
- Install required packages using: `pip install -r requirements.txt`
- Use a virtual environment if possible to avoid conflicts

### Data Validation Failures
- Check the validation logs for specific error messages
- Ensure input CSV files match the expected format
- Review any data type or constraint issues mentioned in the logs

### Oracle troubleshoot
If you face any issues related to oracle connection through the script, please run following commands.

```bash
ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE; export ORACLE_HOME
ORACLE_SID=XE;export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin
export PATH
```