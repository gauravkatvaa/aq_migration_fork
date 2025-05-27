import sys
# # Add the parent directory to sys.path
sys.path.append("..")

from src.utils.library import *
from conf.custom.apollo.config import *
import datetime
today = datetime.datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))



logs = {
    "migration_info_logger":f"stc_validation_info_{current_time_stamp}.log",
    "migration_error_logger":f"stc_validation_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{validation_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

# Step 1: Get file names and count total records for each file
input_data_dir = "input_data"
input_files = os.listdir(feed_file_path)

file_records = {}
for filename in input_files:
    file_path = os.path.join(feed_file_path, filename)
    total_records = pd.read_csv(file_path).shape[0]
    file_records[filename.split("_")[0]] = {"total_records": total_records}

# Step 2: Get count of validation failed records for each file
error_records_dir = "error_records"
error_files = os.listdir(error_record_file_path)

for filename in error_files:
    file_path = os.path.join(error_record_file_path, filename)
    validation_failed_records = pd.read_csv(file_path).shape[0]
    file_records[filename.split("_")[0]]["validation_failed_records"] = validation_failed_records

# Step 3: Get count of valid records for each file
valid_records_dir = "valid_records"
valid_files = os.listdir(input_file_path)

for filename in valid_files:
    file_path = os.path.join(input_file_path, filename)
    valid_records = pd.read_csv(file_path).shape[0]
    file_records[filename.split("_")[0]]["valid_records"] = valid_records

# Step 4: Create dataframe and calculate percentages
report = pd.DataFrame(
    columns=["file_name", "total_records", "valid_records", "validation_failed_records", "valid_record_percentage",
             "validation_failed_records_percentage"])

for filename, data in file_records.items():
    total_records = data.get("total_records", 0)
    validation_failed_records = data.get("validation_failed_records", 0)
    valid_records = data.get("valid_records", 0)

    valid_record_percentage = (valid_records / total_records) * 100 if valid_records != 0 else 0
    validation_failed_records_percentage = (validation_failed_records / total_records) * 100 if validation_failed_records != 0 else 0

    report = report.append({
        "file_name": filename,
        "total_records": total_records,
        "validation_failed_records": validation_failed_records,
        "valid_records": valid_records,
        "valid_record_percentage": valid_record_percentage,
        "validation_failed_records_percentage": validation_failed_records_percentage
    }, ignore_index=True)

print(report)

report.to_csv("reconcile_report.csv",index=False)



