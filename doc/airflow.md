# Apache Airflow Deployment Guide

This guide provides instructions for deploying Apache Airflow on Red Hat Enterprise Linux 8.10 (Ootpa) with Python 3.8.5.

## Prerequisites

- Red Hat Enterprise Linux 8.10 (Ootpa)
- Python 3.8.5
- Sufficient permissions to create directories and install packages

## Installation Steps

### 1. Create a Virtual Environment

It's recommended to install Airflow in a dedicated virtual environment to avoid dependency conflicts:

```bash
python3 -m venv airflow-env
source airflow-env/bin/activate
```

### 2. Install Apache Airflow

#### 2.1 Set Environment Variables for Airflow Version and Constraints

```bash
export AIRFLOW_VERSION="2.9.3"
export PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
export AIRFLOW_CONSTRAINTS="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
```

#### 2.2 Install Airflow with Constraints

```bash
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${AIRFLOW_CONSTRAINTS}"
```

### 3. Initialize the Airflow Database

```bash
airflow db init
```

### 4. Create an Admin User

```bash
airflow users create \
  --username admin \
  --firstname Admin \
  --lastname User \
  --role Admin \
  --email admin@example.com
```

You will be prompted to enter a password for the admin user.

### 5. Start Airflow Services

Start the Airflow webserver:

```bash
airflow webserver --port 8080
```

In a new terminal window (with the virtual environment activated), start the Airflow scheduler:

```bash
source airflow-env/bin/activate
airflow scheduler
```

### 6. Access the Airflow UI

Open a web browser and navigate to:

```
http://localhost:8080
```

Log in with the admin credentials you created in step 4.

## Additional Configuration

### Environment Variables

For production deployments, consider setting these environment variables:

```bash
export AIRFLOW_HOME=~/airflow              # Default location for Airflow files
export AIRFLOW__CORE__LOAD_EXAMPLES=False  # Disable example DAGs
```

### Running Airflow as a Service

For production environments, you may want to set up Airflow components as system services using systemd.

Create service files in `/etc/systemd/system/`:

**airflow-webserver.service**:
```ini
[Unit]
Description=Airflow webserver daemon
After=network.target postgresql.service
Wants=postgresql.service

[Service]
Environment=PATH=/home/airflow/airflow-env/bin:/usr/local/bin:/usr/bin:/bin
User=airflow
Group=airflow
Type=simple
ExecStart=/home/airflow/airflow-env/bin/airflow webserver
Restart=on-failure
RestartSec=5s
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

**airflow-scheduler.service**:
```ini
[Unit]
Description=Airflow scheduler daemon
After=network.target postgresql.service
Wants=postgresql.service

[Service]
Environment=PATH=/home/airflow/airflow-env/bin:/usr/local/bin:/usr/bin:/bin
User=airflow
Group=airflow
Type=simple
ExecStart=/home/airflow/airflow-env/bin/airflow scheduler
Restart=on-failure
RestartSec=5s
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

Enable and start the services:
```bash
sudo systemctl enable airflow-webserver airflow-scheduler
sudo systemctl start airflow-webserver airflow-scheduler
```

## Security Considerations

- Change default connection credentials
- Set up SSL for the webserver
- Configure authentication (LDAP, OAuth, etc.)
- Restrict network access to the Airflow webserver
- Regularly update Airflow and its dependencies

## Troubleshooting

### Common Issues

1. **Port already in use**:
   ```bash
   lsof -i :8080  # Check what's using port 8080
   kill -9 PID    # Kill the process if needed
   ```

2. **Database connection issues**:
   - Verify database credentials and connectivity
   - Check database logs for errors

3. **Permission errors**:
   - Ensure the user running Airflow has appropriate permissions to the AIRFLOW_HOME directory

## Additional Resources

