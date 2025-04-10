-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- UD7. Programación SQL
-- Actividad 11: Ejercicios procedimientos y funciones con acceso a BD
-- Jesús Mañogil

USE ud7_actividades_clinica_veterinaria;

-- --------------------------------------------------------------------------
-- FUNCIONES
-- 1.- Implementa una función con nombre fn_existe_cliente_mascota que reciba la clave
-- del cliente y el nombre de la mascota. Devolverá 0 si ese cliente no tiene ninguna 
-- mascota con ese nombre y 1 en caso contrario. Contempla la posibilidad de que
-- reciba un nombre con espacios al princio o final del texto.
DELIMITER //
DROP FUNCTION IF EXISTS fn_existe_cliente_mascota//
CREATE FUNCTION fn_existe_cliente_mascota(clave_cliente INT, nombre_mascota VARCHAR(50))
RETURNS BOOL
READS SQL DATA
BEGIN
		DECLARE v_num INT DEFAULT 0;
        
        -- buscamos si ese cliente ya tiene una mascota con el mismo nombre
        -- convirtiendo a minúsculas evita tener en cuenta si la collation es
        -- case insensitive o no
        SELECT COUNT(*) INTO v_num FROM mascota 
        WHERE id_cliente = clave_cliente AND LOWER(nombre) = TRIM(LOWER(nombre_mascota));
        
        IF v_num = 0 THEN
			RETURN 0;
		ELSE
			RETURN 1;
        END IF;
        
END //
DELIMITER ;
SELECT fn_existe_cliente_mascota(3, 'pancho') AS Existe;

-- --------------------------------------------------------------------------
-- 2.- Implementa una función con nombre fn_sala_libre que reciba el numero 
-- de una sala y una fecha. Devolverá 1 si la sala no tiene cita para ese dia
-- y 0 en caso contrario.
DELIMITER //
DROP FUNCTION IF EXISTS fn_sala_libre//
CREATE FUNCTION fn_sala_libre(num_sala INT, dia DATE)
RETURNS BOOL
READS SQL DATA
BEGIN
		DECLARE v_num INT DEFAULT 0;
        
        -- buscamos si tenemos una cita en esa sala
        SELECT COUNT(*) INTO v_num FROM atiende 
        WHERE numero_sala = num_sala AND fecha_cita = dia;
        
        IF v_num = 0 THEN
			RETURN 1;
		ELSE
			RETURN 0;
        END IF;
        
END //
DELIMITER ;
-- ocupada
SELECT fn_sala_libre(2, '2025-02-02') AS Libre;
-- libre
SELECT fn_sala_libre(2, '2025-03-07') AS Libre;

-- --------------------------------------------------------------------------
-- 3.- Implementa una función con nombre fn_cliente_premium que reciba la
-- clave de un cliente y devuelva 1 en caso de considerarse cliente premium 
-- o 0 en caso contrario. Se considera cliente premium aquel cliente 
-- que ha gastado más de 150 euros en citas o que 
-- tiene más de 2 mascotas
DELIMITER //
DROP FUNCTION IF EXISTS fn_cliente_premium//
CREATE FUNCTION fn_cliente_premium(clave_cliente INT)
RETURNS BOOL
READS SQL DATA
BEGIN
		DECLARE v_gasto DECIMAL(10, 2) DEFAULT 0;
        DECLARE v_mascotas INT DEFAULT 0;
        
        -- buscamos el gasto del cliente
        SELECT SUM(precio) INTO v_gasto FROM atiende 
        WHERE id_cliente = clave_cliente;
        
        -- buscamos el número de mascotas que tiene
        SELECT COUNT(*) INTO v_mascotas FROM mascota
        WHERE id_cliente = clave_cliente;
        
        -- aplicamos las condiciones
        IF v_gasto > 150 OR v_mascotas > 2 THEN
			RETURN 1;
		ELSE
			RETURN 0;
        END IF;
