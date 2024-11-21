from flask import Flask, render_template, request, redirect, url_for, flash, session
from models.pedido import Pedido

def mostrar_pedidos():
    if 'loggedin' in session:
        if request.method == 'POST':
            accion = request.form['accion']
            if accion:
                id = request.form['id']
                if accion == 'Editar':
                    return redirect(url_for('editar_pedido', id=id))
                else:
                    return redirect(url_for('eliminar_pedido', id=id))
        if session['rol'] == 'admin':
            pedidos = Pedido.get_all()
            return render_template('Ventas.html', pedidos = pedidos)
        else:
            pedidos = Pedido.get_by_cliente(session['idUsuario'])
            return render_template('Mis_pedidos.html', pedidos = pedidos)
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))


def nuevo_pedido():
    if 'loggedin' in session:
        if request.method == 'POST':
            productos = request.form.getlist('productos[]')
            cantidades = request.form.getlist('cantidades[]') 
            id_cliente  = session['idUsuario']
            Pedido.insert(id_cliente, productos, cantidades)
            return render_template('Confirmacion.html')
        return render_template('Pago.html')
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def eliminar_pedido(id):
    if 'loggedin' in session:
        if request.method =='POST':
            try:
                Pedido.delete(id,)
                flash('Pedido eliminado correctamente', 'success')
                if session['rol'] == 'admin':
                    pedidos = Pedido.get_all()
                    return render_template('Ventas.html', pedidos = pedidos)
                else:
                    pedidos = Pedido.get_by_cliente(session['idUsuario'])
                    return render_template('Mis_pedidos.html', pedidos = pedidos)
            except Exception as e:
                return {"error": str(e)}, 500
        else:
            flash('Metodo de acceso incorrecto')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
