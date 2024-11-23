CREATE TABLE ROLES (
    idRol INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);
-- CUALES SERAN LOS ROLES OFICIALES? --
INSERT INTO ROLES (nombre) VALUES
('Cliente'),
('Admin'),
('Staff');

CREATE TABLE TIPOS_STAFF(
    idRolStaff INT PRIMARY KEY AUTO_INCREMENT,
    nombre_staff VARCHAR(255)
);

INSERT INTO TIPOS_STAFF (nombre_staff) VALUES
('Gerente'),
('Mesero'),
('Cocinero'),
('Repartidor');


CREATE TABLE USUARIOS_RESTAURANTE (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    idRol INT NOT NULL,
    FOREIGN KEY (idRol) REFERENCES ROLES(idRol)
);

INSERT INTO USUARIOS_RESTAURANTE (nombre_usuario, password, idRol) VALUES
('JuanGalvan', SHA2('666', 256), 2),
('FernandoOlivares', SHA2('666', 256), 2),
('PamelaRodriguez', SHA2('666', 256), 2),
('EstefaniaNajera', SHA2('666', 256), 2),
('JuanPe', SHA2('666', 256), 1),
('MariaLo', SHA2('666', 256), 1),
('CarlosGo', SHA2('666', 256), 1),
('AnaMar', SHA2('666', 256), 1),
('LuisSa', SHA2('666', 256), 1);


CREATE TABLE ROLES_STAFF (
    idUsuario INT NOT NULL,
    idRolStaff INT NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES USUARIOS_RESTAURANTE(idUsuario),
    FOREIGN KEY (idRolStaff) REFERENCES TIPOS_STAFF(idRolStaff)
);

/*CHECAR CUAL USUARIO ES ADMIN NO USAR INSERT HASTA CHECAR ESO*/
INSERT INTO ROLES_STAFF VALUES
('1','1'),
('2','2'),
('3','3'),
('4','4');

CREATE TABLE PUNTOS_CLIENTES (
    idPuntos INT PRIMARY KEY AUTO_INCREMENT,
    cant_puntos INT NOT NULL
);

INSERT INTO PUNTOS_CLIENTES (cant_puntos) VALUES
(100),
(150),
(200),
(50),
(75);

CREATE TABLE STATUS_CLIENTES (
    idStatus INT PRIMARY KEY AUTO_INCREMENT,
    Status_Clientes VARCHAR(255)
);

INSERT INTO STATUS_CLIENTES (Status_Clientes) VALUES
('Activo'),
('Inactivo');

CREATE TABLE CLIENTES (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    idPuntos INT NOT NULL,
    idUsuario INT NOT NULL,
    idStatus INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES USUARIOS_RESTAURANTE(idUsuario),
    FOREIGN KEY (idPuntos) REFERENCES PUNTOS_CLIENTES(idPuntos),
    FOREIGN KEY (idStatus) REFERENCES STATUS_CLIENTES(idStatus)
);

INSERT INTO CLIENTES (idPuntos, idUsuario, idStatus, nombre, apellido, telefono, correo, direccion) VALUES
(1, 5, 1, 'Juan', 'Pérez', '5551234567', 'juan.perez@email.com', 'Calle Falsa 123, Ciudad, CP 12345'),
(2, 6, 1, 'María', 'López', '5552345678', 'maria.lopez@email.com', 'Av. Siempre Viva 456, Ciudad, CP 67890'),
(3, 7, 2, 'Carlos', 'Gómez', '5553456789', 'carlos.gomez@email.com', 'Boulevard de los Héroes 789, Ciudad, CP 11223'),
(4, 8, 1, 'Ana', 'Martínez', '5554567890', 'ana.martinez@email.com', 'Paseo de la Reforma 101, Ciudad, CP 33445'),
(5, 9, 2, 'Luis', 'Sánchez', '5555678901', 'luis.sanchez@email.com', 'Plaza Mayor 202, Ciudad, CP 55667');

CREATE TABLE DETALLES_METODOPAGOS(
    idDetalleMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    num_tarjeta VARCHAR(255),
    fecha_expiracion DATE
);

INSERT INTO DETALLES_METODOPAGOS (num_tarjeta, fecha_expiracion) VALUES
('1234567812345678', '2025-12-31'),
('2345678923456789', '2024-10-31'),
('3456789034567890', '2026-05-31'),
('4567890145678901', '2025-11-30'),
('5678901256789012', '2025-02-28');

