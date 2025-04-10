-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- UD7. Programación SQL
-- Actividad 10: Ejercicios básicos procedimientos y funciones
-- Jesús Mañogil

USE ud7_actividades_clinica_veterinaria;

-- --------------------------------------------------------------------------
-- FUNCIONES
-- 1.- Implementa una función con nombre fn_area_circulo que reciba el radio
-- de un círculo y devuelva su área. Puedes usar la función predefinida PI()
DELIMITER //
DROP FUNCTION IF EXISTS fn_area_circulo//
CREATE FUNCTION fn_area_circulo(radio FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
	RETURN PI() * POW(radio, 2);
    -- También
    -- RETURN PI() * radio * radio;
END //
DELIMITER ;
SELECT fn_area_circulo(4.5444) AS area;

-- 2.- Implementa una función con nombre fn_hipotenusa_triangulo que reciba 
-- los valores de los lados de un triángulo y devuelva el valor de 
-- su hipotenusa, redondeando a dos decimales. Puedes usar las función predefinidas SQRT() y POW()
DELIMITER //
DROP FUNCTION IF EXISTS fn_hipotenusa_triangulo//
CREATE FUNCTION fn_hipotenusa_triangulo(lado1 FLOAT, lado2 FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
	DECLARE v_hipotenusa FLOAT;
    
    SET v_hipotenusa = ROUND(SQRT(POW(lado1, 2) + POW(lado2, 2)), 2);
    
	RETURN v_hipotenusa;
END //
DELIMITER ;
SELECT fn_hipotenusa_triangulo(2.3, 3.5) AS hipotenusa;

-- 3.- Empleando la estructura de control CASE y la función DAYOFWEEK, implementa una función 
-- con nombre fn_dia_semana que reciba una fecha y devuelva su día de la semana en formato 
-- texto (lunes, martes....)
DELIMITER //
DROP FUNCTION IF EXISTS fn_dia_semana//
CREATE FUNCTION fn_dia_semana(fecha DATE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	DECLARE v_dia VARCHAR(20);
    CASE DAYOFWEEK(fecha)
	WHEN 1 THEN
		SET v_dia = 'Domingo';
	WHEN 2 THEN
		SET v_dia = 'Lunes';
	WHEN 3 THEN
		SET v_dia = 'Martes';        
	WHEN 4 THEN
		SET v_dia = 'Miércoles';
	WHEN 5 THEN
		SET v_dia = 'Jueves';        
	WHEN 6 THEN
		SET v_dia = 'Viernes';        
	WHEN 7 THEN
		SET v_dia = 'Sábado';        
    END CASE;
    
	RETURN v_dia;
END //
DELIMITER ;
SELECT fn_dia_semana('2024-04-06') AS 'dia semana';

-- 4.- Empleando la estructura LOOP, implementa una función con nombre fn_factorial_loop que reciba 
-- un número entero sin signo y devuelva su factorial. Recuerda que el factorial de 0 es 1.
DELIMITER //
DROP FUNCTION IF EXISTS fn_factorial_loop//
CREATE FUNCTION fn_factorial_loop(numero INT UNSIGNED)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_resultado INT DEFAULT 1;

	bucle: LOOP
		IF numero > 0 THEN
			SET v_resultado = v_resultado * numero;
            SET numero = numero - 1;
        ELSE
			LEAVE bucle;
        END IF;
    END LOOP bucle;
    
	RETURN v_resultado;
END //
DELIMITER ;
SELECT fn_factorial_loop(6) AS factorial;

-- 5.- Empleando la estructura REPEAT, implementa una función con nombre fn_factorial_repeat que reciba 
-- un número entero sin signo y devuelva su factorial.
DELIMITER //
DROP FUNCTION IF EXISTS fn_factorial_repeat//
CREATE FUNCTION fn_factorial_repeat(numero INT UNSIGNED)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_resultado INT DEFAULT 1;
    
    -- dado que REPEAT siempre realiza una iteración, contemplamos antes el caso especial
	IF numero = 0 THEN
	 	RETURN 1;
    END IF;
    
	bucle: REPEAT
		SET v_resultado = v_resultado * numero;
		SET numero = numero - 1;
	UNTIL numero <= 0
    END REPEAT bucle;
    
	RETURN v_resultado;
END //
DELIMITER ;
SELECT fn_factorial_repeat(6) AS factorial;

-- 6.- Empleando la estructura WHILE, implementa una función con nombre fn_factorial_while que reciba 
-- un número entero sin signo y devuelva su factorial.
DELIMITER //
DROP FUNCTION IF EXISTS fn_factorial_while//
CREATE FUNCTION fn_factorial_while(numero INT UNSIGNED)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_resultado INT DEFAULT 1;
    
	bucle: WHILE numero > 0 DO
		SET v_resultado = v_resultado * numero;
		SET numero = numero - 1;
    END WHILE bucle;
    
	RETURN v_resultado;
END //
DELIMITER ;
SELECT fn_factorial_while(6) AS factorial;

-- --------------------------------------------------------------------------
-- PROCEDIMIENTOS
-- 1.- Implementa un procedimiento almacenado llamado sp_get_intercambia que reciba
-- dos valores numéricos enteros como parámetros e intercambie sus contenidos
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_intercambia //
CREATE PROCEDURE sp_get_intercambia(INOUT num1 INT, INOUT num2 INT)
BEGIN
	DECLARE v_aux INT;
    
    SET v_aux = num1;
    SET num1 = num2;
    SET num2 = v_aux;
END //
DELIMITER ;

SET @n1 = 5; 
SET @n2 = 11; 
CALL sp_get_intercambia(@n1, @n2);
SELECT @n1, @n2;

-- 2.- Implementa un procedimiento almacenado llamado sp_get_nota recibiendo un parámetro
-- de entrada con un número entero y otro de salida de tipo cadena de caracteres. Este último
-- tomará un valor según el parámetro de entrada: Suspenso (0 a 4), Aprobado (5),
-- Bien (6), Notable (7, 8), Sobresaliente (9, 10), Matrícula de Honor (11). En caso de recibir 
-- una nota con valor NULL, el parámetro de salida tomará el valor NULL, en caso de que la nota
-- no corresponda con ninguno de los valores anteriores el parámetro de salida tomará el valor ''.
-- Debes emplear la estructura CASE
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_nota //
CREATE PROCEDURE sp_get_nota(IN nota_numero INT, OUT nota_texto VARCHAR(50))
BEGIN   
    CASE
		WHEN nota_numero BETWEEN 0 AND 4 THEN 
			SET nota_texto = 'Suspenso';
		WHEN nota_numero = 5 THEN 
			SET nota_texto = 'Aprobado';
		WHEN nota_numero = 6 THEN 
			SET nota_texto = 'Bien';
		WHEN nota_numero BETWEEN 7 AND 8 THEN 
			SET nota_texto = 'Notable';
		WHEN nota_numero BETWEEN 9 AND 10 THEN 
			SET nota_texto = 'Sobresaliente';
		WHEN nota_numero = 11 THEN 
			SET nota_texto = 'Matrícula de Honor';
		WHEN nota_numero IS NULL THEN 
			SET nota_texto = NULL;
		ELSE
			SET nota_texto = '';
    END CASE;
END //
DELIMITER ;
CALL sp_get_nota(NULL, @nota);
CALL sp_get_nota(7, @nota);
CALL sp_get_nota(50, @nota);
SELECT @nota;

-- 3.- Implementa un procedimiento almacenado llamado sp_get_cuenta_caracteres que recibe una
-- cadena de texto y tres parámetros de salida donde devolveremos el número de vocales,
-- número de consonantes y número de espacios que el texto contiene. La cadena recibida solamente puede 
-- contener vocales, consonantes y/o espacios
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_cuenta_caracteres //
CREATE PROCEDURE sp_get_cuenta_caracteres(IN texto VARCHAR(100), OUT num_vocales INT, 
	OUT num_consonantes INT, OUT num_espacios INT)
BEGIN
	DECLARE v_posicion INT DEFAULT 1;
    DECLARE v_caracter CHAR(1);
    
	SET num_vocales = 0;
    SET num_consonantes = 0;
    SET num_espacios = 0;
    
    SET texto = LOWER(texto);
    
    bucle: WHILE v_posicion <= LENGTH(texto) DO
		SET v_caracter = SUBSTR(texto, v_posicion, 1);
		CASE
			WHEN v_caracter IN ('a', 'e', 'i', 'o', 'u') THEN 
				SET num_vocales = num_vocales + 1;
			WHEN v_caracter = ' ' THEN 
				SET num_espacios = num_espacios + 1;
			ELSE
				SET num_consonantes = num_consonantes + 1;
		END CASE;
		SET v_posicion = v_posicion + 1;
    END WHILE bucle;
END //
DELIMITER ;
CALL sp_get_cuenta_caracteres('aepepep papd d', @vocales, @consonantes, @espacios);
CALL sp_get_cuenta_caracteres('', @vocales, @consonantes, @espacios);
CALL sp_get_cuenta_caracteres(NULL, @vocales, @consonantes, @espacios);
SELECT @vocales, @consonantes, @espacios;

-- 4.- Implementa un procedimiento almacenado llamado sp_elimina_espacios que recibe una
-- cadena de texto con un parámetro de salida donde devolveremos el texto sin espacios.
-- No podemos emplear la función REPLACE.
DELIMITER //
DROP PROCEDURE IF EXISTS sp_get_elimina_espacios //
CREATE PROCEDURE sp_get_elimina_espacios(IN texto VARCHAR(100), OUT texto_sin_espacios VARCHAR(100))
BEGIN
	DECLARE v_posicion INT DEFAULT 1;
    DECLARE v_caracter CHAR(1);
    
	SET texto_sin_espacios = '';
    
    bucle: WHILE v_posicion <= LENGTH(texto) DO
		SET v_caracter = SUBSTR(texto, v_posicion, 1);
		IF v_caracter = ' ' THEN
			SET v_caracter = '';
        END IF;
        SET texto_sin_espacios = CONCAT(texto_sin_espacios, v_caracter);
        
		SET v_posicion = v_posicion + 1;
    END WHILE bucle;
END //
DELIMITER ;
CALL sp_get_elimina_espacios('uno dos tres', @sin_espacios);
SELECT @sin_espacios;


-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

