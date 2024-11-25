from flask import Flask, render_template, request, redirect, url_for, flash, session
from models.carrito import Carrito
from models.pedido import Pedido
from models.producto import Producto
from models.cliente import Cliente

def agregarCarrito():
    if 'loggedin' in session:
        if request.method =='POST':
            productoID = request.form['productoID']
            cantidad = int(request.form['cantidad'])
            precio = float(request.form['precio'])
            producto = {'id': productoID, 'cantidad': cantidad, 'precio': precio}
            session['productos'].append(producto)
            session['subtotal'] += cantidad*precio
            return redirect(url_for('mostrar_productos'))
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
def checkoutResumen():
    if 'loggedin' in session:
        prods = session['productos']
        productos = []
        for producto in prods:
            idProducto = producto['id']
            productos.append(Producto.get_by_id(idProducto))
            productos.append(producto['cantidad'])
        return render_template('CheckoutResumen.html', productos = productos, subtotal = session['subtotal'])
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
                cantidad_nueva = request.form.get(f'cantidad_{product_id}', '0')
                
                if not cantidad_nueva.isdigit():
                    cantidad_nueva = 0
                else:
                    cantidad_nueva = int(cantidad_nueva)
                
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
            usuario = Cliente.get_cliente_by_id(session['idCliente'])
            direccionUser = usuario['direccion']
            direcciones = Carrito.get_direccion_restaurantes()
            return render_template('CheckoutDomicilio.html', subtotal=subtotal, direccionUser=direccionUser, direcciones=direcciones)
        return redirect(url_for('checkoutResumen'))
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
def checkoutPago():
    if 'loggedin' in session:
        if request.method =='POST':
            direccion = request.form['opcion_entrega']
            total = session['subtotal']
            costo = 0
            if direccion == 'domicilio':
                costo = 50
                total += costo
            metodos = Carrito.get_metodos(session['idUsuario'])
            for metodo in metodos:
                num_tarjeta = metodo['num_tarjeta']
                censurado = '*' * (len(num_tarjeta) - 4) + num_tarjeta[-4:]  
                metodo['num_tarjeta'] = censurado
            return render_template('CheckoutPago.html', total = total, costo = costo, metodos = metodos, subtotal = session['subtotal'])
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
def pagar():
    if 'loggedin' in session:
        if request.method =='POST':
            productos = session['producto']
            idProductos = []
            cantidades = []
            for producto in productos:
                idProductos.append(producto['id'])
                cantidades.append(producto['cantidad'])
            estado, mensaje = Pedido.insert(idProductos, cantidades, session["idUsuario"])
            if estado:
                return render_template('CheckoutConfirmacion.html')
            else:
                flash(mensaje)
                return redirect(url_for('checkoutPago'))
    else: 
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
def guardar_direccion():
    if 'loggedin' in session:
        if request.method =='POST':
            try:
                nuevaDireccion = request.form['nuevaDireccion']
                Cliente.update_direccion(session['idUsuario'], nuevaDireccion)
                redirect(url_for('CheckoutEnvio'))
            except Exception as e:
                return {"error": str(e)}, 500
        else:
            flash('Metodo de acceso incorrecto')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))
    
def nueva_tarjeta():
    if 'loggedin' in session:
        if request.method =='POST':
            try:
                num_tarjeta = request.form['nuevaDireccion']
                fecha_expiracion = request.form['fecha']
                if num_tarjeta.startswith("4"):
                    nombre_metodo = "Visa"
                elif num_tarjeta[:2] in ["51", "52", "53", "54", "55"] or \
                    2221 <= int(num_tarjeta[:4]) <= 2720:
                    nombre_metodo = "Mastercard"
                elif num_tarjeta[:2] in ["34", "37"]:
                    nombre_metodo = "American Express"
                elif num_tarjeta[:4] == "6011" or num_tarjeta.startswith("65") or \
                    622126 <= int(num_tarjeta[:6]) <= 622925:
                    nombre_metodo = "Discover"
                else:
                    return "Desconocido"
                Cliente.nueva_tarjeta(session['idCliente'], num_tarjeta, fecha_expiracion, nombre_metodo)
                redirect(url_for('checkoutPago'))
            except Exception as e:
                return {"error": str(e)}, 500
        return render_template('AgregarNuevaTarjeta.html')
    else:
        flash('Primero debes de ingresar.', 'error')
        return redirect(url_for('login'))

