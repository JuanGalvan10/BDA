from flask import Flask, render_template, request, redirect, url_for, flash, session
from DB.PROYECTOGIT.BDA.python.models.login import register_user, login_user, register_cliente
import hashlib

def login():
    if request.method == 'POST':
        username = request.form['user']
        password = hashlib.sha256(request.form['passwd'].encode()).hexdigest()
        user = login_user(username,password)
        if user:
            session['loggedin'] = True
            session['idUsuario'] = user['idUsuario']
            session['usuario'] = user['username']
            session['rol'] = user['rol']
            flash('Acceso exitoso', 'success')
            return redirect(url_for('vista_principal'))
        else:
            flash('Usuario o password incorrecto, verifique de nuevo', 'error')
    return render_template('login.html')

def register_user():
    if request.method == 'POST':
        username = request.form['user']
        password = hashlib.sha256(request.form['passwd'].encode()).hexdigest()
        username = request.form['rol']
        success, message = register_user(username, password)
        if success:
            flash('Registro exitoso', 'success')
            return redirect(url_for('login'))
        else:
            flash(message, 'error')
            return redirect(url_for('register'))
    return render_template('registro.html')

def register_user():
    if request.method == 'POST':
        username = request.form['user']
        password = hashlib.sha256(request.form['passwd'].encode()).hexdigest()
        username = request.form['rol']
        success, message = register_user(username, password)
        if success:
            flash('Registro exitoso', 'success')
            return redirect(url_for('login'))
        else:
            flash(message, 'error')
            return redirect(url_for('register'))
    return render_template('registro.html')

def register_user():
    if request.method == 'POST':
        username = request.form['user']
        password = hashlib.sha256(request.form['passwd'].encode()).hexdigest()
        rol = request.form['rol']
        success, message = register_user(username, password, rol)
        if success:
            flash('Registro exitoso', 'success')
            return redirect(url_for('login')) # ruta para msotrar usuarios
        else:
            flash(message, 'error')
            return redirect(url_for('register')) # ruta para registrar usuarios
    return render_template('registro.html') # pagina para registrar usuarios

def register_user_client():
    if request.method == 'POST':
        username = request.form['user']
        password = hashlib.sha256(request.form['passwd'].encode()).hexdigest()
        rol = 'cliente'
        success, message = register_user(username, password, rol)
        if success:
            flash('Registro exitoso', 'success')
            return redirect(url_for('login'))
        else:
            flash(message, 'error')
            return redirect(url_for('register_user_client'))
    return render_template('Registro_login.html')

def register_client():
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        correo = request.form['correo']
        telefono = request.form['telefono']
        direccion = request.form['direccion']
        success, message = register_cliente(nombre, apellido, correo, telefono, direccion)
        if success:
            flash('Registro exitoso', 'success')
            return render_template('Registro_login2.html')
        else:
            flash(message, 'error')
            return redirect(url_for('register'))
    return render_template('Registro_login.html')

def logout():
    session.pop('loggedin', None)
    session.pop('usuario', None)
    flash('Sesión cerrada', 'info')
    return redirect(url_for('login'))


