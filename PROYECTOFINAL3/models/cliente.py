from database import mysql
import MySQLdb.cursors
import hashlib

class Cliente:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('mostrarUsuarios')
        users = cur.fetchall()
        cur.close()
        return users
    
    @staticmethod
    def insert(nombre,apellidos,correo, telefono, direccion, puntos, password, nombre_usuario):
        # Insertar el User
        cur = mysql.connection.cursor()
        # corregir nombre de proc
        cur.callproc('registrarUsuario', (nombre_usuario, password, 'cliente'))
        mysql.connection.commit()
        
        # Obtener el ID del User recién insertado
        id_usuario = cur.lastrowid

        # Insertar detalles del User
        cur.callproc('registrarCliente', (id_usuario, nombre, apellidos, telefono, correo, puntos, direccion))      
        mysql.connection.commit()
        cur.close()
    
    @staticmethod
    def get_by_id(idUser):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('obtenerUser', (idUser,))
        User = cur.fetchone()
        cur.close()
        return User
    
    @staticmethod
    def get_cliente_by_id(idCliente):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('obtenerCliente', (idCliente,))
        Cliente = cur.fetchone()
        cur.close()
        return Cliente
    
    @staticmethod
    def update(nombre,apellidos,correo, telefono, direccion, puntos):
        cur = mysql.connection.cursor()
        cur.callproc("actualizaCliente(%s,%s,%s,%s,%s,%s)", (nombre,apellidos,correo, telefono, direccion, puntos))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def delete(idCliente):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarCliente', (idCliente,))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def update_direccion(idUsuario, nuevadireccion):
        cur = mysql.connection.cursor()
        cur.callproc('nuevaDireccion(%s,%s)', (idUsuario,nuevadireccion,))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def nueva_tarjeta(idCliente, num_tarjeta, fecha_expiracion, nombre_metodo):
        cur = mysql.connection.cursor()
        cur.callproc('nuevaTarjeta(%s,%s,%s,%s)', (idCliente,num_tarjeta,fecha_expiracion,nombre_metodo,))
        mysql.connection.commit()
        cur.close()



