from database import mysql
import MySQLdb.cursors
import hashlib

class Producto:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor()
        cur.callproc('mostrarProductos')
        productos = cur.fetchall()
        cur.close()
        return productos
    
    @staticmethod
    def get_by_id(producto_id):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerProducto(%s)', (producto_id,))
        producto = cur.fetchone()
        cur.close()
        return producto

    @staticmethod
    def insert(nombre, imagen_URL, precio, descripcion, categoria):
        cur = mysql.connection.cursor()
        cur.callproc("nuevoProducto(%s,%s,%s,%s,%s)", (nombre, imagen_URL, precio, descripcion, categoria))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def update(nombre, imagen_URL, precio, descripcion, categoria):
        cur = mysql.connection.cursor()
        cur.callproc("actualizaProducto(%s,%s,%s,%s,%s)", (nombre, imagen_URL, precio, descripcion, categoria))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def delete(producto_id):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarProducto(%s)', (producto_id,))
        mysql.connection.commit()
        cur.close()
