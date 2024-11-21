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

CREATE TABLE MetodoPago (
    idMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    nombre_metodo VARCHAR(255),
    idCliente INT NOT NULL,
    idDetalleMetodoPago INT NOT NULL,
    FOREIGN KEY (idDetalleMetodoPago) REFERENCES Detalle_MetodoPago(idDetalleMetodoPago)
);

CREATE TABLE Detalle_MetodoPago(
    idDetalleMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    num_tarjeta VARCHAR(255),
    fecha_expiracion DATE
);

CREATE TABLE Clientes (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    idPuntos INT NOT NULL,
    idUsuario INT NOT NULL,
    idSatus INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuario_Restaurante(idUsuario),
    FOREIGN KEY (idPuntos) REFERENCES Puntos_Clientes(idPuntos),
    FOREIGN KEY (idSatus) REFERENCES Status_Clientes(idSatus)
);

CREATE TABLE Puntos_Clientes (
    idPuntos INT PRIMARY KEY AUTO_INCREMENT,
    cant_puntos INT NOT NULL
);

CREATE TABLE Status_Clientes (
    idSatus INT PRIMARY KEY AUTO_INCREMENT,
    Status_Clientes VARCHAR(255)
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

/*Agregue llave foranea de platillo en promociones, por que no vi como se iba a guardar si en la tabla platillos o promociones la relacion.
Se me hace mejor en promociones por que no todos los platillos van a tener promociones :)*/

CREATE TABLE Promociones (
    idPromocion INT PRIMARY KEY AUTO_INCREMENT,
    idTipoPromocion INT NOT NULL,
    idPlatillo INT NOT NULL,
    descuento DECIMAL(5, 2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    FOREIGN KEY (idTipoPromocion) REFERENCES TipoPromocion(idTipoPromocion),
    FOREIGN KEY (idPlatillo) REFERENCES Platillos(idPlatillo)
);

CREATE TABLE TipoPromocion (
    idTipoPromocion INT PRIMARY KEY AUTO_INCREMENT,
    tipo_promocion VARCHAR(255)
);

CREATE TABLE Pedido (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    fecha_pedido DATE NOT NULL,
    fecha_entrega DATE,
    total_pedido DECIMAL(10, 2) NOT NULL,
    idCliente INT NOT NULL,
    idStatus INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
    FOREIGN KEY (idStatus) REFERENCES Status_Pedido(idStatus)
);

CREATE TABLE Status_Pedido (
    idSatus INT PRIMARY KEY AUTO_INCREMENT,
    nombre_status VARCHAR(255)
);

CREATE TABLE Platillos (
    idPlatillo INT PRIMARY KEY AUTO_INCREMENT,
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
    FOREIGN KEY (idProducto) REFERENCES Platillos(idPlatillo)
);

/*CREATE TABLE Reseñas (         Tabla anterior de reseñas
    idReseña INT PRIMARY KEY AUTO_INCREMENT,
    puntuacion INT NOT NULL,
    comentario TEXT,
    idPedido INT,
    idProducto INT,
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);*/

/*Deberia de tener el id del cliente que hizo la reseña no?*/

CREATE TABLE Reseñas (
    idReseña INT PRIMARY KEY AUTO_INCREMENT,
    puntuacion INT NOT NULL,
    comentario TEXT,
    idTipoReseña INT NOT NULL,
    idCliente INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)
);

CREATE TABLE Tipo_Reseña (
    idTipoReseña INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255)
);