from database import mysql
import MySQLdb.cursors
import hashlib

class Pedido:
    @staticmethod
    def get_all():
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('mostrarPedidos')
        pedidos = cur.fetchall()
        cur.close()
        return pedidos
    
    @staticmethod
    def insert(productos,cantidades,id_cliente):
        cur = mysql.connection.cursor()
        try:
            # Insertar el pedido
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
            return True, 'Pedido exitoso'

        except MySQLdb.OperationalError as e:
            cur.close()
            return False, str(e)

    @staticmethod
    def get_by_id(idPedido):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('obtenerPedido', (idPedido,))
        pedido = cur.fetchone()
        cur.close()
        return pedido
    
    @staticmethod
    def get_by_cliente(idCliente):
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.callproc('obtenerPedidosCliente', (idCliente,))
        pedidos = cur.fetchall()
        cur.close()
        return pedidos

    @staticmethod
    def delete(idPedido):
        cur = mysql.connection.cursor()
        cur.callproc('eliminarPedido', (idPedido,))
        mysql.connection.commit()
        cur.close()



