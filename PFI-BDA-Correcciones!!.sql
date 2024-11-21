CREATE TABLE ROL (
    idRol INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE USUARIOS_RESTAURANTE (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    idRol INT NOT NULL,
    FOREIGN KEY (idRol) REFERENCES ROL(idRol)
);

CREATE TABLE PUNTOS_CLIENTES (
    idPuntos INT PRIMARY KEY AUTO_INCREMENT,
    cant_puntos INT NOT NULL
);

CREATE TABLE STATUS_CLIENTES (
    idSatus INT PRIMARY KEY AUTO_INCREMENT,
    Status_Clientes VARCHAR(255)
);

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
    FOREIGN KEY (idSatus) REFERENCES STATUS_CLIENTES(idSatus)
);

CREATE TABLE DETALLE_METODOPAGOS(
    idDetalleMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    num_tarjeta VARCHAR(255),
    fecha_expiracion DATE
);


CREATE TABLE METODOPAGOS (
    idMetodoPago INT PRIMARY KEY AUTO_INCREMENT,
    nombre_metodo VARCHAR(255),
    idCliente INT NOT NULL,
    idDetalleMetodoPago INT NOT NULL,
    FOREIGN KEY (idDetalleMetodoPago) REFERENCES DETALLE_METODOPAGOS(idDetalleMetodoPago)
    FOREIGN KEY (idCliente) REFERENCES CLIENTES(idDetalleMetodoPago)
);



CREATE TABLE CATEGORIAS (
    idCategoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE STATUS_RESERVAS (
    idSatus INT PRIMARY KEY AUTO_INCREMENT,
    Status_Reservas VARCHAR(255)
);

CREATE TABLE RESERVA (
    idReserva INT PRIMARY KEY AUTO_INCREMENT,
    fecha_reserva DATE NOT NULL,
    hora_reserva TIME NOT NULL,
    num_personas INT NOT NULL,
    idstatus VARCHAR(20) NOT NULL,
    tema VARCHAR(100),
    FOREIGN KEY (idSatus) REFERENCES STATUS_RESERVAS(idSatus)
);

CREATE TABLE TIPOPROMOCION (
    idTipoPromocion INT PRIMARY KEY AUTO_INCREMENT,
    tipo_promocion VARCHAR(255)
);

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

CREATE TABLE PROMOCIONES (
    idPromocion INT PRIMARY KEY AUTO_INCREMENT,
    idTipoPromocion INT NOT NULL,
    idPlatillo INT NOT NULL,
    descuento DECIMAL(5, 2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    FOREIGN KEY (idTipoPromocion) REFERENCES TIPOPROMOCION(idTipoPromocion),
    FOREIGN KEY (idPlatillo) REFERENCES PLATILLOS(idPlatillo)
);

CREATE TABLE STATUS_PEDIDO (
    idSatus INT PRIMARY KEY AUTO_INCREMENT,
    nombre_status VARCHAR(255)
);

CREATE TABLE PEDIDOS (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    fecha_pedido DATE NOT NULL,
    fecha_entrega DATE,
    total_pedido DECIMAL(10, 2) NOT NULL,
    idCliente INT NOT NULL,
    idStatus INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES CLIENTES(idCliente)
    FOREIGN KEY (idStatus) REFERENCES STATUS_PEDIDO(idStatus)
);



CREATE TABLE DETALLESPEDIDO (
    idPedido INT,
    idProducto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (idPedido, idProducto),
    FOREIGN KEY (idPedido) REFERENCES PEDIDOS(idPedido),
    FOREIGN KEY (idProducto) REFERENCES PLATILLOS(idPlatillo)
);

CREATE TABLE TIPO_RESEÑA (
    idTipoReseña INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255)
);

CREATE TABLE Reseñas (
    idReseña INT PRIMARY KEY AUTO_INCREMENT,
    puntuacion INT NOT NULL,
    comentario TEXT,
    idCliente INT NOT NULL,
    idTipoReseña INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente),
    FOREIGN KEY (idTipoReseña) REFERENCES TIPO_RESEÑA(idTipoReseña) ON DELETE CASCADE,
);

CREATE TABLE Restaurante (
    idRestaurante INT PRIMARY KEY AUTO_INCREMENT,
    nombre VAR(255), -- puede ser un alias --
    ubicacion TEXT,
    telefono VARCHAR(20) NOT NULL,
    descripcion TEXT
);

