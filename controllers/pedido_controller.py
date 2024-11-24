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
        if session['rol'] == 'cliente':
            resultados = Pedido.get_by_cliente(session['idUsuario'])
            pedidos = {}
            for row in resultados:
                id_pedido = row['idPedido']
                if id_pedido not in pedidos:
                    pedidos[id_pedido] = {
                        'idPedido': id_pedido,
                        'fecha_pedido': row['fecha_pedido'],
                        'fecha_entrega': row['fecha_entrega'],
                        'total_pedido': row['total_pedido'],
                        'idCliente': row['idCliente'],
                        'nombre_status': row['nombre_status'],
                        'platillos': []  
                    }
                pedidos[id_pedido]['platillos'].append({
                    'nombre': row['nombre'],
                    'imagen_URL': row['imagen_URL'],
                    'cantidad': row['cantidad'],
                    'precio_unitario': row['precio_unitario']
                })
            return render_template('Mis_pedidos.html', pedidos = pedidos)
        else:
            resultados = Pedido.get_by_all()
            pedidos = {}
            for row in resultados:
                id_pedido = row['idPedido']
                if id_pedido not in pedidos:
                    pedidos[id_pedido] = {
                        'idPedido': id_pedido,
                        'fecha_pedido': row['fecha_pedido'],
                        'fecha_entrega': row['fecha_entrega'],
                        'total_pedido': row['total_pedido'],
                        'idCliente': row['idCliente'],
                        'nombre_status': row['nombre_status'],
                        'platillos': []  
                    }
                pedidos[id_pedido]['platillos'].append({
                    'nombre': row['nombre'],
                    'imagen_URL': row['imagen_URL'],
                    'cantidad': row['cantidad'],
                    'precio_unitario': row['precio_unitario']
                })
            return render_template('Ventas.html', pedidos = pedidos, nombre_usuario = session['usuario'])
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
                    return render_template('Ventas.html', pedidos = pedidos, nombre_usuario = session['usuario'])
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