- [Apache Airflow Documentation](https://airflow.apache.org/docs/)
- [Airflow GitHub Repository](https://github.com/apache/airflow)
- [Airflow Community on Slack](https://apache-airflow.slack.com/)

## Maintenance

### Upgrading Airflow

To upgrade Airflow to a newer version:

```bash
export AIRFLOW_VERSION="NEW_VERSION"
export PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
export CONSTRAINTS="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINTS}" --upgrade
airflow db upgrade
```

### Backing Up

Regularly back up your Airflow database and DAGs directory:

```bash
# Example PostgreSQL backup
pg_dump -U airflow airflow > airflow_db_backup_$(date +%Y%m%d).sql

# DAGs directory backup
tar -czf airflow_dags_$(date +%Y%m%d).tar.gz ~/airflow/dags
```

### Adding example of DAG code of validation layer

```bash
from airflow.models import DAG, Variable
from airflow.operators.python import PythonOperator
from datetime import datetime
import time
import paramiko

default_args = {
    'start_date': datetime(2024, 3, 29),
    'owner': 'airflow',
    'retries': -1,  # Set retries to -1 for infinite retries
}


a1_migration_configs = Variable.get("A1_migration_196_server", deserialize_json=True)


environment = a1_migration_configs['environment']
src_path = environment["src_path"]

sftp_server_configs = environment["sftp_server_configs"]
host = sftp_server_configs["Hostname"]
username = sftp_server_configs["Username"]
password = sftp_server_configs["Password"]
port = sftp_server_configs["Port"]

# A1 Proccesses
a1_processes = a1_migration_configs["processes"]

# Validations variables
validation_config = a1_processes["validation"]
commands = validation_config["commands"]

# Commands
data_validation_command = commands["data_validation"]

def execute_command(path, command):
    """
    This method executes a command on a remote server.
    
    :param path: The directory path on the remote server where the command will be executed.
    :param command: The command to be executed on the remote server.
    """
    commands = f"cd {path} && {command}"
    try:
        # Initialize the SSH client
        client = paramiko.SSHClient()

        # Automatically add the server's host key (this is not secure for production environments)
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Connect to the server
        client.connect(host, port, username, password)

        # Run the command
        stdin, stdout, stderr = client.exec_command(commands)

        # Read the command output
        output = stdout.read().decode()
        error = stderr.read().decode()

        # Print the command output and error (if any)
        print("Output:", output)
        if error:
            print("Error:", error)

    except Exception as e:
        print(f"Failed to connect or execute the command on the remote server: {e}")
    finally:
        # Close the client to free resources
        client.close()

dag = DAG(
    dag_id='A1_2_Validation',
    default_args=default_args,
    catchup=False,
    max_active_runs=1,
    schedule_interval=None,
    tags=["A1"],
)

data_validation = PythonOperator(
    task_id='data_validation',
    python_callable=execute_command,
    op_kwargs={'path': src_path, 'command': data_validation_command},
    dag=dag,
    execution_timeout=None
)

data_validation
```

### Adding the example JSON variable

```bash
{
    "environment": {
        "system_client_path": "/home/aqadmin/migration_scripts",
        "src_path": "/home/aqadmin/migration_scripts/migration/src/",
        "sftp_server_configs": {
            "Hostname": "10.235.117.196",
            "Username": "aqadmin",
            "Password": "Ex0cz@Ws#",
            "Port": 22
        }
    },
    "processes": {
        "pre_execution": {
            "commands": {
                "error_codes": "python3.8 validation/ares/validation_helper.py error_codes",
                "rejection_tables": "python3.8 validation/ares/validation_helper.py rejection_tables"
            }
        },
        "validation": {
            "commands": {
                "data_validation": "python3.8 validation/ares/file_validation_script/feed_file_validator.py validation"
            }
        },
        "transformation": {
            "commands": {
                "data_transformation": "python3.8 transformation/ares/transformation_migration/migration_data_insertion.py ingestion",
                "csr_transformation": "python3.8 transformation/ares/transformation_migration/migration_data_insertion.py csr"
            }
        },
        "ingestion": {
            "aircontrol_onboarding": {
                "commands": {
                    "ec_onboarding": "python3.8 ingestion/ares/aircontrol_onboarding/onboarding.py ec",
                    "bu_onboarding": "python3.8 ingestion/ares/aircontrol_onboarding/onboarding.py bu",
                    "cc_onboarding": "python3.8 ingestion/ares/aircontrol_onboarding/onboarding.py cc",
                    "role_access": "python3.8 ingestion/ares/aircontrol_onboarding/onboarding.py role_access",
                    "user_onboarding": "python3.8 ingestion/ares/aircontrol_onboarding/onboarding.py user"
                }
            },
            "csr_journey": {
                "command": "python3.8 ingestion/ares/csr_journey_migration/csr_jounery_api.py"
            }
        },
        "rule_trigger": {
            "commands": {
                "notification_transform": "python3.8 rule_trigger/ares_rule_trigger_transform.py notification",
                "trigger_transform": "python3.8 rule_trigger/ares_rule_trigger_transform.py trigger",
                "template_ingestion": "python3.8 rule_trigger/ares_trigger_ingestion.py template",
                "trigger_ingestion": "python3.8 rule_trigger/ares_trigger_ingestion.py trigger"
            }
        },
        "db_deployment": {
            "commands": {
                "a1_validation_db": "python3.8 dbdeploy/ares/deploy.py a1_validation",
                "aircontrol_deployment": "python3.8 dbdeploy/ares/deploy.py aircontrol",
                "transformation_deployment": "python3.8 dbdeploy/ares/deploy.py transformation",
                "ingestion_deployment": "python3.8 dbdeploy/ares/deploy.py ingestion",
                "metadata_deployment": "python3.8 dbdeploy/ares/deploy.py metadata"
            }
        },
        "rollback": {
            "command": "python3.8 rollback/ares_rollback.py all"
        }
    }
}
```