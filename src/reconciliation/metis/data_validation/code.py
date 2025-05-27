
import pandas as pd

def calculate_total_data(csv_file1, csv_file2, output_csv):
    try:
        # Read CSV files into DataFrames
        df1 = pd.read_csv(csv_file1)
        df2 = pd.read_csv(csv_file2)


        # Convert the data type of the 'Table_Name' column to be consistent (if necessary)
        if 'Table_Name' in df1.columns and 'Table_Name' in df2.columns:
            df1['Table_Name'] = df1['Table_Name'].astype(str)
            df2['Table_Name'] = df2['Table_Name'].astype(str)

            # Check if both DataFrames are non-empty
            if not df1.empty and not df2.empty:
                # Merge DataFrames based on the table name column
                merged_df = pd.merge(df1, df2, on='Table_Name', how='outer')


                # Calculate total data (difference between before and after execution)
                merged_df['Total_Data'] = merged_df['After_Execution'] - merged_df['Before_Execution']

                # Select only the required columns
                result_df = merged_df[['Table_Name','Before_Execution','After_Execution', 'Total_Data']]

                # Write result DataFrame to a new CSV file
                result_df.to_csv(output_csv, index=False)
            else:
                print("One or both CSV files are empty.")
        else:
            print("The 'Table_Name' column is missing in one or both CSV files.")

    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage:
calculate_total_data('preexecute.csv', 'postexcute.csv', 'migration_validate.csv')

