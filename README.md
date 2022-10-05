### Подготовка окружения
Для работы скриптов используется файл .env, содержащий параметры БД. Он должен располагаться в одной директории с запускаемыми скриптами. Он должен содержать следующие переменные:
- параметры для подключения и создания контейнера с БД источинка
  - `SOURCE_DB_DOCKER_CONTAINER_NAME` - название docker-контейнера
  - `SOURCE_DB_DOCKER_CONTAINER_PORT` - внешний порт, чтобы подключиться к БД в контейнере 
  - `SOURCE_DB_NAME` - название БД источника
- параметры для подключения и создания контейнера с БД таргета
  - `TARGET_DB_DOCKER_CONTAINER_NAME` - название docker-контейнера 
  - `TARGET_DB_DOCKER_CONTAINER_PORT` - внешний порт, чтобы подключиться к БД в контейнере 
  - `TARGET_DB_NAME` - название БД таргета
- параметры для подключения и создания контейнера с airflow
  - `AIRFLOW_DOCKER_CONTAINER_NAME` - название docker-контейнера
  - `AIRFLOW_DOCKER_CONTAINER_PORT` - внешний порт, чтобы подключиться к веб-сервису в контейнере
- общие параметры подключения к обеим БД:
  - `DB_USER` - имя пользователя
  - `DB_PASSWORD` - пароль 

Ниже пример наполнения `.env`:
```
SOURCE_DB_DOCKER_CONTAINER_NAME=my_postgres_source
SOURCE_DB_DOCKER_CONTAINER_PORT=54320
SOURCE_DB_NAME=my_source_database
TARGET_DB_DOCKER_CONTAINER_NAME=my_postgres_target
TARGET_DB_DOCKER_CONTAINER_PORT=5433
TARGET_DB_NAME=my_target_database
AIRFLOW_DOCKER_CONTAINER_NAME=my_airflow
AIRFLOW_DOCKER_CONTAINER_PORT=8082
DB_USER=root
DB_PASSWORD=postgres
```

Помимо этого в директории с файлами скриптов должна присутвовать поддиректория ```tcph```, содержащая в себе файлы:
- файл .ddl, описывающий структуры БД:
  - `dss.ddl` 
- файлы, содержащие данные для таблиц БД:
  - `customer.tbl`
  - `lineitem.tbl`
  - `nation.tbl`
  - `orders.tbl`
  - `part.tbl`
  - `pastsupp.tbl`
  - `region.tbl`
  - `supplier.tbl`
  
Для работы скриптов требуются:
 * установленный `python version 3.9` и выше с пакетами:
   * `psycopg2` 
   * `python-dotenv`
 * `docker-compose version 1.25.0` и выше
 * командная оболочка `bash`

### Порядок запуска скриптов
1. Для создания контейнеров в директории с файлом docker-compose.yml выполнить: `bash docker_create_containers.sh`
2. Для создания БД и наполнения БД источника в контейнерах требуется в директории с папкой tcph выполнить: `bash docker_create_db.sh`
3. Запустить процесс ETL из БД источника в БД таргета можно двумя способами:
   * выполнить python-скрипт `etl.py`
   * ?

### Удаление контейнеров и используемого места на диске
Находясь в директории запустить скрипт из командной оболочки: `bash docker_rm.sh`