END //
DELIMITER ;
-- no premium
SELECT fn_cliente_premium(4) AS Premium;
-- premium (>150)
SELECT fn_cliente_premium(7) AS Premium;
-- premium (>2 mascotas)
SELECT fn_cliente_premium(3) AS Premium;


-- --------------------------------------------------------------------------
-- PROCEDIMIENTOS
-- 1.- Implementa un procedimiento almacenado llamado sp_get_ocupacion_salas_anyo que recibe 
-- un parámetro entero indicando un año y cuatro parámetros de salida uno para cada sala 
-- indicando el número de citas en cada sala ese año.
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_ocupacion_salas_anyo //
CREATE PROCEDURE sp_get_ocupacion_salas_anyo(
IN anyo INT, 
OUT sala1 INT,
OUT sala2 INT,
OUT sala3 INT,
OUT sala4 INT)
BEGIN
	-- citas para cada una de las cuatro salas un año concreto
	SELECT COUNT(*) INTO sala1 FROM atiende WHERE numero_sala = 1 AND YEAR(fecha_cita) = anyo;
    SELECT COUNT(*) INTO sala2 FROM atiende WHERE numero_sala = 2 AND YEAR(fecha_cita) = anyo;
    SELECT COUNT(*) INTO sala3 FROM atiende WHERE numero_sala = 3 AND YEAR(fecha_cita) = anyo;
    SELECT COUNT(*) INTO sala4 FROM atiende WHERE numero_sala = 4 AND YEAR(fecha_cita) = anyo;
END //
DELIMITER ;

CALL sp_get_ocupacion_salas_anyo(2025, @s1, @s2, @s3, @s4);
SELECT @s1 AS 'sala 1', @s2 AS 'sala 2', @s3 AS 'sala 3', @s4 AS 'sala 4';

-- --------------------------------------------------------------------------
-- 2.- Implementa un procedimiento almacenado llamado sp_get_cliente_mascota que recibe 
-- el nombre de una mascota y devuelve los clientes que tienen una mascota con ese nombre
-- Mostraremos el nombre de la mascota, el nombre del cliente (formato apellido, nombre) y su
-- telefono, cada campo en una columa diferente del resultset devuelto. También, si no existe ningún
-- cliente con esa mascota devoverá un resultset con el texto "No existe ningún cliente con una mascota con nombre: <NombreMascota>",
-- en caso contrario el mensaje sería "<NumClientes> tienen una mascota con el nombre: <NombreMascota>"
-- La función FOUND_ROWS(), aunque está deprecada, puede resultar útil. Debes tratar el caso de que
-- reciba el valor NULL como nombre de mascota
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_cliente_mascota //
CREATE PROCEDURE sp_get_cliente_mascota(
IN nombre_mascota VARCHAR(50))
BEGIN
	-- clientes con una mascota
   
    -- cruce de tabla mascota con tabla cliente
	SELECT m.nombre AS mascota, 
		CONCAT(SUBSTR(c.nombre, LOCATE(' ', c.nombre) + 1), ', ', SUBSTR(c.nombre, 1, LOCATE(' ', c.nombre) - 1)) AS cliente,  -- apellido y nombre
		c.telefono
	FROM mascota m INNER JOIN cliente c ON c.id = m.id_cliente
	WHERE m.nombre = TRIM(nombre_mascota);   

	-- FOUND_ROWS deprecada, otra opción sería volver a generar la consulta anterior pero con un count(*)    
	-- en el segundo resultset mostramos mensaje
	IF FOUND_ROWS() = 0 THEN
		SELECT CONCAT(FOUND_ROWS(), ' cliente(s) tienen una mascota con el nombre: ', nombre_mascota) AS mensaje;
    END IF;
END //
DELIMITER ;
-- dos clientes
CALL sp_get_cliente_mascota('Luna');
CALL sp_get_cliente_mascota('Anacleto');
CALL sp_get_cliente_mascota(NULL);

