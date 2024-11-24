from database import mysql
import MySQLdb.cursors
import hashlib

class Producto:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor()
        cur.callproc('mostrarPlatillos')
        productos = cur.fetchall()
        cur.close()
        return productos
    
    @staticmethod
    def get_by_id(producto_id):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerPlatillo(%s)', (producto_id,))
        producto = cur.fetchone()
        cur.close()
        return producto

    @staticmethod
    def insert(nombre, imagen_URL, precio, descripcion, categoria):
        cur = mysql.connection.cursor()
        cur.callproc("nuevoPlatillo(%s,%s,%s,%s,%s)", (nombre, imagen_URL, precio, descripcion, categoria))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def update(nombre, imagen_URL, precio, descripcion, categoria):
        cur = mysql.connection.cursor()
        cur.callproc("actualizaPlatillo(%s,%s,%s,%s,%s)", (nombre, imagen_URL, precio, descripcion, categoria))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def delete(producto_id):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarPlatillo(%s)', (producto_id,))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def obtenerRecomendados(idCliente):
        cur = mysql.connection.cursor()
        cur.callproc('recomendarPlatillosCliente(%s)', (idCliente,))
        productos = cur.fetchall()
        cur.close()
        return productos


