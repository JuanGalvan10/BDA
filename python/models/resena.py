from database import mysql
import MySQLdb.cursors
import hashlib

class Resena:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor()
        cur.callproc('mostrarResenas')
        resenas = cur.fetchall()
        cur.close()
        return resenas
    
    @staticmethod
    def get_by_id(empresa_id):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerResena(%s)', (empresa_id,))
        resena = cur.fetchone()
        cur.close()
        return resena
    
    @staticmethod
    def get_by_cliente(idUsuario):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerResenasCliente(%s)', (idUsuario,))
        resenas = cur.fetchall()
        cur.close()
        return resenas

    @staticmethod
    def insert(nombre, imagen_URL, precio, descripcion, categoria):
        cur = mysql.connection.cursor()
        cur.callproc("nuevoResena(%s,%s,%s,%s,%s)", (nombre, imagen_URL, precio, descripcion, categoria))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def delete(empresa_id):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarResena(%s)', (empresa_id,))
        mysql.connection.commit()
        cur.close()
