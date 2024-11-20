from database import mysql
import MySQLdb.cursors
import hashlib

class Reserva:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor()
        cur.callproc('mostrarReservas')
        reservas = cur.fetchall()
        cur.close()
        return reservas
    
    @staticmethod
    def get_by_id(reserva_id):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerReserva(%s)', (reserva_id,))
        reserva = cur.fetchone()
        cur.close()
        return reserva
    
    @staticmethod
    def get_by_cliente(idUsuario):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerReservasCliente(%s)', (idUsuario,))
        reservas = cur.fetchall()
        cur.close()
        return reservas

    @staticmethod
    def insert(nombre, imagen_URL, precio, descripcion, categoria):
        cur = mysql.connection.cursor()
        cur.callproc("nuevoReserva(%s,%s,%s,%s,%s)", (nombre, imagen_URL, precio, descripcion, categoria))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def delete(empresa_id):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarReserva(%s)', (empresa_id,))
        mysql.connection.commit()
        cur.close()
