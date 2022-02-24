import psycopg2
from dotenv import dotenv_values, find_dotenv


# Параметры соединения используя переменные окружения из файла .env
config = dotenv_values(find_dotenv('.env'))
source_conn_string = f"host='localhost' " \
                     f"port={config.get('SOURCE_DB_DOCKER_CONTAINER_PORT')} " \
                     f"dbname='{config.get('SOURCE_DB_NAME')}' " \
                     f"user='{config.get('DB_USER')}' " \
                     f"password='{config.get('DB_PASSWORD')}'"
target_conn_string = f"host='localhost' " \
                     f"port={config.get('TARGET_DB_DOCKER_CONTAINER_PORT')} " \
                     f"dbname='{config.get('TARGET_DB_NAME')}' " \
                     f"user='{config.get('DB_USER')}' " \
                     f"password='{config.get('DB_PASSWORD')}'"
dirname = 'temp_etl_data/'
try:
    with psycopg2.connect(source_conn_string) as conn, conn.cursor() as cursor:
        query = """
        SELECT table_name 
        FROM information_schema.tables
        WHERE table_schema='public' 
        """
        cursor.execute(query)
        source_tables = cursor.fetchall()
        table_file_map = {}
        for table in source_tables:
            table_file_map[table[0]] = f"{table[0]}.csv"
            q = f"COPY {table[0]} TO STDOUT WITH DELIMITER ',' CSV HEADER;"
            with open(f'{dirname}{table[0]}.csv', 'w') as f:
                cursor.copy_expert(q, f)

    with psycopg2.connect(target_conn_string) as conn, conn.cursor() as cursor:
        for table in table_file_map.keys():
            q = f"COPY {table} from STDIN WITH DELIMITER ',' CSV HEADER;"
            print(q)
            with open(f'{dirname}{table_file_map[table]}', 'r') as f:
                cursor.copy_expert(q, f)
    print('ETL finished.')
except Exception as e:
    print(f'Stopped. Reason: {e}')