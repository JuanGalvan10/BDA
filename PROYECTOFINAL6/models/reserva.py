from database import mysql
import MySQLdb.cursors
import hashlib

class Reserva:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerReservas')
            reservas = cur.fetchall()
            cur.close()
            return True, reservas
        except Exception as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_by_id(reserva_id):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            cur.callproc('obtenerReserva', (reserva_id,))
            reserva = cur.fetchone()
            cur.close()
            return True, reserva
        except Exception as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_by_cliente(IdCliente):
        try:
            cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cur.callproc('obtenerReservasCliente', (IdCliente,))
            reservas = cur.fetchall()
            cur.close()
            return reservas
        except Exception as e:
            cur.close()
            return False, str(e)
    
    @staticmethod
    def get_by_dia(fecha):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        # Consulta SQL para obtener las horas ocupadas
        try:
            cur.callproc('obtenerReservasDia', [fecha])
            horas_ocupadas = [row[0] for row in cur.fetchall()]
            cur.close()    
            return horas_ocupadas
        except Exception as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def insert(fechaReserva, hora_reserva, num_personas, idStatus, tema, idCliente):
        cur = mysql.connection.cursor()
        try:
            cur.callproc("nuevaReserva(%s,%s,%s,%s,%s)", (fechaReserva, hora_reserva, num_personas, idStatus, tema, idCliente))
            mysql.connection.commit()
            cur.close()
        except Exception as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def delete(reserva_id):
        cur = mysql.connection.cursor()
        try:
            cur.callproc('eliminarReserva', (reserva_id,))
            mysql.connection.commit()
            cur.close()
        except Exception as e:
            cur.close()
            return False, str(e)
