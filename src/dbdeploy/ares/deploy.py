import sys
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.ares.config import *
from contextlib import closing 
import csv
timestamp = datetime.now().strftime("%Y%m%d%H%M%S")

today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")

dir_path = dirname(abspath(__file__))

logs = {
    "migration_info_logger":f"A1_db_deploy_validator_info_{current_time_stamp}.log",
    "migration_error_logger":f"A1_db_deploy_validator_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{dbdeploy_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()


import subprocess




class CommandRunner:
    @classmethod
    def run_commands(cls, db_cred, sql_file_paths):
        commands_dict = cls.generate_commands(db_cred, sql_file_paths)
        
        for db_name, commands in commands_dict.items():
            try:
                logger_info.info(f"Running commands for {db_name}")
                print(f"Running commands for {db_name}")
            except Exception as e:
                logger_error.error(f"Failed to log db_name: {e}")
                print(f"Failed to log db_name: {e}")

            for command in commands:
                try:
                    logger_info.info(f"Executing: {command}")
                    print(f"Executing: {command}")
                except Exception as e:
                    logger_error.error(f"Failed to log command: {e}")
                    print(f"Failed to log command: {e}")

                try:
                    result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    try:
                        logger_info.info(f"Success: {result.stdout.decode('utf-8')}")
                        print(f"Success: {result.stdout.decode('utf-8')}")
                    except Exception as e:
                        logger_error.error(f"Failed to log success message: {e}")
                        print(f"Failed to log success message: {e}")
                except subprocess.CalledProcessError as e:
                    try:
                        logger_error.error(f"Error: {e.stderr.decode('utf-8')}")
                        print(f"Error: {e.stderr.decode('utf-8')}")
                    except Exception as log_error:
                        logger_error.error(f"Failed to log error message: {log_error}")
                        print(f"Failed to log error message: {log_error}")

    @staticmethod
    def generate_commands(db_cred, sql_file_paths):
        commands_dict = {}
        
        db_name = db_cred['DATABASE']
        user = db_cred['USER']
        password = db_cred['PASSWORD']
        host = db_cred['HOST']
        port = db_cred['PORT']
        
        commands = []
        for sql_file_path in sql_file_paths:
            command = f"mysql -u {user} -p{password} -h {host} -P {port} {db_name} < {sql_file_path}"
            commands.append(command)
        
        commands_dict[db_name] = commands
        return commands_dict




if __name__ == "__main__":
    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    # Access individual arguments

    for arg in sys.argv[1:]:
        if arg == "a1_migration":
            print("a1_migration")
            CommandRunner.run_commands(migration_db_configs, a1_migration_db_deploy_list)

        if arg == "create_procedures":
            CommandRunner.run_commands(validation_db_configs, validation_db_procedures_list)

        if arg == "aircontrol":
            print("aircontrol")
            CommandRunner.run_commands(aircontrol_db_configs, aircontrol_db_deploy_script_list)

        if arg == "bss":
            print("bss")
            CommandRunner.run_commands(bss_db_configs, bss_db_deploy_list)   

        if arg == "billing":
            print("billing")
            CommandRunner.run_commands(billing_db_configs, billing_db_deploy_script_list)              
            
        if arg=="all":
            print("All db script deploye")
            CommandRunner.run_commands(migration_db_configs, a1_migration_db_deploy_list)
            CommandRunner.run_commands(aircontrol_db_configs, aircontrol_db_deploy_script_list)            
            CommandRunner.run_commands(bss_db_configs, bss_db_deploy_list)   
            CommandRunner.run_commands(billing_db_configs, billing_db_deploy_script_list) 
            CommandRunner.run_commands(validation_db_configs, validation_db_procedures_list)
               