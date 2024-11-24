from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify
from config import MYSQL_HOST, MYSQL_USER,MYSQL_PASSWORD,MYSQL_DB, SECRET_KEY
from database import mysql, init_app
from models.login import register_usuario, login_user, register_cliente

#controladores
from controllers.login_controller import login, register_user,register_user_client, register_client, logout
from controllers.producto_controller import mostrar_productos, nuevo_producto, editar_producto, eliminar_producto
from controllers.pedido_controller import mostrar_pedidos, nuevo_pedido, eliminar_pedido
from controllers.cliente_controller import mostrar_clientes, nuevo_cliente, eliminar_cliente, editar_cliente, guardar_direccion
from controllers.resena_controller import mostrar_resenas, nuevo_resena, eliminar_resena
from controllers.reserva_controller import mostrar_reservas, nuevo_reserva, eliminar_reserva, editar_reserva, horas_disponibles
from controllers.carrito_controller import agregarCarrito, checkoutResumen, checkoutPago, checkoutEnvio, pagar

app = Flask(__name__)

app.config['MYSQL_HOST'] = MYSQL_HOST
app.config['MYSQL_USER'] = MYSQL_USER
app.config['MYSQL_PASSWORD'] = MYSQL_PASSWORD
app.config['MYSQL_DB'] = MYSQL_DB
app.secret_key = SECRET_KEY

init_app(app)

#definimos la ruta del landing
@app.route('/')
def inicio():
    if 'loggedin' in session:
        return redirect(url_for('vista_principal'))
    else:
        return render_template('index.html')

@app.route('/dashboard')
def vista_principal():
    if 'loggedin' in session:
        if session['rol'] == 'cliente':
            return render_template('dashboard_clientes.html', usuario = session['usuario'])
        else:
            return render_template('DashboardAdmins.html', usuario = session['usuario'])
    else:
        flash('Primero ingresa al sistema','error')
        return redirect(url_for('login'))

#RUTAS PARA LA AUTENTICACION
app.add_url_rule('/login', view_func=login, methods = ['GET', 'POST'])
app.add_url_rule('/register_client/<int:idUsuario>', view_func=register_client, methods = ['GET', 'POST'])
app.add_url_rule('/register_user_client', view_func=register_user_client, methods = ['GET', 'POST'])
app.add_url_rule('/register_user', view_func=register_user, methods = ['GET', 'POST'])
app.add_url_rule('/logout', view_func=logout)

#RUTAS PARA PRODUCTOS
app.add_url_rule('/productos', view_func=mostrar_productos, methods = ['GET', 'POST'])
app.add_url_rule('/nuevo_producto', view_func=nuevo_producto,  methods = ['GET', 'POST'])
app.add_url_rule('/editar_producto/<int:id>', view_func=editar_producto,  methods = ['GET', 'POST'])
app.add_url_rule('/eliminar_producto/<int:id>', view_func=eliminar_producto,  methods = ['GET', 'POST'])

#RUTAS PARA Clientes
app.add_url_rule('/clientes', view_func=mostrar_clientes, methods = ['GET', 'POST'])
app.add_url_rule('/nuevo_cliente', view_func=nuevo_cliente,  methods = ['GET', 'POST'])
app.add_url_rule('/editar_cliente/<int:id>', view_func=editar_cliente,  methods = ['GET', 'POST'])
app.add_url_rule('/eliminar_cliente/<int:id>', view_func=eliminar_cliente,  methods = ['GET', 'POST'])


#RUTAS PARA RESERVAS
app.add_url_rule('/reservas', view_func=mostrar_reservas, methods = ['GET', 'POST'])
app.add_url_rule('/nuevo_reserva', view_func=nuevo_reserva,  methods = ['GET', 'POST'])
app.add_url_rule('/editar_reserva/<int:id>', view_func=editar_reserva,  methods = ['GET', 'POST'])
app.add_url_rule('/eliminar_reserva/<int:id>', view_func=eliminar_reserva,  methods = ['GET', 'POST'])

#RUTAS PARA PEDIDOS
app.add_url_rule('/pedidos', view_func=mostrar_pedidos, methods = ['GET', 'POST'])
app.add_url_rule('/nuevo_pedido', view_func=nuevo_pedido,  methods = ['GET', 'POST'])
app.add_url_rule('/eliminar_pedido/<int:id>', view_func=eliminar_pedido,  methods = ['GET', 'POST'])

#RUTAS PARA RESENAS
app.add_url_rule('/resenas', view_func=mostrar_resenas, methods = ['GET', 'POST'])
app.add_url_rule('/nuevo_resena', view_func=nuevo_resena,  methods = ['GET', 'POST'])
app.add_url_rule('/eliminar_resena/<int:id>', view_func=eliminar_resena,  methods = ['GET', 'POST'])
app.add_url_rule('/horas_disponibles',view_func=horas_disponibles, methods=['POST'])

#RUTAS PARA EL CHECKOUT
app.add_url_rule('/agregarCarrito', view_func=agregarCarrito, methods = ['GET', 'POST'])
app.add_url_rule('/chechoutResumen', view_func=checkoutResumen,  methods = ['GET', 'POST'])
app.add_url_rule('/checkoutEnvio', view_func=checkoutEnvio,  methods = ['GET', 'POST'])
app.add_url_rule('/checkoutPago',view_func=checkoutPago, methods=['POST'])
app.add_url_rule('/pagar',view_func=pagar, methods=['POST'])
app.add_url_rule('/guardar_direccion', view_func=guardar_direccion,  methods = ['GET', 'POST'])
app.add_url_rule('/insertar_tarjeta', view_func=guardar_direccion,  methods = ['GET', 'POST'])

@app.route('/reservasC')
def reservas():
    if 'loggedin' in session:
        return render_template('reservas.html')
    else:
        flash('Primero ingresa al sistema','error')
        return redirect(url_for('login'))
    
@app.route('/galeria')
def galeria():
    loggedin = False
    if 'loggedin' in session:
        loggedin = True
    return render_template('galeria.html', loggedin = loggedin)

@app.route('/mi_perfil')
def mi_perfil():
    if 'loggedin' in session:
        return render_template('mi_perfil.html')
    else:
        flash('Primero ingresa al sistema','error')
        return redirect(url_for('login'))

@app.route('/nueva_tarjeta')
def nueva_tarjeta():
    return render_template('AgregarNuevaTarjeta.html')

@app.route('/menu')
def menu():
    loggedin = False
    if 'loggedin' in session:
        loggedin= True
    return render_template('menu.html', loggedin = loggedin)