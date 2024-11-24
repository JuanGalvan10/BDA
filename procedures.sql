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
    IN idU INT,
)
BEGIN
    SELECT idCliente
    FROM CLIENTES
    WHERE idUsuario = idU
END //
DELIMITER ;
