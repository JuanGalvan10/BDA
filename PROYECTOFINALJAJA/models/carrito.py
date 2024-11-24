from database import mysql
import MySQLdb.cursors
import hashlib

class Carrito:
    @staticmethod
    def get_metodos(idUser):
        cur = mysql.connection.cursor()
        cur.callproc('mostrarMetodoPagoCliente(%s)',(idUser,))
        metodos = cur.fetchall()
        cur.close()
        return metodos
    
    def get_direccion_User(idUser):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerDireccion(%s)',(idUser,))
        direcccion = cur.fetchall()
        cur.close()
        return direcccion

    def get_direccion_restaurantes():
        cur = mysql.connection.cursor()
        cur.callproc('obtenerDireccionesR')
        direccciones = cur.fetchall()
        cur.close()
        return direccciones
    