from database import mysql
import MySQLdb.cursors
import hashlib

class Resena:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('mostrarResenas')
        resenas = cur.fetchall()
        cur.close()
        return resenas
    
    @staticmethod
    def get_by_id(resena_id):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('obtenerResena', (resena_id,))
        resena = cur.fetchone()
        cur.close()
        return resena
    
    @staticmethod
    def get_by_producto(productoID):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('obtenerResenasProducto', (productoID,))
        resenas = cur.fetchall()
        cur.close()
        return resenas
    
    @staticmethod
    def get_by_cliente(idCliente):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('obtenerResenasCliente', (idCliente,))
        resenas = cur.fetchall()
        cur.close()
        return resenas

    @staticmethod
    def insert(puntuacion, titulo, comentario, idCliente, idTipoRes):
        cur = mysql.connection.cursor()
        cur.callproc("nuevaResena(%s,%s,%s,%s)", (puntuacion, titulo, comentario, idCliente,idTipoRes))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def delete(resena_id):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarResena', (resena_id,))
        mysql.connection.commit()
        cur.close()