CREATE TABLE METODOPAGOS (
    idMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    nombre_metodo VARCHAR(255),
    idCliente INT NOT NULL,
    idDetalleMetodoPago INT,
    FOREIGN KEY (idDetalleMetodoPago) REFERENCES DETALLES_METODOPAGOS(idDetalleMetodoPago),
    FOREIGN KEY (idCliente) REFERENCES CLIENTES(idCliente)
);

INSERT INTO METODOPAGOS (nombre_metodo, idCliente, idDetalleMetodoPago) VALUES
('Visa', 1, 1),
('MasterCard', 2, 2),
('American Express', 3, NULL),
('Discover', 4, 4),
('Efectivo', 5, NULL);

CREATE TABLE CATEGORIAS (
    idCategoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

INSERT INTO CATEGORIAS (nombre) VALUES
('Rollo Frío'),
('Rollo Caliente'),
('Entrante'),
('Postre');

CREATE TABLE STATUS_RESERVAS (
    idStatus INT PRIMARY KEY AUTO_INCREMENT,
    Status_Reservas VARCHAR(255)
);

INSERT INTO STATUS_RESERVAS (Status_Reservas) VALUES
('Completada'),
('Pendiente'),
('Cancelada');

CREATE TABLE RESERVAS (
    idReserva INT PRIMARY KEY AUTO_INCREMENT,
    fecha_reserva DATE NOT NULL,
    hora_reserva TIME NOT NULL,
    num_personas INT NOT NULL,
    idStatus INT NOT NULL,
    tema VARCHAR(100),
    FOREIGN KEY (idStatus) REFERENCES STATUS_RESERVAS(idStatus)
);

INSERT INTO RESERVAS (fecha_reserva, hora_reserva, num_personas, idStatus, tema) VALUES
('2024-11-20', '19:00:00', 4, 1, 'Reunión de trabajo'),
('2024-12-25', '13:30:00', 2, 2, 'Comida de navidad'),
('2024-11-30', '18:00:00', 6, 3, 'Cena con amigos'),
('2024-12-01', '20:00:00', 3, 1, 'Cena familiar'),
('2024-08-15', '14:00:00', 5, 3, 'Reunión de equipo'),
('2023-09-10', '12:00:00', 2, 2, 'Comida de trabajo');

CREATE TABLE PLATILLOS (
    idPlatillo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    imagen_URL VARCHAR(255) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    descripcion VARCHAR(255),
    inventario INT,
    idCategoria INT,
    FOREIGN KEY (idCategoria) REFERENCES CATEGORIAS(idCategoria)
);

INSERT INTO PLATILLOS (nombre, imagen_URL, precio, descripcion, inventario, idCategoria) VALUES
('Tostada de Atún', 'URL_de_imagen', 100.00, 'Aleta azul, aioli de búfalo, aguacate, cilantro', 20, 1),
('Tostada de Hamachi Aji', 'URL_de_imagen', 120.00, 'Yuzu-soya, aji amarillo, mayo ajo tatemado, cebollín, furakake shiso', 0, 1),
('Batera de Toro', 'URL_de_imagen', 140.00, 'Aleta azul, yuzu-aioli, aguacate, aji amarillo', 10, 1),
('Batera de Salmón', 'URL_de_imagen', 130.00, 'Salmón, aioli habanero, lemon soy, cebollín, cilantro criollo', 18, 1),
('Tartar de Toro', 'URL_de_imagen', 150.00, 'Aleta azul, vinagreta yuzu-trufa', 12, 1),
('Edamame', 'URL_de_imagen', 80.00, 'Sal Maldon, salsa negra, polvo piquín', 0, 2),
('Shishitos', 'URL_de_imagen', 90.00, 'Sal Maldon, limón california', 20, 2),
('Papás Fritas', 'URL_de_imagen', 70.00, 'Sal matcha, soya-trufa', 30, 2),
('Camarones Roca', 'URL_de_imagen', 180.00, 'Soya dulce, mayo-picante, ajonjolí', 15, 2),
('Jalapeño Poppers', 'URL_de_imagen', 160.00, 'Cangrejo, atún aleta azul, queso feta, soya-yuzu', 25, 2),
('Huachinango Tempura', 'URL_de_imagen', 200.00, 'Sal Maldon, salsa negra, polvo piquín', 18, 2);

CREATE TABLE TIPOSPROMOCION (
    idTipoPromocion INT PRIMARY KEY AUTO_INCREMENT,
    tipo_promocion VARCHAR(255)
);

INSERT INTO TIPOSPROMOCION (tipo_promocion) VALUES
('VeranoLoco'),
('Black Friday'), 
('Navidad'),    
('Día del Cliente');


CREATE TABLE PROMOCIONES (
    idPromocion INT PRIMARY KEY AUTO_INCREMENT,
    idTipoPromocion INT NOT NULL,
    idPlatillo INT NOT NULL,
    descuento DECIMAL(5, 2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    FOREIGN KEY (idTipoPromocion) REFERENCES TIPOSPROMOCION(idTipoPromocion),
    FOREIGN KEY (idPlatillo) REFERENCES PLATILLOS(idPlatillo)
);

INSERT INTO PROMOCIONES (idTipoPromocion, idPlatillo, descuento, fecha_inicio, fecha_fin, descripcion) VALUES
(1, 1, 15.00, '2024-06-01', '2024-06-30', 'Descuento del 15% en todos los rollos fríos para celebrar el verano.'),
(1, 2, 15.00, '2024-06-01', '2024-06-30', 'Descuento del 15% en Tostada de Hamachi Aji durante el verano.'),
(1, 3, 15.00, '2024-06-01', '2024-06-30', 'Descuento del 15% en Batera de Toro para refrescarte este verano.'),
(2, 4, 20.00, '2024-11-25', '2024-11-30', 'Descuento del 20% en Tostada de Salmón por Black Friday.'),
(2, 5, 20.00, '2024-11-25', '2024-11-30', 'Descuento del 20% en Tartar de Toro durante Black Friday.'),
(2, 6, 20.00, '2024-11-25', '2024-11-30', 'Descuento del 20% en Edamame para el Black Friday.'),
(3, 7, 10.00, '2024-12-01', '2024-12-25', 'Descuento del 10% en Camarones Roca para celebrar la Navidad.'),
(3, 8, 10.00, '2024-12-01', '2024-12-25', 'Descuento del 10% en Papás Fritas durante Navidad.'),
(3, 9, 10.00, '2024-12-01', '2024-12-25', 'Descuento del 10% en Jalapeño Poppers por Navidad.'),
(4, 10, 25.00, '2024-10-01', '2024-10-31', 'Descuento del 25% en todos los platillos por el Día del Cliente.'),
(4, 11, 25.00, '2024-10-01', '2024-10-31', 'Descuento del 25% en Huachinango Tempura por el Día del Cliente.');


CREATE TABLE STATUS_PEDIDO (
    idStatus INT PRIMARY KEY AUTO_INCREMENT,
    nombre_status VARCHAR(255)
);

INSERT INTO STATUS_PEDIDO (nombre_status) VALUES
('Orden Recibida'),
('En Preparación'), 
('Pedido Completo'); 


CREATE TABLE PEDIDOS (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    fecha_pedido DATE NOT NULL,
    fecha_entrega DATE,
    total_pedido DECIMAL(10, 2) NOT NULL,
    idCliente INT NOT NULL,
    idStatus INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES CLIENTES(idCliente),
    FOREIGN KEY (idStatus) REFERENCES STATUS_PEDIDO(idStatus)
);

INSERT INTO PEDIDOS (fecha_pedido, fecha_entrega, total_pedido, idStatus, idCliente) VALUES
('2024-11-01', '2024-11-02', 250.00, 1, 2),  
('2024-11-02', '2024-11-03', 300.00, 2, 2), 
('2024-11-03', '2024-11-04', 150.00, 3, 3), 
('2024-11-04', '2024-11-05', 200.00, 1, 4),   
('2024-11-05', '2024-11-06', 180.00, 1, 4),   
('2024-11-06', '2024-11-07', 220.00, 2, 5), 
('2024-11-07', '2024-11-08', 270.00, 1, 5); 

CREATE TABLE DETALLESPEDIDO (
    idPedido INT,
    idPlatillo INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (idPedido, idPlatillo),
    FOREIGN KEY (idPedido) REFERENCES PEDIDOS(idPedido),
    FOREIGN KEY (idPlatillo) REFERENCES PLATILLOS(idPlatillo)
);

INSERT INTO DETALLESPEDIDO (idPedido, idPlatillo, cantidad, precio_unitario) VALUES
(1, 1, 2, 50.00),  
(1, 2, 1, 150.00),
(2, 3, 2, 100.00), 
(2, 4, 1, 200.00), 
(3, 5, 1, 150.00), 
(3, 6, 3, 100.00),
(4, 7, 2, 150.00),  
(5, 8, 2, 130.00), 
(5, 9, 1, 180.00), 
(6, 10, 3, 90.00),  
(7, 11, 1, 70.00);  

CREATE TABLE TIPOS_RESENA (
    idTipoResena INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255)
);

INSERT INTO TIPOS_RESENA (nombre) VALUES
('Restaurante'),
('Platillo');

CREATE TABLE RESENAS (
    idResena INT PRIMARY KEY AUTO_INCREMENT,
    puntuacion INT NOT NULL,
    titulo VARCHAR(50) NOT NULL,
    comentario TEXT NOT NULL,
    fecha_comentario DATE NOT NULL,
    idCliente INT NOT NULL,
    idTipoResena INT NOT NULL,
    idPedido INT ,
    FOREIGN KEY (idCliente) REFERENCES CLIENTES(idCliente),
    FOREIGN KEY (idPedido) REFERENCES PEDIDOS(idPedido),
    FOREIGN KEY (idTipoResena) REFERENCES TIPOS_RESENA(idTipoResena) ON DELETE CASCADE
);

INSERT INTO RESENAS (puntuacion, titulo, comentario, fecha_comentario, idCliente, idTipoResena, idPedido) VALUES
(5, 'Increíble experiencia', 'Excelente ambiente, atención de primera y los platillos deliciosos. Sin duda volveré.', '2024-11-15', 2, 2, 2), 
(4, 'Buen servicio', 'El servicio fue bueno, pero la comida estuvo un poco más salada de lo que esperaba.', '2024-11-16', 2, 2, 1), 
(3, 'Regular', 'El lugar es bonito, pero el servicio fue lento y algunos platillos no estaban disponibles.', '2024-11-17', 3, 1, null),
(5, 'Espectacular platillo', 'El Tartar de Toro es espectacular, fresco y con un sabor único.', '2024-11-18', 4, 2, 4),
(4, 'Delicioso Edamame', 'El Edamame estuvo delicioso, aunque podría mejorar la presentación.', '2024-11-19', 5, 2, 6),
(5, 'Recomendado', 'Las Tostadas de Atún fueron una maravilla, todo en su punto perfecto. ¡Altamente recomendable!', '2024-11-20', 5, 2, 7);

CREATE TABLE RESTAURANTES (
    idRestaurante INT PRIMARY KEY AUTO_INCREMENT,
    nombre_sucursal VARCHAR(255),
    ubicacion TEXT,
    telefono VARCHAR(20) NOT NULL,
    descripcion TEXT
);

INSERT INTO RESTAURANTES (nombre_sucursal, ubicacion, telefono, descripcion) VALUES
('Sucursal Valle Oriente', 'Av. Gonzalitos 123, Col. Valle Oriente, Monterrey, N.L.', '81-1234-5678', 'Se trata de una sucursal moderna con un ambiente acogedor, ideal para cenas familiares y reuniones de negocios.'),
('Sucursal Centro', 'Paseo Santa Lucía 456, Col. Centro, Monterrey, N.L.', '81-2345-6789', 'Ubicada en el corazón de Monterrey, ofrece una experiencia gastronómica única con sabores frescos y auténticos.'),
('Sucursal Carretera Nacional', 'Carretera Nacional 789, Col. Cumbres, Monterrey, N.L.', '81-3456-7890', 'Ofrece un espacio amplio y cómodo, ideal para disfrutar de un almuerzo en familia o una cena con amigos.');


-- PROCS PARA LOGIN --

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



-- PROCS PARA PEDIDOS 
create view
    mostrarPedidos_vw as
select
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
from
    DETALLESPEDIDO d
    natural join PEDIDOS
    natural join STATUS_PEDIDO sp
    natural join PLATILLOS p;

DELIMITER / / CREATE PROCEDURE mostrarPedidos (IN id_Sesion INT) BEGIN
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
    mostrarPedidos_vw
WHERE
    idCliente = id_Sesion;
END / / DELIMITER;





-- PROCS PARA PRODUCTOS -- 

--  (MUESTRA PRODUCTOS DISPONIBLES) --
CREATE VIEW
    ProductosDisponibles_vw AS
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

DELIMITER / / CREATE PROCEDURE mostrarProductos () BEGIN
SELECT
    idPlatillo,
    nombre,
    imagen_URL,
    precio,
    descripcion,
    inventario,
    idCategoria
FROM
    ProductosDisponibles;

END / / DELIMITER;





-- PROCS PARA RESENAS -- 
create view
    mostrarResenas_vw as
select
    idCliente,
    nombre_usuario,
    idResena,
    puntuacion,
    titulo,
    comentario,
    fecha_comentario,
    idTipoResena,
    idPedido
from
    USUARIOS_RESTAURANTE
    natural join CLIENTES
    natural join RESENAS;

DELIMITER / / CREATE PROCEDURE mostrarResenas (IN id_Sesion INT) BEGIN
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
    ProductosDisponibles
WHERE
    idCliente = id_Sesion;
END / / DELIMITER;

