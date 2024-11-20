from flask import Flask, render_template, request, redirect, url_for, flash, session
from config import MYSQL_HOST, MYSQL_USER,MYSQL_PASSWORD,MYSQL_DB, SECRET_KEY
from database import mysql, init_app
from models.user import register_user, login_user

#controladores
from controllers.usuario_controller import login, register, logout
from controllers.producto_controller import mostrar_productos, nuevo_producto, editar_producto, eliminar_producto
from controllers.pedido_controller import mostrar_pedidos, nuevo_pedido, eliminar_pedido

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
    return redirect(url_for('login'))

@app.route('/dashboard')
def vista_principal():
    if 'loggedin' in session:
        if session['rol'] == 'cliente':
            return render_template('dashboard_cliente.html', usuario = session['usuario'])
        else:
            return render_template('dashboard_cliente.html', usuario = session['usuario'])
    else:
        flash('Primero ingresa al sistema','error')
        return redirect(url_for('login'))

#RUTAS PARA LA AUTENTICACION
app.add_url_rule('/login', view_func=login, methods = ['GET', 'POST'])
app.add_url_rule('/register', view_func=register, methods = ['GET', 'POST'])
app.add_url_rule('/logout', view_func=logout)

#RUTAS PARA PRODUCTOS
app.add_url_rule('/productos', view_func=mostrar_productos, methods = ['GET', 'POST'])
app.add_url_rule('/nuevo_producto', view_func=nuevo_producto,  methods = ['GET', 'POST'])
app.add_url_rule('/editar_producto/<int:id>', view_func=editar_producto,  methods = ['GET', 'POST'])
app.add_url_rule('/eliminar_producto/<int:id>', view_func=eliminar_producto,  methods = ['GET', 'POST'])

#RUTAS PARA PEDIDOS
app.add_url_rule('/pedidos', view_func=mostrar_pedidos, methods = ['GET', 'POST'])
app.add_url_rule('/nuevo_pedido', view_func=nuevo_pedido,  methods = ['GET', 'POST'])
app.add_url_rule('/eliminar_pedido/<int:id>', view_func=eliminar_pedido,  methods = ['GET', 'POST'])