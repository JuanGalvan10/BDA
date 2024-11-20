from database import mysql
import MySQLdb.cursors
import hashlib


def register_user(username,password, rol):
    cur = mysql.connection.cursor()
    try: 
        cur.callproc('registrarUsuario', [username, password, rol])
        mysql.connection.commit()
        return True, 'Registro de usuario exitoso'
    except MySQLdb.OperationalError as e:
        return False, str(e)
    
def register_cliente(nombre,apellido, telefono, correo, direccion):
    cur = mysql.connection.cursor()
    try: 
        cur.callproc('registrarCliente', [nombre, apellido, telefono, correo, direccion])
        mysql.connection.commit()
        return True, 'Registro existoso'
    except MySQLdb.OperationalError as e:
        return False, str(e)

def login_user(username,password): 
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
#    hashed_password = hashlib.sha256(request.form['passwd'].encode()).hexdigest()
    cur.callproc('BuscaUsuario', [username])
    user = cur.fetchone()
    cur.close()

    if user:
        stored_password = user['password']
        if stored_password == password:
            return user
    else:
        return None

