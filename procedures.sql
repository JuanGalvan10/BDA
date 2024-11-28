CREATE VIEW InfoUsuario AS
SELECT 
    ur.idUsuario,
    ur.nombre_usuario,
    ur.password,
    r.nombre
FROM 
    Usuario_Restaurante ur
JOIN 
    Rol r
ON 
    ur.idRol = r.idRol;


DELIMITER //
CREATE PROCEDURE BuscaUsuario(
    IN username varchar(50)
)
BEGIN
    SELECT * 
    FROM InfoUsuario
    where nombre_usuario = username;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registrarUsuario(
    nom varchar(50),
    pass varchar(225),
    rol varchar(20)
)
BEGIN
    DECLARE rolU INT;

    SELECT idRol INTO rolU
    FROM Rol
    where nombre = rol;

    INSERT INTO Usuario_Restaurante(nombre_usuario, password, idRol)
    VALUES (nom, pass, rolU);

    SELECT LAST_INSERT_ID() AS idUsuario;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registrarCliente(
    IN idUsuario INT,
    IN nom varchar(50),
    IN apell varchar(50),
    IN tel varchar(15),
    IN correo varchar(100),
    IN direc varchar(100),
)
BEGIN
    INSERT INTO Cliente (idUsuario, nombre, apellido, telefono, correo, direccion)
    VALUES (idUsuario, nom, apell, tel, correo, direc) ;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE obtenerId(
    IN idU INT
)
BEGIN
    SELECT idCliente
    FROM CLIENTES
    WHERE idUsuario = idU;
END //
DELIMITER ;

