-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- Ejercicios Unidad 7 - Programación SQL
USE ud7_clinica_veterinaria;

-- 3.1  Procedimientos. Creación, borrado y uso --------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_citas_anyo_actual//
CREATE PROCEDURE sp_get_citas_anyo_actual()
BEGIN
	SELECT * 
	FROM atiende
	WHERE YEAR(fecha_cita) = YEAR(NOW())
    ORDER BY fecha_cita DESC;
END //
DELIMITER ;

CALL sp_get_citas_anyo_actual();

-- 3.3  Procedimientos. Parámetros y variables ------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_citas_anyo_mes//
CREATE PROCEDURE sp_get_citas_anyo_mes(
	IN anyo INT, 
    IN mes INT )
BEGIN
	-- Devuelve citas del año y mes recibido
	SELECT * FROM atiende
	WHERE YEAR(fecha_cita) = anyo AND MONTH(fecha_cita) = mes
    ORDER BY fecha_cita DESC;    
END //
DELIMITER ;

CALL sp_get_citas_anyo_mes(2025, 3);

DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_citas_entre_dias //
CREATE PROCEDURE sp_get_citas_entre_dias(
	IN inicio DATE, 
    IN fin DATE)
BEGIN
	-- Devuelve citas entre un intervalo de fechas
	SELECT * FROM atiende
	WHERE fecha_cita BETWEEN inicio AND fin
    ORDER BY fecha_cita DESC;
END //
DELIMITER ;
CALL sp_get_citas_entre_dias('2024-01-01', '2024-12-31');

DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_estadisticas_citas_dia //
CREATE PROCEDURE sp_get_estadisticas_citas_dia(
	IN dia DATE, 
    OUT citas INT,
    OUT total DECIMAL(10, 2),
    OUT media DECIMAL(10, 2))
BEGIN
	-- Para el día recibido devuelve el número de citas, cantidad total y media
	SELECT COUNT(*), SUM(precio), ROUND(AVG(precio), 2) INTO citas, total, media
    FROM atiende
	WHERE fecha_cita = dia;  
END //
DELIMITER ;

CALL sp_get_estadisticas_citas_dia('2025-03-06', 
	@num_citas, @precio_total, @precio_medio);
    
SELECT @num_citas AS citas, @precio_total AS precio, @precio_medio AS media;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_estadisticas_citas_dia_v2//
CREATE PROCEDURE sp_get_estadisticas_citas_dia_v2(IN dia DATE)
BEGIN
	-- Para el día recibido devuelve el número de citas, cantidad total y media
    -- variables
    DECLARE v_citas INT;
    DECLARE v_total, v_media DECIMAL(10,2);

	-- búsqueda de datos
	SELECT COUNT(*), SUM(precio) INTO v_citas, v_total
    FROM atiende
	WHERE fecha_cita = dia;  
    
    -- cálculo de datos
    SET v_media = ROUND(v_total / v_citas, 2);
    
    -- mostramos info
    SELECT v_citas AS citas, v_total AS precio, v_media AS media;    
END //
DELIMITER ;
CALL sp_get_estadisticas_citas_dia_v2('2025-03-06');

SELECT COUNT(*), SUM(precio), avg(precio)
FROM atiende
WHERE fecha_cita = '2025-03-06';


-- 4.1  Funciones. Creación, borrado y uso ----------------------------------
DELIMITER //
DROP FUNCTION IF EXISTS fn_dia_semana//
CREATE FUNCTION fn_dia_semana()
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN DAYNAME(NOW());
END //
DELIMITER ;

SELECT NOW();
SELECT UPPER(fn_dia_semana()) AS dia_semana;

SET @dia = fn_dia_semana();
SET @dia = 'Monday';
SELECT @dia;


