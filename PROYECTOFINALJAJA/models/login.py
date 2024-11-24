from database import mysql
import MySQLdb.cursors
import hashlib


def register_usuario(username,password, rol):
    cur = mysql.connection.cursor()
    try: 
        id_usuario = None
        cur.callproc('registrarUsuario', [username, password, rol])
        result = cur.fetchone()
        id_usuario = result[0]
        mysql.connection.commit()
        cur.close()
        return True, 'Registro de usuario exitoso', id_usuario
    except MySQLdb.OperationalError as e:
        cur.close()
        return False, str(e), None
    
def register_cliente(idUsuario, nombre,apellido, telefono, correo, direccion):
    cur = mysql.connection.cursor()
    try: 
        cur.callproc('registrarCliente', [idUsuario, nombre, apellido, telefono, correo, direccion])
        mysql.connection.commit()
        cur.close()
        return True, 'Registro existoso'
    except MySQLdb.OperationalError as e:
        cur.close()
        return False, str(e)

def login_user(username,password): 
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.callproc('BuscaUsuario', [username])
    user = cur.fetchone()
    cur.close()

    if user:
        stored_password = user['password']
        if stored_password == password:
            return user
    else:
        return None

def get_users():
    cur = mysql.connection.cursor()
    try: 
        cur.callproc('mostrarUsuarios')
        usuarios = cur.fetchone()
        cur.close()
        return usuarios
    except MySQLdb.OperationalError as e:
        cur.close()
        return False, str(e)
    
def get_id_cliente(idCliente):
    cur = mysql.connection.cursor()
    cur.callproc('obtenerId(%s)', (idCliente,))
    id = cur.fetchone()
    cur.close()
    return id
