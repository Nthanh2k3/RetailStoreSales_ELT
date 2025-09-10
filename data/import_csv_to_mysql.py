import csv
import mysql.connector
import os


db_config = {
    'host':'localhost',
    'user':'admin',
    'password':'nectar23_12',
    'database':'retail_store_db',
    'allow_local_infile': True
}

# Connect to the database
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

# Loop through all CSV files in the current directory
for filename in os.listdir('.'):
    if filename.endswith('.csv'):
        table_name = filename[:-4]  # Table name = filename without .csv
        
        # Read the header row to get column names
        with open(filename, 'r', encoding='utf-8') as f:
            reader = csv.reader(f)
            header = next(reader)  # Assume first row is headers
        
        # Generate CREATE TABLE statement with all columns as TEXT (preserves data exactly)
        columns = ', '.join([f'`{col}` TEXT' for col in header])
        create_query = f"CREATE TABLE IF NOT EXISTS `{table_name}` ({columns})"
        cursor.execute(create_query)
        
        # Import data using LOAD DATA (fast bulk insert, ignores nothing, preserves N/A)
        load_query = f"""
            LOAD DATA LOCAL INFILE '{filename}'
            INTO TABLE `{table_name}`
            FIELDS TERMINATED BY ',' 
            ENCLOSED BY '"'
            LINES TERMINATED BY '\\n'
            IGNORE 1 LINES  # Skips the header row
        """
        cursor.execute(load_query)
        
        conn.commit()
        print(f"Imported {filename} into table {table_name}")

# Close the connection
cursor.close()
conn.close()
print("All imports completed.")