-- 4.2  Funciones. Parametros resultados salida -----------------------------
DELIMITER //
DROP FUNCTION IF EXISTS fn_num_clientes//
CREATE FUNCTION fn_num_clientes()
RETURNS INT
READS SQL DATA
BEGIN
	-- número de clientes
    DECLARE v_num INT;
    
    -- calculamos
    SELECT COUNT(*) INTO v_num FROM cliente;
   
    -- devolvemos resultado
    RETURN v_num;
END //
DELIMITER ;

SELECT fn_num_clientes() AS num_clientes;
SET @num_clientes = fn_num_clientes();
SELECT @num_clientes;

DELIMITER //
DROP FUNCTION IF EXISTS fn_gasto_cliente//
CREATE FUNCTION fn_gasto_cliente(codigo INT)
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
	-- gasto total citas de cliente
	-- gasto
    DECLARE v_total DECIMAL(10, 2);
   
    -- calculamos
    SELECT SUM(precio) INTO v_total 
    FROM atiende
    WHERE id_cliente = codigo;
    
    -- devolvemos resultado
    RETURN v_total;
END //
DELIMITER ;

SELECT fn_gasto_cliente(1) AS gasto_cliente;
SET @num_cli = 1;
SELECT fn_gasto_cliente(@num_cli) AS gasto_cliente;

