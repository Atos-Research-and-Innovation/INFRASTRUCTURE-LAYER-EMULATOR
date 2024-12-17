import requests
import time
import psycopg2

# def table_exists(table_name, connection):
#     """
#     Check if a table exists in the database.
    
#     Args:
#         table_name (str): The name of the table to check.
#         connection (psycopg2.Connection): The connection to the database.
        
#     Returns:
#         bool: True if the table exists, False otherwise.
#     """
#     exists = False
#     try:
#         with connection.cursor() as cursor:
#             cursor.execute(
#                 "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = %s)",
#                 (table_name,)
#             )
#             exists = cursor.fetchone()[0]
#     except psycopg2.Error as e:
#         print("Error checking if table exists:", e)
#     return exists

def create_table(connection, table_name):
    """
    Create a new table in the database.
    
    Args:
        connection (psycopg2.Connection): The connection to the database.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute(f"""
                CREATE TABLE IF NOT EXISTS {table_name} (
                    id SERIAL PRIMARY KEY,
                    connection INTEGER
                )
            """)
        # Commit the transaction
        connection.commit()
        print("Table created successfully.")
    except psycopg2.Error as e:
        # Rollback the transaction in case of error
        connection.rollback()
        print("Error creating table:", e)

def insert_data(connection, table_name, value):
    """
    Insert data into the table.
    
    Args:
        connection (psycopg2.Connection): The connection to the database.
        value (int): The value to insert into the integer column.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute(f"INSERT INTO {table_name} (connection) VALUES (%s)", (value,))
        # Commit the transaction
        connection.commit()
        print("Data inserted successfully.")
    except psycopg2.Error as e:
        # Rollback the transaction in case of error
        connection.rollback()
        print("Error inserting data:", e)

host = "10.126.153.107"
port = "5000"
url = f"http://{host}:{port}/streaming"

# Connect to the database
connection = psycopg2.connect(
    dbname="ile",
    user="admin",
    password="admin",
    host="localhost",
    port="5432"
)

table_name="service_check"

# Check if the table exists
# if table_exists(table_name, connection):
#     print(f"Table {table_name} exists.")
# else:
#     print(f"Table does not exist, creating table {table_name}...")

print(f"Creating table {table_name} if it does not exist...")
create_table(connection, table_name)

# Create a cursor object
# cursor = connection.cursor()

# cursor.execute("SELECT * FROM service_check")

try:
    while True:
        try:
            response = requests.get(url)
            if response.status_code == 200:
                print(f"Connectivity to {host}:{port}: SUCCESS")
                insert_data(connection, table_name, 1)
            else:
                print(f"Connectivity to {host}:{port}: FAILED")
                insert_data(connection, table_name, 0)
        except requests.RequestException as e:
            print(f"Error: {e}")
        time.sleep(3)
except KeyboardInterrupt:
    if connection:
        connection.close()
    exit