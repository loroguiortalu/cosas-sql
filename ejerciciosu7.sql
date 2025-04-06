use ud7_clinica_veterinaria;

-- Funciones ---------------------------------------------------------------------------------
-- 1
-- Implementa una funcion con nombre fn_area_circulo que reciba el radio de un circulo y devuelva su area.
-- Puedes usar la funcion predefinida PI
DELIMITER //
DROP FUNCTION IF EXISTS fn_area_circulo //
CREATE FUNCTION fn_area_circulo (radio INT)
RETURNS INT
DETERMINISTIC
BEGIN 
	return (POW(Radio,2) * PI());-- pow sirve para elevar algo por si mismo
END //
DELIMITER ;

select fn_area_circulo(5);
    
    

-- 2
-- Implementa una función con nombre fn_hipotenusa, redondeando a los decimales.
-- Puedes usar las funciones predefinidas SQRT y POW
DELIMITER //
DROP FUNCTION IF EXISTS fn_hipotenusa //
CREATE FUNCTION fn_hipotenusa (cateto1 DECIMAL(10,2), cateto2 DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
	RETURN sqrt(pow(cateto1, 2)+ pow(cateto1, 2))  ;-- pow sirve para elevar algo por si mismo
END //
DELIMITER ;

select fn_hipotenusa(5,2);



-- 3
-- Empleando la estructura de control CASE y la función DAYOFWEEK, implementa una función con nombre fn_dia_semana
-- que reciba una fecha y devuelva su día de la semana en formato texto, (lunes, martes ...)
DELIMITER //
DROP FUNCTION IF EXISTS fn_dia_semana //
CREATE FUNCTION fn_dia_semana (fecha date)
RETURNS VARCHAR(10)
READS SQL DATA
BEGIN 
	DECLARE v_dia varchar(10);
    
    CASE DAYOFWEEK(fecha) 
		WHEN 1 THEN
			set v_dia = "Domingo";
		WHEN 2 THEN
			set v_dia = "Lunes";
		WHEN 3 THEN
			set v_dia = "Martes";
		WHEN 4 THEN
			set v_dia = "Miercoles";
		WHEN 5 THEN
			set v_dia = "Jueves";
		WHEN 6 THEN
			set v_dia = "Viernes";
		WHEN 7 THEN
			set v_dia = "Sabado";
            
	END CASE;
    
    RETURN v_dia;
END //
DELIMITER ;

select fn_dia_semana('2025-04-06');


 
-- 4
-- Empleando la estructura LOOP, implementa una función con nombre fn_factorial_loop que reciba un numero entero
-- sin signo y devuelva su factorial. Recuerda que el factorial de 0 es 1
DELIMITER //
DROP FUNCTION IF EXISTS fn_factorial_loop //
CREATE FUNCTION fn_factorial_loop (num int)
RETURNS int
READS SQL DATA
BEGIN
	declare v_resultado int default 1;
    declare v_i int default 1;

    bucle:loop
		if v_i > num then
			leave  bucle;
		end if;
        
        set v_resultado = v_resultado * i;
        set v_i = v_i + 1;
	end loop;
    
	return resultado;
End //
DELIMITER ;

SELECT FN_FACTORIAL_LOOP(3);



-- 5
-- Empleando la estructura REPEAT, implementa la función con nombre fn_factorial_repeat que reciba un número entero
-- sin signo y devuelva su factorial.
DELIMITER //
DROP FUNCTION IF EXISTS fn_factorial_repeat //
CREATE FUNCTION fn_factorial_repeat (num INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_resultado INT DEFAULT 1;
    DECLARE v_i INT DEFAULT 1;
    
    REPEAT
        SET v_resultado = v_resultado * v_i;
        SET v_i = v_i + 1;
    UNTIL v_i > num 
    END REPEAT;
    
    RETURN v_resultado;
END //
DELIMITER ;

SELECT fn_factorial_repeat(5);



-- 6
-- Empleando la estructura WHILE, implementa la función con nombre fn_factorial_while que reciba un número entero
-- sin signo y devuelva su factorial.
DELIMITER //
DROP FUNCTION IF EXISTS fn_factorial_while //
CREATE FUNCTION fn_factorial_while (num INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_resultado INT DEFAULT 1;
    DECLARE v_i INT DEFAULT 1;
    
    WHILE v_i <= num DO
        SET v_resultado = v_resultado * v_i;
        SET v_i = v_i + 1;
    END WHILE;
    RETURN v_resultado;
END //
DELIMITER ;

SELECT fn_factorial_while(5);










-- Procedimientos
-- 1
-- Implementa un procedimiento almacenado llamado sp_get_intercambia que reciba los valores numericos enteros
-- como parámetros e intercambie sus contenidos. Los parámetros serán del tipo entrada y salida, como es lógico
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_intercambia //
CREATE PROCEDURE sp_get_intercambia(INOUT num1 INT, INOUT num2 INT)
BEGIN
    DECLARE temp INT;
    SET temp = num1;
    SET num1 = num2;
    SET num2 = temp;
END //
DELIMITER ;

set @a = 11;
set @b = 10;
CALL sp_get_intercambia(@a, @b);
SELECT @a, @b;



-- 2
-- Implementa un procedimiento almacenado llamado sp_get_nota recibiendo un parámetro de entrada con un número entero
-- y otro de salida de tipo cadena de caracteres, varchar. Este último tomará un valor según el parámetro de entrada:
-- Suspenso (0 a 4), Aprobado (5), Bien (6),Notable (7,8), Sobresaliente (9,10) y Matricula de Honor (11).
-- En caso de recibir una nota con valor NULL, el parámetro de salida tomará el valor NULL, en caso de que la nota no
-- corresponda con ninguno de los valores anteriores el parámetro de salida tomará el valor cadena de texto vacía.
-- Debes emplear la estructura CASE.

DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_nota //
CREATE PROCEDURE sp_get_nota(IN nota INT, OUT resultado VARCHAR(20))
BEGIN
    SET resultado = CASE
                    WHEN nota BETWEEN 0 AND 4 THEN 'Suspenso'
                    WHEN nota = 5 THEN 'Aprobado'
                    WHEN nota = 6 THEN 'Bien'
                    WHEN nota BETWEEN 7 AND 8 THEN 'Notable'
                    WHEN nota BETWEEN 9 AND 10 THEN 'Sobresaliente'
                    WHEN nota = 11 THEN 'Matricula de Honor'
                    WHEN nota IS NULL THEN NULL
                    ELSE 'cadena vacía'
                    END;
END //
DELIMITER ;

CALL sp_get_nota(47, @resultado);
SELECT @resultado;



-- 3
-- Implementa un procedimiento almacenado llamado sp_get_cuenta_caracteres que recibe una cadena de texto y tres parámetros
-- de salida donde devolveremos el número de vocales, número de consonantes y número de espacios que el texto contiene.
-- La cadena recibida solamente puede contener vocales, consonantes y/o espacios.
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_cuenta_caracteres //
CREATE PROCEDURE sp_get_cuenta_caracteres(IN texto VARCHAR(255), OUT vocales INT, OUT consonantes INT, OUT espacios INT)
BEGIN
    
    DECLARE i INT DEFAULT 1;
    DECLARE letra CHAR(1);
    
    SET vocales = 0;
    SET consonantes = 0;
    SET espacios = 0;
    
    
    WHILE i <= LENGTH(texto) DO
        SET letra = SUBSTRING(texto, i, 1);
        IF letra IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U') THEN
            SET vocales = vocales + 1;
        ELSEIF letra IN ('b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'ñ', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z',
                         'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'Ñ', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z') THEN
            SET consonantes = consonantes + 1;
		end IF;
        IF letra = '' THEN
            SET espacios = espacios + 1;
        END IF;
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL sp_get_cuenta_caracteres('Hola Mund o', @vocales, @consonantes, @espacios);
SELECT @vocales, @consonantes, @espacios;





-- 4
-- Implementa un procedimiento almacenado llamdo sp_get_elimina_espacios que recibe una cadena de texto con un parámetro
-- de salida donde devolveremos el texto sin espacios. No podemos emplear la función REPLACE.
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_elimina_espacios //
CREATE PROCEDURE sp_get_elimina_espacios(IN texto VARCHAR(255), OUT resultado VARCHAR(255))
BEGIN
	DECLARE i INT DEFAULT 1;
    DECLARE letra CHAR(1);
	set resultado = '';
    
    WHILE i <= LENGTH(texto) DO
        SET letra = SUBSTRING(texto, i, 1);
        IF letra != '' THEN
            set resultado = concat(resultado, letra);
        END IF;
        SET i = i + 1;
    END WHILE;   
    
END //
DELIMITER ;

CALL sp_get_elimina_espacios('Hola   Mun 5 7  do', @resultado);
SELECT @resultado;



  



-- Parte 1: funciones
-- 1.
-- Implementa una función con nombre fn_existe_cliente_mascota que reciba la clave del cliente y el nombre de la mascota. 
-- Devolverá = si ese cliente no tiene ninguna mascota con ese nombre y 1 en caso contrario. 
-- Contempla la posibilidad de que reciba un nombre con espacios al princio o final del texto.

DELIMITER //
DROP FUNCTION IF EXISTS fn_existe_cliente_mascota //
CREATE FUNCTION fn_existe_cliente_mascota(cliente_id INT, mascota_nombre VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE resultado INT;
    SET mascota_nombre = TRIM(mascota_nombre);
    SELECT COUNT(*) INTO resultado
    FROM mascota
    WHERE id_cliente = cliente_id AND TRIM(nombre) = mascota_nombre;
    RETURN IF(resultado > 0, 1, 0);
END //
DELIMITER ;

SELECT fn_existe_cliente_mascota(1, 'Toby');





-- 2.
-- Implementa una función con nombre fn_sala_libre que reciba el numero de una sala y una fecha. 
-- Devolverá 1 si la sala no tiene cita para ese dia y 0 en caso contrario.
DELIMITER //
DROP FUNCTION IF EXISTS fn_sala_libre //
CREATE FUNCTION fn_sala_libre(sala_numero INT, fecha DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE resultado INT;
    SELECT COUNT(*) INTO resultado
    FROM atiende
    WHERE numero_sala = sala_numero AND fecha_cita = fecha;
    RETURN IF(resultado > 0, 0, 1);
END //
DELIMITER ;

SELECT fn_sala_libre(1, '2025-12-01');


-- 3. 
-- Implementa una función con nombre fn_cliente_premium que reciba la clave de un cliente y devuelva 1 
-- en caso de considerarse cliente premium o 0 en caso contrario. Se considera cliente premium aquel cliente que ha
-- gastadi más de 150 euros en citas que tiene más de 2 mascotas.
DELIMITER //
DROP FUNCTION IF EXISTS fn_cliente_premium //
CREATE FUNCTION fn_cliente_premium(cliente_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_gastado DECIMAL(10,2);
    DECLARE num_mascotas INT;
    
    SELECT SUM(precio), COUNT(DISTINCT numero)
    INTO total_gastado, num_mascotas
    FROM atiende
    WHERE id_cliente = cliente_id;
    
    RETURN IF(total_gastado > 150 AND num_mascotas > 2, 1, 0);
END //
DELIMITER ;

SELECT fn_cliente_premium(1);










-- Parte 2: Procedimientos
-- 1.
-- Implementa un procedimiento almacenado llamado sp_get_ocupacion_salas_anyo que recibe un parámetro 
-- entero indicando un año y cuatro parámetros de salida uno para cada sala indicando el número de citas en cada sala ese año.
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_ocupacion_salas_anyo //
CREATE PROCEDURE sp_get_ocupacion_salas_anyo(anio INT, OUT ocupacion_sala1 INT, OUT ocupacion_sala2 INT, OUT ocupacion_sala3 INT, OUT ocupacion_sala4 INT)
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM atiende WHERE numero_sala = 1 AND YEAR(fecha_cita) = anio) INTO ocupacion_sala1,
		(SELECT COUNT(*) FROM atiende WHERE numero_sala = 2 AND YEAR(fecha_cita) = anio) INTO ocupacion_sala2,
        (SELECT COUNT(*) FROM atiende WHERE numero_sala = 3 AND YEAR(fecha_cita) = anio) INTO ocupacion_sala3,
        (SELECT COUNT(*) FROM atiende WHERE numero_sala = 4 AND YEAR(fecha_cita) = anio) INTO ocupacion_sala4;
END //
DELIMITER ;

CALL sp_get_ocupacion_salas_anyo(2025, @ocupacion_sala1, @ocupacion_sala2, @ocupacion_sala3, @ocupacion_sala4);
SELECT @ocupacion_sala1, @ocupacion_sala2, @ocupacion_sala3, @ocupacion_sala4;





-- 2.
--  Implementa un procedimiento almacenado llamado sp_get_cliente_mascota que recibe el nombre de una mascota y
-- devuelve los clientes que tienen una mascota con ese nombre. Mostraremos el nombre de la mascota, 
-- el nombre del cliente (formato apellido, nombre) y su telefono, cada campo en una columa diferente del
-- resultset devuelto. También, si no existe ningún cliente con esa mascota devoverá un segundo resultset con el texto
-- "No existe ningún cliente con una mascota con nombre: <NombreMascota>", 
-- en caso contrario el mensaje sería " <NumClientes> tienen una mascota con el nombre: <NombreMascota>". 
-- Debes tratar el caso de que reciba el valor NULL como nombre de mascota.
-- La función FOUND_ROWS(), aunque está deprecada, puede resultar útil.
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_cliente_mascota //
CREATE PROCEDURE sp_get_cliente_mascota(IN nombre_mascota VARCHAR(50))
BEGIN
    DECLARE mensaje VARCHAR(255);
    
    IF nombre_mascota IS NULL THEN
        SET mensaje = 'No se especificó un nombre de mascota.';
    ELSE
        SELECT COUNT(*) INTO @num_clientes
        FROM mascota m
        JOIN cliente c ON c.id = m.id_cliente
        WHERE m.nombre = nombre_mascota;
        
        IF @num_clientes = 0 THEN
            SET mensaje = CONCAT('No existe ningún cliente con una mascota con nombre: ', nombre_mascota);
        ELSE
            SET mensaje = CONCAT(@num_clientes, ' clientes tienen una mascota con el nombre: ', nombre_mascota);
        END IF;
    END IF;
    
    SELECT mensaje;
END //
DELIMITER ;

CALL sp_get_cliente_mascota('Toby');



-- 3. Implementa un procedimiento almacenado llamado sp_get_ingresos_veterinario que reciba un DNI de 
-- veterinario y un intervalo de dos fechas. Tendrá también dos parámetros de salida que nos devuelvan 
-- los ingresos obtenidos esos días y un texto indicando la valoración de ingresos según los rangos:
-- ▸ 0 → 'Sin ingresos'   ▸ 0 y < 150 → 'Aceptable'  ▸ >= 150 → 'Extraordinario'
-- Si no existiera un veterinario con ese DNI el texto mostrado sería “No existe veterinario”.
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_ingresos_veterinario //
CREATE PROCEDURE sp_get_ingresos_veterinario(IN dni_veterinario VARCHAR(10), IN fecha_inicio DATE, IN fecha_fin DATE, OUT ingresos DECIMAL(10,2), OUT mensaje VARCHAR(255))
BEGIN
    DECLARE total_ingresos DECIMAL(10,2) DEFAULT 0;
    DECLARE texto VARCHAR(255);
    
    SELECT SUM(precio) INTO total_ingresos
    FROM atiende
    WHERE id_veterinario = (SELECT id FROM veterinario WHERE DNI = dni_veterinario)
      AND fecha_cita BETWEEN fecha_inicio AND fecha_fin;
    
    IF total_ingresos IS NULL THEN
        SET mensaje = 'No existe veterinario';
    ELSE
        SET ingresos = total_ingresos;
        IF total_ingresos = 0 THEN
            SET mensaje = 'Sin ingresos';
        ELSEIF total_ingresos < 150 THEN
            SET mensaje = 'Aceptable';
        ELSE
            SET mensaje = 'Extraordinario';
        END IF;
    END IF;
END //
DELIMITER ;

CALL sp_get_ingresos_veterinario('00000A', '2025-01-01', '2025-12-31', @ingresos, @mensaje);
SELECT @ingresos, @mensaje;











