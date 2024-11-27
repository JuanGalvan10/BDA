from flask import Flask, render_template, request, redirect, url_for, flash, session
from models.producto import Producto
from models.resena import Resena

def mostrar_productos():
    productos = Producto.get_all()
    if 'loggedin' in session:
        if request.method == 'POST':
            accion = request.form['accion']
            if accion:
                id = request.form['id']
                if accion == 'Editar':
                    return redirect(url_for('editar_producto', id=id))
                else:
                    return redirect(url_for('eliminar_producto', id=id))
    if session['rol'] == 'admin':
        return render_template('Inventario.html', productos = productos)
    return render_template('catalogo.html', productos = productos, nombre_usuario = session['usuario'])

def ver_producto(id):
    producto = Producto.get_by_id(id)
    resenas = Resena.get_by_producto(id)
    return render_template('producto_especifico.html', producto = producto, resenas = resenas)
    
def nuevo_producto():
    if 'loggedin' in session:
        if request.method =='POST':
            nombre = request.form['nombre']
            imagen_URL = request.form['urlImagen']
            precio = request.form['precio']
            descripcion= request.form['desc']
            categoria= request.form['categoria']
            Producto.insert(nombre, imagen_URL, precio, descripcion, categoria)
            return redirect(url_for('mostrar_productos'))
        return render_template('Crear_producto.html', nombre_usuario = session['usuario'])
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def editar_producto(id):
    if 'loggedin' in session:
        if request.method =='POST':
            nombre = request.form['nombre']
            imagen_URL = request.form['urlImagen']
            precio = request.form['precio']
            descripcion= request.form['desc']
            categoria= request.form['categoria']
            Producto.update(nombre, imagen_URL, precio, descripcion, categoria)
            flash('Prdocuto actualizado correctamente', 'success')
            return redirect(url_for('mostrar_productos'))
        producto = Producto.get_by_id(id)
        return render_template('Editar_producto.html', producto = producto, nombre_usuario = session['usuario'])
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
            return redirect(url_for('mostrar_productos'))
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
