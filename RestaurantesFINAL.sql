CREATE TABLE ROLES (
    idRol INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

-- ROLES OFICIALES --

INSERT INTO ROLES (nombre) VALUES
('cliente'),
('admin'),
('staff');

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
('JuanPe', SHA2('666', 256), 3),
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

INSERT INTO ROLES_STAFF VALUES
('5', '1');

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
    idPuntos INT NOT NULL DEFAULT 0,
    idUsuario INT NOT NULL,
    idStatus INT NOT NULL DEFAULT 1,
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

CREATE TABLE DETALLES_METODOPAGOS (
    idDetalleMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    num_tarjeta VARCHAR(255),
    fecha_expiracion DATE
);

INSERT INTO DETALLES_METODOPAGOS (num_tarjeta, fecha_expiracion) VALUES
('1234567812345678', '2025-12-31'),
('2345678923456789', '2024-10-31'),
('3456789034567890', '2026-05-31');

CREATE TABLE METODOPAGOS (
    idMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    nombre_metodo VARCHAR(255),
    idCliente INT NOT NULL,
    idDetalleMetodoPago INT,
    FOREIGN KEY (idDetalleMetodoPago) REFERENCES DETALLES_METODOPAGOS (idDetalleMetodoPago),
    FOREIGN KEY (idCliente) REFERENCES CLIENTES (idCliente)
);

INSERT INTO METODOPAGOS (nombre_metodo, idCliente, idDetalleMetodoPago) VALUES
('Visa', 1, 1),
('MasterCard', 2, 2),
('American Express', 3, NULL),
('Discover', 4, 3),
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
    idCliente INT NOT NULL,
    FOREIGN KEY (idStatus) REFERENCES STATUS_RESERVAS (idStatus),
    FOREIGN KEY (idCliente) REFERENCES CLIENTES (idCliente)
);

INSERT INTO RESERVAS (fecha_reserva, hora_reserva, num_personas, idStatus, tema, idCliente) VALUES
('2024-11-20', '19:00:00', 4, 1, 'Reunión de trabajo', 1), 
('2024-12-25', '13:30:00', 2, 2, 'Comida de navidad', 2),  
('2024-11-30', '18:00:00', 6, 3, 'Cena con amigos', 3),   
('2024-12-01', '20:00:00', 3, 1, 'Cena familiar', 4),       
('2024-08-15', '14:00:00', 5, 3, 'Reunión de equipo', 5),  
('2023-09-10', '12:00:00', 2, 2, 'Comida de trabajo', 5);

CREATE TABLE PLATILLOS (
    idPlatillo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    imagen_URL TEXT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    descripcion VARCHAR(255),
    inventario INT,
    idCategoria INT,
    FOREIGN KEY (idCategoria) REFERENCES CATEGORIAS(idCategoria)
);

INSERT INTO PLATILLOS (nombre, imagen_URL, precio, descripcion, inventario, idCategoria) VALUES
('Tostada de Atún', 'https://media-cdn.tripadvisor.com/media/photo-s/18/84/96/2b/tostada-de-atun-fresco.jpg', 100.00, 'Aleta azul, aioli de búfalo, aguacate, cilantro', 20, 1),
('Tostada de Hamachi Aji', 'https://www.foodgal.com/wp-content/uploads/2022/10/Juniper-Ivy-hamachi-tostada.jpg', 120.00, 'Yuzu-soya, aji amarillo, mayo ajo tatemado, cebollín, furakake shiso', 0, 1),
('Batera de Toro', 'https://losarrocesdekiko.com/wp-content/uploads/2022/04/Rabo-de-toro--scaled.jpg', 140.00, 'Aleta azul, yuzu-aioli, aguacate, aji amarillo', 10, 1),
('Batera de Salmón', 'https://media-cdn.tripadvisor.com/media/photo-s/1d/3f/0b/0e/batera-de-salmao.jpg', 130.00, 'Salmón, aioli habanero, lemon soy, cebollín, cilantro criollo', 18, 1),
('Tarta de Toro', 'https://cdn7.kiwilimon.com/recetaimagen/29776/960x720/31682.jpg.webp', 150.00, 'Aleta azul, vinagreta yuzu-trufa', 12, 1),
('Edamame', 'https://misssushi.es/wp-content/uploads/edamame.jpg', 80.00, 'Sal Maldon, salsa negra, polvo piquín', 0, 2),
('Shishitos', 'https://www.justonecookbook.com/wp-content/uploads/2022/08/Blistered-Shishito-Peppers-With-Ginger-Soy-Sauce-9223-II.jpg', 90.00, 'Sal Maldon, limón california', 20, 2),
('Papás Fritas', 'https://kodamasushi.cl/wp-content/uploads/2019/08/papas-fritas-touri-sushi02.jpg', 70.00, 'Sal matcha, soya-trufa', 30, 2),
('Camarones Roca', 'https://i0.wp.com/cucharamia.com/wp-content/uploads/2021/07/camarones-roca.jpg?w=798&ssl=1', 180.00, 'Soya dulce, mayo-picante, ajonjolí', 15, 2),
('Jalapeño Poppers', 'https://www.recipetineats.com/tachyon/2024/02/Jalapeno-poppers_2.jpg?resize=1200%2C1500&zoom=0.54', 160.00, 'Cangrejo, atún aleta azul, queso feta, soya-yuzu', 25, 2),
('Huachinango Tempura', 'https://tofuu.getjusto.com/orioneat-local/resized2/rcgzQe2pLxFQT8Ghw-800-x.webp', 200.00, 'Sal Maldon, salsa negra, polvo piquín', 18, 2);

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
('Pedido Completo'),
('Cancelado'); 

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

-- 2. NoStockProductoDeshabilitado
DELIMITER $$
CREATE TRIGGER NoStockProductoDeshabilitado 
AFTER DELETE ON PLATILLOS
FOR EACH ROW
BEGIN
    DELETE FROM inventario
    WHERE inventario = 0;
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
    IN direc INT
)
BEGIN
    UPDATE CLIENTES
    SET 
        direccion = direc
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
    SET 
        nombre = nombre, 
        apellido = apellido,
        correo = correo,
        telefono = telefono,
        direccion = direccion
    WHERE idCliente = p_idCliente;
    
    UPDATE PUNTOS_CLIENTES
    SET 
        cant_puntos = cant_puntos
    WHERE idPuntos = (SELECT idPuntos FROM CLIENTES WHERE idCliente = p_idCliente);
END $$ 
DELIMITER ;

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

<<<<<<< HEAD
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
=======
DELIMITER / / CREATE PROCEDURE BuscaUsuario (IN username varchar(50)) BEGIN
SELECT
    *
FROM
    InfoUsuario
where
    nombre_usuario = username;
>>>>>>> 8e25d15d54e291966ff1bd452800f0ba373c85f8

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

-- PROCS PARA PEDIDOS --

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
    DELETE FROM PEDIDOS
    WHERE idPedido = New_idPedido;
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
END // DELIMITER ;

CREATE VIEW ListaPlatillos AS
SELECT * FROM PLATILLOS;

DELIMITER $$
CREATE PROCEDURE obtenerPlatillo(IN idPlatillo INT)
BEGIN
    SELECT idPlatillo, nombre, imagen_URL, precio, descripcion, inventario, idCategoria
    FROM ListaPlatillos
    WHERE idPlatillo = idPlatillo;
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
