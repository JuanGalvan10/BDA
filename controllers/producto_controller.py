from flask import Flask, render_template, request, redirect, url_for, flash, session
from DB.Proyecto.models.producto import Producto

def mostrar_productos():
    if 'loggedin' in session:
        if request.method == 'POST':
            accion = request.form['accion']
            if accion:
                id = request.form['id']
                if accion == 'Editar':
                    return redirect(url_for('editar_producto', id=id))
                else:
                    return redirect(url_for('eliminar_producto', id=id))
        productos = Producto.get_all()
        if session['rol'] == 'admin':
            return render_template('inventario.html', productos = productos)
        else:
            return render_template('catalogo.html', productos = productos)
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))


def nuevo_producto():
    if 'loggedin' in session:
        if request.method =='POST':
            nombre = request.form['nombre']
            imagen_URL = request.form['imagen']
            precio = request.form['precio']
            descripcion= request.form['desc']
            categoria= request.form['categoria']
            Producto.insert(nombre, imagen_URL, precio, descripcion, categoria)
            return redirect(url_for('mostrar_productos'))
        return render_template('Crear_producto.html')
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def editar_producto(id):
    if 'loggedin' in session:
        if request.method =='POST':
            nombre = request.form['nombre']
            imagen_URL = request.form['imagen']
            precio = request.form['precio']
            descripcion= request.form['desc']
            categoria= request.form['categoria']
            Producto.update(nombre, imagen_URL, precio, descripcion, categoria)
            flash('Prdocuto actualizado correctamente', 'success')
            return redirect(url_for('mostrar_productos'))
        producto = Producto.get_by_id(id)
        return render_template('Editar_producto.html', producto = producto)
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def eliminar_producto(id):
    if 'loggedin' in session:
        if request.method =='POST':
            Producto.delete(id,)
            flash('Producto eliminado correctamente', 'success')
            return redirect(url_for('mostrar_prodcutos'))
        else:
            flash('Metodo de acceso incorrecto')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
