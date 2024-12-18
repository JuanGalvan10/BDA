from flask import Flask, render_template, request, redirect, url_for, flash, session
from models.reserva import Reserva

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
            success, reservas = Reserva.get_all()
            if success:
                return render_template('ReservasAdmin.html', reservas = reservas, nombre_usuario = session['usuario'])
            else:
                flash(reservas,'error')
                return render_template('ReservasAdmin.html')
        else:
            success, reservas = Reserva.get_by_cliente(session['idCliente'])
            if success:
                return render_template('mis_reservas.html', reservas = reservas)
            else:
                flash(reservas,'error')
                return render_template('mis_reservas.html')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))


def nuevo_reserva():
    if 'loggedin' in session:
        if request.method =='POST':
            fechaReserva = request.form['fecha']
            hora_reserva = request.form['hora']
            num_personas = request.form['num_personas']
            idStatus = 2
            tema = request.form['tema']
            idCliente = session['idCliente']
            success, message = Reserva.insert(fechaReserva, hora_reserva, num_personas, idStatus, tema, idCliente)
            if success:
                return render_template('gracias_reserva.html')
            else:
                flash(message, 'error')
                return(redirect(url_for('reservasC')))
        else:
            flash('Metodo de acceso incorrecto', 'error')
            return render_template('reservas.html')
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

# def editar_reserva(id):
#     if 'loggedin' in session:
#         if request.method =='POST':
            # fechaReserva = request.form['fecha']
            # hora_reserva = request.form['hora']
            # num_personas = request.form['num_personas']
            # idStatus = 2
            # tema = request.form['tema']
#             Reserva.update(fechaReserva, hora_reserva, num_personas, idStatus, tema)
#             flash('Reserva actualizada correctamente', 'success')
#             return redirect(url_for('mostrar_reservas'))
#         reserva = Reserva.get_by_id(id)
#         return render_template('Editar_reserva.html', reserva = reserva)
#     else:
#         flash('Primero debes de ingresar.', 'error')
#         return redirect(url_for('login'))

def eliminar_reserva(id):
    if 'loggedin' in session:
        if request.method =='POST':
            success, message = Reserva.delete(id,)
            if success:
                flash('Reserva eliminada correctamente', 'success')
            else:
                flash(message, 'error')
            return redirect(url_for('mostrar_reservas'))
        else:
            flash('Metodo de acceso incorrecto', 'error')
            return render_template('reservas.html')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

def horas_disponibles():
    fecha = request.form['fecha']
    if not fecha:
        return "Fecha no proporcionada", 400
    horas_ocupadas = Reserva.get_by_dia(fecha)
    return render_template('Autocomplete_reservas.html', horas_ocupadas=horas_ocupadas)

    