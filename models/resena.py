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
    def get_by_id(resena_id):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerResena(%s)', (resena_id,))
        resena = cur.fetchone()
        cur.close()
        return resena
    
    @staticmethod
    def get_by_producto(productoID):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerResenasProducto(%s)', (productoID,))
        resenas = cur.fetchall()
        cur.close()
        return resenas
    
    @staticmethod
    def get_by_cliente(idUsuario):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerResenasCliente(%s)', (idUsuario,))
        resenas = cur.fetchall()
        cur.close()
        return resenas

    @staticmethod
    def insert(puntuacion, comentario, idPedido, idProducto):
        cur = mysql.connection.cursor()
        cur.callproc("nuevaResena(%s,%s,%s,%s)", (puntuacion, comentario, idPedido, idProducto))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def delete(resena_id):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarResena(%s)', (resena_id,))
        mysql.connection.commit()
        cur.close()
