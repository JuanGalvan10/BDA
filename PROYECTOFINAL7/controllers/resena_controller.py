from flask import Flask, render_template, request, redirect, url_for, flash, session
from models.resena import Resena

def mostrar_resenas():
    if 'loggedin' in session:
        if session['rol'] == 'admin':
            success, resenas = Resena.get_all()
            if success:
                return render_template('Resenas.html', resenas = resenas,nombre_usuario = session['usuario'])
            else:
                flash(resenas, 'error')
                return render_template('Resenas.html')
        else:
            success, resenas = Resena.get_by_cliente(session['idCliente'])
            if success:
                return render_template('mis_resenas.html', resenas = resenas)
            else:
                flash(resenas, 'error')
                return render_template('mis_resenas.html')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))


def nuevo_resena():
    if 'loggedin' in session:
        if request.method =='POST':
            idTipoRes = request.form['idTipoRes']
            titulo = request.form['titulo']
            puntuacion = request.form['puntuacion']
            comentario = request.form['comentario']
            success, message = Resena.insert(puntuacion, titulo, comentario, session['idCliente'], idTipoRes)
            if success:
                flash(message, 'info')
            else:
                flash(message, 'error')
            return redirect(url_for('mostrar_resenas'))
        return render_template('AgregarNuevaResena.html') #HTML de crear
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def eliminar_resena(id):
    if 'loggedin' in session:
        if request.method =='POST':
            success, message = Resena.delete(id,)
            if success:
                flash('Resena eliminada correctamente', 'success')
            else:
                flash(message,'error')
            return redirect(url_for('mostrar_prodcutos'))
        else:
            flash('Metodo de acceso incorrecto', 'error')
            return redirect(url_for('mostrar_resenas'))
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
