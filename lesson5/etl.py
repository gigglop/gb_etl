import psycopg2
from dotenv import dotenv_values, find_dotenv


# Параметры соединения
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

with psycopg2.connect(source_conn_string) as conn, conn.cursor() as cursor:
    query = 'select * from customer limit 1' # запрос к БД
    cursor.execute(query) # выполнение запроса
    result = cursor.fetchall() # получение результата
    print(result)
