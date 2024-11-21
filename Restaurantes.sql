CREATE TABLE Rol (
    idRol INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE Usuario_Restaurante (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    idRol INT NOT NULL,
    FOREIGN KEY (idRol) REFERENCES Rol(idRol)
);

CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    puntos INT DEFAULT 0,
    direccion VARCHAR(255) NOT NULL
    FOREIGN KEY (idUsuario) REFERENCES Usuario_Restaurante(idUsuario)
);

CREATE TABLE Categoria (
    idCategoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE Reserva (
    idReserva INT PRIMARY KEY AUTO_INCREMENT,
    fecha_reserva DATE NOT NULL,
    hora_reserva TIME NOT NULL,
    num_personas INT NOT NULL,
    estatus VARCHAR(20) NOT NULL,
    tema VARCHAR(100)
);

CREATE TABLE Promocion (
    idPromocion INT PRIMARY KEY AUTO_INCREMENT,
    descuento DECIMAL(5, 2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE MetodoPago (
    idMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    num_tarjeta VARCHAR(255) NOT NULL,  
    fecha_expiracion DATE,            
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE Pedido (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    fecha_pedido DATE NOT NULL,
    fecha_entrega DATE,
    total_pedido DECIMAL(10, 2) NOT NULL,
    estatus VARCHAR(20) NOT NULL,
    idCliente INT,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE Producto (
    idProducto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    imagen_URL VARCHAR(255) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    descripcion VARCHAR(255),
    inventario INT,
    idCategoria INT,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
);

CREATE TABLE DetallesPedido (
    idPedido INT,
    idProducto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (idPedido, idProducto),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

CREATE TABLE Calificacion (
    idCalificacion INT PRIMARY KEY AUTO_INCREMENT,
    puntuacion INT NOT NULL,
    comentario TEXT,
    idPedido INT,
    idProducto INT,
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

INSERT INTO Rol(nombre) Values
('cliente')
('admin')
('staff')

DELIMITER //
CREATE PROCEDURE BuscaUsuario(
    user varchar(50)
)
BEGIN
    SELECT usuario
    FROM usuarios
    WHERE username = user;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trigger_fecha_estimada 
BEFORE INSERT ON Pedido
FOR EACH ROW
BEGIN
    SET NEW.fecha_entrega = DATE_ADD(NEW.fecha_Pedido, INTERVAL 3 DAY);
END //
DELIMITER ;

-- INSERTAR DATOS --

INSERT INTO Usuario_Restaurante (nombre_usuario, password, rol) VALUES
('JuanGalvan', SHA2('666', 256), 'admin'),
('FernandoOlivares', SHA2('666', 256), 'admin'),
('PamelaRodriguez', SHA2('666', 256), 'admin'),
('EstefaniaNajera', SHA2('666', 256), 'admin');

INSERT INTO Cliente (nombre, apellido, telefono, correo, puntos, direccion)
VALUES
('Juan', 'Gomez', '5551234567', 'juan.gomez@email.com', 10, 'Calle Falsa 123, Ciudad, CP 12345'),
('Maria', 'Lopez', '5552345678', 'maria.lopez@email.com', 15, 'Av. Siempre Viva 456, Ciudad, CP 67890'),
('Carlos', 'Rodriguez', '5553456789', 'carlos.rodriguez@email.com', 5, 'Calle del Sol 789, Ciudad, CP 11223'),
('Ana', 'Martinez', '5554567890', 'ana.martinez@email.com', 8, 'Paseo de la Reforma 101, Ciudad, CP 33445'),
('Esteban', 'Perez', '5555678901', 'esteban.perez@email.com', 12, 'Boulevard de los Héroes 202, Ciudad, CP 55667'),
('Lucia', 'Garcia', '5556789012', 'lucia.garcia@email.com', 20, 'Calle de la Luna 303, Ciudad, CP 77889'),
('Pedro', 'Sanchez', '5557890123', 'pedro.sanchez@email.com', 25, 'Plaza Mayor 404, Ciudad, CP 99001');

INSERT INTO Categoria (nombre) VALUES
('Rollo Frío'),
('Rollo Caliente'),
('Entrante'),
('Postre');

INSERT INTO Producto (nombre, imagen_URL, precio, descripcion,inventario, idCategoria) VALUES
('Tostada de Atún', 'URL_de_imagen', 100.00, 'Aleta azul, aioli de búfalo, aguacate, cilantro',20, 1),
('Tostada de Hamachi Aji', 'URL_de_imagen', 120.00, 'Yuzu-soya, aji amarillo, mayo ajo tatemado, cebollín, furakake shiso',0, 1),
('Batera de Toro', 'URL_de_imagen', 140.00, 'Aleta azul, yuzu-aioli, aguacate, aji amarillo',10, 1),
('Batera de Salmón', 'URL_de_imagen', 130.00, 'Salmón, aioli habanero, lemon soy, cebollín, cilantro criollo', 18, 1),
('Tartar de Toro', 'URL_de_imagen', 150.00, 'Aleta azul, vinagreta yuzu-trufa', 12, 1),
('Edamame', 'URL_de_imagen', 80.00, 'Sal Maldon, salsa negra, polvo piquín', 0, 2),
('Shishitos', 'URL_de_imagen', 90.00, 'Sal Maldon, limón california', 20, 2),
('Papás Fritas', 'URL_de_imagen', 70.00, 'Sal matcha, soya-trufa', 30, 2),
('Camarones Roca', 'URL_de_imagen', 180.00, 'Soya dulce, mayo-picante, ajonjolí', 15, 2),
('Jalapeño Poppers', 'URL_de_imagen', 160.00, 'Cangrejo, atún aleta azul, queso feta, soya-yuzu', 25, 2),
('Huachinango Tempura', 'URL_de_imagen', 200.00, 'Sal Maldon, salsa negra, polvo piquín',18, 2);

INSERT INTO Reserva (fecha_reserva, hora_reserva, num_personas, estatus, tema) VALUES
('2024-11-20', '19:00:00', 4, 'activo', 'Reunión de trabajo'),
('2024-12-25', '13:30:00', 2, 'cancelado', 'Comida de navidad'),
('2024-11-30', '18:00:00', 6, 'inactivo', 'Cena con amigos'),
('2024-12-01', '20:00:00', 3, 'activo', 'Cena familiar'),
('2024-08-15', '14:00:00', 5, 'inactivo', 'Reunión de equipo'),
('2023-09-10', '12:00:00', 2, 'cancelado', 'Comida de trabajo');

INSERT INTO Pedido (fecha_pedido, fecha_entrega, total_pedido, estatus, idCliente)
VALUES
('2024-11-01', '2024-11-02', 250.00, 'activo', 2),  
('2024-11-02', '2024-11-03', 300.00, 'cancelado', 2), 
('2024-11-03', '2024-11-04', 150.00, 'inactivo', 3), 
('2024-11-04', '2024-11-05', 200.00, 'activo', 4),   
('2024-11-05', '2024-11-06', 180.00, 'activo', 5),   
('2024-11-06', '2024-11-07', 220.00, 'cancelado', 6), 
('2024-11-07', '2024-11-08', 270.00, 'activo', 7);    

INSERT INTO MetodoPago (idCliente, num_tarjeta, fecha_expiracion)
VALUES
(1, '1234567812345678', '2025-12-31'), 
(2, '2345678923456789', '2024-10-31'),  
(3, '3456789034567890', '2026-05-31'),  
(4, '4567890145678901', '2025-11-30'),  
(5, '5678901256789012', '2025-02-28'), 
(6, '6789012367890123', '2027-08-31'), 
(7, '7890123478901234', '2026-07-31');


INSERT INTO DetallesPedido (idPedido, idProducto, cantidad, precio_unitario)
VALUES
(1, 1, 2, 50.00),  
(1, 2, 1, 150.00); 


INSERT INTO DetallesPedido (idPedido, idProducto, cantidad, precio_unitario)
VALUES
(2, 3, 2, 100.00), 
(2, 4, 1, 200.00);  


INSERT INTO DetallesPedido (idPedido, idProducto, cantidad, precio_unitario)
VALUES
(3, 5, 1, 150.00);  


INSERT INTO DetallesPedido (idPedido, idProducto, cantidad, precio_unitario)
VALUES
(4, 6, 2, 100.00),  
(4, 7, 1, 100.00); 


INSERT INTO DetallesPedido (idPedido, idProducto, cantidad, precio_unitario)
VALUES
(5, 8, 3, 60.00);  


INSERT INTO DetallesPedido (idPedido, idProducto, cantidad, precio_unitario)
VALUES
(6, 9, 4, 55.00);  


INSERT INTO DetallesPedido (idPedido, idProducto, cantidad, precio_unitario)
VALUES
(7, 10, 2, 120.00); 


INSERT INTO Calificacion (puntuacion, comentario, idPedido, idProducto)
VALUES
(5, 'Excelente calidad', 1, 1), 
(4, 'Muy bueno, pero con pequeñas mejoras', 1, 2); 


INSERT INTO Calificacion (puntuacion, comentario, idPedido, idProducto)
VALUES
(3, 'Rico pero no cumplió las expectativas', 2, 3), 
(5, 'Perfecto, volveré a comprar', 2, 4); 


INSERT INTO Calificacion (puntuacion, comentario, idPedido, idProducto)
VALUES
(4, 'Buen sabor', 3, 5);  


INSERT INTO Calificacion (puntuacion, comentario, idPedido, idProducto)
VALUES
(3, 'Excelente, superó mis expectativas', 4, 1), 
(4, 'Muy bueno, pero le falta algo', 4, 7); 

INSERT INTO Promocion (descuento, fecha_inicio, fecha_fin, descripcion) VALUES
(15.00, '2024-11-01', '2024-11-30', 'Descuento del 15% en todos los productos de sushi durante el mes de noviembre.'),
(20.00, '2024-12-01', '2024-12-15', 'Promoción navideña: 20% de descuento en platillos principales.'),
(10.00, '2024-11-10', '2024-11-20', '10% de descuento en combos familiares.'),
(25.00, '2024-12-01', '2024-12-24', 'Descuento del 25% en todas las reservas de cenas para 4 o más personas durante diciembre.'),
(30.00, '2024-11-15', '2024-11-22', 'Semana del sushi: 30% de descuento en todos los rollos fríos.'),
(5.00, '2024-11-05', '2024-11-30', 'Descuento de $5 en tu pedido cuando gastes más de $50 en productos seleccionados.');

-- VISTAS --

CREATE VIEW ProductosDisponibles AS
SELECT 
    idProducto, 
    nombre, 
    imagen_URL, 
    precio, 
    descripcion, 
    inventario, 
    idCategoria
FROM 
    Producto p
WHERE 
    inventario > 0;

CREATE VIEW ReservasActivas as
SELECT idReserva, fecha_reserva, hora_reserva, num_personas, estatus, tema
FROM Reserva r
WHERE estatus = "activo" AND fecha_reserva > NOW();

-- EL ID CLIENTE CAMBIA DEPENDIENDO DEL CLIENTE EN LA SESION
CREATE VIEW PedidosCliente as
SELECT idPedido,fecha_pedido,fecha_entrega, total_pedido, estatus, idCliente
FROM Pedido p
WHERE p.idCliente = 2; 

CREATE VIEW CalificacionesProducto as
SELECT c.idProducto, AVG(c.puntuacion) AS promedio_puntuacion
FROM Calificacion c
GROUP BY c.idProducto;

CREATE VIEW PromocionesVigentes as
SELECT idPromocion,descuento,fecha_inicio, fecha_fin,descripcion
FROM Promocion 
WHERE fecha_inicio < Now()  and fecha_fin > Now();

-- cantidad a comparar se va modifcar o estatico? periodo de tiempo o cantidad?
CREATE VIEW TopProductosVendidos as
SELECT idProducto
FROM DetallesPedido 
GROUP BY idProducto
HAVING SUM(cantidad) > 2; 

-- Se agrupa por fecha de pedido y se suma
CREATE VIEW VentasDiarias as
SELECT SUM(total_pedido)
FROM Pedido p 
GROUP BY fecha_pedido;

-- TRIGGERS --

-- 1. NoStockProducto (Tostada de Hamaichi Aji y Edamame)
DELIMITER $$
CREATE TRIGGER NoStockProducto
BEFORE INSERT ON Producto
FOR EACH ROW
BEGIN 
    IF NEW.inventario = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay inventario de ese producto.';
        END IF;
END $$

DELIMITER ;

-- 1.2 NoStockProductoDeshabilitado
DELIMITER $$
CREATE TRIGGER NoStockProductoDeshabilitado 
AFTER DELETE ON Producto
FOR EACH ROW
BEGIN
DELETE FROM inventario
    WHERE inventario = 0;
    END;
END $$

DELIMITER ;

INSERT INTO Producto (nombre, imagen_URL, precio, descripcion,inventario, idCategoria) VALUES
('Tostada de Atún', 'URL_de_imagen', 100.00, 'Aleta azul, aioli de búfalo, aguacate, cilantro',20, 1),
('Tostada de Hamachi Aji', 'URL_de_imagen', 120.00, 'Yuzu-soya, aji amarillo, mayo ajo tatemado, cebollín, furakake shiso',0, 1),
('Batera de Toro', 'URL_de_imagen', 140.00, 'Aleta azul, yuzu-aioli, aguacate, aji amarillo',10, 1),
('Batera de Salmón', 'URL_de_imagen', 130.00, 'Salmón, aioli habanero, lemon soy, cebollín, cilantro criollo', 18, 1),
('Tartar de Toro', 'URL_de_imagen', 150.00, 'Aleta azul, vinagreta yuzu-trufa', 12, 1),
('Edamame', 'URL_de_imagen', 80.00, 'Sal Maldon, salsa negra, polvo piquín', 0, 2),
('Shishitos', 'URL_de_imagen', 90.00, 'Sal Maldon, limón california', 20, 2),
('Papás Fritas', 'URL_de_imagen', 70.00, 'Sal matcha, soya-trufa', 30, 2),
('Camarones Roca', 'URL_de_imagen', 180.00, 'Soya dulce, mayo-picante, ajonjolí', 15, 2),
('Jalapeño Poppers', 'URL_de_imagen', 160.00, 'Cangrejo, atún aleta azul, queso feta, soya-yuzu', 25, 2),
('Huachinango Tempura', 'URL_de_imagen', 200.00, 'Sal Maldon, salsa negra, polvo piquín',18, 2);

-- 2. ActualizarPuntosCliente
DELIMITER $$
CREATE TRIGGER ActualizarPuntosCliente
BEFORE UPDATE ON Pedido 
FOR EACH ROW
BEGIN
    IF NEW.estatus = 'inactivo' THEN 
    UPDATE Cliente
    SET NuevosPuntos = NuevosPuntos + (NEW.puntos - OLD.puntos)
    WHERE idCliente = NEW.idCliente;
    END IF;
END;
END $$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER ActualizarPuntosCliente
BEFORE UPDATE ON Pedido
FOR EACH ROW
BEGIN
    IF NEW.estatus = 'inactivo' THEN 
    UPDATE Cliente
    SET puntos = puntos + 5;
    END IF;
END $$

DELIMITER ;

INSERT INTO Cliente (nombre, apellido, telefono, correo, puntos, direccion)
VALUES
('Juan', 'Gomez', '5551234567', 'juan.gomez@email.com', 10, 'Calle Falsa 123, Ciudad, CP 12345'),
('Maria', 'Lopez', '5552345678', 'maria.lopez@email.com', 15, 'Av. Siempre Viva 456, Ciudad, CP 67890'),
('Carlos', 'Rodriguez', '5553456789', 'carlos.rodriguez@email.com', 5, 'Calle del Sol 789, Ciudad, CP 11223'),
('Ana', 'Martinez', '5554567890', 'ana.martinez@email.com', 8, 'Paseo de la Reforma 101, Ciudad, CP 33445'),
('Esteban', 'Perez', '5555678901', 'esteban.perez@email.com', 12, 'Boulevard de los Héroes 202, Ciudad, CP 55667'),
('Lucia', 'Garcia', '5556789012', 'lucia.garcia@email.com', 20, 'Calle de la Luna 303, Ciudad, CP 77889'),
('Pedro', 'Sanchez', '5557890123', 'pedro.sanchez@email.com', 25, 'Plaza Mayor 404, Ciudad, CP 99001');

INSERT INTO Categoria (nombre) VALUES

-- 3. ValidarFechaReserva fecha_reserva DATE NOT NULL / INSERT INTO Reserva (fecha_reserva, hora_reserva, num_personas, estatus, tema) VALUES ('2024-11-20', '19:00:00', 4, 'activo', 'Reunión de trabajo'),
DELIMITER $$
CREATE TRIGGER ValidarFechaReserva
BEFORE INSERT ON Reserva
FOR EACH ROW
BEGIN
    IF NEW.fecha_reserva < '2024-%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La reserva ha expirado.';
        END IF;
END $$

DELIMITER ;

-- 4. BloquearCambioPedidoCompletado
INSERT INTO Pedido (fecha_pedido, fecha_entrega, total_pedido, estatus, idCliente)
VALUES
('2024-11-01', '2024-11-02', 250.00, 'activo', 2),  
('2024-11-02', '2024-11-03', 300.00, 'cancelado', 2), 
('2024-11-03', '2024-11-04', 150.00, 'inactivo', 3), 
('2024-11-04', '2024-11-05', 200.00, 'activo', 4),   
('2024-11-05', '2024-11-06', 180.00, 'activo', 5),   
('2024-11-06', '2024-11-07', 220.00, 'cancelado', 6), 
('2024-11-07', '2024-11-08', 270.00, 'activo', 7);    

DELIMITER $$
CREATE TRIGGER BloquearCambioPedidoCompletado
BEFORE INSERT ON Pedido
FOR EACH ROW
BEGIN
    IF NEW.estatus = 'inactivo' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido ya no se puede modificar.';
        END IF;
END $$

DELIMITER ; 

-- 5. LogEliminacionProducto

-- 6. CalcularTotalPedido CALCULA EL TOTAL AUTOMATICAMENTE AL INSERTAR UN NUEVO DETALLE DE PEDIDO
DELIMITER $$
CREATE TRIGGER CalcularTotalPedido
AFTER INSERT ON Pedido
FOR EACH ROW
BEGIN 
    UPDATE total_pedido 
        SET total_suma = (total_suma + 
                    (SELECT precio p FROM Producto p WHERE p.idProducto = :NEW.idProducto)
                    )
        WHERE idPedido = :NEW.idPedido
END;
END $$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER CalcularTotalPedido
AFTER UPDATE ON Pedido
FOR EACH ROW
BEGIN 
    UPDATE total_pedido
        SET total_suma = total_suma + (precio - precio)
        WHERE idProducto = idProducto;
END;
END $$

DELIMITER ;

CREATE OR REPLACE TRIGGER update_sum
AFTER INSERT ON bought
FOR EACH ROW
BEGIN
  UPDATE Receipt
      SET total_sum = (total_sum +
                       (select i.price from items i where i.item_id = :new.item_id)
                      )
      WHERE receipt_id = :new.receipt_id
END;

-- 7. NotificarPromocionExpirada Voy a poner como inactivas las promociones de noviembre.
Marca una promoción como inactiva si su fecha de finalizacion ha pasado

DELIMITER $$
CREATE TRIGGER NotificarPromocionExpirada
BEFORE INSERT ON Promocion
FOR EACH ROW
BEGIN 
    IF NEW.fecha_inicio > '2024-11-01' AND NEW.fecha_inicio < '2024-11-30' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La promoción ya ha expirado.';
        END IF;
END $$

DELIMITER ; 
