# О сборке
Сборка Docker для разработки приложений с использованием Linux, Apache, PostgreSQL и PHP.


# Использование
### **Запуск** _(перезапуск)_ проекта:
```
docker-compose up
docker-compose restart
```

Чтобы полностью пересобрать контейнеры:
```
docker-compose up -d --no-deps --build
```

### Работа с контейнерами:
```
docker exec -it web bash
docker exec -it -u postgres db psql
```


## Приложения
По умолчанию в сборке для примера создано одно приложение ***example-app***. Чтобы добавить еще одно приложение необходимо выполнить несколько действий:
1. Указать в файле **.env** название приложения и путь к файлам проекта:
```
EXAMPLE_APP_NAME=example-app
EXAMPLE_APP_SRC=./example_app/
```

2. В файле _docker-compose.yaml_ добавить описание тома для контейнера _web_:
```
- ${EXAMPLE_APP_SRC}:/var/www/${EXAMPLE_APP_NAME}/
```

3. Добавить файл конфигурации приложения. Важно, чтобы директива _DocumentRoot_ в этом файле совпадала с правой частью описания тома этого приложения, т.е. правильно указывала на расположения файлов приложения;
```
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName example-app.test
    ServerAlias www.example-app.test
    DocumentRoot /var/www/example-app/
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

4. Отредактировать файл _/etc/hosts_ ОС хост-машины.  
Например, добавить:   
```
127.0.0.1       example-app.test
```