-- Igual que el anterior pero sin usar FOUND_ROWS
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_cliente_mascota2 //
CREATE PROCEDURE sp_get_cliente_mascota2(
IN nombre_mascota VARCHAR(50))
BEGIN
	-- clientes con una mascota
    DECLARE v_num INT DEFAULT 0;
   
    -- cruce de tabla mascota con tabla cliente
	SELECT m.nombre AS mascota, 
		CONCAT(SUBSTR(c.nombre, LOCATE(' ', c.nombre) + 1), ', ', SUBSTR(c.nombre, 1, LOCATE(' ', c.nombre) - 1)) AS cliente, 
		c.telefono
	FROM mascota m INNER JOIN cliente c ON c.id = m.id_cliente
	WHERE m.nombre = TRIM(nombre_mascota);   

	-- si no usamos FOUND_ROWS tendremos que hacer una consulta más
	SELECT COUNT(*) INTO v_num
	FROM mascota m INNER JOIN cliente c ON c.id = m.id_cliente
	WHERE m.nombre = TRIM(nombre_mascota);       
    
	IF v_num = 0 THEN
		SELECT CONCAT('No existe ningún cliente con una mascota con nombre: ', COALESCE(nombre_mascota, '<null>')) AS mensaje; -- coalesce sirve para que en orden sea el primer valor que no sea null, si no devuelve null
	ELSE
    	-- en el segundo resultset mostramos mensaje
		SELECT CONCAT(v_num, ' cliente(s) tienen una mascota con el nombre: ', nombre_mascota) AS mensaje;
    END IF;
END //
DELIMITER ;
-- dos clientes
CALL sp_get_cliente_mascota2('Luna');
CALL sp_get_cliente_mascota2(NULL);

-- --------------------------------------------------------------------------
-- 3.- Implementa un procedimiento almacenado llamado sp_get_ingresos_veterinario que reciba
-- un DNI de veterinario y un intervalo de dos fechas. Tendrá también dos parámetros
-- de salida que nos devuelvan los ingresos obtenidos esos días y otro que nos muestre
-- un texto indicando la valoración de ingresos: 
-- 0 -> 'Sin ingresos'
-- > 0 y < 500 -> 'Aceptable'
-- > 500 -> 'Extraordinario'
-- si no existiera un veterinario con ese DNI el texto mostrado sería 'No existe veterinario'
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_ingresos_veterinario //
CREATE PROCEDURE sp_get_ingresos_veterinario(
IN dni_vet VARCHAR(10), 
IN desde DATE,
IN hasta DATE,
OUT ingreso DECIMAL(10, 2),
OUT mensaje VARCHAR(50))
BEGIN
	-- citas e ingreso de veterinario por fechas
    -- solución buscando primero el id del veterinario, sin hacer JOIN
    DECLARE v_clave_vet INT DEFAULT 0;
    
    -- buscamos el id del veterinario (no hacemos JOIN de veterinario-atiende)
    SELECT id INTO v_clave_vet FROM veterinario WHERE DNI = dni_vet;
    
	IF v_clave_vet = 0 THEN
		SET mensaje = 'No existe veterinario';
    ELSE

		SELECT SUM(precio) INTO ingreso FROM atiende
        WHERE id_veterinario = v_clave_vet AND (fecha_cita BETWEEN desde AND hasta);
        
		-- si no encuentra nada, ingreso estará a NULL                
        IF ingreso IS NULL THEN 
			SET ingreso = 0;
        END IF;
        
        CASE 
			WHEN ingreso = 0 THEN 
				SET mensaje = '';
			WHEN ingreso > 0 AND ingreso < 500 THEN 
				SET mensaje = 'Aceptable';       
 			WHEN ingreso >= 500 THEN 
				SET mensaje = 'Extraordinario';       
        END CASE;
    END IF;
END //
DELIMITER ;
-- sin ingresos
CALL sp_get_ingresos_veterinario('00000A', '2024-01-01', '2024-01-28', @ingreso, @mensaje);
SELECT @ingreso, @mensaje;
-- aceptable
CALL sp_get_ingresos_veterinario('11111B', '2025-02-01', '2025-02-28', @ingreso, @mensaje);
SELECT @ingreso, @mensaje;
-- con estos datos, no se puede conseguir el extraordinario


-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