-- 5.1.1  Estructuras de control IF-THEN-ELSE -------------------------------
DELIMITER //
CREATE FUNCTION fn_compara_dos_numeros(n1 FLOAT, n2 FLOAT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	-- compara dos números devolviendo texto resultado
    DECLARE v_resultado VARCHAR(100);
    
    -- comparación tres opciones
    IF n1 = n2 THEN
		SET v_resultado = 'Los dos números son iguales';
	ELSEIF n1 > n2 THEN
		SET v_resultado = 'El primer número es mayor';
	ELSE
		SET v_resultado = 'El segundo número es mayor';
    END IF;
    
    -- devuelve resultado
    RETURN v_resultado;

END //
DELIMITER ;
SELECT fn_compara_dos_numeros(5, 5) AS comparacion;
SELECT fn_compara_dos_numeros(6, 5) AS comparacion;
SELECT fn_compara_dos_numeros(5, 6) AS comparacion;


DELIMITER //
CREATE FUNCTION fn_compara_tres_numeros(n1 FLOAT, n2 FLOAT, n3 FLOAT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	-- compara tres números devolviendo texto resultado
    DECLARE v_resultado VARCHAR(100);
    
    -- comparación opciones
    IF n1 = n2 THEN
		IF n2 = n3 THEN
			SET v_resultado = 'Los tres números son iguales';
		ELSEIF n2 > n3 THEN
			SET v_resultado = 'Primero y segundo iguales y mayores al tercero';
		ELSE
			SET v_resultado = 'Primero y segundo iguales y menores al tercero';
		END IF;
	ELSEIF n1 > n2 THEN
		IF n1 > n3 THEN
			SET v_resultado = 'El primero es el mayor';
		ELSEIF n1 = n3 THEN
			SET v_resultado = 'Primero y tercero iguales y mayores al segundo';
		ELSE
			SET v_resultado = 'Orden: tercero, segundo y primero';
		END IF;
	ELSE
		IF n2 > n3 THEN
			SET v_resultado = 'El segundo es el mayor';
		ELSEIF n2 = n3 THEN
			SET v_resultado = 'Segundo y tercero iguales y mayores al primero';
		ELSE
			SET v_resultado = 'Orden: tercero, segundo y primero';
		END IF;
    END IF;
    
    -- devuelve resultado
    RETURN v_resultado;

END //
DELIMITER ;
SELECT fn_compara_tres_numeros(10, 10, 10) AS comparacion;

-- 5.1.2  Estructuras de control CASE ----------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_mensaje_cumple //
CREATE PROCEDURE sp_get_mensaje_cumple(
	IN dia DATE,
    OUT msj VARCHAR(100))
BEGIN
	-- Busca mascotas con cumple
    
    -- variables
    DECLARE v_cliente INT;
    DECLARE v_nombre_cliente, v_nombre_mascota VARCHAR(50);
    DECLARE v_cumples INT;

	-- búsqueda de datos
	SELECT COUNT(*) INTO v_cumples
    FROM mascota
	WHERE fecha_nacimiento = dia;  
    
    CASE v_cumples
		WHEN 0 THEN 
			SET msj = 'Ninguna mascota con cumple hoy';
        WHEN 1 THEN 
			-- buscamos cod cliente y nombre mascota
			SELECT id_cliente, nombre 
			INTO v_cliente, v_nombre_mascota
			FROM mascota
			WHERE fecha_nacimiento = dia;
			
			-- nos falta el nombre del cliente
			SELECT nombre INTO v_nombre_cliente
			FROM cliente
			WHERE id = v_cliente;        
            
			SET msj = CONCAT('Hoy es el cumple de ', 
				v_nombre_mascota, ', dueño ', v_nombre_cliente);
        ELSE
			-- en este punto, hay varios cumples
			SET msj = 'Varias mascotas tienen cumple hoy';
    END CASE;    
END //
DELIMITER ;
CALL sp_get_mensaje_cumple('2019-03-01', @mensaje);
SELECT @mensaje;

-- 5.2.1 Estructuras de control LOOP ----------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS sp_ejemplo_loop //
CREATE PROCEDURE sp_ejemplo_loop(
	IN fin INT, 
	OUT suma INT)
BEGIN
	-- Suma valores hasta la cantidad fin incluida
    -- para saber la posición actual
    DECLARE v_actual INT DEFAULT 1;
    
    -- iniciamos la suma
    SET suma = 0;
    
	-- bucle hasta fin
    bucle: LOOP
		-- si hemos sobrepasado fin salimos
        IF v_actual > fin THEN	
			LEAVE bucle;
        END IF;
        -- si no, sumamos y avanzamos
        SET suma = suma + v_actual;
        SET v_actual = v_actual + 1;
        
    END LOOP bucle;
END //
DELIMITER ;
CALL sp_ejemplo_loop(-5, @suma);
SELECT @suma;

-- 5.2.2 Estructuras de control REPEAT ----------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS sp_ejemplo_repeat //
CREATE PROCEDURE sp_ejemplo_repeat(
	IN fin INT, 
	OUT suma INT)
BEGIN
	-- Suma valores hasta la cantidad fin incluida
    -- para saber la posición actual
    DECLARE v_actual INT DEFAULT 1;
    
    -- iniciamos la suma
    SET suma = 0;
    
	-- bucle hasta fin
    bucle: REPEAT
        SET suma = suma + v_actual;
        SET v_actual = v_actual + 1;
	UNTIL v_actual > fin
    END REPEAT bucle;
END //
DELIMITER ;
CALL sp_ejemplo_repeat(5, @suma);
SELECT @suma;

-- 5.2.3 Estructuras de control WHILE ----------------------------------------
DELIMITER //
CREATE PROCEDURE sp_ejemplo_while(
	IN fin INT, 
	OUT suma INT)
BEGIN
	-- Suma valores hasta la cantidad fin incluida
    -- para saber la posición actual
    DECLARE v_actual INT DEFAULT 1;
    
    -- iniciamos la suma
    SET suma = 0;
    
	-- bucle hasta fin
    bucle: WHILE v_actual <= fin DO
        SET suma = suma + v_actual;
        SET v_actual = v_actual + 1;
    END WHILE bucle;
END //
DELIMITER ;
CALL sp_ejemplo_while(5, @suma);
SELECT @suma;

DELIMITER //
CREATE PROCEDURE sp_ejemplo_bucle_desde_hasta(
	IN inicio INT, 
    IN fin INT, 
	OUT suma INT)
BEGIN
	-- Suma valores desde inicio hasta fin ambos incluidos
    -- para saber la posición actual
    DECLARE v_actual INT;
    -- empezamos por inicio
    SET v_actual = inicio;
    -- iniciamos la suma
    SET suma = 0;
    
	-- bucle hasta fin
    bucle: WHILE v_actual <= fin DO
        SET suma = suma + v_actual;
        SET v_actual = v_actual + 1;
    END WHILE bucle;
END //
DELIMITER ;
CALL sp_ejemplo_bucle_desde_hasta(4, 5, @suma);
SELECT @suma;

-- 6. SQL dinámico ----------------------------------------------------------
-- ejercicio de consulta sobre una tabla creando el where según los parámetros 
-- distintos de NULL recibidos
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_datos_tabla //
CREATE PROCEDURE sp_get_datos_tabla(
	IN nombre_tabla VARCHAR(50)
)
BEGIN
	-- Muestra todos los campos y filas de la tabla recibida
	SET @declaracion_stmt = CONCAT('SELECT * FROM ', nombre_tabla);
    
    -- preparamos 
    PREPARE stmt_tabla FROM @declaracion_stmt;
    -- ejecutamos
    EXECUTE stmt_tabla;
    -- liberamos
    DEALLOCATE PREPARE stmt_tabla;
END //
DELIMITER ;
CALL sp_get_datos_tabla('cliente');
DELIMITER //
DROP PROCEDURE IF EXISTS sp_ins_veterinario //
CREATE PROCEDURE sp_ins_veterinario(
    IN dni VARCHAR(10), 
    IN nombre VARCHAR(50), 
    IN telefono VARCHAR(50), 
    IN autonomo BOOL,
    IN fecha_incorporacion DATE,
	OUT id INT)
BEGIN
	-- inserta nuevo veterinario devolviendo el id asignado

    -- Construimos la sentencia
    SET @declaracion_stmt = 
		'INSERT INTO veterinario VALUES(NULL, ?, ?, ?, ?, ?)';

    PREPARE prepared_stmt FROM @declaracion_stmt;
    
    -- ejecutamos pasándole parámetros
    -- solo admite variables de usuario
    SET @dni = dni;
    SET @nombre = nombre;
    SET @telefono = telefono;
    SET @autonomo = autonomo;
    SET @fecha_incorporacion = fecha_incorporacion;
    EXECUTE prepared_stmt 
    USING @dni, @nombre, @telefono, @autonomo, @fecha_incorporacion;
    
    -- obtenemos el id asignado
	SET id = LAST_INSERT_ID();
    
    -- liberamos
    DEALLOCATE PREPARE prepared_stmt;
END //
DELIMITER ;
CALL sp_ins_veterinario('1A', 'Josefina Altos', NULL, 1, '2024-01-06', @id);
SELECT @id;

-- 7. Manejo de errores -----------------------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS sp_ins_veterinario_v2 //
CREATE PROCEDURE sp_ins_veterinario_v2(
    IN DNI VARCHAR(10), 
    IN nombre VARCHAR(50), 
    IN telefono VARCHAR(50), 
    IN autonomo BOOL,
    IN fecha_incorporacion DATE,
	OUT id INT)
BEGIN
	-- inserta nuevo veterinario comprobando la correcta inserción  
    
    -- control error clave repetida
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
		SET id = -1;
	END;

    -- Construimos la sentencia
    -- En este caso, optamos por incluir los campos explícitamente
    -- y no indicar nada en el campo id
    SET @declaracion_stmt = 'INSERT INTO veterinario ';
    SET @declaracion_stmt = CONCAT(@declaracion_stmt, 'VALUES(NULL, ?, ?, ?, ?, ?)');
    PREPARE prepared_stmt FROM @declaracion_stmt;
    
    -- ejecutamos pasándole parámetros
    -- solo admite variables de usuario
    SET @DNI = dni;
    SET @nombre = nombre;
    SET @telefono = telefono;
    SET @autonomo = autonomo;
    SET @fecha_incorporacion = fecha_incorporacion;
    EXECUTE prepared_stmt 
    USING @DNI, @nombre, @telefono, @autonomo, @fecha_incorporacion;
    
    -- obtenemos el id asignado
	SET id = LAST_INSERT_ID();
    
    -- liberamos
    DEALLOCATE PREPARE prepared_stmt;
END //
DELIMITER ;
SELECT * FROM veterinario;
CALL sp_ins_veterinario_v2('1A', 'Josefina Altos', NULL, 1, '2024-01-06', @id);
CALL sp_ins_veterinario_v2('2B', NULL, NULL, 1, '2024-01-06', @id);
CALL sp_ins_veterinario_v2('2B', 'angel', NULL, 1, '2024-01-06', @id);
CALL sp_ins_veterinario_v2('3H', 'angel2', NULL, 1, '2024-01-06', @id);
SELECT @id;


DELIMITER //
CREATE PROCEDURE sp_ins_veterinario_v3(
    IN DNI VARCHAR(10), 
    IN nombre VARCHAR(50), 
    IN telefono VARCHAR(50), 
    IN autonomo BOOL,
    IN fecha_incorporacion DATE,
	OUT id INT)
BEGIN
	-- inserta nuevo veterinario comprobando la correcta inserción  
    
    -- control general errores
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET id = -1;
        SELECT CONCAT('Error al insertar veterinario con DNI: ', DNI) AS mensaje;
        DEALLOCATE PREPARE prepared_stmt;
	END;

    -- Construimos la sentencia
    SET @declaracion_stmt = 'INSERT INTO veterinario (DNI, nombre, telefono, ';
    SET @declaracion_stmt = CONCAT(@declaracion_stmt, 'autonomo, fecha_incorporacion) ');
    SET @declaracion_stmt = CONCAT(@declaracion_stmt, 'VALUES(?, ?, ?, ?, ?)');
    PREPARE prepared_stmt FROM @declaracion_stmt;
    
    -- ejecutamos pasándole parámetros
    -- solo admite variables de usuario
    SET @DNI = dni;
    SET @nombre = nombre;
    SET @telefono = telefono;
    SET @autonomo = autonomo;
    SET @fecha_incorporacion = fecha_incorporacion;
    EXECUTE prepared_stmt 
    USING @DNI, @nombre, @telefono, @autonomo, @fecha_incorporacion;
    
    -- obtenemos el id asignado
	SET id = LAST_INSERT_ID();
    
    -- liberamos
    DEALLOCATE PREPARE prepared_stmt;
    
    SELECT CONCAT('Inserción correcta veterinario con DNI: ', DNI) AS mensaje;
END //
DELIMITER ;
CALL sp_ins_veterinario_v3('2A', 'Josefina Altos', NULL, 1, '2024-01-06', @id);
-- CALL sp_ins_veterinario_v3('2B', NULL, NULL, 1, '2024-01-06', @id);
SELECT @id;

-- 8. Implementación de transacciones  --------------------------------------
SELECT @@AUTOCOMMIT;

-- ejemplo 
SET AUTOCOMMIT = 0;
SET AUTOCOMMIT = 1;

SELECT * FROM veterinario WHERE id = 12;
UPDATE veterinario SET telefono = '000' WHERE id = 12;
-- si AUTOCOMMIT está a 0, podemos volvemos atrás 
ROLLBACK;
COMMIT;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_upd_intercambia_propietarios //
CREATE PROCEDURE sp_upd_intercambia_propietarios(
    IN propietario_1 INT, 
    IN propietario_2 INT)
BEGIN
	-- intercambia las mascotas de dos clientes
    -- no comprobamos si tienen mascotas
    
    -- control general errores
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING  
    BEGIN
		ROLLBACK;
        SELECT CONCAT('Error al intercambiar mascotas de ', 
			propietario_1, ' y ', propietario_2) AS mensaje;
	END;

    -- inicio transacción
    START TRANSACTION;

    -- necesario deshabilitar la comprobación de claves ajenas
    SET FOREIGN_KEY_CHECKS = 0;
	UPDATE mascota SET id_cliente = 0 WHERE id_cliente = propietario_2;
	UPDATE mascota SET id_cliente = propietario_2 WHERE id_cliente = propietario_1;
	SET FOREIGN_KEY_CHECKS = 1;
    UPDATE mascota SET id_cliente = propietario_1 WHERE id_cliente = 0;
       
    -- confirmación cambios
	COMMIT;
	SELECT CONCAT('Intercambio correcto de mascotas de ', 
		propietario_1, ' y ', propietario_2) AS mensaje;        
END //
DELIMITER ;
CALL sp_upd_intercambia_propietarios(1, 2);
CALL sp_upd_intercambia_propietarios(2, 1);
SELECT * FROM mascota WHERE id_cliente in (1, 2);

CALL sp_upd_intercambia_propietarios(1, 787878);
SELECT * FROM mascota WHERE id_cliente in (1, 787878);

-- version con SQL dinámico
DELIMITER //
DROP PROCEDURE IF EXISTS sp_upd_intercambia_propietarios //
CREATE PROCEDURE sp_upd_intercambia_propietarios(
    IN propietario_1 INT, 
    IN propietario_2 INT)
BEGIN
	-- intercambia las mascotas de dos clientes
    -- no comprobamos si tienen mascotas
    
    -- control general errores
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING  
    BEGIN
		ROLLBACK;
        SELECT CONCAT('Error al intercambiar mascotas de ', 
			propietario_1, ' y ', propietario_2) AS mensaje;
	END;

    -- inicio transacción
    START TRANSACTION;
    
    -- preparamos la sentencia, que podremos usar varias veces
    SET @propietario_1 = propietario_1;
    SET @propietario_2 = propietario_2;
    SET @cero = 0;
    SET @declaracion_stmt = 'UPDATE mascota SET id_cliente = ? WHERE id_cliente = ?';
    PREPARE prepared_stmt FROM @declaracion_stmt;    
    
    -- necesario deshabilitar la comprobación de claves ajenas
    SET FOREIGN_KEY_CHECKS = 0;
    -- podemos reutilizar varias veces la misma prepared statement
    EXECUTE prepared_stmt USING @cero, @propietario_2;
    EXECUTE prepared_stmt USING @propietario_2, @propietario_1;
	SET FOREIGN_KEY_CHECKS = 1;
    EXECUTE prepared_stmt USING @propietario_1, @cero;
        
    -- confirmación cambios
	COMMIT;
	SELECT CONCAT('Intercambio correcto de mascotas de ', 
		propietario_1, ' y ', propietario_2) AS mensaje;
        
    -- liberamos sentencia
    DEALLOCATE PREPARE prepared_stmt;
END //
DELIMITER ;
CALL sp_upd_intercambia_propietarios(1, 2);
CALL sp_upd_intercambia_propietarios(2, 1);
SELECT * FROM mascota WHERE id_cliente in (1, 2);

-- como no comprobamos que el cliente exista...
CALL sp_upd_intercambia_propietarios(1, 5658);
CALL sp_upd_intercambia_propietarios(5658, 1);
SELECT * FROM mascota WHERE id_cliente in (1, 5658);
SELECT * FROM cliente WHERE id IN (1, 5658);

-- 9. Cursores  -------------------------------------------------------------
DELIMITER //
CREATE DEFINER = root@'%' PROCEDURE sp_get_citas_autonomos(
    IN fecha_desde DATE, 
    IN fecha_hasta DATE, 
    OUT num_citas INT)
-- SQL SECURITY INVOKER
BEGIN
	-- citas de veterinarios autónomos en intervalo fechas
    DECLARE v_id_veterinario INT;
    DECLARE v_fin INT DEFAULT 0;
    DECLARE v_num_citas_vet INT DEFAULT 0;
    DECLARE c_veterinarios CURSOR 
    FOR SELECT id FROM veterinario WHERE autonomo = 1 ORDER BY id;
    
    -- control excepción fin del cursor
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = 1;

	-- apertura cursor
    OPEN c_veterinarios;
    
    -- recorrido hasta fin
    SET num_citas = 0;
    
    veterinarios_autonomos: LOOP
		FETCH c_veterinarios INTO v_id_veterinario;
        
        -- si hemos terminado
        IF v_fin THEN
			LEAVE veterinarios_autonomos;
        END IF;
        
        -- obtenemos las citas de ese veterinario
        SELECT COUNT(*) INTO v_num_citas_vet 
        FROM atiende
        WHERE id_veterinario = v_id_veterinario AND
			fecha_cita BETWEEN fecha_desde AND fecha_hasta;
            
		-- acumulamos
        SET num_citas = num_citas + v_num_citas_vet;
    END LOOP;
    
    -- cerramos cursor
    CLOSE c_veterinarios;

END //
DELIMITER ;
CALL sp_get_citas_autonomos('2024-02-01', '2024-12-31', @num_citas_vet);
SELECT @num_citas_vet;

-- 10. Permisos en procedimientos y funciones  ------------------------------
SELECT * FROM mysql.user;

DROP USER webclinica@'%';
CREATE USER webclinica@'%' IDENTIFIED BY 'webclinica';

GRANT SYSTEM_USER ON *.* TO webclinica@'%';

GRANT CREATE ROUTINE, ALTER ROUTINE ON ud7_clinica_veterinaria.* TO webclinica@'%';
REVOKE CREATE ROUTINE, ALTER ROUTINE ON ud7_clinica_veterinaria.* FROM webclinica@'%';

GRANT EXECUTE ON PROCEDURE ud7_clinica_veterinaria.sp_get_citas_autonomos TO webclinica@'%';
REVOKE EXECUTE ON PROCEDURE ud7_clinica_veterinaria.sp_get_citas_autonomos FROM webclinica@'%';

GRANT EXECUTE ON FUNCTION ud7_clinica_veterinaria.fn_num_clientes TO webclinica@'%';
REVOKE EXECUTE ON FUNCTION ud7_clinica_veterinaria.fn_num_clientes FROM webclinica@'%';

SHOW GRANTS FOR webclinica@'%';

-- Ejecución a todas las funciones y procedimientos
GRANT EXECUTE ON FUNCTION ud7_clinica_veterinaria.* TO webclinica@'%';

GRANT EXECUTE ON PROCEDURE ud7_clinica_veterinaria.* TO webclinica@'%';

-- 11. Triggers o disparadores  ---------------------------------------------
SHOW TRIGGERS;

DELIMITER //
DROP TRIGGER IF EXISTS tr_veterinario_before_insert //
CREATE TRIGGER tr_veterinario_before_insert BEFORE INSERT
ON veterinario
FOR EACH ROW
BEGIN
	SET NEW.DNI = UPPER(NEW.DNI);
END//
DELIMITER ;
SELECT * FROM veterinario;
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) 
VALUES('1a', 'pueba', NULL, 1, '2024-01-06');

DELIMITER //
DROP TRIGGER IF EXISTS tr_veterinario_before_update //
CREATE TRIGGER tr_veterinario_before_update BEFORE UPDATE
ON veterinario
FOR EACH ROW
BEGIN
	SET NEW.DNI = UPPER(NEW.DNI);
END//
DELIMITER ;
SELECT * FROM veterinario;
UPDATE veterinario SET DNI = '1b' WHERE DNI = '1A';

GRANT INSERT, DELETE, UPDATE, SELECT 
ON ud7_clinica_veterinaria.veterinario TO webclinica@'%';
SHOW GRANTS FOR webclinica@'%';

-- VETERINARIO HISTORICO
DROP TABLE IF EXISTS veterinario_history;
CREATE TABLE veterinario_history (
	id INT AUTO_INCREMENT PRIMARY KEY,
    id_veterinario INT,
    DNI VARCHAR(10),
    nombre VARCHAR(50),
    telefono VARCHAR(50),
    autonomo TINYINT,
    fecha_incorporacion DATE,
    log_cambio VARCHAR(10),
    log_ultima_modificacion DATETIME DEFAULT NOW()
);

DELIMITER //
DROP TRIGGER IF EXISTS tr_veterinario_after_update //
CREATE TRIGGER tr_veterinario_after_update AFTER UPDATE
ON veterinario
FOR EACH ROW
BEGIN
	INSERT INTO veterinario_history
    (id_veterinario, DNI, nombre, telefono, autonomo, fecha_incorporacion, log_cambio)
    VALUES
	(NEW.id, NEW.DNI, NEW.nombre, NEW.telefono, NEW.autonomo, NEW.fecha_incorporacion, 'UPDATE');
END//
DELIMITER ;
SELECT * FROM veterinario;
SELECT * FROM veterinario_history;
UPDATE veterinario SET nombre = 'Luis Alfonso Sánchez' WHERE DNI = '00000A';
UPDATE veterinario SET nombre = 'Luis María Sánchez' WHERE DNI = '00000A';
UPDATE veterinario SET autonomo = 1 WHERE DNI = '00000A';
UPDATE veterinario SET DNI = '1c' WHERE DNI = '1B';



-- 12. Exportación datos en JSON  ---------------------------------------------

DROP PROCEDURE IF EXISTS sp_get_citas_entre_dias_JSON;
DELIMITER //
CREATE PROCEDURE sp_get_citas_entre_dias_JSON(
	IN inicio DATE, 
    IN fin DATE)
BEGIN
	-- Devuelve citas entre un intervalo de fechas
    SET @v_json_citas = json_object();
    
    -- cada fila es un objeto JSON, todas forman un array
	SELECT JSON_ARRAYAGG(
		JSON_OBJECT (
			'id_veterinario', id_veterinario,
            'numero_sala', numero_sala,
            'id_cliente', id_cliente,
            'numero_mascota', numero_mascota,
			'fecha_cita', fecha_cita,
			'precio', precio
		)
	) AS resultado INTO @v_json_citas
	FROM atiende
	WHERE fecha_cita BETWEEN inicio AND fin;
  
    -- si no hay citas en ese intervalo
    IF @v_json_citas IS NULL THEN
		SELECT json_object("error", "sin citas") as resultado;		
    ELSE 
		SELECT @v_json_citas AS resultado;
    END IF;    
END //
DELIMITER ;
CALL sp_get_citas_entre_dias_JSON('2024-01-01', '2024-12-31');
CALL sp_get_citas_entre_dias_JSON('2026-01-01', '2026-12-31');


DROP PROCEDURE IF EXISTS sp_get_citas_anyo_mes_JSON;
DELIMITER //
CREATE PROCEDURE sp_get_citas_anyo_mes_JSON(
	IN anyo INT, 
    IN mes INT)
BEGIN
	-- Devuelve citas del año y mes recibido
    SET @v_json_citas = json_object();
    
    -- cada fila es un objeto JSON, todas forman un array
	SELECT JSON_ARRAYAGG(
		JSON_OBJECT (
			'id_veterinario', id_veterinario,
            'numero_sala', numero_sala,
            'id_cliente', id_cliente,
            'numero_mascota', numero_mascota,
			'fecha_cita', fecha_cita,
			'precio', precio
		)
	) AS resultado INTO @v_json_citas
    FROM atiende
	WHERE YEAR(fecha_cita) = anyo AND MONTH(fecha_cita) = mes;    
    
    -- si no hay citas en ese intervalo
    IF @v_json_citas IS NULL THEN
		SELECT json_object("error", "sin citas") as resultado;		
    ELSE 
		SELECT @v_json_citas AS resultado;
    END IF;     
END //
DELIMITER ;
CALL sp_get_citas_anyo_mes_JSON(2023, 12);
CALL sp_get_citas_anyo_mes_JSON(2026, 12);


-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------


