CREATE TABLE Usuario_Restaurante (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL
);

CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    puntos INT DEFAULT 0,
    direccion VARCHAR(255) NOT NULL
);

CREATE TABLE MetodoPago (
    idMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    num_tarjeta VARCHAR(255) NOT NULL,  
    fecha_expiracion DATE,            
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE Reserva (
    idReserva INT PRIMARY KEY AUTO_INCREMENT,
    fecha_reserva DATE NOT NULL,
    hora_reserva TIME NOT NULL,
    num_personas INT NOT NULL,
    estatus VARCHAR(20) NOT NULL,
    tema VARCHAR(100)
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

CREATE TABLE DetallesPedido (
    idPedido INT,
    idProducto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (idPedido, idProducto),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

CREATE TABLE Promocion (
    idPromocion INT PRIMARY KEY AUTO_INCREMENT,
    descuento DECIMAL(5, 2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE Producto (
    idProducto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    imagen_URL VARCHAR(255) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    descripcion VARCHAR(255),
    categoria VARCHAR(50),
    inventario INT,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
);

CREATE TABLE Categoria (
    idCategoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
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

DELIMITER //
CREATE PROCEDURE insertarUsuario(
    nom varchar(50),
    apell varchar(50),
    tel varchar(50),
    correo varchar(100),
    direc varchar(100)
)
BEGIN
    INSERT INTO Cliente (nombre, apellido, telefono, correo, direccion)
    VALUES (nom, apell, tel, correo, direc) ;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE insertarCliente(
    nom varchar(50),
    pass varchar(225),
    rol varchar(20)
)
BEGIN
    INSERT INTO Cliente (nombre_usuario, password, rol)
    VALUES (nom, pass, rol) ;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE BuscaUsuario(
    user varchar(50)
)
BEGIN
    SELECT INTO usuario
    FROM usuarios
    WHERE username = user;
END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER trigger_fecha_estimada 
BEFORE INSERT ON Pedido
FOR EACH ROW
BEGIN
    SET NEW.fechaEntrega = DATE_ADD(NEW.fechaPedido, INTERVAL 3 DAY);
END;
//

INSERT INTO Usuario_Restaurante (nombre_usuario, password, rol) VALUES
('JuanGalvan', SHA2('666', 256), 'admin'),
('FernandoOlivares', SHA2('666', 256), 'admin'),
('PamelaRodriguez', SHA2('666', 256), 'admin'),
('EstefaniaNajera', SHA2('666', 256), 'admin');
