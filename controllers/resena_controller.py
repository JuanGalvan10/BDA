from flask import Flask, render_template, request, redirect, url_for, flash, session
from models.resena import Resena

def mostrar_resenas():
    if 'loggedin' in session:
        if session['rol'] == 'admin':
            resenas = Resena.get_all()
            return render_template('Resenas.html', resenas = resenas,nombre_usuario = session['usuario'])
        else:
            resenas = Resena.get_by_cliente(session['idCliente'])
            return render_template('Mis_resenas.html', resenas = resenas)
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))


def nuevo_resena():
    if 'loggedin' in session:
        if request.method =='POST':
            puntuacion = request.form['puntuacion']
            comentario = request.form['comentario']
            idProducto = request.form['idProducto']
            idPedido = request.form['idPedido']
            Resena.insert(puntuacion, comentario, idProducto, idPedido)
            return redirect(url_for('mostrar_resenas'))
        return render_template('Crear_resena.html') #HTML de crear
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def eliminar_resena(id):
    if 'loggedin' in session:
        if request.method =='POST':
            Resena.delete(id,)
            flash('Resena eliminada correctamente', 'success')
            return redirect(url_for('mostrar_prodcutos'))
        else:
            flash('Metodo de acceso incorrecto')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
