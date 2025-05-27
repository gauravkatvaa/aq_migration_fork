import pandas as pd

# Sample DataFrames (You can replace these with your actual data)
EC = pd.DataFrame({
    'INVOICING_LEVEL_TYPE': ['Customer', 'Customer', 'Customer'],
    'DEFAULT_BUSINESS_UNIT_ID': [101, 102, 104]
})

BU = pd.DataFrame({
    'BUCRM_ID': [101, 102, 103],
    'BILLING_CYCLE_ID': ['Cycle1', 'Cycle2', None]
})

# Ensure that DEFAULT_BUSINESS_UNIT_ID is not missing in EC when INVOICING_LEVEL_TYPE == 'Customer'
ec_customer = EC[EC['INVOICING_LEVEL_TYPE'] == 'Customer']

# Create an empty list to collect fault entries
fault_entries = []

# Check for missing DEFAULT_BUSINESS_UNIT_ID
missing_default_bu = ec_customer['DEFAULT_BUSINESS_UNIT_ID'].isna()
if missing_default_bu.any():
    fault_entries.append(ec_customer[missing_default_bu].assign(code='Missing DEFAULT_BUSINESS_UNIT_ID'))

# Merge EC and BU dataframes on DEFAULT_BUSINESS_UNIT_ID and BUCRM_ID
merged_df = pd.merge(ec_customer, BU, left_on='DEFAULT_BUSINESS_UNIT_ID', right_on='BUCRM_ID', how='left')

# Check for missing BUCRM_ID in merged dataframe
missing_bucrm_id = merged_df['BUCRM_ID'].isna()
if missing_bucrm_id.any():
    fault_entries.append(ec_customer[ec_customer['DEFAULT_BUSINESS_UNIT_ID'].isin(merged_df[missing_bucrm_id]['DEFAULT_BUSINESS_UNIT_ID'])].assign(code='BUCRM_ID does not exist in BU'))

# Check for missing BILLING_CYCLE_ID in merged dataframe
missing_billing_cycle = merged_df['BILLING_CYCLE_ID'].isna()
if missing_billing_cycle.any():
    fault_entries.append(ec_customer[ec_customer['DEFAULT_BUSINESS_UNIT_ID'].isin(merged_df[missing_billing_cycle]['DEFAULT_BUSINESS_UNIT_ID'])].assign(code='Missing BILLING_CYCLE_ID'))


# Combine all fault entries into a single dataframe with only EC columns
if fault_entries:
    fault_entries_df = pd.concat(fault_entries, ignore_index=True)[EC.columns.tolist() + ['code']]
    # Save the fault entries to a CSV file
    fault_entries_df.to_csv('fault_entries.csv', index=False)
else:
    fault_entries_df = pd.DataFrame(columns=EC.columns.tolist() + ['code'])
    print("No fault entries found.")

# Identify valid rows in EC by excluding faulty DEFAULT_BUSINESS_UNIT_IDs
valid_default_bu_ids = set(ec_customer['DEFAULT_BUSINESS_UNIT_ID']) - set(fault_entries_df['DEFAULT_BUSINESS_UNIT_ID'])
valid_ec = EC[EC['DEFAULT_BUSINESS_UNIT_ID'].isin(valid_default_bu_ids) | (EC['INVOICING_LEVEL_TYPE'] != 'Customer')]

# Show the valid rows in EC that pass all the checks
print(valid_ec)