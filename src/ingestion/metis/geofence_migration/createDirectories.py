import os

# List of directory names you want to create
directory_list = ["missing_imsi", "missing_account_details", "duplicate_imsi" , "NAEmailsBRN", "ban_email_error" \
,"groupedAccountIDZone", "createTag_success", "createTag_failure", "createTagAssign_success", "createTagAssign_failure", \
"createZone_success", "createZone_failure", "createRule_success", "createRule_failure"]

# Get the current working directory
current_directory = os.getcwd()

# Create directories if they don't exist
for directory_name in directory_list:
    # Construct the full path for the directory
    full_path = os.path.join(current_directory, directory_name)

    # Check if the directory already exists
    if not os.path.exists(full_path):
        # If it doesn't exist, create it
        os.makedirs(full_path)
        print(f"Directory created: {full_path}")
    else:
        # If it already exists, print a message
        print(f"Directory already exists: {full_path}")


