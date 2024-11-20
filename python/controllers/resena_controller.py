from flask import Flask, render_template, request, redirect, url_for, flash, session
from DB.Proyecto.models.resena import Resena

def mostrar_reservas():
    if 'loggedin' in session:
        if request.method == 'POST':
            accion = request.form['accion']
            if accion:
                id = request.form['id']
                if accion == 'Editar':
                    return redirect(url_for('editar_reserva', id=id))
                else:
                    return redirect(url_for('eliminar_reserva', id=id))
        if session['rol'] == 'admin':
            reservas = Reserva.get_all()
            return render_template('Reservas.html', reservas = reservas)
        else:
            reservas = Reserva.get_by_cliente()
            return render_template('Mis_reservas.html', reservas = reservas)
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))


def nuevo_reserva():
    if 'loggedin' in session:
        if request.method =='POST':
            nombre = request.form['nombre']
            imagen_URL = request.form['imagen']
            precio = request.form['precio']
            descripcion= request.form['desc']
            categoria= request.form['categoria']
            Reserva.insert(nombre, imagen_URL, precio, descripcion, categoria)
            return redirect(url_for('mostrar_reservas'))
        return render_template('Crear_reserva.html')
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def editar_reserva(id):
    if 'loggedin' in session:
        if request.method =='POST':
            nombre = request.form['nombre']
            imagen_URL = request.form['imagen']
            precio = request.form['precio']
            descripcion= request.form['desc']
            categoria= request.form['categoria']
            Reserva.update(nombre, imagen_URL, precio, descripcion, categoria)
            flash('Prdocuto actualizado correctamente', 'success')
            return redirect(url_for('mostrar_reservas'))
        reserva = Reserva.get_by_id(id)
        return render_template('Editar_reserva.html', reserva = reserva)
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def eliminar_reserva(id):
    if 'loggedin' in session:
        if request.method =='POST':
            Reserva.delete(id,)
            flash('Reserva eliminado correctamente', 'success')
            return redirect(url_for('mostrar_prodcutos'))
        else:
            flash('Metodo de acceso incorrecto')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
