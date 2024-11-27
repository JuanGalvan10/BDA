from database import mysql
import MySQLdb.cursors
import hashlib

class Resena:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('mostrarResenas')
            resenas = cur.fetchall()
            cur.close()
            return True, resenas
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_by_id(resena_id):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerResena', (resena_id,))
            resena = cur.fetchone()
            cur.close()
            return True, resena
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_by_producto(productoID):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerResenasProducto', (productoID,))
            resenas = cur.fetchall()
            cur.close()
            return True, resenas
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_by_cliente(idCliente):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerResenasCliente', (idCliente,))
            resenas = cur.fetchall()
            cur.close()
            return True, resenas
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def insert(puntuacion, titulo, comentario, idCliente, idTipoRes):
        cur = mysql.connection.cursor()
        try:
            cur.callproc("nuevaResena(%s,%s,%s,%s)", (puntuacion, titulo, comentario, idCliente,idTipoRes))
            mysql.connection.commit()
            cur.close()
            return True, 'Resena insertada exitosamente'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def delete(resena_id):
        cur = mysql.connection.cursor()
        try:
            cur.callproc('eliminarResena', (resena_id,))
            mysql.connection.commit()
            cur.close()
            return True, 'Resena eliminada exitosamente'
        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)
