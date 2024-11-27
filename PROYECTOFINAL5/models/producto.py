from database import mysql
import MySQLdb.cursors
import hashlib

class Producto:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('mostrarPlatillos')
            productos = cur.fetchall()
            cur.close()
            return True, productos
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_by_id(producto_id):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerPlatillo', (producto_id,))
            producto = cur.fetchone()
            cur.close()
            return True, producto
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def insert(nombre, imagen_URL, precio, descripcion, categoria):
        cur = mysql.connection.cursor()
        try:
            cur.callproc("nuevoPlatillo", (nombre, imagen_URL, precio, descripcion, categoria))
            mysql.connection.commit()
            cur.close()
            return True, 'Platillo agregado exitosamente'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def update(nombre, imagen_URL, precio, descripcion, categoria):
        cur = mysql.connection.cursor()
        try:
            cur.callproc("actualizaPlatillo", (nombre, imagen_URL, precio, descripcion, categoria))
            mysql.connection.commit()
            cur.close()
            return True, 'Platillo actualizado exitosamente'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def delete(producto_id):
        cur = mysql.connection.cursor()
        try:
            cur.callproc('eliminarPlatillo', (producto_id,))
            mysql.connection.commit()
            cur.close()
            return True, 'Platillo eliminado exitosamente'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def obtenerRecomendados(idCliente):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('recomendarPlatillosCliente', (idCliente,))
            productos = cur.fetchall()
            cur.close()
            return True, productos
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)