DELIMITER $$
CREATE TRIGGER usuarioOcupado
BEFORE INSERT ON USUARIOS_RESTAURANTE
FOR EACH ROW
BEGIN 
    IF EXISTS (
        SELECT 1 FROM USUARIOS_RESTAURANTE WHERE nombre_usuario = NEW.nombre_usuario.
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario ya registrado, intente on otro.';
        END IF;
END $$


-- TRIGGERS -- 

-- 1. NoStockProducto
DELIMITER $$
CREATE TRIGGER NoStockProducto
BEFORE INSERT ON PLATILLOS
FOR EACH ROW
BEGIN 
    IF NEW.inventario < 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay inventario suficiente de ese producto, hay que hacer stock.';
        END IF;
END $$

DELIMITER ;


-- 3. ActualizarPuntosCliente
DELIMITER $$
CREATE TRIGGER ActualizarPuntosCliente
BEFORE UPDATE ON PUNTOS_CLIENTES 
FOR EACH ROW
BEGIN
    UPDATE CLIENTES
    SET cant_puntos = cant_puntos + (NEW.cant_puntos - OLD.cant_puntos)
    WHERE idPuntos = NEW.idPuntos;
END $$

DELIMITER ;

-- 4. BloquearCambioPedidoCompletado
DELIMITER $$
CREATE TRIGGER BloquearCambioPedidoCompletado
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
BEGIN
    IF NEW.idStatus = 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido ya no se puede modificar.';
        END IF;
END $$

DELIMITER ; 

-- 5. usuarioOcupado
DELIMITER $$
CREATE TRIGGER usuarioOcupado
BEFORE INSERT ON USUARIOS_RESTAURANTE
FOR EACH ROW
BEGIN 
    IF EXISTS (
        SELECT 1 FROM USUARIOS_RESTAURANTE WHERE nombre_usuario = NEW.nombre_usuario
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario ya registrado, intente on otro.';
        END IF;
END $$

DELIMITER ;

-- 6. CalcularTotalPedido
DELIMITER $$
CREATE TRIGGER CalcularTotalPedido
AFTER INSERT ON DETALLESPEDIDO
FOR EACH ROW
BEGIN 
    UPDATE PEDIDOS 
    SET total_suma = total_suma + 
        (SELECT precio
        FROM PLATILLOS p 
        WHERE p.idPlatillo = NEW.idPlatillo)
        WHERE idPedido = NEW.idPedido;
END $$

DELIMITER ;

-- 7. NotificarPromocionExpirada 
DELIMITER $$
CREATE TRIGGER NotificarPromocionExpirada
BEFORE INSERT ON PROMOCIONES
FOR EACH ROW
BEGIN 
    IF NEW.fecha_inicio >= '2024-06-01' AND NEW.fecha_inicio <= '2024-11-30' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La promoción ya ha expirado.';
        END IF;
END $$

DELIMITER ; 

-- 8. ValidarFechaReserva
DELIMITER $$
CREATE TRIGGER ValidarFechaReserva
BEFORE INSERT ON RESERVAS
FOR EACH ROW
BEGIN
    IF NEW.fecha_reserva < '2024-11-30' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La reserva ha expirado.';
    END IF;
END $$

DELIMITER;

-- STORED PROCEDURES --

-- PROCS PARA Restaurante --
DELIMITER $$
CREATE PROCEDURE obtenerDireccionesR()
BEGIN
    SELECT ubicacion
    FROM RESTAURANTES;
END $$ 
DELIMITER ;

-- PROCS PARA Cliente --

DELIMITER $$
CREATE PROCEDURE nuevaDireccion(
    IN p_idUsuario INT,
    IN direc varchar(100)
)
BEGIN
    UPDATE CLIENTES
    SET 
        direccion = direc
    WHERE idUsuario = p_idUsuario;
END $$ 
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE obtenerId(
    IN p_idUsuario INT,
)
BEGIN
    SELECT idCliente
    FROM CLIENTES
    WHERE idUsuario = p_idUsuario;
END $$ 
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE actualizaCliente(
    IN p_idCliente INT,
    IN nombre VARCHAR(50),
    IN apellido VARCHAR(50),
    IN correo VARCHAR(100),
    IN telefono VARCHAR(15),
    IN direccion VARCHAR(255),
    IN cant_puntos INT
)
BEGIN
    UPDATE CLIENTES
    SET nombre = nombre, apellido = apellido, correo = correo
    WHERE idCliente = p_idCliente;

    UPDATE TELEFONOS_CLIENTE
    SET telefono = telefono
    WHERE idtelefono = (SELECT idtelefono FROM CLIENTES WHERE idCliente = p_idCliente);

    UPDATE DIRECCIONES_CLIENTE
    SET direccion = direccion
    WHERE iddireccion = (SELECT iddireccion FROM CLIENTES WHERE idCliente = p_idCliente);
    
    UPDATE PUNTOS_CLIENTES
    SET cant_puntos = cant_puntos
    WHERE idPuntos = (SELECT idPuntos FROM CLIENTES WHERE idCliente = p_idCliente);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE actualizaCliente(
    IN NEWidCliente INT,
    IN NEWnombre VARCHAR(50),
    IN NEWapellido VARCHAR(50),
    IN NEWcorreo VARCHAR(100),
    IN NEWcant_puntos INT
)
BEGIN
    UPDATE CLIENTES
    SET nombre = NEWnombre, apellido = NEWapellido, correo = NEWcorreo
    WHERE idCliente = NEWidCliente;

    UPDATE PUNTOS_CLIENTES
    SET cant_puntos = NEWcant_puntos
    WHERE idPuntos = (SELECT idPuntos FROM CLIENTES WHERE idCliente = NEWidCliente);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE eliminarCliente(
    IN p_idCliente INT
)
BEGIN
    DECLARE vidUsuario INT;
    DECLARE vidPuntos INT;
    DECLARE vidPedido INT;
    DECLARE vidDetalleMetodoPago INT;

    SELECT idPedido INTO vidPedido
    FROM PEDIDOS
    WHERE idCliente = p_idCliente
    LIMIT 1;

    SELECT idUsuario INTO vidUsuario
    FROM CLIENTES
    WHERE idCliente = p_idCliente
    LIMIT 1;

    SELECT idPuntos INTO vidPuntos
    FROM CLIENTES
    WHERE idCliente = p_idCliente
    LIMIT 1;

    SELECT idDetalleMetodoPago INTO vidDetalleMetodoPago
    FROM METODOPAGOS
    WHERE idcliente = p_idCliente
    LIMIT 1;

    SET FOREIGN_KEY_CHECKS=0;

    DELETE FROM DETALLES_METODOPAGOS
    WHERE idDetalleMetodoPago = vidDetalleMetodoPago;

    DELETE FROM PUNTOS_CLIENTES
    WHERE idPuntos = vidPuntos;

    DELETE FROM USUARIOS_RESTAURANTE
    WHERE idUsuario = vidUsuario;

    SET FOREIGN_KEY_CHECKS=1;

    DELETE FROM  TELEFONOS_CLIENTE
    WHERE idCliente = p_idCliente;

    DELETE FROM DIRECCIONES_CLIENTE
    WHERE idCliente = p_idCliente;

    DELETE FROM METODOPAGOS
    WHERE idCliente = p_idCliente;

    DELETE FROM RESERVAS
    WHERE idCliente = p_idCliente;

    DELETE FROM DETALLESPEDIDO
    WHERE idPedido IN (SELECT idPedido FROM PEDIDOS WHERE idCliente = p_idCliente);

    UPDATE RESENAS
    SET idCliente = NULL
    WHERE idCliente = p_idCliente;

    SET FOREIGN_KEY_CHECKS=0;

    DELETE FROM PEDIDOS
    WHERE idCliente = p_idCliente;

    DELETE FROM CLIENTES
    WHERE idCliente = p_idCliente;

    SET FOREIGN_KEY_CHECKS=1;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE insertarCliente(
    IN idUsuario INT,
    IN idStatus INT,
    IN nombre VARCHAR(50),
    IN apellido VARCHAR(50),
    IN correo VARCHAR(100),
    IN telefono VARCHAR(14),
    IN direccion VARCHAR(255)
)
BEGIN
    DECLARE idCliente INT;
    DECLARE idPuntos INT;

    INSERT INTO PUNTOS_CLIENTES(cant_puntos)
    VALUES (0);

    SET idPuntos = LAST_INSERT_ID();

    INSERT INTO CLIENTES (idPuntos, idUsuario, idStatus, nombre, apellido, correo)
    VALUES (idPuntos, idUsuario, idStatus, nombre, apellido, correo);

    SET idCliente = LAST_INSERT_ID();

    INSERT INTO TELEFONOS_CLIENTE (idCliente, telefono)
    VALUES (idCliente, telefono);

    INSERT INTO DIRECCIONES_CLIENTE (idCliente, direccion)
    VALUES (idCliente, direccion);
END $$
DELIMITER ;
-- PROCS PARA DIRECCIONES --

DELIMITER $$
CREATE PROCEDURE actualizarDireccion(
    IN idCliente INT,
    IN direccion VARCHAR(255)
)
BEGIN
    UPDATE DIRECCIONES_CLIENTE
    SET direccion = direccion
    WHERE iddireccion = (SELECT iddireccion FROM CLIENTES WHERE idCliente = idCliente LIMIT 1);
END $$ 
DELIMITER ;

-- PROCS PARA LOGIN --

CREATE VIEW
    InfoUsuario AS
SELECT
    ur.idUsuario,
    ur.nombre_usuario,
    ur.password,
    r.nombre
FROM
    USUARIOS_RESTAURANTE ur
    JOIN ROLES r ON ur.idRol = r.idRol;

DELIMITER / / 
CREATE PROCEDURE BuscaUsuario (IN username varchar(50)) 
BEGIN
    SELECT
        *
    FROM
        InfoUsuario
    where
        nombre_usuario = username;
END / /
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registrarUsuario(
    nom varchar(50),
    pass varchar(225),
    rol varchar(20)
)
BEGIN
    DECLARE rolU INT;

    SELECT idRol INTO rolU
    FROM ROLES
    where nombre = rol;

    INSERT INTO USUARIOS_RESTAURANTE(nombre_usuario, password, idRol)
    VALUES (nom, pass, rolU);

    SELECT LAST_INSERT_ID() AS idUsuario;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registrarCliente(
    IN idUsuario INT,
    IN nom VARCHAR(50),
    IN apell VARCHAR(50),
    IN tel VARCHAR(15),
    IN correo VARCHAR(100),
    IN direc VARCHAR(100)
)
BEGIN
    DECLARE newIdPuntos INT;
    INSERT INTO PUNTOS_CLIENTES (cant_puntos)
    VALUES (0);

    SET newIdPuntos = LAST_INSERT_ID();

    INSERT INTO CLIENTES (idUsuario, nombre, apellido, telefono, correo, direccion, idPuntos)
    VALUES (idUsuario, nom, apell, tel, correo, direc, newIdPuntos);
END //
DELIMITER ;

-- PROCS DE CLIENTES --

CREATE VIEW mostrarUsuarios_vw AS
SELECT 
    ur.idUsuario AS idUsuario, 
    ur.nombre_usuario AS nombre_usuario,
    ur.password AS password,
    ur.idRol AS idRol,
    r.nombre AS nombre,
    rs.idRolStaff,
    ts.nombre_staff
FROM 
    USUARIOS_RESTAURANTE ur
LEFT JOIN 
    ROLES r ON ur.idRol = r.idRol
LEFT JOIN 
    ROLES_STAFF rs ON ur.idUsuario = rs.idUsuario
LEFT JOIN 
    TIPOS_STAFF ts ON rs.idRolStaff = ts.idRolStaff;

CREATE VIEW actualizaCliente_vw AS
SELECT
    c.idCliente,
    c.nombre,
    c.apellido,
    c.correo,
    c.telefono,
    c.direccion,
    p.cant_puntos
FROM
    CLIENTES c
JOIN PUNTOS_CLIENTES p ON c.idPuntos = p.idPuntos;

CREATE VIEW eliminarCliente_vw AS
SELECT
    c.idCliente
FROM
    CLIENTES c
WHERE
    c.idCliente = c.idCliente;

CREATE VIEW
    mostrarMetodoPagos_vw AS
SELECT
    *
FROM
    METODOPAGOS m
    NATURAL JOIN DETALLES_METODOPAGOS dm;

DELIMITER //
CREATE PROCEDURE mostrarUsuarios()
BEGIN
SELECT
    idUsuario, 
    nombre_usuario,
    password,
    idRol,
    nombre,
    idRolStaff,
    nombre_staff
FROM
    mostrarUsuarios_vw;

 -- INSERTAR CLIENTES --

DELIMITER / /
CREATE PROCEDURE obtenerUser(
    IN idUsuario INT
)
BEGIN
    SELECT idUsuario, nombre_usuario, idRol
    FROM USUARIOS_RESTAURANTE
    WHERE idUsuario = idUsuario;
END / /
DELIMITER ;

DELIMITER //
CREATE PROCEDURE obtenerCliente(
    IN New_idCliente INT
)
BEGIN
    SELECT u.nombre_usuario, c.idCliente, c.nombre, c.apellido, c.telefono, c.correo, p.cant_puntos, c.direccion
    FROM CLIENTES c
    JOIN USUARIOS_RESTAURANTE u ON c.idUsuario = u.idUsuario 
    JOIN PUNTOS_CLIENTES p ON c.idPuntos = p.idPuntos
    WHERE idCliente = New_idCliente;
END //
DELIMITER ;

DELIMITER / / 
CREATE PROCEDURE actualizaCliente (
    IN NewidCliente INT,
    IN NewNombre VARCHAR(50),
    IN NewApellido VARCHAR(50),
    IN NewCorreo VARCHAR(100), 
    IN NewTelefono VARCHAR(15),
    IN NewDireccion VARCHAR(255),
    IN NewPuntos INT
)
BEGIN
    UPDATE CLIENTES
    SET nombre = NewNombre,
        apellido = NewApellido,
        correo = NewCorreo,
        telefono = NewTelefono,
        direccion = NewDireccion
    WHERE idCliente = NewidCliente;

    UPDATE PUNTOS_CLIENTES
    SET puntos = NewPuntos
    WHERE idPuntos = (SELECT idPuntos FROM CLIENTES WHERE idCliente = NewidCliente);
END / / 
DELIMITER ; 

CREATE VIEW eliminarCliente_vw AS
SELECT
    c.idCliente
FROM
    CLIENTES c
WHERE
    c.idCliente = c.idCliente;

DELIMITER / /
CREATE PROCEDURE obtenerCliente(
    IN idCliente
)
BEGIN
    SELECT idCliente, nombre, apellido, telefono
    FROM CLIENTES
    WHERE idCliente = idCliente;
END / /
DELIMITER ;

DELIMITER / / 
CREATE PROCEDURE eliminarCliente (
    IN idCliente INT
)
BEGIN
    DELETE FROM CLIENTES
    WHERE idCliente = idCliente;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE nuevaTarjetaCliente(
	IN NEWidCliente INT,
    IN NEWnum_tarjeta INT,
    IN NEWfecha_expiracion DATE,
    in NEWnombre_metodo VARCHAR(255)
)
begin
	DECLARE idDetalleMetodoPago INT;

	IF NEWnombre_metodo = 'Efectivo' THEN
        INSERT INTO METODOPAGOS (nombre_metodo, id_Cliente, idDetalleMetodoPago)
        VALUES (NEWnombre_metodo, NEWidCliente, NULL);
       
    ELSE
        INSERT INTO DETALLES_METODOPAGOS (num_tarjeta, fecha_expiracion)
        VALUES (NEWnum_tarjeta, NEWfecha_expiracion);

        SET idDetalleMetodoPago = LAST_INSERT_ID();
        
        INSERT INTO METODOPAGOS (nombre_metodo, id_Cliente, idDetalleMetodoPago)
        VALUES (NEWnombre_metodo, NEWidCliente, idDetalleMetodoPago);
    END IF;
    
END //
DELIMITER ; 

DELIMITER //
CREATE PROCEDURE mostrarMetodoPagoCliente (IN id_Sesion INT) 
BEGIN
    SELECT
        idMetodoPago,
        nombre_metodo,
        idCliente,
        num_tarjeta
    FROM
        mostrarMetodoPagos_vw
    WHERE
        idCliente = id_Sesion;
END //
DELIMITER ;

create view mostrarClientes_vw as
select * 
from CLIENTES natural join PUNTOS_CLIENTES

DELIMITER //
CREATE PROCEDURE mostrarClientes()
BEGIN
    SELECT 
        idCliente, 
        nombre, 
        apellido, 
        telefono, 
        correo, 
        direccion, 
        cant_puntos
    FROM 
        mostrarClientes_vw;
END //
DELIMITER ;



-- PROCS PARA PEDIDOS --

DELIMITER //
CREATE PROCEDURE eliminarPedido (
    IN New_idPedido INT
)
BEGIN
    DELETE FROM DETALLESPEDIDO
    WHERE idPedido = New_idPedido;

    DELETE FROM PEDIDOS
    WHERE idPedido = New_idPedido;
END //
DELIMITER ; 


CREATE VIEW
    mostrarPedidos_vw AS
SELECT
    idPedido,
    fecha_pedido,
    fecha_entrega,
    total_pedido,
    idCliente,
    nombre_status,
    p.nombre,
    p.imagen_URL,
    d.cantidad,
    d.precio_unitario
FROM
    DETALLESPEDIDO d
    NATURAL JOIN PEDIDOS
    NATURAL JOIN STATUS_PEDIDO sp
    NATURAL JOIN PLATILLOS p;

CREATE VIEW insertarPedido AS
SELECT c.idCliente, p.fecha_entrega, p.idStatus
FROM CLIENTES c
JOIN PEDIDOS p ON c.idCliente = p.idCliente; 

CREATE VIEW insertarDetallesPedido AS
SELECT d.idPedido, d.idPlatillo, d.cantidad, d.precio_unitario
FROM DETALLESPEDIDO d
JOIN PLATILLOS p ON p.idPlatillo = d.idPlatillo;

CREATE VIEW eliminarPedido AS
SELECT c.idCliente, p.idPedido, p.fecha_pedido
FROM PEDIDOS p
JOIN CLIENTES c ON c.idCliente = p.idCliente;

DELIMITER //
CREATE PROCEDURE mostrarPedidos()
BEGIN
SELECT
    idPedido,
    fecha_pedido,
    fecha_entrega,
    total_pedido,
    idCliente,
    nombre_status,
    nombre,
    imagen_URL,
    cantidad,
    precio_unitario
FROM
    mostrarPedidos_vw;
END //
DELIMITER ;

CREATE VIEW insertarPedido AS
SELECT c.idCliente, p.fecha_entrega, p.idStatus
FROM CLIENTES c
JOIN PEDIDOS p ON c.idCliente = p.idCliente; 

DELIMITER / /
CREATE PROCEDURE insertarPedido (
    IN New_idCliente INT
)
BEGIN
    DECLARE New_fecha_entrega DATE;
    
    SET New_fecha_entrega = DATE_ADD(CURDATE(), INTERVAL 3 DAY);

    INSERT INTO PEDIDOS (fecha_pedido, fecha_entrega, total_pedido, idCliente, idStatus)
    VALUES (CURDATE(), New_fecha_entrega, 0.0, New_idCliente, 1);
END / /
DELIMITER ;

CREATE VIEW insertarDetallesPedido AS
SELECT d.idPedido, d.idPlatillo, d.cantidad, d.precio_unitario
FROM DETALLESPEDIDO d
JOIN PLATILLOS p ON p.idPlatillo = d.idPlatillo;

DELIMITER / /
CREATE PROCEDURE insertarDetallesPedido (
    IN New_idPedido INT,
    IN New_idPlatillo INT,
    IN New_cantidad INT
)
BEGIN
    INSERT INTO DETALLESPEDIDO(idPedido, idPlatillo, cantidad, precio_unitario)
    SELECT New_idPedido, New_idPlatillo, New_cantidad, precio 
    FROM PLATILLOS
    WHERE idPlatillo = New_idPlatillo;
END / /
DELIMITER ; 

DELIMITER $$
CREATE PROCEDURE obtenerPedido (IN in_idPedido INT)
BEGIN
    SELECT 
        idPedido, 
        fecha_pedido, 
        fecha_entrega, 
        total_pedido, 
        idCliente, 
        nombre_status, 
        nombre, 
        imagen_URL, 
        cantidad, 
        precio_unitario
    FROM 
        mostrarPedidos_vw
    WHERE 
        idPedido = in_idPedido;
END $$
DELIMITER ;

DELIMITER //
CREATE PROCEDURE obtenerPedidosCliente (IN id_Sesion INT) 
BEGIN
    SELECT
    idPedido,
    fecha_pedido,
    fecha_entrega,
    total_pedido,
    idCliente,
    nombre_status,
    nombre,
    imagen_URL,
    cantidad,
    precio_unitario
FROM
    mostrarPedidos_vw
WHERE
    idCliente = id_Sesion;
END //
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE eliminarPedido ( 
	IN New_idPedido INT 
) 
BEGIN 
	DELETE FROM DETALLESPEDIDO WHERE idPedido = New_idPedido;
	DELETE FROM RESENAS WHERE idPedido = New_idPedido;
	DELETE FROM PEDIDOS WHERE idPedido = New_idPedido; 
END // 
DELIMITER ;

-- PROCS PARA PLATILLOS -- 
DELIMITER $$
CREATE PROCEDURE actualizaPlatillo(
    IN idPlatillo INT,
    IN nombre VARCHAR(100),
    IN imagen_URL VARCHAR(100),
    IN precio DECIMAL(10,2),
    IN descripcion VARCHAR(255),
    IN inventario INT,
    IN idCategoria INT
)
BEGIN
    UPDATE PLATILLOS
    SET nombre = nombre, 
        imagen_URL = imagen_URL, 
        precio = precio, 
        descripcion = descripcion,
        inventario = inventario,
        idCategoria = idCategoria
    WHERE idPlatillo = idPlatillo;
END $$
DELIMITER ;

--  (MUESTRA PLATILLOS DISPONIBLES) --

CREATE VIEW
    PlatillosDisponibles_vw AS
SELECT
    idPlatillo,
    nombre,
    imagen_URL,
    precio,
    descripcion,
    inventario,
    idCategoria
FROM
    PLATILLOS p
WHERE
    inventario > 0;

DELIMITER //
CREATE PROCEDURE mostrarPlatillos ()
BEGIN
SELECT
    idPlatillo,
    nombre,
    imagen_URL,
    precio,
    descripcion,
    inventario,
    idCategoria
FROM
    PlatillosDisponibles_vw;
END //
DELIMITER ;

CREATE VIEW ListaPlatillos AS
SELECT * FROM PLATILLOS;

DELIMITER $$
CREATE PROCEDURE obtenerPlatillo(IN id INT)
BEGIN
    SELECT idPlatillo, nombre, imagen_URL, precio, descripcion, inventario, idCategoria
    FROM ListaPlatillos
    WHERE idPlatillo = id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE nuevoPlatillo(
    IN nombre VARCHAR(100),
    IN imagen_URL VARCHAR(100),
    IN precio DECIMAL(10,2),
    IN descripcion VARCHAR(255),
    IN inventario INT,
    IN idCategoria INT
)
BEGIN
    INSERT INTO PLATILLOS(nombre, imagen_URL, precio, descripcion, inventario, idCategoria)
    VALUES (nombre, imagen_URL, precio, descripcion, inventario, idCategoria);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE actualizarPlatillo(
    IN idPlatillo INT,
    IN nombre VARCHAR(100),
    IN imagen_URL VARCHAR(100),
    IN precio DECIMAL(10,2),
    IN descripcion VARCHAR(255),
    IN inventario INT,
    IN idCategoria INT
)
BEGIN
    UPDATE PLATILLOS
    SET nombre = nombre, 
        imagen_URL = imagen_URL, 
        precio = precio, 
        descripcion = descripcion,
        inventario = inventario,
        idCategoria = idCategoria
    WHERE idPlatillo = idPlatillo;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE eliminarPlatillo(
    IN idPlatillo INT
)
BEGIN
    DELETE FROM PLATILLOS
    WHERE idPlatillo = idPlatillo; 
END $$
DELIMITER ;



DELIMITER //
CREATE PROCEDURE recomendarPlatillosCliente(
    IN cliente_id INT
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM PEDIDOS p
        WHERE p.idCliente = cliente_id
    ) THEN
        SELECT DISTINCT
            p.idPlatillo,
            p.nombre,
            p.imagen_URL,
            p.idCategoria,
            p.descripcion, 
            p.precio
        FROM
            PLATILLOS p
        WHERE
            p.idCategoria IN (
                SELECT DISTINCT pl.idCategoria
                FROM PEDIDOS pd NATURAL JOIN DETALLESPEDIDO dp NATURAL JOIN PLATILLOS pl
                WHERE pd.idCliente = cliente_id
            )
            AND p.idPlatillo NOT IN (
                SELECT dp.idPlatillo
                FROM PEDIDOS pd NATURAL JOIN DETALLESPEDIDO dp
                WHERE pd.idCliente = cliente_id
            )
        LIMIT 10;

    ELSE
        SELECT 
            idPlatillo,
            nombre,
            imagen_URL,
            idCategoria,
            descripcion, 
            precio
        FROM 
            PLATILLOS
        ORDER BY RAND()
        LIMIT 10;
    END IF;
END //
DELIMITTER ;

-- PROCS PARA RESEÑAS --

CREATE VIEW
    mostrarResenas_vw AS
SELECT
    c.idCliente,
    nombre_usuario,
    idResena,
    puntuacion,
    titulo,
    comentario,
    fecha_comentario,
    idTipoResena,
    idPedido
FROM
    USUARIOS_RESTAURANTE
    NATURAL JOIN CLIENTES c
    NATURAL JOIN RESENAS;

DELIMITER //
CREATE PROCEDURE mostrarResenas()
BEGIN
SELECT
    idCliente,
    nombre_usuario,
    idResena,
    puntuacion,
    titulo,
    comentario,
    fecha_comentario,
    idTipoResena,
    idPedido
FROM
    mostrarResenas_vw;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE  obtenerResenasCliente (IN id_Sesion INT) 
BEGIN
    SELECT
    idCliente,
    nombre_usuario,
    idResena,
    puntuacion,
    titulo,
    comentario,
    fecha_comentario,
    idTipoResena,
    idPedido
FROM
    mostrarResenas_vw
WHERE
    idCliente = id_Sesion;
END //
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE nuevaResena(
    IN punt INT,
    IN title VARCHAR(50),
    IN coment TEXT,
    IN idClientePar INT,
    IN idTipoRes INT,
)
BEGIN
    INSERT INTO RESENAS(puntuacion, titulo, comentario, fecha_comentario, idCliente, idTipoResena, idPedido)
    VALUES (punt, title, coment, CURDATE(), idClientePar, idTipoRes, NULL);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE eliminarResena(
    IN idRes INT
)
BEGIN
    DELETE FROM RESENAS
    WHERE idResena = idRes;
END $$
DELIMITER ;

CREATE VIEW obtenerResenasProducto_vw AS
SELECT *
FROM DETALLESPEDIDO NATURAL JOIN PLATILLOS NATURAL JOIN PEDIDOS NATURAL JOIN RESENAS r
WHERE r.idTipoResena = 2;

DELIMITER //
CREATE PROCEDURE  obtenerResenasProducto (IN id_Platillo INT) 
BEGIN
    SELECT 
	idCliente,
	idPlatillo,
	nombre,
	imagen_URL,
	descripcion,
	idResena,
	puntuacion,
	comentario
FROM
    obtenerResenasProducto_vw
WHERE
    idPlatillo = id_Platillo;
END //
DELIMITER ;

-- PROCS PARA RESERVAS --

CREATE VIEW
    muestrareservas_vw AS
SELECT
    idReserva,
    fecha_reserva,
    hora_reserva,
    num_personas,
    r.idStatus,
    tema,
    c.idCliente,
    nombre,
    apellido,
    telefono,
    correo
FROM
    RESERVAS r
    LEFT JOIN CLIENTES c ON c.idCliente = r.idCliente;

CREATE VIEW eliminarPedido AS
SELECT 
    c.idCliente, 
    p.idPedido, 
    p.fecha_pedido
FROM 
    PEDIDOS p
JOIN 
    CLIENTES c ON c.idCliente = p.idCliente;

CREATE VIEW eliminarReserva AS
SELECT c.idCliente, r.idReserva, r.fecha_reserva, r.hora_reserva
FROM RESERVAS r
JOIN CLIENTES c ON r.idCliente = c.idCliente;

DELIMITER //
CREATE PROCEDURE mostrarReservas ()
BEGIN
SELECT
    idReserva,
    fecha_reserva,
    hora_reserva,
    num_personas,
    idStatus,
    tema,
    idCliente,
    nombre,
    apellido,
    telefono,
    correo
FROM
    muestrareservas_vw;
END //
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE obtenerReserva (IN in_idReserva INT)
BEGIN
    SELECT 
        idReserva, 
        fecha_reserva, 
        hora_reserva, 
        num_personas, 
        idStatus, 
        tema, 
        idCliente, 
        nombre, 
        apellido, 
        telefono, 
        correo
    FROM 
        muestrareservas_vw
    WHERE 
        idReserva = in_idReserva;
END $$
DELIMITER ;

DELIMITER //
CREATE PROCEDURE obtenerReservas()
BEGIN
SELECT
    idReserva,
    fecha_reserva,
    hora_reserva,
    num_personas,
    idStatus,
    tema,
    idCliente,
    nombre,
    apellido,
    telefono,
    correo
FROM
    muestrareservas_vw;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE obtenerReservasCliente (IN id_Sesion INT)
BEGIN
SELECT
    idReserva,
    fecha_reserva,
    hora_reserva,
    num_personas,
    idStatus,
    tema,
    idCliente,
    nombre,
    apellido,
    telefono,
    correo
FROM
    muestrareservas_vw
WHERE
    idCliente = id_Sesion;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE obtenerReservasDia (IN fecha date)
BEGIN
SELECT
    hora_reserva
FROM
    RESERVAS
WHERE 
    fecha_reserva = fecha
GROUP BY hora_reserva
HAVING COUNT(*) >= 10;
END //
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE nuevaReserva(
    IN fecha_reservaPar DATE,
    IN hora_reservaPar TIME,
    IN num_personasPar INT,
    IN idStatusPar INT,
    IN temaPar VARCHAR(100),
    IN idClientePar INT
)
BEGIN
    INSERT INTO RESERVAS (fecha_reserva, hora_reserva, num_personas, idStatus, tema, idCliente)
    VALUES (fecha_reservaPar, hora_reservaPar, num_personasPar, idStatusPar, temaPar, idClientePar);
END $$
DELIMITER ;

DELIMITER / /
CREATE PROCEDURE eliminarReserva (
    IN New_idReserva INT
)
BEGIN 
    DELETE FROM RESERVAS
    WHERE idReserva = New_idReserva;
END / /
DELIMITER ; 

-- EXTRAS -- 

CREATE VIEW
    mostrarMetodoPagos_vw AS
SELECT
    *
FROM
    metodopagos m
    NATURAL JOIN detalles_metodopagos dm;

DELIMITER / / CREATE PROCEDURE mostrarMetodoPagoCliente (IN id_Sesion INT) BEGIN
SELECT
    idMetodoPago,
    nombre_metodo,
    idCliente,
    num_tarjeta
FROM
    mostrarMetodoPagos_vw
WHERE
    idCliente = id_Sesion;
END / / DELIMITER;

-- GRAFICAS --

DELIMITER //
CREATE PROCEDURE VentasXMes_gr () 
BEGIN
SELECT
    YEAR (fecha_pedido),
    MONTH (fecha_pedido) AS Mes,
    SUM(total_pedido) AS Total
FROM
    PEDIDOS
    NATURAL JOIN STATUS_PEDIDO sp
WHERE
    idStatus != 4
GROUP BY
    year (fecha_pedido),
    month (fecha_pedido)
ORDER BY
    Mes;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE UsuariosXRol_gr()
BEGIN
    SELECT
        r.nombre AS rol_nombre,
        COUNT(*) AS total_usuarios
    FROM
        USUARIOS_RESTAURANTE ur
    NATURAL JOIN
        ROLES r
    GROUP BY
        r.idRol;
END //

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE PromedioXTipoResenas_gr()
BEGIN
    SELECT nombre AS Tipo, AVG(puntuacion) AS Puntuacion
	FROM RESENAS NATURAL JOIN TIPOS_RESENA tr 
	GROUP BY idTipoResena;
END $$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ComprasXCategoria_gr() 
BEGIN
    SELECT ct.nombre AS Categoria, COUNT(pl.idCategoria) AS Total_Compras
    FROM PEDIDOS pe JOIN DETALLESPEDIDO dp 
    ON pe.idPedido=dp.idPedido JOIN PLATILLOS pl 
    ON dp.idPlatillo=pl.idPlatillo JOIN CATEGORIAS ct 
    ON pl.idCategoria=ct.idCategoria
    GROUP BY ct.nombre;
END $$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE VentasXDia_gr() 
BEGIN
    SELECT fecha_entrega, sum(total_pedido) AS Ventas_totales
    FROM pedidosCompletos_vw
    GROUP BY fecha_entrega;
END $$

DELIMITER ;

DELIMITER / / 
CREATE PROCEDURE StatusDeClientes() 
BEGIN
    SELECT Status_Clientes, COUNT(*) AS Total
    FROM STATUS_CLIENTES
    GROUP BY Status_Clientes;
END / /

DELIMITER ;

DELIMITER / /
CREATE PROCEDURE resenasCalificaciones() 
BEGIN
    SELECT puntuacion, COUNT(*) AS Total
    FROM RESENAS
    GROUP BY puntuacion;
END / /

DELIMITER ;

DELIMITER / /
CREATE PROCEDURE Status_Reservas() 
BEGIN
    SELECT Status_Reservas, COUNT(*) AS Reservas
    FROM STATUS_RESERVAS
    GROUP BY Status_Reservas;
END / /

DELIMITER ; 

DELIMITER / /
CREATE PROCEDURE PlatillosStock() 
BEGIN
    SELECT inventario, COUNT(*) AS Stock
    FROM PLATILLOS
    GROUP BY inventario;
END / /

DELIMITER ;

DELIMITER ;
