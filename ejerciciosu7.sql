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
	return POW(Radio,2) * PI() ;-- pow sirve para elevar algo por si mismo
END //
DELIMITER ;

select fn_area_circulo(5);
    
    

-- 2
-- Implementa una función con nombre fn_hipotenusa, redondeando a los decimales.
-- Puedes usar las funciones predefinidas SQRT y POW
DELIMITER //
DROP FUNCTION IF EXISTS fn_hipotenusa //
CREATE FUNCTION fn_area_circulo (radio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
	return POW(Radio,2) * PI() ;-- pow sirve para elevar algo por si mismo
END //
DELIMITER ;

select fn_area_circulo(5);



-- 3
-- Empleando la estructura de control CASE y la función DAYOFWEEK, implementa una función con nombre fn_dia_semana
-- que reciba una fecha y devuelva su día de la semana en formato texto, (lunes, martes ...)
 


 
-- 4
-- Empleando la estructura LOOP, implementa una función con nombre fn_factorial_loop que reciba un numero entero
-- sin signo y devuelva su factorial. Recuerda que el factorial de 0 es 1




-- 5
-- Empleando la estructura REPEAT, implementa la función con nombre fn_factorial_repeat que reciba un número entero
-- sin signo y devuelva su factorial.




-- 6
-- Empleando la estructura WHILE, implementa la función con nombre fn_factorial_while que reciba un número entero
-- sin signo y devuelva su factorial.








-- Procedimientos
-- 1
-- Implementa un procedimiento almacenado llamado sp_get_intercambia que reciba los valores numericos enteros
-- como parámetros e intercambie sus contenidos. Los parámetros serán del tipo entrada y salida, como es lógico




-- 2
-- Implementa un procedimiento almacenado llamado sp_get_nota recibiendo un parámetro de entrada con un número entero
-- y otro de salida de tipo cadena de caracteres, varchar. Este último tomará un falor según el parámetro de entrada:
-- Suspenso (0 a 4), Aprobado (5), Bien (6),Notable (7,8), Sobresaliente (9,10) y Matricula de Honor (11).
-- En caso de recibir una nota con valor NULL, el parámetro de salida tomará el valor NULL, en caso de que la nota no
-- corresponda con ninguno de los valores anteriores el parámetro de salida tomará el valor cadena de texto vacía.
-- Debes emplear la estructura CASE.




-- 3
-- Implementa un procedimiento almacenado llamado sp_get_cuenta_caracteres que recibe una cadena de texto y tres parámetros
-- de salida donde devolveremos el número de vocales, número de consonantes y número de espacios que el texto contiene.
-- La cadena recibida solamente puede contener vocales, consonantes y/o espacios.




-- 4
-- Implementa un procedimiento almacenado llamdo sp_get_elimina_espacios que recibe una cadena de texto con un parámetro
-- de salida donde devolveremos el texto sin espacios. No podemos emplear la función REPLACE.




  



-- Parte 1: funciones
-- 1.
-- Implementa una función con nombre fn_existe_cliente_mascota que reciba la clave del cliente y el nombre de la mascota. 
-- Devolverá = si ese cliente no tiene ninguna mascota con ese nombre y 1 en caso contrario. 
-- Contempla la posibilidad de que reciba un nombre con espacios al princio o final del texto.

DELIMITER //
DROP PROCEDURE IF EXISTS fn_existe_cliente_mascota //
CREATE FUNCTION fn_existe_cliente_mascota
(in )



-- 2.
-- Implementa una función con nombre fn_sala_libre que reciba el numero de una sala y una fecha. 
-- Devolverá 1 si la sala no tiene cita para ese dia y 0 en caso contrario.



-- 3. 
-- Implementa una función con nombre fn_cliente_premium que reciba la clave de un cliente y devuelva 1 
-- en caso de considerarse cliente premium o 0 en caso contrario. Se considera cliente premium aquel cliente que ha
-- gastadi más de 150 euros en citas que tiene más de 2 mascotas.











-- Parte 2: Procedimientos
-- 1.
-- Implementa un procedimiento almacenado llamado sp_get_ocupacion_salas_anyo que recibe un parámetro 
-- entero indicando un año y cuatro parámetros de salida uno para cada sala indicando el número de citas en cada sala ese año.






-- 2.
--  Implementa un procedimiento almacenado llamado sp_get_cliente_mascota que recibe el nombre de una mascota y
-- devuelve los clientes que tienen una mascota con ese nombre. Mostraremos el nombre de la mascota, 
-- el nombre del cliente (formato apellido, nombre) y su telefono, cada campo en una columa diferente del
-- resultset devuelto. También, si no existe ningún cliente con esa mascota devoverá un segundo resultset con el texto
-- "No existe ningún cliente con una mascota con nombre: <NombreMascota>", 
-- en caso contrario el mensaje sería " <NumClientes> tienen una mascota con el nombre: <NombreMascota>". 
-- Debes tratar el caso de que reciba el valor NULL como nombre de mascota.
-- La función FOUND_ROWS(), aunque está deprecada, puede resultar útil.




-- 3. Implementa un procedimiento almacenado llamado sp_get_ingresos_veterinario que reciba un DNI de 
-- veterinario y un intervalo de dos fechas. Tendrá también dos parámetros de salida que nos devuelvan 
-- los ingresos obtenidos esos días y un texto indicando la valoración de ingresos según los rangos:
-- ▸ 0 → 'Sin ingresos'   ▸ 0 y < 150 → 'Aceptable'  ▸ >= 150 → 'Extraordinario'
-- Si no existiera un veterinario con ese DNI el texto mostrado sería “No existe veterinario”.








