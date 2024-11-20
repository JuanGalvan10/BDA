from database import mysql
import MySQLdb.cursors
import hashlib

class Pedido:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor()
        cur.callproc('mostrarPedidos')
        pedidos = cur.fetchall()
        cur.close()
        return pedidos
    
    @staticmethod
    def insert(productos,cantidades,id_cliente):
        # Insertar el pedido
        cur = mysql.connection.cursor()
        cur.callproc('insertarPedido', (id_cliente,))
        mysql.connection.commit()
        
        # Obtener el ID del pedido recién insertado
        id_pedido = cur.lastrowid

        # Insertar detalles del pedido
        for i, id_producto in enumerate(productos):
            cantidad = cantidades[i]
            cur.callproc('insertarDetallePedido', (id_pedido, id_producto, cantidad))      
        mysql.connection.commit()
        cur.close()
    
    @staticmethod
    def get_by_id(idPedido):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerPedido(%s)', (idPedido,))
        pedido = cur.fetchone()
        cur.close()
        return pedido
    
    @staticmethod
    def get_by_cliente(idUsuario):
        cur = mysql.connection.cursor()
        cur.callproc('obtenerPedidosCliente(%s)', (idUsuario,))
        pedidos = cur.fetchall()
        cur.close()
        return pedidos

    @staticmethod
    def delete(idPedido):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarPedido(%s)', (idPedido,))
        mysql.connection.commit()
        cur.close()



