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
            success, resultados = Pedido.get_by_cliente(session['idUsuario'])
            if success:
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
            else:
                message = resultados
                flash(message, 'error')
                return redirect(url_for('mostrar_pedidos'))
            return render_template('mis_pedidos.html', pedidos = pedidos)
        else:
            success, pedidos = Pedido.get_all()
            if success:
                # Filtrar pedidos únicos basados en idPedido
                pedidos_unicos = {}
                for pedido in pedidos:
                    idPedido = pedido['idPedido']
                    if idPedido not in pedidos_unicos:
                        pedidos_unicos[idPedido] = pedido
                    else:
                        pass
                pedidos_unicos = list(pedidos_unicos.values())
            else:
                message = pedidos
                flash(message, 'error')
            return render_template('Ventas.html', pedidos = pedidos, nombre_usuario = session['usuario'])
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))


def nuevo_pedido():
    if 'loggedin' in session:
        if request.method == 'POST':
            productos = request.form.getlist('productos[]')
            cantidades = request.form.getlist('cantidades[]') 
            id_cliente  = session['idCliente']
            success, message = Pedido.insert(id_cliente, productos, cantidades)
            if success:
                flash(message, 'info')
                return render_template('Confirmacion.html')
            else:
                flash(message, 'error')
                return redirect(url_for('mostrar_pedidos'))
        return render_template('Pago.html')
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def eliminar_pedido(id):
    if 'loggedin' in session:
        if request.method =='POST':
                success, message = Pedido.delete(id,)
                if success:
                    flash(message, 'info')
                    return redirect(url_for('mostrar_pedidos'))
                else:
                    flash(message, 'error')
                    return redirect(url_for('mostrar_pedidos'))
        else:
            flash('Metodo de acceso incorrecto', 'error')
            return(url_for('mostrar_pedidos'))
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
