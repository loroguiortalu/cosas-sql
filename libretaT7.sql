-- ---------------------------------------------
-- ---------------------------------------------
-- Ejercicios Unidad 7 Programación SQL


USE ud7_clinica_veterinaria;

-- 3.1 Procedimiento. Creación, borrado y uso -----------------------------------
DELIMITER //   -- se usa el // para cambiar de linea dentro de ese procedimiento o función, esto es temporal
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

-- 3.3 Procedimientos. Parámetros y variables -----------------------------------------------

-- ver diferencia entr paso por valor y referencia
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_citas_anyo_mes//
CREATE PROCEDURE sp_get_citas_anyo_mes(          -- o (IN anyo INT, IN mes INT)
	IN anyo INT,
    IN mes INT)
BEGIN
	-- Devuelve citas del año y mes recibido
    SELECT * FROM Atiende
    WHERE YEAR(fecha_cita) = anyo AND MONTH(fecha_cita) = mes
    ORDER BY fecha_cita DESC;
END //
DELIMITER ;
CALL sp_Get_citas_anyo_mes(2025,12);

DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_citas_entre_dias//
CREATE PROCEDURE sp_get_citas_entre_dias(          -- o (IN anyo INT, IN mes INT)
	IN inicio DATE,
    IN fin DATE)
BEGIN
	-- Devuelve citas del año y mes recibido
    SELECT * FROM atiende
    WHERE fecha_cita BETWEEN inicio AND fin
    ORDER BY fecha_cita DESC;
END //
DELIMITER ;
CALL sp_get_citas_entre_dias('2025-01-01', '2025-12-31');


DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_estadisticas_citas_dia//
CREATE PROCEDURE sp_get_estadisticas_citas_dia(          -- o (IN anyo INT, IN mes INT)
	IN dia DATE,
    OUT citas INT,
    OUT total DECIMAL(10,2),
    OUT media DECIMAL(10,2))
BEGIN
	-- Para el dia recibido devuelve el número de citas, cantidad total y media
    SELECT COUNT(*), SUM(precio), ROUND(AVG(precio), 2) INTO citas, total, media
    FROM atiende
    WHERE fecha_cita = dia;
END //
DELIMITER ;
select * FROM atiende;
-- la cosa se complica, ahora se crean variables
CALL sp_get_estadisticas_citas_dia('2025-02-07', @num_citas, @precio_total, @precio_medio);
SELECT @num_Citas AS citas, @precio_total AS precio, @precio_media AS media;




DELIMITER // -- esto podría ser de un examen
DROP PROCEDURE IF EXISTS sp_v3 //
CREATE PROCEDURE sp_v3(IN dia DATE)
BEGIN
	-- PARA el dia recibido devuelve el número de citas, cantidad total y media
    -- variables
    DECLARE v_citas INT;
    DECLARE v_total, v_media DECIMAL (10,2);
    
    -- búsqueda de datos
    SELECT COUNT(*), SUM(precio) INTO v_citas, v_total
    FROM atiende
    WHERE fecha_cita = dia;
    
    -- calculo de datos
    SET v_media = ROUND((v_total / v_citas), 2);
    
    -- mostramos info
    SELECT v_citas AS citas, v_total AS precio, v_media AS media;
    
END //
DELIMITER ;
CALL sp_get_estadisticas_citas_dia_v3('2025-02-07');


SELECT COUNT(*), SUM(precio), Avg(precio)
FROM atiende
Where fecha_cita = '2025-03-06';






-- 4.1 Funciones. Creación, borrado y uso --------------------------------
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

SET @dia = fn_dia_semana(); -- SE ASIgna a la variable el valor de una función
SELECT @dia; -- CAdA variable se asigna a cada conexión, a cada usuario

SET @dia = 'monday'; -- se puede cambiar la variable
SELECT @dia;


-- 4.2 Funciones. Parametros resultados salida -----------------------------
DELIMITER //
DROP FUNCTION IF EXISTS fn_num_clientes//
CREATE FUNCTION fn_num_clientes()
RETURNS inT
READS SQL DATA
BEGIN
	-- NÚmERO Clientes
	DECLARE v_num INT;
    
    -- Calculamos
    SELECT COUNT(*) INTO v_num FROM cliente;
    
    -- SET v_num = (SELECT COUNT(*) INTO v_num FROM cliente); -- esto hace lo mismo que la de arriba, pero mejor hacerlo como la de arriba
     
    -- devolvemos resultado 
    RETURN v_num;
END//
DELIMITER ;

SELECT fn_num_clientes() AS num_clientes;
SET @num_clientes = fn_num_clientes();
SELECT @num_clientes;



