CREATE VIEW InfoUsuario AS
SELECT 
    ur.idUsuario,
    ur.nombre_usuario,
    ur.password,
    r.nombre_rol
FROM 
    Usuario_Restaurante ur
JOIN 
    Rol r
ON 
    ur.idRol = r.idRol;


DELIMITER //
CREATE PROCEDURE BuscaUsuario(
    IN username varchar(50),
)
BEGIN
    SELECT * 
    FROM InfoUsuario
    where username = nombre_usuario;
END //
DELIMITER ;