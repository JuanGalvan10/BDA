from database import mysql
import MySQLdb.cursors
import hashlib

class Carrito:
    @staticmethod
    def get_metodos(idUser):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerMetodos(%s)',(idUser,))
        metodos = cur.fetchall()
        cur.close()
        return metodos
    