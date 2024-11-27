from flask import Flask, render_template, request, redirect, url_for, flash, session
from models.cliente import Cliente
from models.pedido import Pedido

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
        if session['rol'] == 'cliente':
            username = session['usuario']
            success, cliente = Cliente.get_cliente_by_id(session['idCliente'])
            if success:
                return render_template('mi_perfil.html', cliente = cliente, username = username)
            else:
                flash(cliente, 'error')
                redirect(url_for('mostrar_clientes'))
        else:
            success, clientes = Cliente.get_clientes()
            if success:
                success2, pedidos = Pedido.get_all()
                if success2:
                    pedidos_unicos = {pedido['idPedido']: pedido for pedido in pedidos}.values()
                    return render_template('Clientes.html', clientes = clientes,pedidos = pedidos_unicos, nombre_usuario = session['usuario'])
                else:
                    flash(pedidos, 'error')
                    redirect(url_for('mostrar_clientes'))
            else:
                flash(cliente, 'error')
                redirect(url_for('mostrar_clientes'))
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
            success, message = Cliente.insert(nombre, apellidos, correo, telefono, direccion, puntos, password, nombre_usuario)
            if success:
                flash('Cliente creado correctamente', 'success')
                return redirect(url_for('mostrar_clientes'))
            else:
                flash(message, 'error')
                redirect(url_for('mostrar_clientes'))
        if session['rol'] == 'admin':
            return render_template('Crear_cliente.html')
        else: 
            flash('No tienes permisos para acceder a esta pagina.', 'error')
            return redirect(url_for('login'))
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
            success, message = Cliente.update(nombre, apellidos, correo, telefono, direccion)
            if success:
                flash('Cliente actualizado correctamente', 'success')
                return redirect(url_for('mostrar_clientes'))
            else:
                flash(message, 'error')
                return redirect(url_for('mostrar_clientes'))
        if session['rol'] == 'cliente':
            success, cliente = Cliente.get_cliente_by_id(session['idCliente'])
            if success:
                return render_template('editar_mi_perfil.html', cliente = cliente)
            else:
                flash(cliente, 'error')
                return redirect(url_for('mostrar_clientes'))
        else:
            success, cliente = Cliente.get_cliente_by_id(id)
            if success:
                return render_template('Editar_cliente.html', cliente = cliente, nombre_usuario = session['usuario'])
            else:
                flash(cliente,'error')
                return redirect(url_for('mostrar_clientes'))
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def eliminar_cliente(id):
    if 'loggedin' in session:
        if request.method =='POST':
            success, message = Cliente.delete(id,)
            if success:
                flash('cliente eliminado correctamente', 'success')
            else:
                flash(message, 'error')
        else:
            flash('Metodo de acceso incorrecto', 'error')
        return redirect(url_for('mostrar_clientes'))
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
