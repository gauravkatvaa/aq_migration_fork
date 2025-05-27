How to run imsi_migration.sh
1. Make sure sql client is already installed in the server.
2. tnsora is properly set.
3. Place data file in the same path from where you are running this script.
	e.g: if this script is running from /opt/Roamware/scripts/operations/airocs path then the data file must be in the same path i.e /opt/Roamware/scripts/operations/airocs
4. Name of the data file must be: imsi_data.csv
5. Run command
	./imsi_migration.sh <db_user> <db_password> <sid_set_in_tnsora>