DELIMITER //
DROP FUNCTION IF EXISTS fn_gasto_cliente//
CREATE FUNCTION fn_gasto_cliente(codigo INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
	-- GASTO TOTAL CITAS DE CLIENTE
    -- GASTO
    DECLARE v_total DECIMAL(10,2);
    
    -- CALCULAMOS
    select sum(precio) INTO v_total
    From atiende
    Where id_cliente = codigo;
    
    -- Devolvemos resultado
    return v_total;
END //
DELIMITER ;

SELECT fn_gasto_cliente(1) AS gasto_cliente;
SET @num_cli = 2;
SELECT fn_gasto_cliente(@num_cli) AS gasto_cliente;


-- 5.1.1 Estructuras de control if-then-else -----------------
DELIMITER //
DROP FUNCTION IF EXISTS fn_compara_dos_numeros//
CREATE FUNCTION fn_compara_dos_numeros(n1 FLOAT, n2 FLOAT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	-- compara dos números devolviendo texto resultado
    DECLARE v_resultado VARCHAR(100);
    
    -- comparacion tres opciones
    IF n1 = n2 THEN
		SET v_resultado = 'Los dos números son iguales';
	ELSEIF n1 > n2 THEN
		SET v_resultado = 'El primer número es mayor';
	ELSE
		SET v_resultado = 'El segundor número es mayor';
    END IF;
    
    -- devolver resultado
    RETURN v_resultado;
    
END //
DELIMITER ;

SELECT fn_compara_dos_numeros(6, 5) AS comparacion;
SELECT fn_compara_dos_numeros(5, 5) AS comparacion;
SELECT fn_compara_dos_numeros(5, 6) AS comparacion;


DELIMITER // 
DROP FUNCTION IF EXISTS fn_compara_tres_numeros//
CREATE FUNCTION fn_compara_tres_numeros(n1 FLOAT, n2 FLOAT, n3 FLOAT)
RETURNS varchar(100)
DETERMINISTIC
BEGIN
	-- 
	
	
	

-- 5.1.2 EStructuras de control CASE
-- el case es como el switch
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_mensaje_cumple //
CREATE PROCEDURE sp_get_mensaje_cumple(
	IN dia DATE,
    OUT msj VARCHAR(100))
BEGIN

	-- Busca mascotas com cumple
    -- Variables
    DECLARE v_cliente, v_mascota INT;
    DECLARE v_nombre_cliente, v_nombre_mascota VARCHAR (50);
    DECLARE v_cumples INT;
    
    -- BUSQUEDA de datos
    SELECT COUNT(*) INTO v_cumples
    FROM mascota
    WHERE fecha_nacimiento = dia;
    
    CASE v_cumples
		WHEN 0 THEN
			SET msj = 'ninguna mascota cumple hoy';
		WHEN 1 THEN 
			-- buscamos cod cliente y nombre mascota
			SELECT id_cliente, numero, nombre
            INTO v_cliente, v_nombre_mascota
            FROM mascota
            WHERE fecha_nacimiento = dia;
            
            -- nos falta el nombre del cliente
            SELECT nombre into v_nombre_cliente
            FROM cliente
            WHERE id = v_cliente;
            
            SET msj = CONCAT ('Hoy es el cumple de ', 
            v_nombre_mascota, ', dueño', v_nombre_cliente );
		ELSE
			-- en este punto, hay varios cumples
            SET msj = ('Varia mascotas tienen cumple hoy');

    END CASE;
END //
DELIMITER ;
CALL sp_get_mensaje_cumple( '2019-03-01', @mensaje);
SELECT @mensaje;

-- 5.2.1. Estructuras de control loop ----------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS sp_ejemplo_loop //
CREATE PROCEDURE sp_ejemplo_loop (
	IN fin INT,
    OUT suma INT)
BEGIN
	-- Suma valores hasta la cantidad fin incluida
	-- para saber la posición actual
    DECLARE v_actual INT DEFAULT 1;
    
    
    
    
    -- 6. SQL dinámico
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_datos_tabla //
CREATE PROCEDURE sp_get_datos_tabla( IN nombre_tabla VARCHAR(50) )
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
	IN DNI VARCHAR(10),
    IN nombre VARCHAR(50),
    IN telefono VARCHAR(50),
    IN autonomo BOOL,
    IN fecha_incorporacion DATE,
    OUT id INT )
BEGIN
	-- inserta nuevo veterinario devolviendo el id asignado
    
    -- Construimos la sentencia
    SET @declaracion_stmt = 
		'INSERT INTO veterinario VALUES(NULL, ?, ?, ?, ?, ?)'; -- el NULL es autonumerico
        -- los interrogantes son parámetros de las sentencias de SQL dinámico
        
        -- también   'INSERT INTO veterinario(nombre, .....) VALUES(NULL, ?, ?, ?, ?, ?)';
        
	PREPARE prepared_stmt FROM @declaracion_stmt;
    
    -- ejecutamos pasándole parámetros
    -- solo admite variables de usuario
    SET @DNI = dni;
    SET @nombre = nombre;
    SET @telefono = telefono;
    SET @autonomo = autonomo;
    SET @fecha_incorporacion = fecha_incorporacion;
    
    
    EXECUTE prepared_stmt
    USING @DNI, @nombre, @telefono, @autonomo, @fecha_incorporacion ;
    
    -- obtenemos el id asignado
    SET id = LAST_INSERT_ID();-- last_insert_id() es para saber el último id que ha dado el sistema
    
    -- liberamos
    DEALLOCATE PREPARE prepared_stmt;
END //
DELIMITER ;
CALL sp_ins_veterinario( '1A', 'JOSEFINA ALTOS', NULL, 1, '2025-01-06', @id );
SELECT @id;




-- 7. Manejo de errores
DELIMITER //
DROP PROCEDURE IF EXISTS sp_ins_veterinario_v2 //
CREATE PROCEDURE sp_ins_veterinario_v2(
	IN DNI VARCHAR(10),
    IN nombre VARCHAR(50),
    IN telefono VARCHAR(50),
    IN autonomo BOOL,
    IN fecha_incorporacion DATE,
    OUT id INT )
BEGIN
	-- inserta nuevo veterinario comprobando la correcta inserción
    
    -- control error clave repetida
    DECLARE EXIT HANDLER FOR 1062, 1048 SET id = -1;
    
    -- construimos la sentencia
    -- En este caso, optamos por incluir los campos explícitamente
    -- y no indicar nada en el campo id
    SET @declaracion_stmt = 'INSERT INTO veterinario (DNI, nombre, telefono, ';
    SET @declaracion_stmt = CONCAT(@declaracion_stmt, 'autonomo, fecha_incorporacion)');
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
    USING @DNI, @nombre, @telefono, @autonomo, @fecha_incorporacion ;
   
    -- obtenemos el id asignado
    SET id = LAST_INSERT_ID();-- last_insert_id() es para saber el último id que ha dado el sistema
    
    -- liberamos
    DEALLOCATE PREPARE prepared_stmt;
    
    
END //
DELIMITER ;

SELECT * FROM veterinario;
CALL sp_ins_veterinario_v2('1A', 'Josefina Altos', NULL, 1, '2024-01.06', @id);
CALL sp_ins_veterinario_v2('2B', 'angel', NULL, 1, '2024', @id);
SELECT @id;
    
    
-- 8 implementación de Transacciones
SELECT @@AUTOCOMMIT;

-- ejemplo
SET AUTOCOMMIT = 0; -- no sirve para mucho el autocommit, solo es para que no se hagan efectivo el cambio en diferentes sesiones
SET AUTOCOMMIT = 1;-- por defecto

SELECT * FROM veterinario WHERE id = 12;
UPDATE veterinario SET telefono = '555' WHERE id = 12;
-- si Autocommit está a 0, podemos volver atrás
ROLLBACK; -- por si hay errores, buelbes atrás
COMMIT;


-- procedimiento inventado para el tema del commit
DELIMITER //
CREATE PROCEDURE sp_upd_intercambia_propietarios(
	IN propietario_1 INT,
    IN propietario_2 INT)
BEGIN

-- intercambia las mascotas de los dos clientes
-- no comprobamos si tienen mascotas

-- control general errores
DECLARE EXIT


	-- necesario deshabilitar 




	-- confirmación cambios
	COMMIT;
    SELECT CONCAT('INTERCAMBIO CORRECTO DE MASCOTAS DE ',
		propietario_1, ' y ', propietario_2) AS mensaje;

END //
DELIMITER ;

CALL sp_upd_intercambia_propietarios(1,2);
CALL sp_upd_intercambia_propietarios(2,1);
SELECT * FROM mascota WHERE id_cliente in (1,2);

CALL sp_upd_intercambia_propietarios(1,787878); -- esto es forzar a los errores, por haber deshabilitado la comprobación de claves ajenas
SELECT * FROM mascota WHERE id_cliente in (1, 787878);





-- cursores
DELIMITER //
CREATE PROCEDURE sp_get_citas_autonomos(
IN fecha_desde DATE,
IN fecha_hasta DATE,
OUT num_citas INT)

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
END//
DELIMITER ;









