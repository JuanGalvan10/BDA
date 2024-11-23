from flask import Flask, render_template, request, redirect, url_for, flash, session
from models.carrito import Carrito

def agregarCarrito():
    if 'loggedin' in session:
        if request.method =='POST':
            productoID = request.form['productoID']
            cantidad = request.form['cantidad']
            precio = request.form['precio']
            producto = {'id': productoID, 'cantidad': cantidad}
            session['productos'].append(producto)
            session['subtotal'] += cantidad*precio
            return render_template('catalogo.html')
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
def checkoutResumen():
    if 'loggedin' in session:
        if request.method =='POST':
            productoID = request.form['productoID']
            cantidad = request.form['cantidad']
            precio = request.form['precio']
            producto = {'id': productoID, 'cantidad': cantidad, 'precio': precio}
            session['productos'].append(producto)
            session['subtotal'] += cantidad*precio
            return render_template('catalogo.html')
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
def checkoutEnvio():
    if 'loggedin' in session:
        if request.method == 'POST':
            cambios = []
            subtotal = 0
            nuevos_productos = []  

            for producto in session['productos']:
                product_id = producto['id']
                cantidad_nueva = int(request.form.get(f'cantidad_{product_id}', 0))
                cantidad_anterior = producto['cantidad']

                if cantidad_nueva > 0:
                    producto['cantidad'] = cantidad_nueva
                    subtotal += cantidad_nueva * producto['precio']
                    nuevos_productos.append(producto)

                    if cantidad_nueva != cantidad_anterior:
                        cambios.append({
                            'id': product_id,
                            'cantidad_anterior': cantidad_anterior,
                            'cantidad_nueva': cantidad_nueva
                        })
                else:
                    cambios.append({
                        'id': product_id,
                        'cantidad_anterior': cantidad_anterior,
                        'cantidad_nueva': 0,
                        'eliminado': True
                    })
            session['productos'] = nuevos_productos
            session['subtotal'] = subtotal
            metodos = Carrito.get_Metodos(session['idUsuario'])
            metodos_censurados = []
            for metodo in metodos:
                num_tarjeta = metodo['num_tarjeta']
                censurado = '*' * (len(num_tarjeta) - 4) + num_tarjeta[-4:]  
                metodo['num_tarjeta'] = censurado
                metodos_censurados.append(metodo)
            total = subtotal + 50
            return render_template('CheckoutPago.html', subtotal = subtotal, total = total, metodos = metodos_censurados)
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
def checkoutPago(subtotal):
    if 'loggedin' in session:
        if request.method =='POST':
            productoID = request.form['productoID']
            cantidad = request.form['cantidad']
            precio = request.form['precio']
            producto = {'id': productoID, 'cantidad': cantidad, 'precio': precio}
            session['productos'].append(producto)
            session['subtotal'] += cantidad*precio
            return render_template('catalogo.html')
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))