from flask import Flask, render_template, request, redirect, url_for, flash, session
from DB.Proyecto.models.cliente import Cliente

def mostrar_clientes():
    if 'loggedin' in session:
        if request.method == 'POST':
            accion = request.form['accion']
            if accion:
                id = request.form['id']
                if accion == 'Editar':
                    return redirect(url_for('editar_cliente', id=id))
                else:
                    return redirect(url_for('eliminar_cliente', id=id))
        if session['rol'] == 'admin':
            clientes = Cliente.get_all()
            return render_template('Clientes.html', clientes = clientes)
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))


def nuevo_cliente():
    if 'loggedin' in session:
        if request.method == 'POST':
            nombre = request.form['nombre']
            apellidos = request.form['apellidos']
            correo = request.form['correo']
            telefono = request.form['telefono']
            direccion= request.form['direccion']
            puntos= request.form['puntos']
            password = request.form['password']
            nombre_usuario = request.form['nombre_usuario']
            Cliente.insert(nombre, apellidos, correo, telefono, direccion, puntos, password, nombre_usuario)
            flash('Cliente creado correctamente', 'success')
            return redirect(url_for('mostrar_clientes'))
        return render_template('Crear_cliente.html')
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
def editar_cliente(id):
    if 'loggedin' in session:
        if request.method =='POST':
            nombre = request.form['nombre']
            apellidos = request.form['apellidos']
            correo = request.form['correo']
            telefono = request.form['telefono']
            direccion= request.form['direccion']
            Cliente.update(nombre, apellidos, correo, telefono, direccion)
            flash('Cliente actualizado correctamente', 'success')
            return redirect(url_for('mostrar_clientes'))
        cliente = Cliente.get_by_id(id)
        return render_template('Editar_cliente.html', cliente = cliente)
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def eliminar_cliente(id):
    if 'loggedin' in session:
        if request.method =='POST':
            try:
                Cliente.delete(id,)
                flash('cliente eliminado correctamente', 'success')
                if session['rol'] == 'admin':
                    clientes = Cliente.get_all()
                    return render_template('Ventas.html', clientes = clientes)
            except Exception as e:
                return {"error": str(e)}, 500
        else:
            flash('Metodo de acceso incorrecto')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))