from database import mysql
import MySQLdb.cursors
import hashlib

class Cliente:
    @staticmethod
    def get_usuarios():
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('mostrarUsuarios')
            users = cur.fetchall()
            cur.close()
            return True , users
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_clientes():
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('mostrarClientes')
            clientes = cur.fetchall()
            cur.close()
            return True, clientes
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def insert(nombre,apellidos,correo, telefono, direccion, puntos, password, nombre_usuario):
        cur = mysql.connection.cursor()
        try:
            cur.callproc('registrarUsuario', (nombre_usuario, password, 'cliente'))
            mysql.connection.commit()
            id_usuario = cur.lastrowid
            cur.callproc('registrarCliente', (id_usuario, nombre, apellidos, telefono, correo, puntos, direccion))      
            mysql.connection.commit()
            cur.close()
            return True, 'Registro exitoso'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_by_id(idUser):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerUser', (idUser,))
            User = cur.fetchone()
            cur.close()
            return True, User
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_cliente_by_id(idCliente):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerCliente', (idCliente,))
            Cliente = cur.fetchone()
            cur.close()
            return True, Cliente
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def update(nombre,apellidos,correo, telefono, direccion, puntos):
        cur = mysql.connection.cursor()
        try:
            cur.callproc("actualizaCliente(%s,%s,%s,%s,%s,%s)", (nombre,apellidos,correo, telefono, direccion, puntos))
            mysql.connection.commit()
            cur.close()
            return True, 'Cliente actualizado exitosamente'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def delete(idCliente):
        cur = mysql.connection.cursor()
        try:
            cur.callproc('eliminarCliente', (idCliente,))
            mysql.connection.commit()
            cur.close()
            return True, 'Cliente eliminado exitosamente'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def update_direccion(idUsuario, nuevadireccion):
        cur = mysql.connection.cursor()
        try:
            cur.callproc('nuevaDireccion(%s,%s)', (idUsuario,nuevadireccion,))
            mysql.connection.commit()
            cur.close()
            return True, 'Nueva direccion agregada'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def nueva_tarjeta(idCliente, num_tarjeta, fecha_expiracion, nombre_metodo):
        cur = mysql.connection.cursor()
        try:
            cur.callproc('nuevaTarjeta(%s,%s,%s,%s)', (idCliente,num_tarjeta,fecha_expiracion,nombre_metodo,))
            mysql.connection.commit()
            cur.close()
            return True, 'Tarjeta agregada exitosamente'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)



