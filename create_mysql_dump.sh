#!/bin/bash

# Export directory
EXPORT_DIR="./mysql_dumps_export"

mkdir -p $EXPORT_DIR

echo "Starting database exports..."

# Validation: schema only + data for tables ending with error_codes
echo "Exporting validation database..."

# First export schema only for all tables
mysqldump -u aqadmin -pAqadmin@123 \
    --add-drop-database \
    --no-data \
    --databases validation > "${EXPORT_DIR}/validation_schema_temp.sql"

# Get list of tables ending with error_codes
ERROR_TABLES=$(mysql -u aqadmin -pAqadmin@123 -Nse "SELECT GROUP_CONCAT(table_name) FROM information_schema.tables WHERE table_schema = 'validation' AND table_name LIKE '%error_codes'")

echo "Found error_codes tables: $ERROR_TABLES"

if [ -n "$ERROR_TABLES" ]; then
  # Export data for error_codes tables (with schema to ensure proper INSERT statements)
  IFS=',' read -ra TABLE_ARRAY <<< "$ERROR_TABLES"
  
  # Create empty file for data
  > "${EXPORT_DIR}/validation_data_temp.sql"
  
  # Export each error_codes table individually to ensure data is captured
  for TABLE in "${TABLE_ARRAY[@]}"; do
    echo "Exporting data for table: $TABLE"
    mysqldump -u aqadmin -pAqadmin@123 \
        --no-create-info \
        --skip-add-drop-table \
        validation "$TABLE" >> "${EXPORT_DIR}/validation_data_temp.sql"
  done
  
  # Combine schema and data files
  cat "${EXPORT_DIR}/validation_schema_temp.sql" "${EXPORT_DIR}/validation_data_temp.sql" > "${EXPORT_DIR}/validation.sql"
  
  # Clean up temporary files
  rm "${EXPORT_DIR}/validation_schema_temp.sql" "${EXPORT_DIR}/validation_data_temp.sql"
else
  echo "No tables ending with error_codes found in validation database."
  mv "${EXPORT_DIR}/validation_schema_temp.sql" "${EXPORT_DIR}/validation.sql"
fi

# Transformation: schema only
echo "Exporting transformation database schema..."
mysqldump -u aqadmin -pAqadmin@123 \
    --add-drop-database \
    --no-data \
    --databases transformation > "${EXPORT_DIR}/transformation.sql"

# Ingestion: schema only
echo "Exporting ingestion database schema..."
mysqldump -u aqadmin -pAqadmin@123 \
    --add-drop-database \
    --no-data \
    --databases ingestion > "${EXPORT_DIR}/ingestion.sql"

# Metadata: schema with data
echo "Exporting metadata database with data..."
mysqldump -u aqadmin -pAqadmin@123 \
    --add-drop-database \
    --databases metadata > "${EXPORT_DIR}/metadata.sql"

echo "All exports completed!"
echo "Files created:"
echo "- validation.sql (schema + data for error_codes tables)"
echo "- transformation.sql (schema only)"
echo "- ingestion.sql (schema only)"
echo "- metadata.sql (schema with data)"