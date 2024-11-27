from database import mysql
import MySQLdb.cursors
import hashlib

class Carrito:
    @staticmethod
    def get_metodos(idUser):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('mostrarMetodoPagoCliente',(idUser,))
            metodos = cur.fetchall()
            cur.close()
            return True, metodos
        except Exception as e:
            cur.close()
            return False, str(e)
    
    def get_direccion_User(idUser):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerDireccion',(idUser,))
            direcccion = cur.fetchall()
            cur.close()
            return True, direcccion
        except Exception as e:
            cur.close()
            return False, str(e)

    def get_direccion_restaurantes():
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerDireccionesR')
            direccciones = cur.fetchall()
            cur.close()
            return True , direccciones
        except Exception as e:
            cur.close()
            return False, str(e)
    