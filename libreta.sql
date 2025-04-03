use ud6_alquiler_patinetes;
-- 4.1
-- -----------------------------------------------------------------
-- Para evitar errores con las contraseñas, compruebo que tengo ins
-- el componente de validación de contraseñas (desde la 8)alterç
SHOW VARIABLES LIKE 'validate_password.%';
-- si no aparece la variable instalo el componente
INSTALL COMPONENT 'file://component_validate_password';
-- podria modificar los siguientes valores
SET GLOBAL validate_password.lenght = 4; -- 8
SET GLOBAL validate_password.number_count = 1; -- 1
SET GLOBAL validate_password.mixed_case_count = 1; -- 1
SET GLOBAL validate_password.special_char_count = 1; -- 1

-- LOW hace que solo se compruebe longitud >= 8
SET GLOBAL validate_password.policy = LOW; -- LOW(0), MEDIUM (1), HIGH (2)  normalmente se deja en Medium
SET GLOBAL validate_password.length = 0; -- mejor no poner los números

-- creando usuarios solo damos permiso de entrada a esos usuarios, pero no pueden hacer nada de momento
CREATE USER usuario1@localhost IDENTIFIED BY 'pwd1'; -- con localhost solo te puedes conectar en local
CREATE USER usuario2@'%' IDENTIFIED BY 'pwd2';-- esto es lo normal y lo recomendable (te puedes conectar desde donde quieras conectarte)
CREATE USER usuario3@localhost IDENTIFIED BY 'pwd3'
	WITH MAX_USER_CONNECTIONS 10 MAX_QUERIES_PER_HOUR 1000;-- se le pueden añadir más cosas, pero esto es más de Asir, esto es para que solo se puedan conectar al mismo tiempo 10 usuairos y temas de consultas


SELECT user, host FROM mysql.user ORDER BY user;
SELECT * FROM mysql.user ORDER BY user;


-- 4.2.--
DROP USER usuario1@localhost;-- borrar usuario
DROP USER usuario2@'%';
SELECT * FROM mysql.user WHERE user LIKE '%usuario%';







-- Lo que realmente interesa empieza ahora

-- 4.3 
RENAME USER usuario3@localhost TO mi_usuario@localhost;

ALTER USER mi_usuario@localhost IDENTIFIED BY 'usuario3'; -- identificado por la contraseña
ALTER USER mi_usuario@localhost ACCOUNT LOCK; -- Bloquear un usuario
ALTER USER mi_usuario@localhost ACCOUNT UNLOCK; -- desbloquearlo
ALTER USER mi_usuario@localhost WITH MAX_UPDATES_PER_HOUR 100;

DROP USER mi_usuario@localhost;

-- 5. PRIVILEGIOS de usuarios ---------------------------------------------------------

-- 5.1. Concesión
SELECT * FROM mysql.user;

-- para poder dar permisos desde root@gateway (root@%, desde workbench)
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root1';


SHOW GRANTS;
-- para acceder desde cualquier ip al servidor, modificar my.cnf
-- bind.address = 0.0.0.0


-- permisos para usuarios
DROP USER mecanico@'%';
CREATE USER mecanico@'%' IDENTIFIED BY 'mecanico';
GRANT INSERT, DELETE, UPDATE, SELECT ON ud6_alquiler_patinetes.patinete TO mecanico@'%';
GRANT SELECT (nombre,email) ON ud6_alquiler_patinetes.cliente TO mecanico@'%';-- esto quizás no haga falta en la vida, pero saber que se puede hacer lo de dar permisos en dos campos en concreto en una tabla
SHOW GRANTS FOR mecanico@'%';


DROP USER jefe_taller@'%';
CREATE USER jefe_taller@'%' IDENTIFIED BY 'jefe_taller';
GRANT INSERT, DELETE, UPDATE, SELECT ON ud6_alquiler_patinetes.patinete TO jefe_taller@'%' WITH GRANT OPTION; -- WITH grant option es para que este usuario pueda conceder los permisos que tiene a otros usuario, esto se usa poco en realidad
SHOW GRANTS FOR jefe_taller@'%';

DROP USER practicas@'%';
CREATE USER practicas@'%' IDENTIFIED BY 'practicas';
GRANT SELECT ON ud6_alquiler_patinetes.* TO practicas@'%';
SHOW GRANTS FOR practicas@'%';

DROP USER jefe@'%';
CREATE USER jefe@'%' IDENTIFIED BY 'jefe';
GRANT ALL ON ud6_alquiler_patinetes.* TO jefe@'%'; -- usuario que puede hacer de todo
SHOW GRANTS FOR jefe@'%';




-- 5.2. Revocación
SHOW GRANTS FOR mecanico@'%';-- mejor consultar antes lo que pueda hacer cada usuario
REVOKE INSERT, DELETE ON ud6_alquiler_patinetes.patinete FROM mecanico@'%';

SHOW GRANTS FOR practicas@'%';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM practicas@'%';


-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------

-- 













