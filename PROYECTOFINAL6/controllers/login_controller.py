from flask import Flask, render_template, request, redirect, url_for, flash, session
from models.login import register_usuario, login_user, register_cliente, get_users, get_id_cliente
import hashlib

def login():
    if request.method == 'POST':
        username = request.form['username']
        password = hashlib.sha256(request.form['password'].encode()).hexdigest()
        success, user = login_user(username,password)
        if success:
            if user:
                session['loggedin'] = True
                session['idUsuario'] = user['idUsuario']
                session['usuario'] = user['nombre_usuario']
                session['rol'] = user['nombre']
                if session['rol'] == 'cliente':
                    session['idCliente'] = get_id_cliente(session['idUsuario'])
                session['productos'] = []
                session['subtotal'] = 0
                flash('Acceso exitoso', 'success')
                return redirect(url_for('vista_principal'))
            else:
                flash('Usuario o password incorrecto, verifique de nuevo', 'error')
        else:
            message = user
            flash(message, 'error')
            return redirect(url_for('login'))
    return render_template('login.html')

def register_user():
    if request.method == 'POST':
        username = request.form['username']
        password = hashlib.sha256(request.form['password'].encode()).hexdigest()
        rol = request.form['rol']
        success, message, idUsuario = register_usuario(username, password, rol)
        if success:
            flash('Registro exitoso', 'success')
            return redirect(url_for('register_user')) # ruta para msotrar usuarios
        else:
            flash(message, 'error')
            return redirect(url_for('register')) # ruta para registrar usuarios
    return render_template('registro.html') # pagina para registrar usuarios

def register_user_client():
    if request.method == 'POST':
        username = request.form['username']
        password = hashlib.sha256(request.form['password'].encode()).hexdigest()
        rol = 'cliente'
        success, message, idUsuario = register_usuario(username, password, rol)
        print(success)
        if success:
            return redirect(url_for('register_client', idUsuario = idUsuario))
        else:
            flash(message, 'error')
            return redirect(url_for('register_user_client'))
    return render_template('registro_login2.html')

def register_client(idUsuario):
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        correo = request.form['correo']
        telefono = request.form['telefono']
        direccion = request.form['direccion']
        success, message = register_cliente(idUsuario, nombre, apellido, telefono , correo, direccion)
        if success:
            flash('Registro exitoso', 'success')
            return redirect(url_for('login'))
        else:
            flash(message, 'error')
            return redirect(url_for('register_client', idUsuario = idUsuario))
    if idUsuario:
        return render_template('registro_login.html')
    else:
        return redirect(url_for('register_user'))

def logout():
    session.clear()
    flash('Sesión cerrada', 'info')
    return render_template('DASHBOARD_LOGOUT.html')

def mostrar_usuarios():
    if 'loggedin' in session:
        usuarios = get_users()
        return render_template('Usuarios.html', usuarios = usuarios, nombre_usuario = session['usuario'])
    else:
        flash('Credenciales invalidas', 'error')
        return redirect(url_for(login))