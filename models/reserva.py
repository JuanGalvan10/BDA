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
    def get_by_dia(fecha):
        cur = mysql.connection.cursor()
        # Consulta SQL para obtener las horas ocupadas
        cur.execute("""
            SELECT hora_reserva
            FROM RESERVA
            WHERE fecha_reserva = %s
            GROUP BY hora_reserva
            HAVING COUNT(*) >= 10
        """, [fecha])
        horas_ocupadas = [row[0] for row in cur.fetchall()]
        cur.close()    
        return horas_ocupadas

    @staticmethod
    def insert(fechaReserva, hora_reserva, num_personas, idStatus, tema):
        cur = mysql.connection.cursor()
        cur.callproc("nuevoReserva(%s,%s,%s,%s,%s)", (fechaReserva, hora_reserva, num_personas, idStatus, tema))
        mysql.connection.commit()
        cur.close()

    @staticmethod
    def delete(empresa_id):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarReserva(%s)', (empresa_id,))
        mysql.connection.commit()
        cur.close()
