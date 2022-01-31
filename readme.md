# О сборке
Сборка Docker для разработки приложений с использованием Linux, Apache, PostgreSQL и PHP.

### Струкура:
```
apache2/apache2.conf      файл конфигурации веб-сервера apache;  
apache2/site-available    файлы конфигурации приложений;  
postgres/data/            том контейнера db;  
.env                      файл с информацией о приложениях и БД.
```


# Использование
### **Сборка** проекта:
```
docker-compose build
```

### **Запуск** _(перезапуск)_ проекта:
```
docker-compose up
docker-compose restart
```

Чтобы полностью пересобрать контейнеры:
```
docker-compose up -d --no-deps --build
```

### Работа в CLI __php-apache__ и __postgres__:
```
docker-compose exec -it web bash
docker-compose exec -it db bash
```


## Приложения
По умолчанию в сборке для примера создано одно приложение app. Чтобы добавить еще одно приложение необходимо выполнить несколько действий:
1. Указать в файле _.env_ название приложения и путь к файлам проекта. Для приложения __app__ - это переменные *APP_NAME* и *APP_SRC*;
2. В файле _docker-compose.yaml_ добавить описание тома для контейнера _web_;
3. Добавить файл конфигурации приложения. Важно, чтобы директива _DocumentRoot_ в этом файле совпадала с правой частью описания тома этого приложения, т.е. правильно указывала на расположения файлов приложения;
4. Отредактировать файл _hosts_ ОС хост-машины.  
Например, добавить:   
_"127.0.0.1   app.test"_
5. _(Дополнительно)_ Для нового приложения необходимо вручную создать базу данных. Для этого необходимо воспользоваться CLI PostgeSQL внутри контейнера db. 

Для работы с базами данных используется один суперпользователь. Его имя **POSTGRES_USER** и пароль **POSTGRES_PASSWORD** указаны в файле _.env_. 

# Для Laravel
## Подготовка к разработке
1. В каталог приложения (который указан в файле _.env_) скопировать шаблон приложения Laravel:
```
git clone https://github.com/laravel/laravel.git
```

2. Создать пользователя и БД через CLI PostgreSQL в контейнере _db_:
```
CREATE USER username WITH PASSWORD 'password';
CREATE DATABASE database_name;
GRANT ALL PRIVILEGES ON DATABASE database_name TO username;
```

3. Файл _.env.example_ переименовать в _.env_;

4. Для работы с базой данных необходимо указать в .env файле параметры подключения к ней:
``` 
DB_CONNECTION=pgsql
DB_HOST=db                 (название контейнера БД, если не работает, указать localhost)
DB_PORT=5432               (порт в контейнере БД)
DB_DATABASE=database_name  (название БД)
DB_USERNAME=username       (имя пользователя)
DB_PASSWORD=password       (пароль)
```

4. Чтобы выполнить установку composer и подготовить прилоджение к разработке, нужно выполнить в CLI ОС контейнера web следующие команды:
```
composer install

php artisan config:cache
php artisan key:generate
php artisan migrate
```