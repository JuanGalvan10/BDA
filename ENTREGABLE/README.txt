Proyecto Final - Sistema de Reservas y Ventas
Este proyecto es una aplicación web desarrollada en Flask que utiliza una base de datos MySQL. Este archivo describe los pasos necesarios para configurar y ejecutar el sistema en una instancia de Google Cloud Platform (GCP).

Requisitos previos
Instancia de GCP configurada con acceso a la terminal.
Python 3.10+ y pip instalados en la instancia.
MySQL o MariaDB instalados en la instancia.
Archivos del proyecto comprimidos en proyectofinal.tar.
Los archivos dump.sql y procedures.sql disponibles en la misma carpeta que el proyecto.
Pasos para ejecutar el sistema
1. Transferir los archivos al servidor
subir los archivos 

scp proyectofinal.tar usuario@IP_DE_LA_INSTANCIA:/home/usuario/
2. Acceder a la instancia GCP
Conéctate a la instancia usando ssh:

ssh usuario@IP_DE_LA_INSTANCIA
3. Descomprimir los archivos del proyecto
Una vez conectado a la instancia, descomprime el archivo proyectofinal.tar:

tar -xvf proyectofinal.tar
cd proyectofinal
4. Configurar la base de datos
Inicia sesión en MySQL como root:

sudo mysql -u root -p
Crear la base de datos:

CREATE DATABASE restaurantes;
Crear el usuario user_01 con contraseña 666 y asignar privilegios:

CREATE USER 'user_01'@'localhost' IDENTIFIED BY '666';
GRANT ALL PRIVILEGES ON restaurantes.* TO 'user_01'@'localhost';
FLUSH PRIVILEGES;
Cargar el dump de datos: Sal de MySQL y ejecuta:

mysql -u user_01 -p restaurantes < dump.sql
Cargar los procedimientos almacenados:

mysql -u user_01 -p restaurantes < procedures.sql

Exportar la variable de entorno para Flask:
export FLASK_APP=app.py
Ejecutar la aplicación:
flask run --host=0.0.0.0

Acceder al sistema: En un navegador, abre http://IP_DE_LA_INSTANCIA:5000.

Notas importantes
Asegúrate de que el puerto 5000 esté abierto en las reglas de firewall de GCP para permitir el acceso externo.