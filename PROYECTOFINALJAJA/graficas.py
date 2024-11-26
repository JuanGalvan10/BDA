from flask import Flask, render_template, request, jsonify
from flask_mysqldb import MySQL

app = Flask(__name__)
mysql = MySQL(app)

####### CONFIGURACION DE ACCESO A LA DB
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'user_01'
app.config['MYSQL_PASSWORD'] = '222'
app.config['MYSQL_DB'] = 'Restaurante'

print("Conectado a la base de datos.")

@app.route('/')
def inicio():
    return render_template('DashboardAdmins.html')

####### INICIO DE GRÁFICAS
@app.route('/data/status_de_clientes', methods=['GET'])
def status_de_clientes():
    cur = mysql.connection.cursor()
    cur.callproc('StatusDeClientes') 
    resultado = cur.fetchall()
    cur.close()
    return jsonify([{"name": row[0], "y": row[1]} for row in resultado])

@app.route('/data/status_de_reservas', methods=['GET'])
def status_de_reservas():
    cur = mysql.connection.cursor()
    cur.callproc('Status_Reservas') 
    resultado = cur.fetchall()
    cur.close()
    return jsonify([{"name": row[0], "y": row[1]} for row in resultado])

@app.route('/data/platillos_stock', methods=['GET'])
def platillos_stock():
    cur = mysql.connection.cursor()
    cur.callproc('PlatillosStock') 
    resultado = cur.fetchall()
    cur.close()
    return jsonify([{"name": row[0], "y": row[1]} for row in resultado])

@app.route('/data/compras_por_categoria', methods = ['GET'])
def compras_por_categoria():
    cur = mysql.connection.cursor()
    cur.callproc('ComprasXCategoria_gr') 
    resultado = cur.fetchall()
    cur.close()
    return jsonify([{"name": row[0], "y": row[1]} for row in resultado])

@app.route('/data/ventas_por_mes', methods=['GET'])
def ventas_por_mes():
    cur = mysql.connection.cursor()
    cur.callproc('VentasXMes_gr')
    resultado = cur.fetchall()
    cur.close()
    return jsonify([{"name": row[0], "y": row[1]} for row in resultado])

@app.route('/data/ventas_por_dia', methods = ['GET'])
def ventas_por_dia():
    cur = mysql.connection.cursor()
    cur.callproc('VentasXDia_gr') 
    resultado = cur.fetchall()
    cur.close()
    return jsonify([{"name": row[0], "Ventas_totales": float(row[1])} for row in resultado])

@app.route('/data/usuarios_activos', methods=['GET'])
def usuarios_activos():
    cur = mysql.connection.cursor()
    cur.callproc('UsuariosXRol_gr')
    resultado = cur.fetchall()
    cur.close()
    return jsonify([{"name": row[0], "y": row[1]} for row in resultado])

@app.route('/data/resenas_calif', methods=['GET'])
def resenas_calif():
    cur = mysql.connection.cursor()
    cur.callproc('resenasCalificaciones') 
    resultado = cur.fetchall()
    cur.close()
    return jsonify([{"name": row[0], "y": row[1]} for row in resultado])

@app.route('/data/promedio_resenas_calif', methods=['GET'])
def promedio_resenas_calif():
    cur = mysql.connection.cursor()
    cur.callproc('PromedioXTipoResenas_gr')
    resultado = cur.fetchall()
    cur.close()
    return jsonify([{"name": row[0], "y": row[1]} for row in resultado])

if __name__ == '__main__':
    app.run(debug=True)